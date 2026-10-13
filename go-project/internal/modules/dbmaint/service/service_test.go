package service

import "testing"

func TestMapTableStatusUsesFrontendFields(t *testing.T) {
	got := mapTableStatus(map[string]interface{}{
		"Name": "sa_system_user", "Comment": "用户", "Engine": "InnoDB",
		"Rows": 12, "Data_free": 2048, "Data_length": 4096, "Index_length": 1024,
		"Collation":   "utf8mb4_unicode_ci",
		"Create_time": "2026-01-01 00:00:00", "Update_time": "2026-01-02 00:00:00",
	})
	if got["name"] != "sa_system_user" || got["comment"] != "用户" || got["engine"] != "InnoDB" {
		t.Fatalf("%v", got)
	}
	if got["data_free"] != "2.00 KB" || got["data_length"] != "5.00 KB" {
		t.Fatalf("size %v %v", got["data_free"], got["data_length"])
	}
	if got["rows"] != 12 {
		t.Fatal(got["rows"])
	}
}

func TestMapColumn(t *testing.T) {
	got := mapColumn(map[string]interface{}{
		"Field": "id", "Type": "int", "Key": "PRI", "Null": "NO", "Comment": "主键",
	})
	if got["column_name"] != "id" || got["column_key"] != "PRI" || got["is_nullable"] != false {
		t.Fatalf("%v", got)
	}
}

func TestValidTable(t *testing.T) {
	if !validTable("sa_system_user") || validTable("a;drop") || validTable("") {
		t.Fatal("ident")
	}
}
