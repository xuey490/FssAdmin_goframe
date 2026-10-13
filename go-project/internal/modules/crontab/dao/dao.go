package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
)

const Table = "sa_tool_crontab"
const LogTable = "sa_tool_crontab_log"

func Model() *gdb.Model    { return dbx.Alive(dbx.Model(Table)) }
func LogModel() *gdb.Model { return dbx.Alive(dbx.Model(LogTable)) }
