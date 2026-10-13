package dao

import (
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/net/ghttp"
)

const Table = "sa_system_user"

func Model() *gdb.Model { return dbx.Alive(dbx.Model(Table)) }

// ScopedModel 返回带软删除的 user model。
// sa_system_user 表无 tenant_id 列，租户隔离通过 sa_system_user_tenant 关联表实现。
// 因此此处仅做软删除过滤，租户校验在 service 层通过 user_tenant 关联实现。
func ScopedModel(r *ghttp.Request) *gdb.Model {
	m := dbx.Alive(dbx.Model(Table))
	_ = ctxuser.Get(r) // 保持接口一致，但 user 表无 tenant_id 列不做隔离
	return m
}
