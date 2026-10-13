package service

import (
	"bytes"
	"context"
	"database/sql"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"

	"fssadmin/go-project/internal/shared/conf"

	"github.com/go-sql-driver/mysql"
	"github.com/gogf/gf/v2/frame/g"
)

const restoreCode = "database_restore"

func restoreTo(ctx context.Context, file string, flushRedis bool) (g.Map, error) {
	if file = strings.TrimSpace(file); file == "" {
		file = conf.RestoreFile()
	}
	raw, err := os.ReadFile(file)
	if err != nil {
		return nil, fmt.Errorf("读取还原脚本失败：%v", err)
	}
	if len(bytes.TrimSpace(raw)) == 0 {
		return nil, fmt.Errorf("还原脚本为空：%s", file)
	}
	method, n, err := importSQL(ctx, raw)
	if err != nil {
		return nil, err
	}
	redisFlushed := 0
	if flushRedis {
		redisFlushed, err = flushRedisDB(ctx)
		if err != nil {
			return resultFail(restoreCode, g.Map{
				"file": file, "method": method, "statements": n, "redis_flushed": 0,
			}), fmt.Errorf("数据库已还原，但清空 Redis 失败：%v", err)
		}
	}
	return resultOf(restoreCode, g.Map{
		"file": file, "method": method, "statements": n, "bytes": len(raw),
		"redis_flushed": redisFlushed,
	}), nil
}

func importSQL(ctx context.Context, raw []byte) (method string, statements int, err error) {
	n := countSQL(raw)
	if bin, lookErr := exec.LookPath("mysql"); lookErr == nil {
		if err = importViaMysql(ctx, bin, raw); err == nil {
			return "mysql", n, nil
		}
		g.Log().Warningf(ctx, "mysql client fallback to driver: %v", err)
	}
	if err = importViaDriver(ctx, raw); err != nil {
		return "driver", n, err
	}
	return "driver", n, nil
}

func importViaMysql(ctx context.Context, bin string, raw []byte) error {
	host, port, user, pass, name := mysqlConn()
	if name == "" {
		return fmt.Errorf("数据库名为空")
	}
	cnf, err := writeClientCNF(host, port, user, pass)
	if err != nil {
		return err
	}
	defer func() { _ = os.Remove(cnf) }()
	cmd := exec.CommandContext(ctx, bin,
		"--defaults-extra-file="+cnf,
		"--default-character-set=utf8mb4",
		"--max-allowed-packet=1073741824",
		name,
	)
	cmd.Stdin = bytes.NewReader(raw)
	out, err := cmd.CombinedOutput()
	if err != nil {
		return fmt.Errorf("mysql: %v: %s", err, Truncate(string(out), 512))
	}
	return nil
}

// importViaDriver 用独立 *sql.Conn 导入，避开 gdb 请求事务。
// MySQL 执行 DROP/CREATE 会隐式提交，gdb 若复用 ctx 里的 Tx，后续语句等于没真正落库。
func importViaDriver(ctx context.Context, raw []byte) error {
	dsn, err := restoreDSN()
	if err != nil {
		return err
	}
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		return err
	}
	defer func() { _ = db.Close() }()
	conn, err := db.Conn(ctx)
	if err != nil {
		return err
	}
	defer func() { _ = conn.Close() }()
		if _, err = conn.ExecContext(ctx, "SET NAMES utf8mb4"); err != nil {
			return err
		}
		if _, err = conn.ExecContext(ctx, "SET FOREIGN_KEY_CHECKS=0"); err != nil {
			return err
		}
		defer func() { _, _ = conn.ExecContext(context.Background(), "SET FOREIGN_KEY_CHECKS=1") }()
		stmts := splitSQL(string(raw))
		if len(stmts) == 0 {
			return fmt.Errorf("还原脚本没有可执行的 SQL")
		}
		for i, stmt := range stmts {
			if err = ctx.Err(); err != nil {
				return err
			}
			if skipRestoreStmt(stmt) {
				continue
			}
			if _, err = conn.ExecContext(ctx, stmt); err != nil {
				return fmt.Errorf("第 %d 条 SQL 失败：%v", i+1, err)
			}
		}
		return nil
	}

func restoreDSN() (string, error) {
	host, port, user, pass, name := mysqlConn()
	if name == "" {
		return "", fmt.Errorf("数据库名为空")
	}
	cfg := mysql.NewConfig()
	cfg.User = user
	cfg.Passwd = pass
	cfg.Net = "tcp"
	cfg.Addr = host + ":" + port
	cfg.DBName = name
	cfg.Timeout = 10 * time.Second
	cfg.Params = map[string]string{
		"charset":          "utf8mb4",
		"maxAllowedPacket": "1073741824",
	}
	cfg.AllowNativePasswords = true
	return cfg.FormatDSN(), nil
}

func skipRestoreStmt(stmt string) bool {
	u := strings.ToUpper(strings.TrimSpace(stmt))
	return strings.HasPrefix(u, "CREATE DATABASE") ||
		strings.HasPrefix(u, "DROP DATABASE") ||
		strings.HasPrefix(u, "USE ")
}

func flushRedisDB(ctx context.Context) (int, error) {
	n := 0
	if v, err := g.Redis().Do(ctx, "DBSIZE"); err == nil && v != nil {
		n = v.Int()
	}
	if _, err := g.Redis().Do(ctx, "FLUSHDB"); err != nil {
		return 0, err
	}
	return n, nil
}

func countSQL(raw []byte) int {
	return len(splitSQL(string(raw)))
}

func splitSQL(raw string) []string {
	var stmts []string
	var buf strings.Builder
	inStr, esc := false, false
	for i := 0; i < len(raw); i++ {
		c := raw[i]
		if inStr {
			buf.WriteByte(c)
			if esc {
				esc = false
				continue
			}
			if c == '\\' {
				esc = true
				continue
			}
			if c == '\'' {
				inStr = false
			}
			continue
		}
		if c == '-' && i+1 < len(raw) && raw[i+1] == '-' {
			for i < len(raw) && raw[i] != '\n' {
				i++
			}
			continue
		}
		if c == '#' {
			for i < len(raw) && raw[i] != '\n' {
				i++
			}
			continue
		}
		if c == '/' && i+1 < len(raw) && raw[i+1] == '*' {
			i += 2
			for i+1 < len(raw) && !(raw[i] == '*' && raw[i+1] == '/') {
				i++
			}
			if i+1 < len(raw) {
				i++
			}
			continue
		}
		if c == '\'' {
			inStr = true
			buf.WriteByte(c)
			continue
		}
		if c == ';' {
			s := strings.TrimSpace(buf.String())
			buf.Reset()
			if s != "" {
				stmts = append(stmts, s)
			}
			continue
		}
		buf.WriteByte(c)
	}
	if s := strings.TrimSpace(buf.String()); s != "" {
		stmts = append(stmts, s)
	}
	return stmts
}
