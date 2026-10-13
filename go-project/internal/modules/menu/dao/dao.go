package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
)

const Table = "sa_system_menu"

func Model() *gdb.Model { return dbx.Alive(dbx.Model(Table)) }

func AllEnabled() (gdb.Result, error) {
	return Model().Where("status", 1).Order("sort asc, id asc").All()
}

func All() (gdb.Result, error) {
	return Model().Order("sort asc, id asc").All()
}

func One(id int) (gdb.Record, error) {
	return Model().Where("id", id).One()
}
