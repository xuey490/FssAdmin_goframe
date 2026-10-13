package service

import (
	"context"
	"sort"
	"strings"

	"fssadmin/go-project/internal/authkit"
	"fssadmin/go-project/internal/modules/monitor/models"
	"fssadmin/go-project/internal/shared/cachex"
	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/iploc"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

func OnlineList(r *ghttp.Request) (interface{}, error) {
	ctx := r.Context()
	rows := onlineRows(ctx)
	q := reqx.Merge(r)

	// 过滤：登录账号 / 登录地址（与 Python 版一致，包含匹配）
	if kw := strings.ToLower(reqx.Str(q, "userName", "username", "user_name")); kw != "" {
		rows = filterOnline(rows, func(row models.OnlineRow) bool {
			return strings.Contains(strings.ToLower(row.UserName), kw)
		})
	}
	if kw := reqx.Str(q, "ipaddr", "ip"); kw != "" {
		rows = filterOnline(rows, func(row models.OnlineRow) bool {
			return strings.Contains(row.IPAddr, kw)
		})
	}

	sortOnline(rows, reqx.Str(q, "orderField", "orderBy", "sortField"),
		reqx.Str(q, "orderType", "order", "sortOrder"))

	pg, limit := page.Parse(r)
	total := len(rows)
	start := (pg - 1) * limit
	if start > total {
		start = total
	}
	end := start + limit
	if end > total {
		end = total
	}
	return response.Page(rows[start:end], total, pg, limit), nil
}

// onlineRows 把 Redis 会话映射成前端行，并补全「所属部门」与「登录地点」。
func onlineRows(ctx context.Context) []models.OnlineRow {
	sessions := authkit.ListSessions()
	rows := make([]models.OnlineRow, 0, len(sessions))
	for _, s := range sessions {
		if len(s) == 0 {
			continue
		}
		row := rowFromSession(s)
		// 开关关闭时覆盖会话里旧的查询结果；开启时只补空值和「查询中」
		if !conf.IPLocationEnable() {
			if v := iploc.Sync(ctx, row.IPAddr); v != "" {
				row.LoginLocation = v
			}
		} else if row.LoginLocation == "" || row.LoginLocation == iploc.LocationResolving {
			if v := iploc.Sync(ctx, row.IPAddr); v != "" {
				row.LoginLocation = v
			}
		}
		rows = append(rows, row)
	}
	fillDeptNames(rows)
	return rows
}

// rowFromSession 把 Redis 会话字典映射成前端行（兼容 camelCase / snake_case）。
func rowFromSession(s map[string]interface{}) models.OnlineRow {
	return models.OnlineRow{
		TokenID:       pick(s, "tokenId", "session_id", "jti"),
		UserName:      pick(s, "userName", "user_name", "username"),
		DeptName:      pick(s, "deptName", "dept_name"),
		IPAddr:        pick(s, "ipaddr", "ip", "loginIp"),
		LoginLocation: pick(s, "loginLocation", "login_location"),
		OS:            pick(s, "os"),
		Browser:       pick(s, "browser"),
		LoginTime:     pick(s, "loginTime", "login_time"),
		UserID:        gconv.Int(s["user_id"]),
		TenantID:      gconv.Int(s["tenant_id"]),
	}
}

// pick 按优先级取会话字段（兼容 camelCase / snake_case 两种写入方式）。
func pick(session map[string]interface{}, keys ...string) string {
	for _, k := range keys {
		v, ok := session[k]
		if !ok || v == nil {
			continue
		}
		if s := strings.TrimSpace(gconv.String(v)); s != "" {
			return s
		}
	}
	return ""
}

// fillDeptNames 批量补全部门名：优先「用户-部门」关联表（按租户匹配），回退用户主归属部门。
func fillDeptNames(rows []models.OnlineRow) {
	need := map[int]bool{}
	for _, row := range rows {
		if row.DeptName == "" && row.UserID > 0 {
			need[row.UserID] = true
		}
	}
	if len(need) == 0 {
		return
	}
	ids := make([]int, 0, len(need))
	for id := range need {
		ids = append(ids, id)
	}

	// 用户 → 部门（同租户优先，其次任意关联）
	tenantOf := map[int]int{}
	for _, row := range rows {
		if row.TenantID > 0 && tenantOf[row.UserID] == 0 {
			tenantOf[row.UserID] = row.TenantID
		}
	}
	links, _ := dbx.Alive(dbx.Model("sa_system_user_dept")).
		Fields("user_id, tenant_id, dept_id").WhereIn("user_id", ids).Order("id asc").All()
	deptIDs := make([]int, 0, len(links))
	deptOf := map[int]int{}    // user_id -> dept_id（租户精确匹配优先）
	deptOfAny := map[int]int{} // user_id -> dept_id（任意租户兜底）
	for _, link := range links {
		uid, did := link["user_id"].Int(), link["dept_id"].Int()
		if did == 0 {
			continue
		}
		if _, ok := deptOfAny[uid]; !ok {
			deptOfAny[uid] = did
		}
		if row, ok := tenantOf[uid]; ok && row == link["tenant_id"].Int() {
			deptOf[uid] = did
		}
		deptIDs = append(deptIDs, did)
	}

	// 回退：用户主归属部门
	missing := make([]int, 0, len(ids))
	for _, id := range ids {
		if _, ok := deptOf[id]; !ok {
			if _, ok := deptOfAny[id]; !ok {
				missing = append(missing, id)
			}
		}
	}
	if len(missing) > 0 {
		users, _ := dbx.Alive(dbx.Model("sa_system_user")).
			Fields("id, dept_id").WhereIn("id", missing).All()
		for _, u := range users {
			if did := u["dept_id"].Int(); did > 0 {
				deptOfAny[u["id"].Int()] = did
				deptIDs = append(deptIDs, did)
			}
		}
	}

	names := map[int]string{}
	if len(deptIDs) > 0 {
		depts, _ := dbx.Alive(dbx.Model("sa_system_dept")).Fields("id, name").WhereIn("id", deptIDs).All()
		for _, d := range depts {
			names[d["id"].Int()] = d["name"].String()
		}
	}

	for i := range rows {
		if rows[i].DeptName != "" {
			continue
		}
		uid := rows[i].UserID
		did := deptOf[uid]
		if did == 0 {
			did = deptOfAny[uid]
		}
		rows[i].DeptName = names[did]
	}
}

// sortOnline 按 loginTime（默认）/ userName / ipaddr 排序。
func sortOnline(rows []models.OnlineRow, field, order string) {
	desc := !strings.EqualFold(order, "asc")
	value := func(row models.OnlineRow) string { return row.LoginTime }
	switch field {
	case "userName":
		value = func(row models.OnlineRow) string { return row.UserName }
	case "ipaddr":
		value = func(row models.OnlineRow) string { return row.IPAddr }
	}
	sort.SliceStable(rows, func(i, j int) bool {
		a, b := value(rows[i]), value(rows[j])
		if desc {
			return a > b
		}
		return a < b
	})
}

func filterOnline(rows []models.OnlineRow, keep func(models.OnlineRow) bool) []models.OnlineRow {
	out := rows[:0]
	for _, row := range rows {
		if keep(row) {
			out = append(out, row)
		}
	}
	return out
}

func ForceLogout(r *ghttp.Request) (interface{}, error) {
	token := r.Get("token").String()
	authkit.DeleteSession(token)
	return g.Map{}, nil
}

func ServerMonitor(r *ghttp.Request) (interface{}, error) {
	return serverSnapshot(), nil
}

func CacheList(r *ghttp.Request) (interface{}, error) {
	return RedisInfo(r)
}

func CacheClear(r *ghttp.Request) (interface{}, error) {
	n := cachex.Clear(r.Context())
	return g.Map{"cleared": g.Map{"deleted": n}, "message": "缓存已清理"}, nil
}
