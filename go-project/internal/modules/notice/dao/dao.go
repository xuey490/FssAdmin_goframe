package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
)

const Table = "sa_system_notice"

func Model() *gdb.Model { return dbx.Alive(dbx.Model(Table)) }
