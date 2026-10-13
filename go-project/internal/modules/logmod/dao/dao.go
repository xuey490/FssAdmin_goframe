package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
)

const LoginTable = "sa_system_login_log"
const OperTable = "sa_system_oper_log"
const EmailTable = "sa_system_mail"

func LoginModel() *gdb.Model { return dbx.Alive(dbx.Model(LoginTable)) }
func OperModel() *gdb.Model  { return dbx.Alive(dbx.Model(OperTable)) }
func EmailModel() *gdb.Model { return dbx.Alive(dbx.Model(EmailTable)) }
