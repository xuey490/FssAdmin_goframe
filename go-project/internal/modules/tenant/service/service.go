package service

import (
	"fssadmin/go-project/internal/modules/tenant/dao"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/crud"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

var spec = crud.Spec{Table: dao.Table, AsPage: true, Like: []string{"tenant_name", "tenant_code"}, Allow: []string{"tenant_name", "tenant_code", "contact_name", "contact_phone", "contact_email", "address", "logo_url", "status", "expire_time", "max_users", "max_depts", "max_roles", "remark"}}

func List(r *ghttp.Request) (interface{}, error) {
	// tenant 表本身无 tenant_id 列，用 dao.ScopedModel 做隔离
	m := dao.ScopedModel(r)
	q := reqx.Merge(r)
	m = dbx.FilterLike(m, "tenant_name", reqx.Str(q, "tenant_name"))
	m = dbx.FilterLike(m, "tenant_code", reqx.Str(q, "tenant_code"))
	if st := reqx.Str(q, "status"); st != "" {
		m = m.Where("status", st)
	}
	pg, limit := page.Parse(r)
	total, _ := m.Clone().Count()
	rows, err := m.Order("id desc").Page(pg, limit).All()
	if err != nil {
		return nil, err
	}
	return response.Page(dbx.ToMaps(rows), total, pg, limit), nil
}
func Detail(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	rec, err := dao.ScopedModel(r).Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("租户不存在")
	}
	return dbx.ToMap(rec), nil
}
func Create(r *ghttp.Request) (interface{}, error) { return spec.Create(r) }
func Update(r *ghttp.Request) (interface{}, error) { return spec.Update(r) }
func Delete(r *ghttp.Request) (interface{}, error) { return spec.Delete(r) }
func Status(r *ghttp.Request) (interface{}, error) { return spec.Status(r) }

func Users(r *ghttp.Request) (interface{}, error) {
	tid := gconv.Int(r.Get("id"))
	pg, limit := page.Parse(r)
	q := reqx.Merge(r)
	m := dbx.DB().Model("sa_system_user_tenant ut").
		InnerJoin("sa_system_user u", "u.id=ut.user_id").
		Where("ut.tenant_id", tid).Where("ut.delete_time IS NULL").Where("u.delete_time IS NULL")
	m = dbx.FilterLike(m, "u.username", reqx.Str(q, "username"))
	m = dbx.FilterLike(m, "u.realname", reqx.Str(q, "realname"))
	m = dbx.FilterLike(m, "u.phone", reqx.Str(q, "phone"))
	total, _ := m.Clone().Count()
	rows, _ := m.Fields("ut.id, ut.tenant_id, ut.is_super, ut.is_default, ut.join_time, u.id AS user_id, u.username, u.realname, u.phone, u.email, u.status").
		Order("ut.id desc").Page(pg, limit).All()
	list := dbx.ToMaps(rows)
	for _, item := range list {
		item["user_id"] = gconv.Int(item["user_id"])
		item["is_super"] = gconv.Int(item["is_super"])
		item["is_default"] = gconv.Int(item["is_default"])
		item["status"] = gconv.Int(item["status"])
	}
	return response.Page(list, total, pg, limit), nil
}

func AvailableUsers(r *ghttp.Request) (interface{}, error) {
	tid := gconv.Int(r.Get("id"))
	pg, limit := page.Parse(r)
	m := dbx.Alive(dbx.Model("sa_system_user")).
		Where("id NOT IN (SELECT user_id FROM sa_system_user_tenant WHERE tenant_id=? AND delete_time IS NULL)", tid)
	total, _ := m.Clone().Count()
	rows, _ := m.FieldsEx("password").Page(pg, limit).All()
	return response.Page(dbx.ToMaps(rows), total, pg, limit), nil
}

func AddUsers(r *ghttp.Request) (interface{}, error) {
	tid := gconv.Int(r.Get("id"))
	ids := reqx.Ints(reqx.Merge(r), "user_ids")
	if tid <= 0 || len(ids) == 0 {
		return g.Map{}, nil
	}
	u := ctxuser.Must(r)
	// 批量去重：一次查出已关联的用户，避免循环内逐条 One()+Insert() 的 N+1。
	existRows, _ := dbx.Alive(dbx.Model("sa_system_user_tenant")).
		Where("tenant_id", tid).WhereIn("user_id", ids).Fields("user_id").All()
	exist := map[int]struct{}{}
	for _, rec := range existRows {
		exist[rec["user_id"].Int()] = struct{}{}
	}
	now := dbx.Now()
	for _, uid := range ids {
		if uid <= 0 {
			continue
		}
		if _, ok := exist[uid]; ok {
			continue
		}
		if _, err := dbx.Model("sa_system_user_tenant").Data(g.Map{
			"user_id": uid, "tenant_id": tid, "created_by": u.ID, "create_time": now, "status": 1,
		}).Insert(); err != nil {
			return nil, err
		}
		exist[uid] = struct{}{}
	}
	return g.Map{}, nil
}

func tenantUserID(r *ghttp.Request) int {
	uid := gconv.Int(r.Get("userId"))
	if uid == 0 {
		uid = gconv.Int(r.Get("user_id"))
	}
	if uid == 0 {
		uid = gconv.Int(r.Get("uid"))
	}
	if uid == 0 {
		uid = reqx.Int(reqx.Merge(r), "user_id", "userId", "uid")
	}
	return uid
}

func RemoveUser(r *ghttp.Request) (interface{}, error) {
	tid := gconv.Int(r.Get("id"))
	uid := tenantUserID(r)
	_, err := dbx.Alive(dbx.Model("sa_system_user_tenant")).Where("tenant_id", tid).Where("user_id", uid).Data(g.Map{"delete_time": dbx.Now()}).Update()
	return g.Map{}, err
}

func SetAdmin(r *ghttp.Request) (interface{}, error) {
	tid := gconv.Int(r.Get("id"))
	uid := tenantUserID(r)
	st := reqx.Int(reqx.Merge(r), "is_super")
	_, err := dbx.Alive(dbx.Model("sa_system_user_tenant")).Where("tenant_id", tid).Where("user_id", uid).Data(g.Map{"is_super": st, "update_time": dbx.Now()}).Update()
	return g.Map{}, err
}

func SetDefault(r *ghttp.Request) (interface{}, error) {
	tid := gconv.Int(r.Get("id"))
	uid := tenantUserID(r)
	st := reqx.Int(reqx.Merge(r), "is_default")
	if st == 1 {
		_, _ = dbx.Alive(dbx.Model("sa_system_user_tenant")).Where("user_id", uid).Data(g.Map{"is_default": 0}).Update()
	}
	_, err := dbx.Alive(dbx.Model("sa_system_user_tenant")).Where("tenant_id", tid).Where("user_id", uid).Data(g.Map{"is_default": st, "update_time": dbx.Now()}).Update()
	return g.Map{}, err
}
