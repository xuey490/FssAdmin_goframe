package service

import (
	"bytes"
	"compress/gzip"
	"context"
	"encoding/hex"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"time"
	"unicode/utf8"

	"fssadmin/go-project/internal/shared/conf"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
	"github.com/gogf/gf/v2/util/gconv"
)

const backupCode = "database_backup"

var (
	mysqlLinkRe = regexp.MustCompile(`^mysql:([^:]*):([^@]*)@tcp\(([^:)]+):(\d+)\)/([^?]+)`)
	tableIdent  = regexp.MustCompile(`^[A-Za-z0-9_]+$`)
)

func parseMySQLLink(link string) (host, port, user, pass, name string, ok bool) {
	m := mysqlLinkRe.FindStringSubmatch(link)
	if m == nil {
		return "", "", "", "", "", false
	}
	return m[3], m[4], m[1], m[2], m[5], true
}

func mysqlConn() (host, port, user, pass, name string) {
	cfg := g.DB().GetConfig()
	host, port, user, pass, name = cfg.Host, cfg.Port, cfg.User, cfg.Pass, cfg.Name
	if host == "" || name == "" {
		if h, p, u, pw, n, ok := parseMySQLLink(cfg.Link); ok {
			if host == "" {
				host = h
			}
			if port == "" {
				port = p
			}
			if user == "" {
				user = u
			}
			if pass == "" {
				pass = pw
			}
			if name == "" {
				name = n
			}
		}
	}
	if port == "" {
		port = "3306"
	}
	return
}

func Backup(ctx context.Context) (g.Map, error) {
	return backupTo(ctx, conf.BackupDir(), 30)
}

func backupTo(ctx context.Context, dir string, keepDays int) (g.Map, error) {
	if dir = strings.TrimSpace(dir); dir == "" {
		dir = conf.BackupDir()
	}
	if keepDays <= 0 {
		keepDays = 30
	}
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return nil, err
	}
	host, port, user, pass, name := mysqlConn()
	if name == "" {
		return nil, fmt.Errorf("数据库名为空")
	}
	raw, method, err := dumpMySQL(ctx, host, port, user, pass, name)
	if err != nil {
		return nil, err
	}
	if err = rejectEmptyDump(raw); err != nil {
		return nil, err
	}
	path := filepath.Join(dir, fmt.Sprintf("%s_%s.sql.gz", name, time.Now().Format("20060102_150405")))
	if err = writeGzip(path, raw); err != nil {
		return nil, err
	}
	gzipBytes, err := verifyGzip(path)
	if err != nil {
		_ = os.Remove(path)
		return nil, err
	}
	removed := cleanupOld(dir, keepDays)
	return resultOf(backupCode, g.Map{
		"file": path, "bytes": len(raw), "gzip_bytes": gzipBytes,
		"method": method, "removed_old": removed,
	}), nil
}

func dumpMySQL(ctx context.Context, host, port, user, pass, name string) ([]byte, string, error) {
	if bin, err := exec.LookPath("mysqldump"); err == nil {
		out, err := dumpViaMysqldump(ctx, bin, host, port, user, pass, name)
		if err == nil && len(out) > 0 {
			return out, "mysqldump", nil
		}
		g.Log().Warningf(ctx, "mysqldump fallback to orm: %v", err)
	}
	out, err := dumpSQL(ctx)
	if err != nil {
		return nil, "", err
	}
	return out, "orm", nil
}

func dumpViaMysqldump(ctx context.Context, bin, host, port, user, pass, name string) ([]byte, error) {
	cnf, err := writeClientCNF(host, port, user, pass)
	if err != nil {
		return nil, err
	}
	defer func() { _ = os.Remove(cnf) }()
	cmd := exec.CommandContext(ctx, bin,
		"--defaults-extra-file="+cnf,
		"--default-character-set=utf8mb4",
		"--hex-blob",
		"--single-transaction", "--routines", "--triggers", "--set-gtid-purged=OFF",
		name,
	)
	out, err := cmd.Output()
	if err != nil {
		if ee, ok := err.(*exec.ExitError); ok {
			return nil, fmt.Errorf("mysqldump: %v: %s", err, Truncate(string(ee.Stderr), 512))
		}
		return nil, err
	}
	return out, nil
}

func writeClientCNF(host, port, user, pass string) (string, error) {
	f, err := os.CreateTemp("", "mysqldump-*.cnf")
	if err != nil {
		return "", err
	}
	defer f.Close()
	_, err = fmt.Fprintf(f, "[client]\ndefault-character-set=utf8mb4\nuser=%s\npassword=%s\nhost=%s\nport=%s\n",
		cnfQuote(user), cnfQuote(pass), cnfQuote(host), cnfQuote(port))
	if err != nil {
		_ = os.Remove(f.Name())
		return "", err
	}
	return f.Name(), nil
}

func cnfQuote(s string) string {
	return `"` + strings.ReplaceAll(strings.ReplaceAll(s, `\`, `\\`), `"`, `\"`) + `"`
}

func dumpSQL(ctx context.Context) ([]byte, error) {
	rows, err := g.DB().GetAll(ctx, "SHOW TABLES")
	if err != nil {
		return nil, err
	}
	var buf bytes.Buffer
	buf.WriteString("/*!40101 SET NAMES utf8mb4 */;\nSET NAMES utf8mb4;\n")
	for _, row := range rows {
		if err := ctx.Err(); err != nil {
			return nil, err
		}
		table := ""
		for _, v := range row {
			table = v.String()
		}
		if !tableIdent.MatchString(table) {
			continue
		}
		create, err := g.DB().GetOne(ctx, "SHOW CREATE TABLE `"+table+"`")
		if err != nil || create.IsEmpty() {
			continue
		}
		ddl := create["Create Table"].String()
		if ddl == "" {
			for k, v := range create {
				if strings.Contains(strings.ToLower(k), "create") {
					ddl = v.String()
				}
			}
		}
		buf.WriteString("DROP TABLE IF EXISTS `" + table + "`;\n")
		buf.WriteString(ddl + ";\n")
		data, err := g.DB().Model(table).Ctx(ctx).All()
		if err != nil {
			continue
		}
		for _, rec := range data {
			cols := make([]string, 0, len(rec))
			vals := make([]string, 0, len(rec))
			for k, v := range rec {
				cols = append(cols, "`"+k+"`")
				if v == nil || v.IsNil() {
					vals = append(vals, "NULL")
					continue
				}
				vals = append(vals, sqlLit(v.Interface()))
			}
			buf.WriteString("INSERT INTO `" + table + "` (" + strings.Join(cols, ",") + ") VALUES (" + strings.Join(vals, ",") + ");\n")
		}
	}
	return buf.Bytes(), nil
}

func rejectEmptyDump(raw []byte) error {
	if len(raw) == 0 || (!bytes.Contains(raw, []byte("CREATE TABLE")) && !bytes.Contains(raw, []byte("DROP TABLE"))) {
		return fmt.Errorf("备份内容为空")
	}
	return nil
}

func sqlLit(v interface{}) string {
	if v == nil {
		return "NULL"
	}
	switch t := v.(type) {
	case []byte:
		return sqlBytes(t)
	case time.Time:
		if t.IsZero() {
			return "NULL"
		}
		return "'" + t.Format("2006-01-02 15:04:05") + "'"
	case *time.Time:
		if t == nil || t.IsZero() {
			return "NULL"
		}
		return "'" + t.Format("2006-01-02 15:04:05") + "'"
	case *gtime.Time:
		if t == nil || t.IsZero() {
			return "NULL"
		}
		return "'" + t.Layout("2006-01-02 15:04:05") + "'"
	case gtime.Time:
		if t.IsZero() {
			return "NULL"
		}
		return "'" + t.Layout("2006-01-02 15:04:05") + "'"
	case int, int8, int16, int32, int64, uint, uint16, uint32, uint64, float32, float64:
		return gconv.String(t)
	case uint8:
		return gconv.String(int(t))
	case bool:
		if t {
			return "1"
		}
		return "0"
	default:
		return sqlBytes([]byte(gconv.String(t)))
	}
}

func sqlBytes(b []byte) string {
	if b == nil {
		return "NULL"
	}
	if !utf8.Valid(b) {
		return "0x" + hex.EncodeToString(b)
	}
	return sqlQuote(string(b))
}

func sqlQuote(s string) string {
	var buf strings.Builder
	buf.Grow(len(s) + 2)
	buf.WriteByte('\'')
	for i := 0; i < len(s); i++ {
		switch s[i] {
		case 0:
			buf.WriteString(`\0`)
		case '\n':
			buf.WriteString(`\n`)
		case '\r':
			buf.WriteString(`\r`)
		case '\\':
			buf.WriteString(`\\`)
		case '\'':
			buf.WriteString(`\'`)
		case 26:
			buf.WriteString(`\Z`)
		default:
			buf.WriteByte(s[i])
		}
	}
	buf.WriteByte('\'')
	return buf.String()
}

func writeGzip(path string, raw []byte) error {
	f, err := os.Create(path)
	if err != nil {
		return err
	}
	defer f.Close()
	zw := gzip.NewWriter(f)
	if _, err = zw.Write(raw); err != nil {
		_ = zw.Close()
		return err
	}
	return zw.Close()
}

func verifyGzip(path string) (int64, error) {
	fi, err := os.Stat(path)
	if err != nil {
		return 0, err
	}
	if fi.Size() == 0 {
		return 0, fmt.Errorf("备份文件为空")
	}
	f, err := os.Open(path)
	if err != nil {
		return 0, err
	}
	defer f.Close()
	zr, err := gzip.NewReader(f)
	if err != nil {
		return 0, fmt.Errorf("gzip 无法解压: %v", err)
	}
	defer zr.Close()
	n, err := io.CopyN(io.Discard, zr, 16)
	if n == 0 && err != nil && err != io.EOF {
		return 0, fmt.Errorf("gzip 内容无法读取: %v", err)
	}
	return fi.Size(), nil
}

func cleanupOld(dir string, days int) int {
	cutoff := time.Now().AddDate(0, 0, -days)
	entries, err := os.ReadDir(dir)
	if err != nil {
		return 0
	}
	n := 0
	for _, e := range entries {
		if e.IsDir() || !strings.HasSuffix(strings.ToLower(e.Name()), ".sql.gz") {
			continue
		}
		info, err := e.Info()
		if err != nil || !info.ModTime().Before(cutoff) {
			continue
		}
		if os.Remove(filepath.Join(dir, e.Name())) == nil {
			n++
		}
	}
	return n
}
