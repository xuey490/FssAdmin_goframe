package service

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestSplitSQL(t *testing.T) {
	raw := "SET NAMES utf8mb4;\nINSERT INTO t (a) VALUES ('a;b');\n-- skip\nSELECT 1;\n"
	got := splitSQL(raw)
	if len(got) != 3 {
		t.Fatalf("%#v", got)
	}
	if got[1] != "INSERT INTO t (a) VALUES ('a;b')" {
		t.Fatal(got[1])
	}
	if got[2] != "SELECT 1" {
		t.Fatal(got[2])
	}
}

func TestRestoreMissingFile(t *testing.T) {
	_, err := restoreTo(t.Context(), filepath.Join(t.TempDir(), "no.sql"), false)
	if err == nil {
		t.Fatal("missing file should fail")
	}
}

func TestRestoreEmptyFile(t *testing.T) {
	p := filepath.Join(t.TempDir(), "empty.sql")
	if err := os.WriteFile(p, []byte("  \n"), 0o644); err != nil {
		t.Fatal(err)
	}
	_, err := restoreTo(t.Context(), p, false)
	if err == nil {
		t.Fatal("empty file should fail")
	}
}

func TestSplitSQLKeepsCreateAndNamedPath(t *testing.T) {
	raw := "DROP TABLE IF EXISTS `casbin_rule`;\n" +
		"CREATE TABLE `casbin_rule` (\n" +
		"  `ptype` varchar(255) NOT NULL DEFAULT '' COMMENT '策略类型: p(权限) / g(角色继承)',\n" +
		"  PRIMARY KEY (`id`)\n" +
		") ENGINE=InnoDB COMMENT='Casbin权限规则表';\n" +
		"INSERT INTO `casbin_rule` (`v1`) VALUES ('/flow/template/design/:id/*');\n"
	got := splitSQL(raw)
	if len(got) != 3 {
		t.Fatalf("%d %#v", len(got), got)
	}
	if !strings.Contains(got[1], "CREATE TABLE") || !strings.Contains(got[1], "Casbin") {
		t.Fatal(got[1])
	}
	if !strings.Contains(got[2], ":id") {
		t.Fatal(got[2])
	}
}

func TestSkipRestoreStmt(t *testing.T) {
	if !skipRestoreStmt("USE `fssoa-net`") || skipRestoreStmt("INSERT INTO t VALUES (1)") {
		t.Fatal("skipRestoreStmt")
	}
}
