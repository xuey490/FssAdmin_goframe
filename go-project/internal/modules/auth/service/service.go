package service

import (
	"context"
	"strings"
	"time"

	"fssadmin/go-project/internal/authkit"
	"fssadmin/go-project/internal/modules/auth/dao"
	menusvc "fssadmin/go-project/internal/modules/menu/service"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/cachex"
	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/iploc"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

func Captcha(r *ghttp.Request) (interface{}, error) {
	uuid := authkit.RandomHex(16)
	if !conf.CaptchaEnable() {
		return g.Map{"result": 0, "uuid": uuid, "image": "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"}, nil
	}
	code := authkit.RandomCode(4)
	authkit.SetCaptcha(uuid, code)
	return g.Map{"result": 1, "uuid": uuid, "image": authkit.ImageDataURI(code)}, nil
}

func parseUA(ua string) (osName, browser string) {
	l := strings.ToLower(ua)
	switch {
	case strings.Contains(l, "windows"):
		osName = "Windows"
	case strings.Contains(l, "android"):
		osName = "Android"
	case strings.Contains(l, "iphone"), strings.Contains(l, "ipad"):
		osName = "iOS"
	case strings.Contains(l, "mac os"), strings.Contains(l, "macintosh"):
		osName = "Mac OS"
	case strings.Contains(l, "linux"):
		osName = "Linux"
	default:
		osName = "Unknown"
	}
	switch {
	case strings.Contains(l, "edg/"):
		browser = "Edge"
	case strings.Contains(l, "chrome"):
		browser = "Chrome"
	case strings.Contains(l, "firefox"):
		browser = "Firefox"
	case strings.Contains(l, "safari"):
		browser = "Safari"
	default:
		browser = "Unknown"
	}
	return
}

func tenantValid(t g.Map) bool {
	if gconv.Int(t["status"]) != 1 {
		return false
	}
	exp := gconv.String(t["expire_time"])
	if exp == "" {
		return true
	}
	tm, err := time.ParseInLocation("2006-01-02 15:04:05", exp, time.Local)
	if err != nil {
		return true
	}
	return tm.After(time.Now())
}

func Login(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	username := reqx.Str(m, "username")
	password := reqx.Str(m, "password")
	tenantID := reqx.Int(m, "tenant_id")
	ip := reqx.ClientIP(r)
	osName, browser := parseUA(r.Header.Get("User-Agent"))
	// 归属地只在这里取一次：内网/缓存命中立即有值，未命中返回「归属地查询中」并异步补齐
	location := iploc.Sync(r.Context(), ip)
	if username == "" || password == "" {
		return nil, biz.Bad("用户名和密码不能为空")
	}
	if tenantID == 0 {
		return nil, biz.Bad("租户ID不能为空")
	}
	if conf.CaptchaEnable() && !authkit.VerifyCaptcha(reqx.Str(m, "uuid"), reqx.Str(m, "code")) {
		return nil, biz.Bad("验证码错误或已过期")
	}
	user, err := dao.UserByName(username)
	if err != nil || user.IsEmpty() || !authkit.Check(password, user["password"].String()) {
		dao.WriteLoginLog(username, ip, osName, browser, location, "用户名或密码错误", 2)
		return nil, biz.Bad("用户名或密码错误")
	}
	if user["status"].Int() != 1 {
		dao.WriteLoginLog(username, ip, osName, browser, location, "账号已被禁用", 2)
		return nil, biz.Forbidden("账号已被禁用")
	}
	isSuper := user["is_super"].Int() == 1
	if !isSuper {
		ut, _ := dao.UserTenant(user["id"].Int(), tenantID)
		if ut.IsEmpty() {
			dao.WriteLoginLog(username, ip, osName, browser, location, "您不属于该租户", 2)
			return nil, biz.Forbidden("您不属于该租户")
		}
	}
	ten, _ := dao.TenantByID(tenantID)
	if ten.IsEmpty() || !tenantValid(dbx.ToMap(ten)) {
		dao.WriteLoginLog(username, ip, osName, browser, location, "租户无效或已过期", 2)
		return nil, biz.Forbidden("租户无效或已过期")
	}
	_, _ = dbx.Alive(dbx.Model("sa_system_user")).Where("id", user["id"].Int()).Data(g.Map{
		"login_time": dbx.Now(), "login_ip": ip,
	}).Update()
	dao.WriteLoginLog(username, ip, osName, browser, location, "登录成功", 1)
	return issue(r.Context(), dbx.ToMap(user), tenantID, ip, osName, browser)
}

func issue(ctx context.Context, user g.Map, tenantID int, ip, osName, browser string) (g.Map, error) {
	uid := gconv.Int(user["id"])
	isSuper := gconv.Int(user["is_super"]) == 1
	realname := gconv.String(user["realname"])
	if realname == "" {
		realname = gconv.String(user["username"])
	}
	pair, err := authkit.Issue(authkit.IssueCtx{
		UID: uid, Username: gconv.String(user["username"]), Nickname: realname,
		TenantID: tenantID, Roles: dao.RoleCodes(uid, tenantID, isSuper),
		IsSuper: isSuper, IP: ip, OS: osName, Browser: browser,
		// 在线用户列表的「所属部门」「登录地点」两列
		DeptName:      dao.DeptName(uid, tenantID),
		LoginLocation: iploc.Sync(ctx, ip),
	})
	if err != nil {
		return nil, err
	}
	u := &ctxuser.User{ID: uid, Username: gconv.String(user["username"]), Realname: realname, IsSuper: isSuper, TenantID: tenantID, Status: 1}
	menus, _ := menusvc.UserMenuTree(u)
	perms := menusvc.UserPermissions(u)
	return g.Map{
		"access_token": pair.AccessToken, "refresh_token": pair.RefreshToken,
		"token_type": pair.TokenType, "expires_in": pair.ExpiresIn, "tenant_id": tenantID,
		"user":  g.Map{"id": uid, "username": u.Username, "nickname": realname, "avatar": gconv.String(user["avatar"]), "is_admin": isSuper},
		"menus": menus, "permissions": perms,
	}, nil
}

func Refresh(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	rt := reqx.Str(m, "refreshToken", "refresh_token")
	uid, _, err := authkit.ResolveRefresh(rt)
	if err != nil || uid == 0 {
		return nil, biz.Unauthorized("刷新令牌无效")
	}
	user, err := dao.UserByID(uid)
	if err != nil || user.IsEmpty() {
		return nil, biz.Unauthorized("用户不存在")
	}
	tid := 0
	uts, _ := dao.UserTenants(uid)
	for _, rec := range uts {
		if rec["is_default"].Int() == 1 {
			tid = rec["id"].Int()
			break
		}
	}
	if tid == 0 && len(uts) > 0 {
		tid = uts[0]["id"].Int()
	}
	out, err := issue(r.Context(), dbx.ToMap(user), tid, reqx.ClientIP(r), "", "")
	if err != nil {
		return nil, err
	}
	return out, nil
}

func Logout(r *ghttp.Request) (interface{}, error) {
	u := ctxuser.Get(r)
	if u != nil {
		authkit.Invalidate(u.Token)
	}
	return g.Map{}, nil
}

func TenantsByUsername(r *ghttp.Request) (interface{}, error) {
	username := strings.TrimSpace(r.Get("username").String())
	if username == "" {
		return []interface{}{}, nil
	}
	user, err := dao.UserByName(username)
	if err != nil || user.IsEmpty() {
		return []interface{}{}, nil
	}
	rows, _ := dao.UserTenants(user["id"].Int())
	return dbx.ToMaps(rows), nil
}

func SwitchTenant(r *ghttp.Request) (interface{}, error) {
	u := ctxuser.Must(r)
	tid := reqx.Int(reqx.Merge(r), "tenant_id")
	if !u.IsSuper {
		ut, _ := dao.UserTenant(u.ID, tid)
		if ut.IsEmpty() {
			return nil, biz.Forbidden("您不属于该租户")
		}
	}
	ten, _ := dao.TenantByID(tid)
	if ten.IsEmpty() || !tenantValid(dbx.ToMap(ten)) {
		return nil, biz.Forbidden("租户无效或已过期")
	}
	_, _ = dbx.Alive(dbx.Model("sa_system_user_tenant")).Where("user_id", u.ID).Data(g.Map{"is_default": 0}).Update()
	_, _ = dbx.Alive(dbx.Model("sa_system_user_tenant")).Where("user_id", u.ID).Where("tenant_id", tid).Data(g.Map{"is_default": 1}).Update()
	user, _ := dao.UserByID(u.ID)
	out, err := issue(r.Context(), dbx.ToMap(user), tid, reqx.ClientIP(r), "", "")
	if err != nil {
		return nil, err
	}
	out["tenant_name"] = ten["tenant_name"].String()
	return out, nil
}

func CurrentUser(r *ghttp.Request) (interface{}, error) {
	u := ctxuser.Must(r)
	user, err := dao.UserByID(u.ID)
	if err != nil || user.IsEmpty() {
		return nil, biz.Unauthorized("用户不存在")
	}
	m := dbx.ToMap(user)
	perms := menusvc.UserPermissions(u)
	roles := dao.RoleCodes(u.ID, u.TenantID, u.IsSuper)
	var dept interface{}
	if gconv.Int(m["dept_id"]) > 0 {
		d, _ := dbx.Alive(dbx.Model("sa_system_dept")).Where("id", m["dept_id"]).One()
		if !d.IsEmpty() {
			dept = g.Map{"id": d["id"].Int(), "name": d["name"].String()}
		}
	}
	var tenant interface{}
	if u.TenantID > 0 {
		t, _ := dao.TenantByID(u.TenantID)
		if !t.IsEmpty() {
			tenant = g.Map{"id": t["id"].Int(), "name": t["tenant_name"].String(), "code": t["tenant_code"].String()}
		}
	}
	buttons := perms
	if u.IsSuper {
		buttons = []string{"*"}
	}
	return g.Map{
		"id": m["id"], "username": m["username"], "nickname": gconv.String(m["realname"]),
		"realname": m["realname"], "email": m["email"], "phone": m["phone"], "avatar": m["avatar"],
		"gender": m["gender"], "signed": m["signed"], "remark": m["remark"],
		"dashboard": m["dashboard"], "login_time": m["login_time"], "login_ip": m["login_ip"],
		"is_admin": u.IsSuper, "buttons": buttons, "roles": roles, "department": dept, "posts": []interface{}{}, "tenant": tenant,
	}, nil
}

func UserMenus(r *ghttp.Request) (interface{}, error) {
	return menusvc.UserMenuTree(ctxuser.Must(r))
}

func Permissions(r *ghttp.Request) (interface{}, error) {
	return menusvc.UserPermissions(ctxuser.Must(r)), nil
}

func DictAll(r *ghttp.Request) (interface{}, error) {
	return cachex.DictAll(r.Context())
}

func UpdateInfo(r *ghttp.Request) (interface{}, error) {
	u := ctxuser.Must(r)
	m := reqx.Merge(r)
	data := g.Map{"update_time": dbx.Now()}
	for _, k := range []string{"realname", "email", "phone", "avatar", "gender", "signed", "remark"} {
		if v, ok := m[k]; ok {
			data[k] = v
		}
	}
	_, err := dbx.Alive(dbx.Model("sa_system_user")).Where("id", u.ID).Data(data).Update()
	return g.Map{}, err
}

func ModifyPassword(r *ghttp.Request) (interface{}, error) {
	u := ctxuser.Must(r)
	m := reqx.Merge(r)
	old := reqx.Str(m, "old_password", "oldPassword", "password")
	nw := reqx.Str(m, "new_password", "newPassword")
	user, _ := dao.UserByID(u.ID)
	if !authkit.Check(old, user["password"].String()) {
		return nil, biz.Bad("原密码错误")
	}
	h, err := authkit.Hash(nw)
	if err != nil {
		return nil, err
	}
	_, err = dbx.Alive(dbx.Model("sa_system_user")).Where("id", u.ID).Data(g.Map{"password": h, "update_time": dbx.Now()}).Update()
	return g.Map{}, err
}

func PersonalLogs(table string) func(r *ghttp.Request) (interface{}, error) {
	return func(r *ghttp.Request) (interface{}, error) {
		u := ctxuser.Must(r)
		pg, limit := page.Parse(r)
		m := dbx.Alive(dbx.Model(table)).Where("username", u.Username)
		total, _ := m.Clone().Count()
		rows, _ := m.Order("id desc").Page(pg, limit).All()
		return response.Page(dbx.ToMaps(rows), total, pg, limit), nil
	}
}

func ClearCache(r *ghttp.Request) (interface{}, error) {
	n := cachex.Clear(r.Context())
	cachex.Warm(r.Context())
	return g.Map{"deleted": n}, nil
}

func PublicConfig(r *ghttp.Request) (interface{}, error) {
	key := r.Get("key").String()
	if val, ok := cachex.ConfigValue(r.Context(), key); ok {
		return g.Map{"key": key, "value": val}, nil
	}
	rec, _ := dbx.Alive(dbx.Model("sa_system_config")).Where("`key`", key).One()
	val := ""
	if !rec.IsEmpty() {
		val = rec["value"].String()
	}
	return g.Map{"key": key, "value": val}, nil
}

func Statistics(r *ghttp.Request) (interface{}, error) {
	user, _ := dbx.Alive(dbx.Model("sa_system_user")).Count()
	attach, _ := dbx.Alive(dbx.Model("sa_system_attachment")).Count()
	login, _ := dbx.Alive(dbx.Model("sa_system_login_log")).Count()
	operate, _ := dbx.Alive(dbx.Model("sa_system_oper_log")).Count()
	return g.Map{"user": user, "attach": attach, "login": login, "operate": operate}, nil
}

func LoginChart(r *ghttp.Request) (interface{}, error) {
	rows, _ := dbx.DB().Raw(`SELECT DATE(login_time) AS d, COUNT(*) AS c FROM sa_system_login_log WHERE delete_time IS NULL AND login_time>=DATE_SUB(CURDATE(), INTERVAL 29 DAY) GROUP BY DATE(login_time)`).All()
	counts := map[string]int{}
	for _, rec := range rows {
		counts[ymd(rec["d"].String())] = rec["c"].Int()
	}
	dates, vals := loginChartSeries(time.Now(), counts)
	return g.Map{"login_date": dates, "login_count": vals}, nil
}

func LoginBarChart(r *ghttp.Request) (interface{}, error) {
	rows, _ := dbx.DB().Raw(`SELECT DATE_FORMAT(login_time,'%Y-%m') AS m, COUNT(*) AS c FROM sa_system_login_log WHERE delete_time IS NULL AND login_time>=DATE_SUB(CURDATE(), INTERVAL 12 MONTH) GROUP BY DATE_FORMAT(login_time,'%Y-%m')`).All()
	counts := map[string]int{}
	for _, rec := range rows {
		counts[ym(rec["m"].String())] = rec["c"].Int()
	}
	months, vals := loginBarSeries(time.Now(), counts)
	return g.Map{"login_month": months, "login_count": vals}, nil
}

func ymd(s string) string {
	s = strings.TrimSpace(s)
	if len(s) >= 10 && s[4] == '-' {
		return s[:10]
	}
	return s
}

func ym(s string) string {
	s = strings.TrimSpace(s)
	if len(s) >= 7 && s[4] == '-' {
		return s[:7]
	}
	return s
}

func loginChartSeries(now time.Time, counts map[string]int) ([]string, []int) {
	dates := make([]string, 0, 30)
	vals := make([]int, 0, 30)
	for i := 29; i >= 0; i-- {
		d := now.AddDate(0, 0, -i).Format("2006-01-02")
		dates = append(dates, d)
		vals = append(vals, counts[d])
	}
	return dates, vals
}

func loginBarSeries(now time.Time, counts map[string]int) ([]string, []int) {
	anchor := time.Date(now.Year(), now.Month(), 1, 0, 0, 0, 0, now.Location())
	months := make([]string, 0, 12)
	vals := make([]int, 0, 12)
	for i := 11; i >= 0; i-- {
		m := anchor.AddDate(0, -i, 0).Format("2006-01")
		months = append(months, m)
		vals = append(vals, counts[m])
	}
	return months, vals
}
