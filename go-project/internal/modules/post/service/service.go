package service

import (
	"fssadmin/go-project/internal/modules/post/dao"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

var specAllow = []string{"name", "code", "sort", "status", "remark", "tenant_id"}

// currentTenantID 获取当前请求租户ID。
func currentTenantID(r *ghttp.Request) int {
	u := ctxuser.Get(r)
	if u == nil {
		return 0
	}
	return u.TenantID
}

func List(r *ghttp.Request) (interface{}, error) {
	m := dao.ScopedModel(r)
	q := reqx.Merge(r)
	m = dbx.FilterLike(m, "name", reqx.Str(q, "name"))
	m = dbx.FilterLike(m, "code", reqx.Str(q, "code"))
	if st := reqx.Str(q, "status"); st != "" {
		m = m.Where("status", st)
	}
	pg, limit := page.Parse(r)
	total, _ := m.Clone().Count()
	rows, err := m.Order("sort asc, id asc").Page(pg, limit).All()
	if err != nil {
		return nil, err
	}
	return response.Page(dbx.ToMaps(rows), total, pg, limit), nil
}

func Enabled(r *ghttp.Request) (interface{}, error) {
	rows, err := dao.ScopedModel(r).Where("status", 1).Order("sort asc, id asc").All()
	if err != nil {
		return nil, err
	}
	return dbx.ToMaps(rows), nil
}

func AccessPost(r *ghttp.Request) (interface{}, error) { return Enabled(r) }

func Detail(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	rec, err := dao.ScopedModel(r).Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("岗位不存在")
	}
	return dbx.ToMap(rec), nil
}

func Create(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	u := ctxuser.Must(r)
	tid := currentTenantID(r)
	if tid <= 0 {
		tid = 1
	}
	data := g.Map{
		"tenant_id": tid,
		"status":    1,
		"created_by": u.ID, "updated_by": u.ID,
		"create_time": dbx.Now(), "update_time": dbx.Now(),
	}
	for _, k := range specAllow {
		if v, ok := m[k]; ok {
			if k == "tenant_id" {
				continue // 强制使用当前租户
			}
			data[k] = v
		}
	}
	id, err := dbx.Model(dao.Table).Data(data).InsertAndGetId()
	if err != nil {
		return nil, err
	}
	rec, _ := dao.ScopedModel(r).Where("id", id).One()
	return dbx.ToMap(rec), nil
}

func Update(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	m := reqx.Merge(r)
	data := g.Map{"update_time": dbx.Now(), "updated_by": ctxuser.Must(r).ID}
	for _, k := range specAllow {
		if v, ok := m[k]; ok {
			if k == "tenant_id" {
				continue // 禁止修改租户
			}
			data[k] = v
		}
	}
	if _, err := dao.ScopedModel(r).Where("id", id).Data(data).Update(); err != nil {
		return nil, err
	}
	rec, _ := dao.ScopedModel(r).Where("id", id).One()
	return dbx.ToMap(rec), nil
}

func Delete(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	if !dbx.AssertTenantOwned(r, dao.Table, id) {
		return nil, biz.NotFound("岗位不存在或无权操作")
	}
	return g.Map{}, dbx.SoftDeleteScopedRequest(r, dao.Table, id)
}

func Status(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	st := reqx.Int(reqx.Merge(r), "status")
	_, err := dao.ScopedModel(r).Where("id", id).Data(g.Map{"status": st, "update_time": dbx.Now()}).Update()
	return g.Map{}, err
}
