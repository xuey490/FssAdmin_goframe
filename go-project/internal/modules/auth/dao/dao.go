package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
)

func UserByName(username string) (gdb.Record, error) {
	return dbx.Alive(dbx.Model("sa_system_user")).Where("username", username).One()
}

func UserByID(id int) (gdb.Record, error) {
	return dbx.Alive(dbx.Model("sa_system_user")).Where("id", id).One()
}

func TenantByID(id int) (gdb.Record, error) {
	return dbx.Alive(dbx.Model("sa_system_tenant")).Where("id", id).One()
}

func UserTenant(userID, tenantID int) (gdb.Record, error) {
	return dbx.Alive(dbx.Model("sa_system_user_tenant")).Where("user_id", userID).Where("tenant_id", tenantID).One()
}

func UserTenants(userID int) (gdb.Result, error) {
	return dbx.DB().Raw(
		`SELECT t.id, t.tenant_name AS name, t.tenant_code AS code, ut.is_default, t.status
		 FROM sa_system_user_tenant ut
		 JOIN sa_system_tenant t ON t.id=ut.tenant_id
		 WHERE ut.user_id=? AND ut.delete_time IS NULL AND t.delete_time IS NULL`, userID,
	).All()
}

func RoleCodes(userID, tenantID int, isSuper bool) []string {
	if isSuper {
		return []string{"super_admin", "admin"}
	}
	arr, _ := dbx.DB().Raw(
		`SELECT r.code FROM sa_system_user_role ur
		 JOIN sa_system_role r ON r.id=ur.role_id
		 WHERE ur.user_id=? AND ur.tenant_id=? AND ur.delete_time IS NULL AND r.delete_time IS NULL`,
		userID, tenantID,
	).Array()
	out := []string{}
	for _, v := range arr {
		if s := v.String(); s != "" {
			out = append(out, s)
		}
	}
	if len(out) == 0 {
		return []string{"user"}
	}
	return out
}

// DeptName 取用户在指定租户下的部门名：优先用户-部门关联表，回退主归属部门。
// 用于登录会话（在线用户列表「所属部门」列）与登录日志补全。
func DeptName(userID, tenantID int) string {
	if userID <= 0 {
		return ""
	}
	deptID := 0
	link := dbx.Alive(dbx.Model("sa_system_user_dept")).Where("user_id", userID)
	if tenantID > 0 {
		link = link.Where("tenant_id", tenantID)
	}
	if rec, err := link.Order("id asc").One(); err == nil && !rec.IsEmpty() {
		deptID = rec["dept_id"].Int()
	}
	if deptID == 0 {
		if u, err := UserByID(userID); err == nil && !u.IsEmpty() {
			deptID = u["dept_id"].Int()
		}
	}
	if deptID == 0 {
		return ""
	}
	rec, err := dbx.Alive(dbx.Model("sa_system_dept")).Where("id", deptID).One()
	if err != nil || rec.IsEmpty() {
		return ""
	}
	return rec["name"].String()
}

func WriteLoginLog(username, ip, osName, browser, loc, msg string, status int) {
	_, _ = dbx.Model("sa_system_login_log").Data(gmap{
		"username": username, "ip": ip, "os": osName, "browser": browser,
		"ip_location": loc, "message": msg, "status": status,
		"login_time": dbx.Now(), "create_time": dbx.Now(),
	}).Insert()
}

type gmap = map[string]interface{}
