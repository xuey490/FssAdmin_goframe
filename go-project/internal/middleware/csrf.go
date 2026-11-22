package middleware

import (
	"crypto/subtle"
	"net/http"
	"strings"

	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/guid"
)

const csrfCookie = "csrf_token"
const csrfHeader = "X-CSRF-Token"

// CSRF is the WebServer middleware for cookie double-submit.
// Bearer requests and public routes skip it: this API authenticates with Authorization, not cookies.
func CSRF(r *ghttp.Request) {
	if !conf.CSRFEnable() {
		r.Middleware.Next()
		return
	}
	token := r.Cookie.Get(csrfCookie).String()
	if token == "" {
		token = guid.S()
	}
	// TLS 或反代声明 https 时携带 Secure 标志；localhost/127.0.0.1 的浏览器视其为可信源不受影响。
	secure := r.TLS != nil || strings.EqualFold(r.Header.Get("X-Forwarded-Proto"), "https")
	r.Cookie.SetHttpCookie(&http.Cookie{
		Name: csrfCookie, Value: token, Path: "/", HttpOnly: true,
		Secure: secure, SameSite: http.SameSiteLaxMode,
	})
	if csrfAllowed(r.Method, r.Header.Get("Authorization"), r.Header.Get(csrfHeader), token, csrfExempt(r.URL.Path)) {
		r.Middleware.Next()
		return
	}
	response.FailHTTP(r, http.StatusForbidden, http.StatusForbidden, "CSRF token 无效")
	r.ExitAll()
}

func csrfAllowed(method, authorization, headerToken, cookieToken string, public bool) bool {
	switch method {
	case http.MethodGet, http.MethodHead, http.MethodOptions:
		return true
	}
	if public || hasBearer(authorization) {
		return true
	}
	if headerToken == "" || cookieToken == "" || len(headerToken) != len(cookieToken) {
		return false
	}
	return subtle.ConstantTimeCompare([]byte(headerToken), []byte(cookieToken)) == 1
}

func csrfExempt(path string) bool {
	// 刷新令牌时访问令牌已经失效，请求里没有 Bearer。
	// 用后缀匹配而非 Contains，避免 "/aaa/core/refreshbbb" 这类子串误豁免。
	return isPublic(path) || strings.HasSuffix(path, "/core/refresh") || strings.HasSuffix(path, "/core/logout")
}

func hasBearer(h string) bool {
	const p = "Bearer "
	return strings.HasPrefix(h, p) && strings.TrimSpace(h[len(p):]) != ""
}
