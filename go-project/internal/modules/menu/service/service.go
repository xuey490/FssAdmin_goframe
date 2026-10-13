package service

import (
	"strings"

	"fssadmin/go-project/internal/modules/menu/dao"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/cachex"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/tree"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gctx"
	"github.com/gogf/gf/v2/util/gconv"
)

var typeName = map[int]string{1: "目录", 2: "菜单", 3: "按钮", 4: "外链"}

func format(m map[string]interface{}) map[string]interface{} {
	t := gconv.Int(m["type"])
	st := gconv.Int(m["status"])
	m["status_text"] = map[int]string{1: "启用", 0: "停用"}[st]
	if m["status_text"] == "" {
		m["status_text"] = "启用"
	}
	hid := gconv.Int(m["is_hidden"])
	if hid == 1 {
		m["visible_text"] = "隐藏"
	} else {
		m["visible_text"] = "显示"
	}
	m["menu_type_name"] = typeName[t]
	if m["menu_type_name"] == "" {
		m["menu_type_name"] = "未知"
	}
	m["value"] = m["id"]
	m["label"] = m["name"]
	return m
}

func List(r *ghttp.Request) (interface{}, error) {
	rows, err := dao.All()
	if err != nil {
		return nil, err
	}
	maps := make([]map[string]interface{}, 0)
	for _, rec := range dbx.ToMaps(rows) {
		maps = append(maps, format(rec))
	}
	out := tree.Build(maps, "id", "parent_id", "children")
	q := reqx.Merge(r)
	name, path, status := reqx.Str(q, "name"), reqx.Str(q, "path"), reqx.Str(q, "status")
	if name == "" && path == "" && status == "" {
		return out, nil
	}
	return filterTree(out, name, path, status), nil
}

func filterTree(nodes []map[string]interface{}, name, path, status string) []map[string]interface{} {
	var out []map[string]interface{}
	for _, item := range nodes {
		kids, _ := item["children"].([]map[string]interface{})
		fkids := filterTree(kids, name, path, status)
		nameOK := name == "" || strings.Contains(strings.ToLower(gconv.String(item["name"])), strings.ToLower(name))
		pathOK := path == "" || strings.Contains(strings.ToLower(gconv.String(item["path"])), strings.ToLower(path))
		statusOK := status == "" || gconv.String(item["status"]) == status
		if (nameOK && pathOK && statusOK) || len(fkids) > 0 {
			node := item
			if len(fkids) > 0 {
				node["children"] = fkids
			} else {
				delete(node, "children")
			}
			out = append(out, node)
		}
	}
	return out
}

func Tree(r *ghttp.Request) (interface{}, error) { return navTree(ctxuser.Must(r), false) }

func UserTree(r *ghttp.Request) (interface{}, error) {
	return UserMenuTree(ctxuser.Must(r))
}

func UserMenuTree(u *ctxuser.User) ([]map[string]interface{}, error) {
	ctx := gctx.New()
	// 尝试命中缓存
	if cached, ok := cachex.GetMenuTree(ctx, u.ID, u.TenantID); ok {
		return cached, nil
	}
	data, err := navTree(u, true)
	if err != nil {
		return nil, err
	}
	cachex.SetMenuTree(ctx, u.ID, u.TenantID, data)
	return data, nil
}

func navTree(u *ctxuser.User, onlyUser bool) ([]map[string]interface{}, error) {
	ids := MergedMenuIDs(u)
	if len(ids) == 0 {
		return []map[string]interface{}{}, nil
	}
	if !u.IsSuper {
		ids = ExpandParents(ids)
	}
	// 只渲染未隐藏（is_hidden=2）的菜单；status=1 启用；type 1目录/2菜单/4外链
	hiddenCond := "is_hidden=2"
	q := dao.Model().WhereIn("id", ids).Where("status", 1).Where(hiddenCond).WhereIn("type", g.Slice{1, 2, 4}).Order("sort asc, id asc")
	if !onlyUser {
		q = dao.Model().Where("status", 1).Where(hiddenCond).WhereIn("type", g.Slice{1, 2, 4}).Order("sort asc, id asc")
	}
	rows, err := q.All()
	if err != nil {
		return nil, err
	}
	maps := []map[string]interface{}{}
	for _, rec := range dbx.ToMaps(rows) {
		maps = append(maps, format(rec))
	}
	return tree.Build(maps, "id", "parent_id", "children"), nil
}

func UserPermissions(u *ctxuser.User) []string {
	if u.IsSuper {
		return []string{"*"}
	}
	ctx := gctx.New()
	if cached, ok := cachex.GetPerms(ctx, u.ID, u.TenantID); ok {
		return cached
	}
	ids := MergedMenuIDs(u)
	if len(ids) == 0 {
		return []string{}
	}
	arr, _ := dao.Model().WhereIn("id", ids).Where("status", 1).Where("slug IS NOT NULL AND slug<>''").Fields("slug").Array()
	out := []string{}
	seen := map[string]struct{}{}
	for _, v := range arr {
		s := v.String()
		if s == "" {
			continue
		}
		if _, ok := seen[s]; ok {
			continue
		}
		seen[s] = struct{}{}
		out = append(out, s)
	}
	cachex.SetPerms(ctx, u.ID, u.TenantID, out)
	return out
}

func Perms(r *ghttp.Request) (interface{}, error) {
	return UserPermissions(ctxuser.Must(r)), nil
}

func PermissionTree(r *ghttp.Request) (interface{}, error) {
	rows, err := dao.AllEnabled()
	if err != nil {
		return nil, err
	}
	maps := []map[string]interface{}{}
	for _, rec := range dbx.ToMaps(rows) {
		maps = append(maps, format(rec))
	}
	return tree.Build(maps, "id", "parent_id", "children"), nil
}

func AccessMenu(r *ghttp.Request) (interface{}, error) {
	return PermissionTree(r)
}

func AssignableTree(r *ghttp.Request) (interface{}, error) {
	return PermissionTree(r)
}

func Detail(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	rec, err := dao.One(id)
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("菜单不存在")
	}
	return format(dbx.ToMap(rec)), nil
}

func Create(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	u := ctxuser.Must(r)
	data := g.Map{
		"parent_id": reqx.Int(m, "parent_id"), "name": reqx.Str(m, "name"),
		"code": reqx.Str(m, "code"), "slug": reqx.Str(m, "slug"),
		"type": reqx.Int(m, "type"), "path": reqx.Str(m, "path"),
		"component": reqx.Str(m, "component"), "icon": reqx.Str(m, "icon"),
		"sort": reqx.Int(m, "sort"), "link_url": reqx.Str(m, "link_url"),
		"is_iframe": reqx.Int(m, "is_iframe"), "is_keep_alive": reqx.Int(m, "is_keep_alive"),
		"is_hidden": reqx.Int(m, "is_hidden"), "is_fixed_tab": reqx.Int(m, "is_fixed_tab"),
		"status": 1, "created_by": u.ID, "create_time": dbx.Now(), "update_time": dbx.Now(),
	}
	if data["type"] == 0 {
		data["type"] = 2
	}
	id, err := dao.Model().Data(data).InsertAndGetId()
	if err != nil {
		return nil, err
	}
	cachex.InvalidateAllMenuTree(r.Context())
	return DetailID(int(id))
}

func Update(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	m := reqx.Merge(r)
	data := g.Map{"update_time": dbx.Now(), "updated_by": ctxuser.Must(r).ID}
	for _, k := range []string{"parent_id", "name", "code", "slug", "type", "path", "component", "icon", "sort", "link_url", "is_iframe", "is_keep_alive", "is_hidden", "is_fixed_tab", "status", "remark"} {
		if v, ok := m[k]; ok {
			data[k] = v
		}
	}
	if _, err := dao.Model().Where("id", id).Data(data).Update(); err != nil {
		return nil, err
	}
	cachex.InvalidateAllMenuTree(r.Context())
	return DetailID(id)
}

func Delete(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	err := dbx.SoftDelete(dao.Table, id)
	cachex.InvalidateAllMenuTree(r.Context())
	return g.Map{}, err
}

func Status(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	st := reqx.Int(reqx.Merge(r), "status")
	_, err := dao.Model().Where("id", id).Data(g.Map{"status": st, "update_time": dbx.Now()}).Update()
	cachex.InvalidateAllMenuTree(r.Context())
	return g.Map{}, err
}

func DetailID(id int) (interface{}, error) {
	rec, err := dao.One(id)
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("菜单不存在")
	}
	return format(dbx.ToMap(rec)), nil
}

func MergedMenuIDs(u *ctxuser.User) []int {
	ctx := gctx.New()
	if cached, ok := cachex.GetMenuIDs(ctx, u.ID, u.TenantID); ok {
		return cached
	}
	ids := mergedMenuIDsDB(u)
	if len(ids) > 0 {
		cachex.SetMenuIDs(ctx, u.ID, u.TenantID, ids)
	}
	return ids
}

// mergedMenuIDsDB 从数据库查询用户合并后的菜单 ID 集合（原始逻辑）。
func mergedMenuIDsDB(u *ctxuser.User) []int {
	if u.IsSuper {
		arr, _ := dao.Model().Where("status", 1).Where("is_hidden", 2).Fields("id").Array()
		ids := make([]int, 0, len(arr))
		for _, v := range arr {
			ids = append(ids, v.Int())
		}
		return ids
	}
	set := map[int]struct{}{}
	if u.TenantID > 0 {
		roleIDs, _ := dbx.Alive(dbx.Model("sa_system_user_role")).Where("user_id", u.ID).Where("tenant_id", u.TenantID).Fields("role_id").Array()
		rids := []int{}
		for _, v := range roleIDs {
			rids = append(rids, v.Int())
		}
		if len(rids) > 0 {
			mids, _ := dbx.Model("sa_system_role_menu").WhereIn("role_id", rids).Fields("menu_id").Array()
			for _, v := range mids {
				set[v.Int()] = struct{}{}
			}
		}
		um, _ := dbx.Alive(dbx.Model("sa_system_user_menu")).Where("user_id", u.ID).Where("tenant_id", u.TenantID).Fields("menu_id").Array()
		for _, v := range um {
			set[v.Int()] = struct{}{}
		}
	}
	ids := make([]int, 0, len(set))
	for id := range set {
		ids = append(ids, id)
	}
	return ids
}

func ExpandParents(ids []int) []int {
	rows, _ := dao.All()
	byID := map[int]int{}
	for _, rec := range rows {
		byID[rec["id"].Int()] = rec["parent_id"].Int()
	}
	set := map[int]struct{}{}
	for _, id := range ids {
		set[id] = struct{}{}
		cur := id
		for i := 0; i < 20; i++ {
			pid := byID[cur]
			if pid <= 0 {
				break
			}
			if _, ok := set[pid]; ok {
				break
			}
			set[pid] = struct{}{}
			cur = pid
		}
	}
	out := make([]int, 0, len(set))
	for id := range set {
		out = append(out, id)
	}
	return out
}
