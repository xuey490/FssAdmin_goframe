package service

import (
	"fssadmin/go-project/internal/modules/article/dao"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/crud"
	"fssadmin/go-project/internal/shared/datascope"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

var spec = crud.Spec{
	Table:  dao.Table,
	Tenant: true,
	AsPage: true,
	Like:   []string{"title", "author", "describe"},
	Allow: []string{
		"category_id", "title", "author", "dept_id", "tenant_id", "image", "describe",
		"content", "summary", "cover_image", "category", "tags", "views", "sort",
		"status", "is_link", "link_url", "is_hot",
	},
}

var catSpec = crud.Spec{
	Table: dao.CatTable, Tree: true, Like: []string{"category_name"},
	Allow: []string{"parent_id", "category_name", "describe", "image", "sort", "status"},
}

// scopedModel 返回带租户隔离 + 数据权限过滤的 model。
func scopedModel(r *ghttp.Request) *gdb.Model {
	return datascope.Apply(r, dao.Table)
}

// scopedList 构建带数据权限的列表查询（复用 spec 的 Like / status 逻辑）。
func scopedList(r *ghttp.Request) (interface{}, error) {
	m := scopedModel(r)
	q := reqx.Merge(r)
	for _, col := range spec.Like {
		m = dbx.FilterLike(m, col, reqx.Str(q, col))
	}
	if st := reqx.Str(q, "status"); st != "" {
		m = m.Where("status", st)
	}
	m = m.Order("id desc")

	pg, limit := page.Parse(r)
	total, _ := m.Clone().Count()
	rows, err := m.Page(pg, limit).All()
	if err != nil {
		return nil, err
	}
	return response.Page(dbx.ToMaps(rows), total, pg, limit), nil
}

// ─── 文章 CRUD（带数据权限过滤）───

func List(r *ghttp.Request) (interface{}, error) { return scopedList(r) }

func Detail(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	rec, err := scopedModel(r).Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("记录不存在")
	}
	return dbx.ToMap(rec), nil
}

func Create(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	data := g.Map{"create_time": dbx.Now(), "update_time": dbx.Now()}
	uid := datascope.CurrentUserID(r)
	if uid > 0 {
		data["created_by"] = uid
	}
	tid := datascope.CurrentTenantID(r)
	if tid > 0 {
		if reqx.Int(m, "tenant_id") == 0 {
			data["tenant_id"] = tid
		}
	}
	// 自动填充当前用户的部门 ID（如果前端未传 dept_id）
	if did := datascope.CurrentDeptID(r); did > 0 {
		if reqx.Int(m, "dept_id") == 0 {
			data["dept_id"] = did
		}
	}
	for _, k := range spec.Allow {
		if v, ok := m[k]; ok {
			data[k] = v
		}
	}
	id, err := dbx.Model(dao.Table).Data(data).InsertAndGetId()
	if err != nil {
		return nil, err
	}
	rec, _ := dbx.Alive(dbx.Model(dao.Table)).Where("id", id).One()
	return dbx.ToMap(rec), nil
}

func Update(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	m := reqx.Merge(r)
	data := g.Map{"update_time": dbx.Now()}
	if uid := datascope.CurrentUserID(r); uid > 0 {
		data["updated_by"] = uid
	}
	for _, k := range spec.Allow {
		if v, ok := m[k]; ok {
			data[k] = v
		}
	}
	// 使用带数据权限的 model，确保只能修改自己有权限的数据
	if _, err := scopedModel(r).Where("id", id).Data(data).Update(); err != nil {
		return nil, err
	}
	rec, _ := scopedModel(r).Where("id", id).One()
	return dbx.ToMap(rec), nil
}

func Delete(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	ids := reqx.Ints(reqx.Merge(r), "ids")
	if id > 0 {
		ids = append(ids, id)
	}
	if len(ids) == 0 {
		return g.Map{}, nil
	}
	// 先用数据权限过滤确认这些记录当前用户可删除，再软删
	m := scopedModel(r).WhereIn("id", ids)
	rows, _ := m.All()
	allowedIDs := make([]int, 0, len(rows))
	for _, rec := range rows {
		allowedIDs = append(allowedIDs, gconv.Int(rec["id"]))
	}
	if len(allowedIDs) == 0 {
		return nil, biz.NotFound("没有可删除的记录")
	}
	return g.Map{}, dbx.SoftDeleteIDs(dao.Table, allowedIDs)
}

func Status(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	m := reqx.Merge(r)
	st := reqx.Int(m, "status")
	// 使用带数据权限的 model
	_, err := scopedModel(r).Where("id", id).Data(g.Map{"status": st, "update_time": dbx.Now()}).Update()
	return g.Map{}, err
}

// ─── 文章分类 CRUD（无数据权限过滤，复用通用 spec）───

func CategoryList(r *ghttp.Request) (interface{}, error)   { return catSpec.List(r) }
func CategoryCreate(r *ghttp.Request) (interface{}, error) { return catSpec.Create(r) }
func CategoryUpdate(r *ghttp.Request) (interface{}, error) { return catSpec.Update(r) }
func CategoryDelete(r *ghttp.Request) (interface{}, error) { return catSpec.Delete(r) }

func BannerList(r *ghttp.Request) (interface{}, error) {
	rows, err := dao.BannerModel().Order("sort desc, id desc").All()
	if err != nil {
		return nil, err
	}
	return dbx.ToMaps(rows), nil
}
