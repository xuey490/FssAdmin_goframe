package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
)

const Table = "sa_system_config"
const GroupTable = "sa_system_config_group"

func Model() *gdb.Model      { return dbx.Alive(dbx.Model(Table)) }
func GroupModel() *gdb.Model { return dbx.Alive(dbx.Model(GroupTable)) }
