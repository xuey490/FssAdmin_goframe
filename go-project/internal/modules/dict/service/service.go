package service

import (
	"fssadmin/go-project/internal/modules/dict/dao"
	"fssadmin/go-project/internal/shared/cachex"
	"fssadmin/go-project/internal/shared/crud"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/reqx"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
)

var typeSpec = crud.Spec{Table: dao.TypeTable, AsPage: true, Like: []string{"name", "code"}, Allow: []string{"name", "code", "status", "remark"}}
var dataSpec = crud.Spec{Table: dao.DataTable, Like: []string{"label", "value"}, Allow: []string{"type_id", "label", "value", "color", "code", "sort", "status", "remark"}}

func TypeList(r *ghttp.Request) (interface{}, error) { return typeSpec.List(r) }
func TypeCreate(r *ghttp.Request) (interface{}, error) {
	return touchDict(r, typeSpec.Create)
}
func TypeUpdate(r *ghttp.Request) (interface{}, error) {
	return touchDict(r, typeSpec.Update)
}
func TypeDelete(r *ghttp.Request) (interface{}, error) {
	return touchDict(r, typeSpec.Delete)
}
func TypeStatus(r *ghttp.Request) (interface{}, error) {
	return touchDict(r, typeSpec.Status)
}

func DataList(r *ghttp.Request) (interface{}, error) {
	m := dao.DataModel()
	q := reqx.Merge(r)
	if code := reqx.Str(q, "code"); code != "" {
		m = m.Where("code", code)
	}
	if tid := reqx.Int(q, "type_id"); tid > 0 {
		m = m.Where("type_id", tid)
	}
	m = dbx.FilterLike(m, "label", reqx.Str(q, "label"))
	rows, err := m.Order("sort asc, id asc").All()
	if err != nil {
		return nil, err
	}
	return dbx.ToMaps(rows), nil
}

func DataByCode(r *ghttp.Request) (interface{}, error) {
	code := r.Get("code").String()
	rows, _ := dao.DataModel().Where("code", code).Where("status", 1).Order("sort asc").All()
	return dbx.ToMaps(rows), nil
}

func DataCreate(r *ghttp.Request) (interface{}, error) { return touchDict(r, dataSpec.Create) }
func DataUpdate(r *ghttp.Request) (interface{}, error) { return touchDict(r, dataSpec.Update) }
func DataDelete(r *ghttp.Request) (interface{}, error) { return touchDict(r, dataSpec.Delete) }
func DataStatus(r *ghttp.Request) (interface{}, error) { return touchDict(r, dataSpec.Status) }
func DataBatchDelete(r *ghttp.Request) (interface{}, error) {
	ids := reqx.Ints(reqx.Merge(r), "ids")
	err := dbx.SoftDeleteIDs(dao.DataTable, ids)
	if err == nil {
		_ = cachex.RefreshDict(r.Context())
	}
	return g.Map{}, err
}

func touchDict(r *ghttp.Request, fn func(*ghttp.Request) (interface{}, error)) (interface{}, error) {
	out, err := fn(r)
	if err == nil {
		_ = cachex.RefreshDict(r.Context())
	}
	return out, err
}
