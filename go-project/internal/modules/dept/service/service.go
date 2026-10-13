package service

import (
	"fssadmin/go-project/internal/modules/dept/dao"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/cachex"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/tree"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

func loadRows(r *ghttp.Request, enabledOnly bool) ([]map[string]interface{}, error) {
	m := dao.ScopedModel(r)
	q := reqx.Merge(r)
	m = dbx.FilterLike(m, "name", reqx.Str(q, "name", "dept_name"))
	m = dbx.FilterLike(m, "code", reqx.Str(q, "code", "dept_code"))
	if enabledOnly {
		m = m.Where("status", 1)
	} else if st := reqx.Str(q, "status"); st != "" {
		m = m.Where("status", st)
	}
	rows, err := m.Order("sort asc, id asc").All()
	if err != nil {
		return nil, err
	}
	maps := dbx.ToMaps(rows)
	decorate(maps)
	return maps, nil
}

func decorate(rows []map[string]interface{}) {
	ids := make([]int, 0)
	seen := map[int]struct{}{}
	for _, row := range rows {
		lid := gconv.Int(row["leader_id"])
		if lid > 0 {
			if _, ok := seen[lid]; !ok {
				seen[lid] = struct{}{}
				ids = append(ids, lid)
			}
		}
	}
	leaders := map[int]map[string]interface{}{}
	if len(ids) > 0 {
		recs, _ := dbx.Alive(dbx.Model("sa_system_user")).
			Fields("id,username,realname,phone,email,avatar,status").
			WhereIn("id", ids).All()
		for _, rec := range recs {
			item := dbx.ToMap(rec)
			leaders[gconv.Int(item["id"])] = item
		}
	}
	for _, row := range rows {
		lid := gconv.Int(row["leader_id"])
		leader := leaders[lid]
		row["leader"] = leader
		if leader != nil {
			name := gconv.String(leader["realname"])
			if name == "" {
				name = gconv.String(leader["username"])
			}
			row["leader_name"] = name
		} else {
			row["leader_name"] = nil
		}
		row["label"] = row["name"]
		row["value"] = row["id"]
	}
}

func pickLeaderID(v interface{}) interface{} {
	if v == nil {
		return nil
	}
	switch t := v.(type) {
	case map[string]interface{}:
		id := gconv.Int(t["id"])
		if id <= 0 {
			return nil
		}
		return id
	default:
		id := gconv.Int(v)
		if id <= 0 {
			return nil
		}
		return id
	}
}

func List(r *ghttp.Request) (interface{}, error) {
	rows, err := loadRows(r, false)
	if err != nil {
		return nil, err
	}
	return tree.Build(rows, "id", "parent_id", "children"), nil
}

func Tree(r *ghttp.Request) (interface{}, error) { return List(r) }

func AllEnabled(r *ghttp.Request) (interface{}, error) {
	return loadRows(r, true)
}

func AccessDept(r *ghttp.Request) (interface{}, error) {
	u := ctxuser.Get(r)
	tid := 0
	if u != nil {
		tid = u.TenantID
	}
	ctx := r.Context()
	// 尝试命中缓存（仅无搜索参数时）
	if cached, ok := cachex.GetDeptTree(ctx, tid); ok {
		return cached, nil
	}
	rows, err := loadRows(r, true)
	if err != nil {
		return nil, err
	}
	result := tree.Build(rows, "id", "parent_id", "children")
	cachex.SetDeptTree(ctx, tid, result)
	return result, nil
}

func Detail(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	rec, err := dao.ScopedModel(r).Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("部门不存在")
	}
	m := dbx.ToMap(rec)
	decorate([]map[string]interface{}{m})
	return m, nil
}

func Create(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	u := ctxuser.Must(r)
	parentID := reqx.Int(m, "parent_id")
	data := g.Map{
		"parent_id":   parentID,
		"name":        reqx.Str(m, "name"),
		"code":        reqx.Str(m, "code"),
		"leader_id":   pickLeaderID(m["leader_id"]),
		"remark":      reqx.Str(m, "remark"),
		"sort":        reqx.Int(m, "sort"),
		"status":      1,
		"created_by":  u.ID,
		"updated_by":  u.ID,
		"create_time": dbx.Now(),
		"update_time": dbx.Now(),
	}
	if _, ok := m["status"]; ok {
		data["status"] = reqx.Int(m, "status")
	}
	if u.TenantID > 0 {
		data["tenant_id"] = u.TenantID
	}
	if v, ok := m["level"]; ok {
		data["level"] = v
	} else if parentID > 0 {
		parent, _ := dao.Model().Where("id", parentID).One()
		if !parent.IsEmpty() {
			data["level"] = gconv.String(parent["level"]) + gconv.String(parent["id"]) + ","
		}
	} else {
		data["level"] = "0,"
	}
	id, err := dbx.Model(dao.Table).Data(data).InsertAndGetId()
	if err != nil {
		return nil, err
	}
	r.SetParam("id", id)
	cachex.InvalidateDeptTree(r.Context(), u.TenantID)
	return Detail(r)
}

func Update(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	m := reqx.Merge(r)
	u := ctxuser.Must(r)
	data := g.Map{"update_time": dbx.Now(), "updated_by": u.ID}
	for _, k := range []string{"name", "code", "remark", "parent_id", "sort", "status", "level"} {
		if v, ok := m[k]; ok {
			data[k] = v
		}
	}
	if _, ok := m["leader_id"]; ok {
		data["leader_id"] = pickLeaderID(m["leader_id"])
	}
	if _, err := dao.ScopedModel(r).Where("id", id).Data(data).Update(); err != nil {
		return nil, err
	}
	cachex.InvalidateDeptTree(r.Context(), u.TenantID)
	return Detail(r)
}

func Delete(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	u := ctxuser.Get(r)
	tid := 0
	if u != nil {
		tid = u.TenantID
	}
	err := dbx.SoftDeleteScopedRequest(r, dao.Table, id)
	cachex.InvalidateDeptTree(r.Context(), tid)
	return g.Map{}, err
}

func Status(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	st := reqx.Int(reqx.Merge(r), "status")
	_, err := dao.ScopedModel(r).Where("id", id).Data(g.Map{"status": st, "update_time": dbx.Now()}).Update()
	u := ctxuser.Get(r)
	tid := 0
	if u != nil {
		tid = u.TenantID
	}
	cachex.InvalidateDeptTree(r.Context(), tid)
	return g.Map{}, err
}

func Children(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	rows, _ := dao.ScopedModel(r).All()
	byP := map[int][]int{}
	for _, rec := range rows {
		pid := rec["parent_id"].Int()
		byP[pid] = append(byP[pid], rec["id"].Int())
	}
	out := []int{}
	var walk func(int)
	walk = func(pid int) {
		for _, cid := range byP[pid] {
			out = append(out, cid)
			walk(cid)
		}
	}
	walk(id)
	return out, nil
}
