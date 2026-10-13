package service

import (
	"fssadmin/go-project/internal/modules/notice/dao"
	"fssadmin/go-project/internal/shared/crud"

	"github.com/gogf/gf/v2/net/ghttp"
)

var spec = crud.Spec{
	Table:  dao.Table,
	AsPage: true,
	Like:   []string{"title", "content"},
	Allow:  []string{"title", "content", "type", "status", "remark"},
}

func List(r *ghttp.Request) (interface{}, error)   { return spec.List(r) }
func Detail(r *ghttp.Request) (interface{}, error) { return spec.Detail(r) }
func Create(r *ghttp.Request) (interface{}, error) { return spec.Create(r) }
func Update(r *ghttp.Request) (interface{}, error) { return spec.Update(r) }
func Delete(r *ghttp.Request) (interface{}, error) { return spec.Delete(r) }
func Status(r *ghttp.Request) (interface{}, error) { return spec.Status(r) }
