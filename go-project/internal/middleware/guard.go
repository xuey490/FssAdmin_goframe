package middleware

import (
	"bytes"
	"encoding/json"
	"io"
	"net"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"sync"
	"time"

	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/microcosm-cc/bluemonday"
)

func IPBan(r *ghttp.Request) {
	ip := reqx.ClientIP(r)
	ok, msg := IPAllowed(ip, conf.IPWhiteList(), conf.IPBlackList())
	if !ok {
		response.FailHTTP(r, http.StatusForbidden, 403, msg)
		r.ExitAll()
		return
	}
	r.Middleware.Next()
}

func RateLimit(r *ghttp.Request) {
	if !conf.RateLimitOn() || r.Method == http.MethodOptions || skipLimit(r.URL.Path) {
		r.Middleware.Next()
		return
	}
	ip := reqx.ClientIP(r)
	n, err := hitLimit(r, ip, conf.RateLimitTimes(), conf.RateLimitSeconds())
	if err != nil {
		g.Log().Warningf(r.Context(), "rate limit skipped: %v", err)
		r.Middleware.Next()
		return
	}
	if n > conf.RateLimitTimes() {
		r.Response.Header().Set("Retry-After", strconv.Itoa(conf.RateLimitSeconds()))
		response.FailHTTP(r, http.StatusTooManyRequests, 429, "请求过于频繁，请稍后重试！")
		r.ExitAll()
		return
	}
	r.Middleware.Next()
}

func Debug(r *ghttp.Request) {
	start := time.Now()
	if conf.Debug() {
		r.Response.Header().Set("X-Debug", "1")
	}
	r.Middleware.Next()
	sec := time.Since(start).Seconds()
	r.Response.Header().Set("X-Process-Time", strconv.FormatFloat(sec, 'f', 5, 64))
	if conf.Debug() {
		g.Log().Infof(r.Context(), "请求: %s %s | client=%s | %d | %.1fms",
			r.Method, r.URL.Path, reqx.ClientIP(r), r.Response.Status, sec*1000)
	}
}

func XSS(r *ghttp.Request) {
	if !conf.XSSEnable() || r.Method == http.MethodOptions {
		r.Middleware.Next()
		return
	}
	q := r.URL.Query()
	for k, vs := range q {
		for i, v := range vs {
			q[k][i] = FilterXSS(v)
		}
	}
	r.URL.RawQuery = q.Encode()
	ct := r.Header.Get("Content-Type")
	if !strings.Contains(ct, "multipart/form-data") {
		body := r.GetBody()
		if len(body) > 0 {
			r.Body = io.NopCloser(bytes.NewReader(sanitizeBody(ct, body)))
		}
	}
	r.ReloadParam()
	r.Middleware.Next()
}

func IPAllowed(ip string, white, black []string) (bool, string) {
	ip = normalizeIP(ip)
	if ip == "" {
		if len(white) > 0 {
			return false, "IP不在白名单"
		}
		return true, ""
	}
	if ipInList(ip, black) {
		return false, "IP已被封禁"
	}
	if len(white) > 0 && !ipInList(ip, white) {
		return false, "IP不在白名单"
	}
	return true, ""
}

func normalizeIP(ip string) string {
	ip = strings.TrimSpace(ip)
	if ip == "" {
		return ""
	}
	if host, _, err := net.SplitHostPort(ip); err == nil {
		ip = host
	}
	return strings.Trim(ip, "[]")
}

func ipInList(ip string, rules []string) bool {
	parsed := net.ParseIP(ip)
	for _, rule := range rules {
		rule = strings.TrimSpace(rule)
		if rule == "" {
			continue
		}
		if rule == ip {
			return true
		}
		if strings.Contains(rule, "/") {
			_, cidr, err := net.ParseCIDR(rule)
			if err == nil && parsed != nil && cidr.Contains(parsed) {
				return true
			}
		}
	}
	return false
}

func skipLimit(path string) bool {
	paths := []string{"/health", "/live", "/ready", "/common/health", "/docs", "/api.json", "/static/", "/uploads/", "/favicon"}
	if p := conf.UploadPublicPrefix(); p != "" {
		paths = append(paths, strings.TrimRight(p, "/")+"/")
	}
	for _, p := range paths {
		if path == p || strings.HasPrefix(path, p) {
			return true
		}
	}
	return false
}

func hitLimit(r *ghttp.Request, ip string, times, seconds int) (int, error) {
	if seconds <= 0 {
		seconds = 60
	}
	key := conf.RateLimitPrefix() + ip
	v, err := g.Redis().Do(r.Context(), "INCR", key)
	if err == nil && v != nil {
		n := v.Int()
		if n == 1 {
			_, _ = g.Redis().Do(r.Context(), "EXPIRE", key, seconds)
		}
		return n, nil
	}
	return memHit(key, seconds), nil
}

type memBucket struct {
	mu  sync.Mutex
	n   int
	exp time.Time
}

// ponytail: process-local fallback when Redis is down; upgrade is Redis INCR (already primary).
var memRL sync.Map

func memHit(key string, seconds int) int {
	now := time.Now()
	raw, _ := memRL.LoadOrStore(key, &memBucket{exp: now.Add(time.Duration(seconds) * time.Second)})
	b := raw.(*memBucket)
	b.mu.Lock()
	defer b.mu.Unlock()
	if now.After(b.exp) {
		b.n = 0
		b.exp = now.Add(time.Duration(seconds) * time.Second)
	}
	b.n++
	return b.n
}

// xssPolicy matches Python bleach allow-tags (notice HTML) without style=.
var xssPolicy = func() *bluemonday.Policy {
	p := bluemonday.UGCPolicy()
	p.AllowElements("div", "font", "video", "source", "strike", "tt", "col", "colgroup")
	p.AllowAttrs("color", "size", "face").OnElements("font")
	p.AllowAttrs("src", "controls", "width", "height", "poster").OnElements("video")
	p.AllowAttrs("src", "type").OnElements("source")
	p.AllowAttrs("span", "width").OnElements("col", "colgroup")
	return p
}()

func FilterXSS(s string) string {
	if s == "" {
		return s
	}
	if strings.ContainsAny(s, "<>") {
		s = xssPolicy.Sanitize(s)
	}
	return stripDangerURL(s)
}

func stripDangerURL(s string) string {
	t := strings.TrimSpace(strings.ToLower(s))
	if strings.HasPrefix(t, "javascript:") || strings.HasPrefix(t, "vbscript:") || strings.HasPrefix(t, "data:text/html") {
		return ""
	}
	return s
}

func sanitizeBody(ct string, body []byte) []byte {
	if strings.Contains(ct, "application/json") || looksJSON(body) {
		var v interface{}
		if err := json.Unmarshal(body, &v); err == nil {
			out, err := json.Marshal(walkXSS(v))
			if err == nil {
				return out
			}
		}
	}
	if strings.Contains(ct, "application/x-www-form-urlencoded") {
		vals, err := url.ParseQuery(string(body))
		if err == nil {
			for k, vs := range vals {
				for i, x := range vs {
					vals[k][i] = FilterXSS(x)
				}
			}
			return []byte(vals.Encode())
		}
	}
	return []byte(FilterXSS(string(body)))
}

func looksJSON(b []byte) bool {
	s := bytes.TrimSpace(b)
	return len(s) > 0 && (s[0] == '{' || s[0] == '[')
}

func walkXSS(v interface{}) interface{} {
	switch t := v.(type) {
	case string:
		return FilterXSS(t)
	case map[string]interface{}:
		for k, x := range t {
			if skipXSSKey(k) {
				continue
			}
			t[k] = walkXSS(x)
		}
		return t
	case []interface{}:
		for i, x := range t {
			t[i] = walkXSS(x)
		}
		return t
	default:
		return v
	}
}

func skipXSSKey(k string) bool {
	switch strings.ToLower(k) {
	case "password", "oldpassword", "old_password", "newpassword", "new_password",
		"confirmpassword", "confirm_password", "pwd", "passwd":
		return true
	}
	return false
}
