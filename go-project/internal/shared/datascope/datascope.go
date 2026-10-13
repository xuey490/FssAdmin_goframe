package datascope

import (
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/tenant"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

// Data scope constants — 与数据库 sa_system_role.data_scope 注释一致
const (
	ScopeAll            = 1 // 全部数据
	ScopeDeptAndChild   = 2 // 本部门及下属
	ScopeDept           = 3 // 本部门
	ScopeSelf           = 4 // 仅本人
	ScopeDeptAndSelf    = 5 // 本部门及本人
	ScopeCustom         = 6 // 自定义部门
)

// Apply 对 model 应用数据权限过滤。
// table 为业务表名（如 "sa_article"），用于获取原始 model。
// 返回经过 租户隔离 + 数据范围 过滤后的 model。
//
// 逻辑参照 PHP DataScopeTrait：
//  1. 未登录 → 无数据
//  2. 超管 → 仅租户隔离，跳过数据范围（但仍按 tenant_id 隔离）
//  3. 按角色 data_scope 分 6 档处理
func Apply(r *ghttp.Request, table string) *gdb.Model {
	u := ctxuser.Get(r)
	m := dbx.Alive(dbx.Model(table))

	// 未登录：无数据
	if u == nil || u.ID == 0 {
		return m.Where("1 = 0")
	}

	// 租户隔离（强制），所有用户（含超管）都按 tenant_id 隔离
	// 仅 WithIgnore 闭包内才跳过
	if !tenant.IsIgnoreRequest(r) && u.TenantID > 0 {
		m = dbx.Tenant(m, u.TenantID, "tenant_id")
	}

	// 超管跳过数据范围（但仍受租户隔离约束）
	if u.IsSuper || tenant.IsIgnoreRequest(r) {
		return m
	}

	// 获取当前用户的主角色 data_scope
	dataScope, roleID := loadRoleScope(u.ID, u.TenantID)

	switch dataScope {
	case ScopeAll:
		// 全部数据：仅租户隔离，无额外限制
		return m

	case ScopeDept:
		if u.DeptID > 0 {
			return m.Where("dept_id", u.DeptID)
		}
		return m.Where("created_by", u.ID)

	case ScopeDeptAndChild:
		if u.DeptID > 0 {
			deptIDs := deptAndChildIDs(u.DeptID, u.TenantID)
			if len(deptIDs) > 0 {
				return m.WhereIn("dept_id", deptIDs)
			}
		}
		return m.Where("created_by", u.ID)

	case ScopeSelf:
		return m.Where("created_by", u.ID)

	case ScopeDeptAndSelf:
		if u.DeptID > 0 {
			deptIDs := deptAndChildIDs(u.DeptID, u.TenantID)
			if len(deptIDs) > 0 {
				return m.Where("dept_id IN(?) OR created_by=?", deptIDs, u.ID)
			}
		}
		return m.Where("created_by", u.ID)

	case ScopeCustom:
		deptIDs := customDeptIDs(roleID)
		if len(deptIDs) > 0 {
			return m.WhereIn("dept_id", deptIDs)
		}
		return m.Where("created_by", u.ID)

	default:
		// 降级：仅本人
		return m.Where("created_by", u.ID)
	}
}

// loadRoleScope 获取用户主角色的 data_scope 和 role_id。
// 优先取 sa_system_user_role 关联的第一个角色的 data_scope。
func loadRoleScope(userID, tenantID int) (int, int) {
	// 查用户关联的角色 ID
	roleIDRec, _ := dbx.Alive(dbx.Model("sa_system_user_role")).
		Where("user_id", userID).
		Where("tenant_id", tenantID).
		Order("id asc").
		One()
	if roleIDRec.IsEmpty() {
		return ScopeSelf, 0
	}
	roleID := gconv.Int(roleIDRec["role_id"])

	// 查角色的 data_scope
	roleRec, _ := dbx.Alive(dbx.Model("sa_system_role")).
		Where("id", roleID).
		One()
	if roleRec.IsEmpty() {
		return ScopeSelf, roleID
	}
	ds := gconv.Int(roleRec["data_scope"])
	if ds == 0 {
		ds = ScopeSelf
	}
	return ds, roleID
}

// deptAndChildIDs 获取本部门及所有子部门 ID（含自身）。
// 利用 sa_system_dept.level 字段（祖级列表）高效查询子孙节点。
func deptAndChildIDs(deptID, tenantID int) []int {
	result := []int{deptID}

	// 方式1：通过 level 字段查找子孙（level 以 "0,1,5," 格式存储祖级链）
	m := dbx.Alive(dbx.Model("sa_system_dept"))
	if tenantID > 0 {
		m = m.Where("tenant_id", tenantID)
	}
	recs, _ := m.All()
	for _, rec := range recs {
		level := gconv.String(rec["level"])
		id := gconv.Int(rec["id"])
		if id == deptID {
			continue
		}
		// 如果 level 中包含本部门 ID，说明是子孙部门
		if containsDeptID(level, deptID) {
			result = append(result, id)
		}
	}

	// 方式2（兜底）：如果 level 查不到，用 parent_id 递归
	if len(result) <= 1 {
		byParent := map[int][]int{}
		for _, rec := range recs {
			pid := gconv.Int(rec["parent_id"])
			id := gconv.Int(rec["id"])
			byParent[pid] = append(byParent[pid], id)
		}
		var walk func(int)
		walk = func(pid int) {
			for _, cid := range byParent[pid] {
				result = append(result, cid)
				walk(cid)
			}
		}
		walk(deptID)
	}

	return result
}

// containsDeptID 检查 level 祖级链字符串中是否包含某个 deptID。
// level 格式如 "0,1,5,"，检查 "5," 是否在其中。
func containsDeptID(level string, deptID int) bool {
	if level == "" {
		return false
	}
	target := gconv.String(deptID) + ","
	// 在 level 中查找 ",{deptID},"
	prefix := "," + target
	s := "," + level
	for i := 0; i+len(prefix) <= len(s); i++ {
		if s[i:i+len(prefix)] == prefix {
			return true
		}
	}
	return false
}

// customDeptIDs 获取角色自定义关联的部门 ID 列表。
func customDeptIDs(roleID int) []int {
	if roleID <= 0 {
		return nil
	}
	recs, _ := dbx.DB().Model("sa_system_role_dept").
		Where("role_id", roleID).
		Fields("dept_id").
		All()
	out := make([]int, 0, len(recs))
	for _, rec := range recs {
		out = append(out, gconv.Int(rec["dept_id"]))
	}
	return out
}

// CurrentUserID 从请求上下文获取当前用户 ID（方便 service 层填充 created_by）。
func CurrentUserID(r *ghttp.Request) int {
	u := ctxuser.Get(r)
	if u == nil {
		return 0
	}
	return u.ID
}

// CurrentDeptID 从请求上下文获取当前用户部门 ID（方便 service 层填充 dept_id）。
func CurrentDeptID(r *ghttp.Request) int {
	u := ctxuser.Get(r)
	if u == nil {
		return 0
	}
	return u.DeptID
}

// CurrentTenantID 从请求上下文获取当前租户 ID。
func CurrentTenantID(r *ghttp.Request) int {
	u := ctxuser.Get(r)
	if u == nil {
		return 0
	}
	return u.TenantID
}

// IsSuperAdmin 判断当前用户是否超管。
func IsSuperAdmin(r *ghttp.Request) bool {
	u := ctxuser.Get(r)
	return u != nil && u.IsSuper
}

// g import is used to silence unused import if g.Map is needed in future extensions.
var _ = g.Map{}
