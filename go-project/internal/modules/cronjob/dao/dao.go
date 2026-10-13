package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
)

const NodeTable = "task_node"
const JobTable = "task_job"

func NodeModel() *gdb.Model { return dbx.Alive(dbx.Model(NodeTable)) }
func JobModel() *gdb.Model  { return dbx.Alive(dbx.Model(JobTable)) }
