package reqx

import (
	"encoding/json"
	"net"
	"strings"

	"fssadmin/go-project/internal/shared/conf"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

func Merge(r *ghttp.Request) g.Map {
	out := g.Map{}
	for k, v := range r.GetQueryMap() {
		out[k] = v
	}
	if r.Method == "GET" {
		return out
	}
	ct := r.Header.Get("Content-Type")
	if strings.Contains(ct, "multipart/form-data") {
		for k, v := range r.GetFormMap() {
			out[k] = v
		}
		return out
	}
	if body, ok := decodeBody(strings.TrimSpace(r.GetBodyString())); ok {
		for k, v := range body {
			out[k] = v
		}
		return out
	}
	for k, v := range r.GetFormMap() {
		out[k] = v
	}
	return out
}

// decodeBody 解析 JSON 请求体。
// 对象体按字段展开；数组体（前端 request.del({data: [1,2]}) 的写法）统一挂在 _array 键下，
// 由 reqx.Ints 兜底读取，否则批量删除会解析不到 id 而静默无操作。
// 第二个返回值为 false 表示请求体不是 JSON，调用方应回退到表单解析。
func decodeBody(raw string) (g.Map, bool) {
	if raw == "" {
		return nil, false
	}
	switch raw[0] {
	case '[':
		var arr []interface{}
		if err := json.Unmarshal([]byte(raw), &arr); err != nil {
			return nil, false
		}
		return g.Map{"_array": arr}, true
	case '{':
		var obj map[string]interface{}
		if err := json.Unmarshal([]byte(raw), &obj); err != nil {
			return nil, false
		}
		out := g.Map{}
		for k, v := range obj {
			out[k] = v
		}
		return out, true
	default:
		return nil, false
	}
}

func Int(m g.Map, keys ...string) int {
	for _, k := range keys {
		if v, ok := m[k]; ok && v != nil && gconv.String(v) != "" {
			return gconv.Int(v)
		}
	}
	return 0
}

func Str(m g.Map, keys ...string) string {
	for _, k := range keys {
		if v, ok := m[k]; ok && v != nil {
			return strings.TrimSpace(gconv.String(v))
		}
	}
	return ""
}

func Ints(m g.Map, keys ...string) []int {
	for _, k := range keys {
		v, ok := m[k]
		if !ok || v == nil {
			continue
		}
		switch t := v.(type) {
		case []int:
			return t
		case []any:
			out := make([]int, 0, len(t))
			for _, x := range t {
				out = append(out, gconv.Int(x))
			}
			return out
		default:
			s := gconv.String(v)
			if s == "" {
				continue
			}
			parts := strings.Split(s, ",")
			out := make([]int, 0, len(parts))
			for _, p := range parts {
				p = strings.TrimSpace(p)
				if p == "" {
					continue
				}
				out = append(out, gconv.Int(p))
			}
			return out
		}
	}
	if arr, ok := m["_array"]; ok {
		return gconv.Ints(arr)
	}
	return nil
}

// ClientIP 获取客户端真实 IP。
// 安全：仅当直连地址（RemoteAddr）命中可信代理列表（app.trustedProxies，默认本机回环）
// 时才信任 X-Forwarded-For / X-Real-IP，取 XFF 最右侧一跳（由可信反代追加、不可伪造）；
// 否则直接使用直连地址，防止伪造 XFF 绕过限流与 IP 黑白名单。
func ClientIP(r *ghttp.Request) string {
	remote := remoteHost(r)
	if !isTrustedProxy(remote) {
		return remote
	}
	if x := r.Header.Get("X-Forwarded-For"); x != "" {
		parts := strings.Split(x, ",")
		// XFF 由代理逐跳追加：最后一段才是可信代理看到的来源。
		for i := len(parts) - 1; i >= 0; i-- {
			if ip := strings.TrimSpace(parts[i]); ip != "" {
				return ip
			}
		}
	}
	if x := strings.TrimSpace(r.Header.Get("X-Real-IP")); x != "" {
		return x
	}
	return remote
}

func remoteHost(r *ghttp.Request) string {
	// 注意：不能用 GetClientIp()——它内部优先读 X-Forwarded-For（gf v2.10.5
	// ghttp_request.go:201），会架空可信代理校验。这里只用 TCP 对端地址。
	addr := r.GetRemoteIp()
	if host, _, err := net.SplitHostPort(addr); err == nil {
		return host
	}
	return strings.Trim(addr, "[]")
}

func isTrustedProxy(ip string) bool {
	if ip == "" {
		return false
	}
	parsed := net.ParseIP(ip)
	if parsed == nil {
		return false
	}
	for _, rule := range conf.TrustedProxies() {
		rule = strings.TrimSpace(rule)
		if rule == "" {
			continue
		}
		if rule == ip {
			return true
		}
		if strings.Contains(rule, "/") {
			if _, cidr, err := net.ParseCIDR(rule); err == nil && cidr.Contains(parsed) {
				return true
			}
		} else if p := net.ParseIP(rule); p != nil && p.Equal(parsed) {
			return true
		}
	}
	return false
}
