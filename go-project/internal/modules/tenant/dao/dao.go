package dao

import (
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/net/ghttp"
)

const Table = "sa_system_tenant"

func Model() *gdb.Model { return dbx.Alive(dbx.Model(Table)) }

// ScopedModel 返回带软删除的 tenant model。
// sa_system_tenant 表本身无 tenant_id 列（id 即租户ID），
// 因此仅做软删除过滤。租户列表的隔离在 service 层实现：
//   - 超管可看所有租户（或仅看当前租户）
//   - 非超管只能看自己所属的租户
func ScopedModel(r *ghttp.Request) *gdb.Model {
	m := dbx.Alive(dbx.Model(Table))
	u := ctxuser.Get(r)
	if u != nil && u.TenantID > 0 && !u.IsSuper {
		// 非超管只能看自己所属的租户
		m = m.Where("id", u.TenantID)
	}
	return m
}
