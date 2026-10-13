package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
)

const Table = "sa_system_attachment"
const CatTable = "sa_system_category"

func Model() *gdb.Model    { return dbx.Alive(dbx.Model(Table)) }
func CatModel() *gdb.Model { return dbx.Alive(dbx.Model(CatTable)) }
