package reqx

import (
	"encoding/json"
	"strings"

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

func ClientIP(r *ghttp.Request) string {
	if x := r.Header.Get("X-Forwarded-For"); x != "" {
		return strings.TrimSpace(strings.Split(x, ",")[0])
	}
	if x := r.Header.Get("X-Real-IP"); x != "" {
		return x
	}
	return r.GetClientIp()
}
