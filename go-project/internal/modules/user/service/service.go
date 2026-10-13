package service

import (
	"strings"

	"fssadmin/go-project/internal/authkit"
	"fssadmin/go-project/internal/modules/user/dao"
	menusvc "fssadmin/go-project/internal/modules/menu/service"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/cachex"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

func List(r *ghttp.Request) (interface{}, error) {
	q := reqx.Merge(r)
	u := ctxuser.Get(r)
	// sa_system_user 表无 tenant_id 列，通过 InnerJoin sa_system_user_tenant 做租户隔离
	// 注意：两表都有 delete_time/status 等同名字段，所有条件必须带表前缀
	m := dbx.Model(dao.Table).InnerJoin("sa_system_user_tenant ut", "ut.user_id = sa_system_user.id").
		WhereNull("sa_system_user.delete_time").
		WhereNull("ut.delete_time")
	if u != nil && u.TenantID > 0 {
		m = m.Where("ut.tenant_id", u.TenantID)
	}
	m = dbx.FilterLike(m, "sa_system_user.username", reqx.Str(q, "username"))
	m = dbx.FilterLike(m, "sa_system_user.realname", reqx.Str(q, "realname", "nickname"))
	if st := reqx.Str(q, "status"); st != "" {
		m = m.Where("sa_system_user.status", st)
	}
	if d := reqx.Int(q, "dept_id"); d > 0 {
		m = m.Where("sa_system_user.dept_id", d)
	}
	pg, limit := page.Parse(r)
	total, _ := m.Clone().Count()
	// 明确指定查询字段，避免 join 后同名字段歧义
	rows, err := m.Fields("sa_system_user.id, sa_system_user.username, sa_system_user.realname, sa_system_user.email, sa_system_user.phone, sa_system_user.avatar, sa_system_user.gender, sa_system_user.dept_id, sa_system_user.status, sa_system_user.is_super, sa_system_user.dashboard, sa_system_user.login_time, sa_system_user.login_ip, sa_system_user.create_time, sa_system_user.update_time, ut.tenant_id").
		Order("sa_system_user.id desc").Page(pg, limit).All()
	if err != nil {
		return nil, err
	}
		list := dbx.ToMaps(rows)
		for _, item := range list {
			fillUser(item, gconv.Int(item["tenant_id"]))
		}
		return response.Page(list, total, pg, limit), nil
	}

	func fillUser(item map[string]interface{}, tid int) {
		id := gconv.Int(item["id"])
		if tid <= 0 {
			tid = gconv.Int(item["tenant_id"])
		}
		if tid <= 0 {
			tid = 1
		}
		item["tenant_id"] = tid
		roles, _ := dbx.DB().Raw(`SELECT r.id,r.name,r.code FROM sa_system_user_role ur JOIN sa_system_role r ON r.id=ur.role_id WHERE ur.user_id=? AND ur.tenant_id=? AND ur.delete_time IS NULL AND r.delete_time IS NULL`, id, tid).All()
		rm := dbx.ToMaps(roles)
		item["roles"] = rm
		item["roleList"] = rm
		item["role_ids"] = idsOf(rm)
		posts, _ := dbx.DB().Raw(`SELECT p.id,p.name,p.code FROM sa_system_user_post up JOIN sa_system_post p ON p.id=up.post_id WHERE up.user_id=? AND up.tenant_id=? AND up.delete_time IS NULL AND p.delete_time IS NULL`, id, tid).All()
		pm := dbx.ToMaps(posts)
		item["posts"] = pm
		item["postList"] = pm
		item["post_ids"] = idsOf(pm)
		item["nickname"] = item["realname"]
		if did := gconv.Int(item["dept_id"]); did > 0 {
			if rec, _ := dbx.Alive(dbx.Model("sa_system_dept")).Where("id", did).One(); !rec.IsEmpty() {
				item["dept"] = dbx.ToMap(rec)
			}
		}
	}

	func idsOf(rows []map[string]interface{}) []int {
		ids := make([]int, 0, len(rows))
		for _, row := range rows {
			if n := gconv.Int(row["id"]); n > 0 {
				ids = append(ids, n)
			}
		}
		return ids
	}

func Selector(r *ghttp.Request) (interface{}, error) {
	return List(r)
}

func Detail(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	rec, err := dao.ScopedModel(r).FieldsEx("password").Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("用户不存在")
	}
		m := dbx.ToMap(rec)
		tid := 0
		if u := ctxuser.Get(r); u != nil {
			tid = u.TenantID
		}
		fillUser(m, tid)
		menus, _ := dbx.Alive(dbx.Model("sa_system_user_menu")).Where("user_id", id).Fields("menu_id").Array()
	ids := []int{}
	for _, v := range menus {
		ids = append(ids, v.Int())
	}
	m["menu_ids"] = ids
	return m, nil
}

func Create(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	username := reqx.Str(m, "username")
	if username == "" {
		return nil, biz.Bad("用户名不能为空")
	}
	exist, _ := dao.ScopedModel(r).Where("username", username).One()
	if !exist.IsEmpty() {
		return nil, biz.Bad("用户名已存在")
	}
	pwd := reqx.Str(m, "password")
	if pwd == "" {
		pwd = "123456"
	}
	h, err := authkit.Hash(pwd)
	if err != nil {
		return nil, err
	}
	u := ctxuser.Must(r)
	tid := u.TenantID
	if tid <= 0 {
		tid = 1
	}
	// sa_system_user 表无 tenant_id 列，租户关联通过 sa_system_user_tenant 实现
	id, err := dbx.Model(dao.Table).Data(g.Map{
		"username": username, "password": h, "realname": reqx.Str(m, "realname", "nickname"),
		"email": reqx.Str(m, "email"), "phone": reqx.Str(m, "phone"), "avatar": reqx.Str(m, "avatar"),
		"gender": reqx.Str(m, "gender"), "dept_id": reqx.Int(m, "dept_id"), "status": 1,
		"is_super": reqx.Int(m, "is_super"), "dashboard": "work",
		"created_by": u.ID, "create_time": dbx.Now(), "update_time": dbx.Now(),
	}).InsertAndGetId()
	if err != nil {
		return nil, err
	}
	if err = saveRels(int(id), tid, u.ID, m); err != nil {
		return nil, err
	}
	cachex.InvalidateUserMenuTree(r.Context(), int(id), u.TenantID)
	r.SetParam("id", id)
	return Detail(r)
}

func Update(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	m := reqx.Merge(r)
	data := g.Map{"update_time": dbx.Now(), "updated_by": ctxuser.Must(r).ID}
	for _, k := range []string{"realname", "email", "phone", "avatar", "gender", "dept_id", "status", "remark", "signed", "dashboard"} {
		if v, ok := m[k]; ok {
			data[k] = v
		}
	}
	if v, ok := m["nickname"]; ok && data["realname"] == nil {
		data["realname"] = v
	}
	if v, ok := m["username"]; ok {
		un := strings.TrimSpace(gconv.String(v))
		if un == "" {
			return nil, biz.Bad("用户名不能为空")
		}
		exist, _ := dao.ScopedModel(r).Where("username", un).WhereNot("id", id).One()
		if !exist.IsEmpty() {
			return nil, biz.Bad("用户名已存在")
		}
		data["username"] = un
	}
	if _, err := dao.ScopedModel(r).Where("id", id).Data(data).Update(); err != nil {
		return nil, err
	}
	u := ctxuser.Must(r)
	if err := saveRels(id, u.TenantID, u.ID, m); err != nil {
		return nil, err
	}
	cachex.InvalidateUserMenuTree(r.Context(), id, u.TenantID)
	return Detail(r)
}

func saveRels(uid, tid, by int, m g.Map) error {
	if tid <= 0 {
		tid = 1
	}
	now := dbx.Now()
	if _, ok := m["role_ids"]; ok {
		if _, err := dbx.Alive(dbx.Model("sa_system_user_role")).Where("user_id", uid).Where("tenant_id", tid).
			Data(g.Map{"delete_time": now}).Update(); err != nil {
			return err
		}
		for _, rid := range reqx.Ints(m, "role_ids") {
			if rid <= 0 {
				continue
			}
			if _, err := dbx.Model("sa_system_user_role").Data(g.Map{
				"user_id": uid, "role_id": rid, "tenant_id": tid, "status": 1,
				"created_by": by, "updated_by": by, "create_time": now, "update_time": now,
			}).Insert(); err != nil {
				return err
			}
		}
	}
	if _, ok := m["post_ids"]; ok {
		if _, err := dbx.Alive(dbx.Model("sa_system_user_post")).Where("user_id", uid).Where("tenant_id", tid).
			Data(g.Map{"delete_time": now}).Update(); err != nil {
			return err
		}
		for _, pid := range reqx.Ints(m, "post_ids") {
			if pid <= 0 {
				continue
			}
			if _, err := dbx.Model("sa_system_user_post").Data(g.Map{
				"user_id": uid, "post_id": pid, "tenant_id": tid, "status": 1,
				"created_by": by, "updated_by": by, "create_time": now, "update_time": now,
			}).Insert(); err != nil {
				return err
			}
		}
	}
	return nil
}

func Delete(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	if id == 1 {
		return nil, biz.Bad("不能删除超级管理员")
	}
	// sa_system_user 表无 tenant_id 列，使用 AssertTenantOwned 通过 user_tenant 关联校验
	if !dbx.AssertTenantOwned(r, dao.Table, id) {
		return nil, biz.NotFound("用户不存在或无权操作")
	}
	u := ctxuser.Get(r)
	tid := 0
	if u != nil {
		tid = u.TenantID
	}
	cachex.InvalidateUserMenuTree(r.Context(), id, tid)
	return g.Map{}, dbx.SoftDelete(dao.Table, id)
}

func Status(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	st := reqx.Int(reqx.Merge(r), "status")
	_, err := dao.ScopedModel(r).Where("id", id).Data(g.Map{"status": st, "update_time": dbx.Now()}).Update()
	return g.Map{}, err
}

func ResetPassword(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	pwd := reqx.Str(reqx.Merge(r), "password")
	if pwd == "" {
		pwd = "123456"
	}
	h, err := authkit.Hash(pwd)
	if err != nil {
		return nil, err
	}
	_, err = dao.ScopedModel(r).Where("id", id).Data(g.Map{"password": h, "update_time": dbx.Now()}).Update()
	authkit.InvalidateUser(id)
	return g.Map{}, err
}

func ChangePassword(r *ghttp.Request) (interface{}, error) {
	return ResetPassword(r)
}

func ClearCache(r *ghttp.Request) (interface{}, error) {
	authkit.InvalidateUser(gconv.Int(r.Get("id")))
	return g.Map{}, nil
}

func SetHomePage(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	dash := reqx.Str(reqx.Merge(r), "dashboard")
	_, err := dao.ScopedModel(r).Where("id", id).Data(g.Map{"dashboard": dash, "update_time": dbx.Now()}).Update()
	return g.Map{}, err
}

func GetMenus(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	u := ctxuser.Must(r)
	tid := u.TenantID
	if tid <= 0 {
		tid = 1
	}
	rows, err := dbx.Alive(dbx.Model("sa_system_user_menu")).
		Where("user_id", id).Where("tenant_id", tid).Fields("menu_id").All()
	if err != nil {
		return nil, err
	}
	ids := make([]int, 0, len(rows))
	for _, rec := range rows {
		if mid := rec["menu_id"].Int(); mid > 0 {
			ids = append(ids, mid)
		}
	}
	return ids, nil
}

func SaveMenus(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	u := ctxuser.Must(r)
	ids := menusvc.ExpandParents(reqx.Ints(reqx.Merge(r), "menu_ids"))
	tid := u.TenantID
	if tid <= 0 {
		tid = 1
	}
	if _, err := dbx.Model("sa_system_user_menu").Where("user_id", id).Where("tenant_id", tid).Delete(); err != nil {
		return nil, err
	}
	now := dbx.Now()
	for _, mid := range ids {
		if mid <= 0 {
			continue
		}
		if _, err := dbx.Model("sa_system_user_menu").Data(g.Map{
			"user_id": id, "menu_id": mid, "tenant_id": tid, "status": 1,
			"created_by": u.ID, "updated_by": u.ID, "create_time": now, "update_time": now,
		}).Insert(); err != nil {
			return nil, err
		}
	}
	cachex.InvalidateUserMenuTree(r.Context(), id, u.TenantID)
	return g.Map{}, nil
}
