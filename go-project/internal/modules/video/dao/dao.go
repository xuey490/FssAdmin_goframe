package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
)

const Table = "platform_video"
const JobTable = "platform_video_download"

func Model() *gdb.Model    { return dbx.Alive(dbx.Model(Table)) }
func JobModel() *gdb.Model { return dbx.Alive(dbx.Model(JobTable)) }
