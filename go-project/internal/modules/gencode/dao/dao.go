package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
)

const Table = "sa_tool_generate_tables"
const ColTable = "sa_tool_generate_columns"

func Model() *gdb.Model    { return dbx.Alive(dbx.Model(Table)) }
func ColModel() *gdb.Model { return dbx.Alive(dbx.Model(ColTable)) }
