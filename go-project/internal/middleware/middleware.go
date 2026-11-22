package middleware

import (
	"context"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
	"time"

	"fssadmin/go-project/internal/authkit"
	"fssadmin/go-project/internal/modules/auth/dao"
	menusvc "fssadmin/go-project/internal/modules/menu/service"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"
	"fssadmin/go-project/internal/shared/tenant"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/guid"
)

func RewriteAPIPrefix(r *ghttp.Request) {
	p := r.URL.Path
	for {
		switch {
		case strings.HasPrefix(p, "/api/v1/"):
			p = p[len("/api/v1"):]
		case p == "/api/v1":
			p = "/"
		case strings.HasPrefix(p, "/api/") && !strings.HasPrefix(p, "/api/v1"):
			p = p[len("/api"):]
		case p == "/api":
			p = "/"
		default:
			if p != r.URL.Path {
				r.URL.Path = p
			}
			return
		}
	}
}

func StripAPIPrefix(r *ghttp.Request) {
	RewriteAPIPrefix(r)
	r.Middleware.Next()
}

func CORS(r *ghttp.Request) {
	if !conf.CORSEnable() {
		r.Middleware.Next()
		return
	}
	origin := r.Header.Get("Origin")
	allow, ok := corsOrigin(origin, conf.CORSOrigins())
	if ok && allow != "" {
		r.Response.Header().Set("Access-Control-Allow-Origin", allow)
		r.Response.Header().Set("Vary", "Origin")
		r.Response.Header().Set("Access-Control-Allow-Methods", "GET,POST,PUT,PATCH,DELETE,OPTIONS")
		r.Response.Header().Set("Access-Control-Allow-Headers", "Content-Type,Authorization,X-Requested-With,X-Tenant-Id,X-Correlation-ID,X-CSRF-Token")
		r.Response.Header().Set("Access-Control-Expose-Headers", "X-Request-ID,X-Correlation-ID,Content-Disposition")
		if allow != "*" {
			r.Response.Header().Set("Access-Control-Allow-Credentials", "true")
		}
		if maxAge := conf.CORSMaxAge(); maxAge > 0 {
			r.Response.Header().Set("Access-Control-Max-Age", strconv.Itoa(maxAge))
		}
	}
	if r.Method == http.MethodOptions {
		r.Response.WriteStatus(http.StatusNoContent)
		return
	}
	r.Middleware.Next()
}

func corsOrigin(origin string, list []string) (string, bool) {
	if origin == "" {
		return "*", true
	}
	for _, o := range list {
		if o == "*" {
			return origin, true
		}
		if o == origin {
			return origin, true
		}
	}
	return "", false
}

func Correlation(r *ghttp.Request) {
	id := r.Header.Get("X-Correlation-ID")
	if id == "" {
		id = guid.S()
	}
	r.Response.Header().Set("X-Correlation-ID", id)
	r.Response.Header().Set("X-Request-ID", id)
	r.Middleware.Next()
}

func Gzip(r *ghttp.Request) {
	if !conf.GzipEnable() || !strings.Contains(r.Header.Get("Accept-Encoding"), "gzip") {
		r.Middleware.Next()
		return
	}
	r.Middleware.Next()
}

func Recover(r *ghttp.Request) {
	r.Middleware.Next()
	if err := r.GetError(); err != nil {
		g.Log().Errorf(r.Context(), "%v", err)
		if e, ok := biz.As(err); ok {
			response.FailHTTP(r, e.HTTPStatus, e.Code, e.Msg)
			r.ExitAll()
			return
		}
		msg := "系统异常，请联系管理员"
		if conf.Debug() {
			msg = err.Error()
		}
		response.Fail(r, msg, 500)
		r.ExitAll()
	}
}

func DemoGuard(r *ghttp.Request) {
	if !conf.DemoEnable() {
		r.Middleware.Next()
		return
	}
	if r.Method == http.MethodGet || r.Method == http.MethodOptions {
		r.Middleware.Next()
		return
	}
	p := r.URL.Path
	if strings.Contains(p, "/core/login") || strings.Contains(p, "/core/logout") || strings.Contains(p, "/core/refresh") || strings.Contains(p, "/system/auth/login") {
		r.Middleware.Next()
		return
	}
	response.Fail(r, "演示模式禁止修改数据", 403)
	r.ExitAll()
}

func Auth(r *ghttp.Request) {
	if isPublic(r.URL.Path) {
		r.Middleware.Next()
		return
	}
	token := authkit.Bearer(r.Header.Get("Authorization"))
	if token == "" {
		response.FailHTTP(r, 401, 401, "未登录或登录已过期")
		r.ExitAll()
		return
	}
	c, err := authkit.ParseAccess(token)
	if err != nil {
		response.FailHTTP(r, 401, 401, "未登录或登录已过期")
		r.ExitAll()
		return
	}
	u := authkit.FromClaims(c, token)
	rec, err := dbx.Alive(dbx.Model("sa_system_user")).Ctx(r.Context()).Where("id", c.UID).One()
	if err != nil {
		// DB 抖动不能等同于「用户不存在」：报 503 并记录日志，前端可重试而不是被登出。
		g.Log().Warningf(r.Context(), "auth: 查询用户失败 uid=%d: %v", c.UID, err)
		response.FailHTTP(r, 503, 503, "系统繁忙，请稍后重试")
		r.ExitAll()
		return
	}
	if rec.IsEmpty() {
		response.FailHTTP(r, 401, 401, "用户不存在")
		r.ExitAll()
		return
	}
	u.Realname = rec["realname"].String()
	u.Avatar = rec["avatar"].String()
	u.IsSuper = rec["is_super"].Int() == 1
	u.Status = rec["status"].Int()
	u.DeptID = rec["dept_id"].Int()
	u.Username = rec["username"].String()
	if u.Status != 1 {
		response.FailHTTP(r, 401, 401, "账号已被禁用")
		r.ExitAll()
		return
	}
	tid := c.TenantID
	// 优先使用前端 X-Tenant-Id 头（切换租户后即使 token 未完全同步也能立即生效）
	if h := reqx.Int(g.Map{"t": r.Header.Get("X-Tenant-Id")}, "t"); h > 0 {
		if u.IsSuper {
			tid = h
		} else {
			// 非超管必须校验是否属于该租户
			if ut, _ := dao.UserTenant(u.ID, h); !ut.IsEmpty() {
				tid = h
			}
		}
	}
	u.TenantID = tid
	ctxuser.Set(r, u)
	// 设置 TenantContext 到请求上下文，对标 PHP TenantContext
	// 超管也按当前 tenant_id 隔离数据，Ignore 始终为 false
	// WithIgnore 仅用于租户管理等需要跨租户查询的场景
	tenant.SetToRequest(r, tid, false)
	r.Middleware.Next()
}

func Tenant(r *ghttp.Request) {
	u := ctxuser.Get(r)
	if u != nil && u.TenantID > 0 {
		r.SetCtxVar("tenant_id", u.TenantID)
	} else if h := r.Header.Get("X-Tenant-Id"); h != "" {
		r.SetCtxVar("tenant_id", h)
	}
	r.Middleware.Next()
}

func OperLog(r *ghttp.Request) {
	start := time.Now()
	r.Middleware.Next()
	if r.Method == http.MethodGet || r.Method == http.MethodOptions {
		return
	}
	u := ctxuser.Get(r)
	username := ""
	if u != nil {
		username = u.Username
	}
	body := maskSensitiveBody(r.GetBodyString())
	if len(body) > 2000 {
		body = body[:2000]
	}
	_, _ = dbx.Model("sa_system_oper_log").Data(g.Map{
		"username": username, "app": "system", "method": r.Method,
		"router": r.URL.Path, "service_name": r.Router.Uri,
		"ip": reqx.ClientIP(r), "request_data": body,
		"duration":    g.NewVar(time.Since(start).Milliseconds()).String(),
		"create_time": dbx.Now(),
	}).Insert()
}

// sensitiveLogKeys 操作日志中必须脱敏的字段（密码/令牌/验证码），防止明文入库。
var sensitiveLogKeys = map[string]struct{}{
	"password": {}, "oldpassword": {}, "old_password": {}, "newpassword": {}, "new_password": {},
	"confirmpassword": {}, "confirm_password": {}, "pwd": {}, "passwd": {},
	"refresh_token": {}, "refreshtoken": {}, "access_token": {}, "accesstoken": {},
	"token": {}, "captcha": {}, "code": {},
}

func maskSensitiveBody(body string) string {
	if body == "" || (!strings.Contains(body, "{") && !strings.Contains(body, "[")) {
		return body
	}
	var v interface{}
	if json.Unmarshal([]byte(body), &v) != nil {
		return body
	}
	maskWalk(v)
	if out, err := json.Marshal(v); err == nil {
		return string(out)
	}
	return body
}

func maskWalk(v interface{}) {
	switch t := v.(type) {
	case map[string]interface{}:
		for k, x := range t {
			if _, ok := sensitiveLogKeys[strings.ToLower(k)]; ok {
				if s, isStr := x.(string); isStr && s != "" {
					t[k] = "******"
				}
				continue
			}
			maskWalk(x)
		}
	case []interface{}:
		for _, x := range t {
			maskWalk(x)
		}
	}
}

func isPublic(path string) bool {
	pubs := []string{
		"/core/captcha", "/core/login", "/core/tenants-by-username",
		"/core/config/public/", "/system/auth/login", "/system/auth/captcha",
		"/common/health", "/common/live", "/common/ready", "/health", "/live", "/ready",
		"/docs", "/redoc", "/api.json", "/swagger", "/favicon",
		"/static/", "/uploads/", "/ws/ai",
	}
	if p := conf.UploadPublicPrefix(); p != "" {
		pubs = append(pubs, strings.TrimRight(p, "/")+"/")
	}
	for _, p := range pubs {
		if publicMatch(path, p) {
			return true
		}
	}
	return false
}

// publicMatch：以 / 结尾按前缀匹配；否则要求完全相等或后跟 "/"，
// 避免 "/docs" 误放行 "/docsfoo" 这类子串绕过。
func publicMatch(path, entry string) bool {
	if strings.HasSuffix(entry, "/") {
		return strings.HasPrefix(path, entry)
	}
	return path == entry || strings.HasPrefix(path, entry+"/")
}

func Permission(slugs ...string) func(r *ghttp.Request) {
	return func(r *ghttp.Request) {
		u := ctxuser.Must(r)
		if u.IsSuper {
			r.Middleware.Next()
			return
		}
		if len(slugs) == 0 {
			r.Middleware.Next()
			return
		}
		perms := UserPerms(r.Context(), u)
		set := map[string]struct{}{}
		for _, p := range perms {
			set[p] = struct{}{}
		}
		if _, ok := set["*"]; ok {
			r.Middleware.Next()
			return
		}
		for _, s := range slugs {
			if _, ok := set[s]; ok {
				r.Middleware.Next()
				return
			}
		}
		response.Fail(r, "无权限", 403)
		r.ExitAll()
	}
}

func UserPerms(ctx context.Context, u *ctxuser.User) []string {
	return menusvc.UserPermissions(ctx, u)
}
