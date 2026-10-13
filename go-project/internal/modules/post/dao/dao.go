package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/net/ghttp"
)

const Table = "sa_system_post"

func Model() *gdb.Model { return dbx.Alive(dbx.Model(Table)) }

// ScopedModel 返回带软删除 + 租户隔离的 model。
// 超管或 TenantContext.Ignore 时跳过租户隔离。
func ScopedModel(r *ghttp.Request) *gdb.Model { return dbx.ScopedModel(r, Table) }
