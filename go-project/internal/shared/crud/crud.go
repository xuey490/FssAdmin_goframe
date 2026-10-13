package crud

import (
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"
	"fssadmin/go-project/internal/shared/tenant"
	"fssadmin/go-project/internal/shared/tree"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

type Spec struct {
	Table      string
	Tenant     bool
	Tree       bool
	AsPage     bool
	Like       []string
	Allow      []string
	StatusCol  string
	CreateFill map[string]interface{}
}

func (s Spec) model(r *ghttp.Request) *gdb.Model {
	m := dbx.Alive(dbx.Model(s.Table))
	if s.Tenant {
		// 检查 TenantContext 是否设置了 Ignore（仅 WithIgnore 闭包内才会为 true）
		if !tenant.IsIgnoreRequest(r) {
			u := ctxuser.Get(r)
			if u != nil && u.TenantID > 0 {
				m = dbx.Tenant(m, u.TenantID, "tenant_id")
			}
		}
	}
	return m
}

func (s Spec) List(r *ghttp.Request) (interface{}, error) {
	m := s.model(r)
	q := reqx.Merge(r)
	for _, col := range s.Like {
		m = dbx.FilterLike(m, col, reqx.Str(q, col))
	}
	if st := reqx.Str(q, "status"); st != "" {
		m = m.Where("status", st)
	}
	m = m.Order("id desc")
	if s.Tree {
		rows, err := m.Order("sort asc, id asc").All()
		if err != nil {
			return nil, err
		}
		maps := dbx.ToMaps(rows)
		return tree.Build(maps, "id", "parent_id", "children"), nil
	}
	if s.AsPage {
		pg, limit := page.Parse(r)
		total, _ := m.Clone().Count()
		rows, err := m.Page(pg, limit).All()
		if err != nil {
			return nil, err
		}
		return response.Page(dbx.ToMaps(rows), total, pg, limit), nil
	}
	rows, err := m.All()
	if err != nil {
		return nil, err
	}
	return dbx.ToMaps(rows), nil
}

func (s Spec) Detail(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	rec, err := s.model(r).Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("记录不存在")
	}
	return dbx.ToMap(rec), nil
}

func (s Spec) Create(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	data := g.Map{"create_time": dbx.Now(), "update_time": dbx.Now()}
	if u := ctxuser.Get(r); u != nil {
		data["created_by"] = u.ID
		if s.Tenant && u.TenantID > 0 {
			// tenant_id 从当前用户上下文获取，忽略前端传入
			data["tenant_id"] = u.TenantID
		}
	}
	// 忽略前端传入的 tenant_id（安全：租户 ID 不可由前端控制）
	delete(m, "tenant_id")
	for _, k := range s.Allow {
		if v, ok := m[k]; ok {
			data[k] = v
		}
	}
	for k, v := range s.CreateFill {
		if _, ok := data[k]; !ok {
			data[k] = v
		}
	}
	id, err := dbx.Model(s.Table).Data(data).InsertAndGetId()
	if err != nil {
		return nil, err
	}
	rec, _ := dbx.Alive(dbx.Model(s.Table)).Where("id", id).One()
	return dbx.ToMap(rec), nil
}

func (s Spec) Update(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	m := reqx.Merge(r)
	data := g.Map{"update_time": dbx.Now()}
	if u := ctxuser.Get(r); u != nil {
		data["updated_by"] = u.ID
	}
	for _, k := range s.Allow {
		if v, ok := m[k]; ok {
			data[k] = v
		}
	}
	if _, err := s.model(r).Where("id", id).Data(data).Update(); err != nil {
		return nil, err
	}
	rec, _ := s.model(r).Where("id", id).One()
	return dbx.ToMap(rec), nil
}

func (s Spec) Delete(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	ids := reqx.Ints(reqx.Merge(r), "ids")
	if id > 0 {
		ids = append(ids, id)
	}
	if len(ids) == 0 {
		return g.Map{}, nil
	}
	// 使用带租户校验的批量软删除，修复安全隐患
	if s.Tenant {
		return g.Map{}, dbx.SoftDeleteIDsScopedRequest(r, s.Table, ids)
	}
	return g.Map{}, dbx.SoftDeleteIDs(s.Table, ids)
}

func (s Spec) Status(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	col := s.StatusCol
	if col == "" {
		col = "status"
	}
	m := reqx.Merge(r)
	st := reqx.Int(m, col, "status", "enabled")
	_, err := s.model(r).Where("id", id).Data(g.Map{col: st, "update_time": dbx.Now()}).Update()
	return g.Map{}, err
}

func (s Spec) Enabled(r *ghttp.Request) (interface{}, error) {
	m := s.model(r).Where("status", 1)
	rows, err := m.Order("id asc").All()
	if err != nil {
		return nil, err
	}
	return dbx.ToMaps(rows), nil
}
