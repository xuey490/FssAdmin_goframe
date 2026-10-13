package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
)

const TypeTable = "sa_system_dict_type"
const DataTable = "sa_system_dict_data"

func TypeModel() *gdb.Model { return dbx.Alive(dbx.Model(TypeTable)) }
func DataModel() *gdb.Model { return dbx.Alive(dbx.Model(DataTable)) }
