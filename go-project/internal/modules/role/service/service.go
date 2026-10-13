package service

import (
	menusvc "fssadmin/go-project/internal/modules/menu/service"
	"fssadmin/go-project/internal/modules/role/dao"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/cachex"
	"fssadmin/go-project/internal/shared/crud"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"
	"fssadmin/go-project/internal/shared/tree"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

var spec = crud.Spec{Table: dao.Table, Tenant: true, AsPage: true, Like: []string{"name", "code"}, Allow: []string{"name", "code", "parent_id", "level", "data_scope", "remark", "sort", "status", "tenant_id"}}

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
	for _, col := range spec.Like {
		m = dbx.FilterLike(m, col, reqx.Str(q, col))
	}
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

func Detail(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	rec, err := dao.ScopedModel(r).Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("角色不存在")
	}
	m := dbx.ToMap(rec)
	roleID := gconv.Int(m["id"])
	arr, _ := dbx.Model("sa_system_role_menu").Where("role_id", roleID).Fields("menu_id").Array()
	ids := []int{}
	for _, v := range arr {
		ids = append(ids, v.Int())
	}
	m["menu_ids"] = ids
	return m, nil
}

func Create(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	u := ctxuser.Must(r)
	tid := currentTenantID(r)
	if tid <= 0 {
		tid = 1
	}
	data := g.Map{
		"tenant_id":  tid,
		"status":     1,
		"created_by": u.ID, "updated_by": u.ID,
		"create_time": dbx.Now(), "update_time": dbx.Now(),
	}
	for _, k := range spec.Allow {
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
	cachex.InvalidateAllMenuTree(r.Context())
	rec, _ := dao.ScopedModel(r).Where("id", id).One()
	return dbx.ToMap(rec), nil
}

func Update(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	m := reqx.Merge(r)
	data := g.Map{"update_time": dbx.Now(), "updated_by": ctxuser.Must(r).ID}
	for _, k := range spec.Allow {
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
	cachex.InvalidateAllMenuTree(r.Context())
	rec, _ := dao.ScopedModel(r).Where("id", id).One()
	return dbx.ToMap(rec), nil
}

func Delete(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	if !dbx.AssertTenantOwned(r, dao.Table, id) {
		return nil, biz.NotFound("角色不存在或无权操作")
	}
	err := dbx.SoftDeleteScopedRequest(r, dao.Table, id)
	cachex.InvalidateAllMenuTree(r.Context())
	return g.Map{}, err
}

func Status(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	st := reqx.Int(reqx.Merge(r), "status")
	_, err := dao.ScopedModel(r).Where("id", id).Data(g.Map{"status": st, "update_time": dbx.Now()}).Update()
	return g.Map{}, err
}

func All(r *ghttp.Request) (interface{}, error) {
	rows, err := dao.ScopedModel(r).Where("status", 1).Order("sort asc, id asc").All()
	if err != nil {
		return nil, err
	}
	return dbx.ToMaps(rows), nil
}

func Tree(r *ghttp.Request) (interface{}, error) {
	rows, err := dao.ScopedModel(r).Where("status", 1).Order("sort asc, id asc").All()
	if err != nil {
		return nil, err
	}
	return tree.Build(dbx.ToMaps(rows), "id", "parent_id", "children"), nil
}

func AccessRole(r *ghttp.Request) (interface{}, error) { return All(r) }

func MenuByRole(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	if !dbx.AssertTenantOwned(r, dao.Table, id) {
		return nil, biz.NotFound("角色不存在")
	}
	// sa_system_role_menu 只有 role_id/menu_id；菜单是全局表，没有 tenant_id。
	rows, err := dbx.Model("sa_system_role_menu").Where("role_id", id).Fields("menu_id").All()
	if err != nil {
		return nil, err
	}
	menus := make([]g.Map, 0, len(rows))
	for _, rec := range rows {
		if mid := rec["menu_id"].Int(); mid > 0 {
			menus = append(menus, g.Map{"id": mid})
		}
	}
	return g.Map{"menus": menus}, nil
}

func AssignMenus(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	if !dbx.AssertTenantOwned(r, dao.Table, id) {
		return nil, biz.NotFound("角色不存在或无权操作")
	}
	ids := menusvc.ExpandParents(reqx.Ints(reqx.Merge(r), "menu_ids"))
	if _, err := dbx.Model("sa_system_role_menu").Where("role_id", id).Delete(); err != nil {
		return nil, err
	}
	for _, mid := range ids {
		if mid <= 0 {
			continue
		}
		if _, err := dbx.Model("sa_system_role_menu").Data(g.Map{
			"role_id": id, "menu_id": mid,
		}).Insert(); err != nil {
			return nil, err
		}
	}
	cachex.InvalidateAllMenuTree(r.Context())
	return g.Map{}, nil
}

func MenuPermission(r *ghttp.Request) (interface{}, error) { return AssignMenus(r) }
