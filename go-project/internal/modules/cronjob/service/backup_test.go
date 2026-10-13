package service

import (
	"encoding/hex"
	"os"
	"path/filepath"
	"testing"
	"time"
)

func TestParseMySQLLink(t *testing.T) {
	host, port, user, pass, name, ok := parseMySQLLink("mysql:root:root@tcp(127.0.0.1:3306)/fssoa-net?charset=utf8mb4")
	if !ok || host != "127.0.0.1" || port != "3306" || user != "root" || pass != "root" || name != "fssoa-net" {
		t.Fatalf("%v %s %s %s %s %s", ok, host, port, user, pass, name)
	}
}

func TestSQLLit(t *testing.T) {
	if sqlLit(nil) != "NULL" {
		t.Fatal(sqlLit(nil))
	}
	if sqlLit("a'b") != `'a\'b'` {
		t.Fatal(sqlLit("a'b"))
	}
	if sqlLit("命令执行失败") != "'命令执行失败'" {
		t.Fatal(sqlLit("命令执行失败"))
	}
	if sqlLit([]byte("邮件批量发送")) != "'邮件批量发送'" {
		t.Fatal(sqlLit([]byte("邮件批量发送")))
	}
	if sqlLit("a\\b\n") != `'a\\b\n'` {
		t.Fatal(sqlLit("a\\b\n"))
	}
	bin := []byte{0xff, 0xfe, 0x00, 0x41}
	got := sqlLit(bin)
	if got != "0x"+hex.EncodeToString(bin) {
		t.Fatal(got)
	}
}

func TestCnfQuote(t *testing.T) {
	if cnfQuote(`a"b\c`) != `"a\"b\\c"` {
		t.Fatal(cnfQuote(`a"b\c`))
	}
}

func TestRejectEmptyDump(t *testing.T) {
	if rejectEmptyDump(nil) == nil || rejectEmptyDump([]byte("SET NAMES utf8mb4;\n")) == nil {
		t.Fatal("empty dump should fail")
	}
	raw := []byte("DROP TABLE IF EXISTS `x`;\nCREATE TABLE `x` (id int);\n")
	if err := rejectEmptyDump(raw); err != nil {
		t.Fatal(err)
	}
}

func TestWriteGzipAndVerify(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "t.sql.gz")
	raw := []byte("DROP TABLE IF EXISTS `x`;\nCREATE TABLE `x` (id int);\n")
	if err := writeGzip(path, raw); err != nil {
		t.Fatal(err)
	}
	n, err := verifyGzip(path)
	if err != nil || n <= 0 {
		t.Fatal(n, err)
	}
	empty := filepath.Join(dir, "empty.sql.gz")
	if err := os.WriteFile(empty, nil, 0o644); err != nil {
		t.Fatal(err)
	}
	if _, err := verifyGzip(empty); err == nil {
		t.Fatal("empty gzip should fail")
	}
}

func TestCleanupOldOnlyGzip(t *testing.T) {
	dir := t.TempDir()
	old := filepath.Join(dir, "old.sql.gz")
	keep := filepath.Join(dir, "notes.txt")
	if err := os.WriteFile(old, []byte("x"), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(keep, []byte("y"), 0o644); err != nil {
		t.Fatal(err)
	}
	past := time.Now().AddDate(0, 0, -40)
	_ = os.Chtimes(old, past, past)
	_ = os.Chtimes(keep, past, past)
	if n := cleanupOld(dir, 30); n != 1 {
		t.Fatalf("removed=%d", n)
	}
	if _, err := os.Stat(keep); err != nil {
		t.Fatal("should keep non-gz file")
	}
	if _, err := os.Stat(old); err == nil {
		t.Fatal("old gzip should be removed")
	}
}

func TestNormalizeCron(t *testing.T) {
	if normalizeCron("0 2 * * *") != "0 0 2 * * *" {
		t.Fatal(normalizeCron("0 2 * * *"))
	}
	if normalizeCron("0 0 2 * * *") != "0 0 2 * * *" {
		t.Fatal(normalizeCron("0 0 2 * * *"))
	}
	if normalizeCron("0 0 2 * * * *") != "0 0 2 * * *" {
		t.Fatal(normalizeCron("0 0 2 * * * *"))
	}
	if normalizeCron("") != "" || normalizeCron("@daily") != "@daily" {
		t.Fatal("empty")
	}
}

func TestIntervalPattern(t *testing.T) {
	got := intervalPattern("0 5 0 0 0")
	if got != "@every 5m0s" {
		t.Fatal(got)
	}
}
