package service

import (
	"fssadmin/go-project/internal/modules/logmod/dao"
	"fssadmin/go-project/internal/shared/crud"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/reqx"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
)

var loginSpec = crud.Spec{Table: dao.LoginTable, AsPage: true, Like: []string{"username", "ip", "message"}}
var operSpec = crud.Spec{Table: dao.OperTable, AsPage: true, Like: []string{"username", "router", "service_name", "ip"}}
var emailSpec = crud.Spec{Table: dao.EmailTable, AsPage: true, Like: []string{"email", "content", "from", "gateway"}}

func LoginList(r *ghttp.Request) (interface{}, error) { return loginSpec.List(r) }
func LoginDelete(r *ghttp.Request) (interface{}, error) {
	ids := reqx.Ints(reqx.Merge(r), "ids")
	if len(ids) == 0 {
		id := r.Get("id").Int()
		if id > 0 {
			ids = []int{id}
		}
	}
	return g.Map{}, dbx.SoftDeleteIDs(dao.LoginTable, ids)
}

func OperList(r *ghttp.Request) (interface{}, error) { return operSpec.List(r) }
func OperDelete(r *ghttp.Request) (interface{}, error) {
	ids := reqx.Ints(reqx.Merge(r), "ids")
	if len(ids) == 0 {
		id := r.Get("id").Int()
		if id > 0 {
			ids = []int{id}
		}
	}
	return g.Map{}, dbx.SoftDeleteIDs(dao.OperTable, ids)
}

func EmailList(r *ghttp.Request) (interface{}, error)   { return emailSpec.List(r) }
func EmailDelete(r *ghttp.Request) (interface{}, error) { return emailSpec.Delete(r) }
func EmailResend(r *ghttp.Request) (interface{}, error) {
	return g.Map{"ok": true}, nil
}
