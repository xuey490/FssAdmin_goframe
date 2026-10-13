package service

import (
	"testing"

	"fssadmin/go-project/internal/modules/monitor/models"
)

// 会话写入同时存在 camelCase 与 snake_case，映射必须都能取到（前端列依赖这些字段）。
func TestRowFromSessionCamelAndSnake(t *testing.T) {
	camel := map[string]interface{}{
		"tokenId": "abc123", "userName": "admin", "deptName": "研发部",
		"ipaddr": "8.8.8.8", "loginLocation": "中国-北京", "os": "Windows",
		"browser": "Chrome", "loginTime": "2026-09-25 10:00:00",
		"user_id": 1, "tenant_id": 1,
	}
	row := rowFromSession(camel)
	if row.TokenID != "abc123" || row.UserName != "admin" || row.DeptName != "研发部" ||
		row.IPAddr != "8.8.8.8" || row.LoginLocation != "中国-北京" || row.OS != "Windows" ||
		row.Browser != "Chrome" || row.LoginTime != "2026-09-25 10:00:00" ||
		row.UserID != 1 || row.TenantID != 1 {
		t.Fatalf("camelCase 会话映射异常: %+v", row)
	}

	snake := map[string]interface{}{
		"session_id": "sid-1", "user_name": "martin", "dept_name": "市场部",
		"ipaddr": "114.114.114.114", "login_location": "中国-上海",
		"login_time": "2026-09-25 11:00:00", "user_id": 2, "tenant_id": 1,
	}
	row = rowFromSession(snake)
	if row.TokenID != "sid-1" || row.UserName != "martin" || row.DeptName != "市场部" ||
		row.LoginLocation != "中国-上海" || row.LoginTime != "2026-09-25 11:00:00" || row.UserID != 2 {
		t.Fatalf("snake_case 会话映射异常: %+v", row)
	}
}

// 缺字段时不应panic，且空格子串应被跳过。
func TestRowFromSessionMissingFields(t *testing.T) {
	row := rowFromSession(map[string]interface{}{"session_id": "  ", "user_id": "3"})
	if row.TokenID != "" || row.UserID != 3 {
		t.Fatalf("缺字段处理异常: %+v", row)
	}
}

func TestSortOnline(t *testing.T) {
	rows := []models.OnlineRow{
		{TokenID: "a", UserName: "bob", IPAddr: "10.0.0.1", LoginTime: "2026-09-25 10:00:00"},
		{TokenID: "b", UserName: "alice", IPAddr: "10.0.0.9", LoginTime: "2026-09-25 12:00:00"},
		{TokenID: "c", UserName: "carol", IPAddr: "10.0.0.5", LoginTime: "2026-09-25 11:00:00"},
	}

	sortOnline(rows, "", "desc") // 默认按登录时间倒序
	if rows[0].TokenID != "b" || rows[2].TokenID != "a" {
		t.Fatalf("按登录时间倒序异常: %+v", rows)
	}
	sortOnline(rows, "userName", "asc")
	if rows[0].UserName != "alice" || rows[2].UserName != "carol" {
		t.Fatalf("按账号升序异常: %+v", rows)
	}
	sortOnline(rows, "ipaddr", "asc")
	if rows[0].IPAddr != "10.0.0.1" || rows[2].IPAddr != "10.0.0.9" {
		t.Fatalf("按主机升序异常: %+v", rows)
	}
}

func TestFilterOnline(t *testing.T) {
	rows := []models.OnlineRow{
		{UserName: "admin", IPAddr: "8.8.8.8"},
		{UserName: "martin", IPAddr: "114.114.114.114"},
	}
	got := filterOnline(rows, func(row models.OnlineRow) bool { return row.UserName == "admin" })
	if len(got) != 1 || got[0].UserName != "admin" {
		t.Fatalf("过滤异常: %+v", got)
	}
}
