package service

import (
	"context"
	"sort"
	"strconv"
	"strings"

	"fssadmin/go-project/internal/shared/reqx"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

func redisInfoMap(ctx context.Context) map[string]string {
	out := map[string]string{}
	v, err := g.Redis().Do(ctx, "INFO")
	if err != nil || v == nil {
		return out
	}
	for _, line := range strings.Split(v.String(), "\n") {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		k, rest, ok := strings.Cut(line, ":")
		if ok {
			out[k] = strings.TrimSpace(rest)
		}
	}
	return out
}

func coerceInfo(in map[string]string) g.Map {
	out := g.Map{}
	for k, v := range in {
		if i, err := strconv.ParseInt(v, 10, 64); err == nil {
			out[k] = i
			continue
		}
		if f, err := strconv.ParseFloat(v, 64); err == nil {
			out[k] = f
			continue
		}
		out[k] = v
	}
	return out
}

func RedisInfo(r *ghttp.Request) (interface{}, error) {
	raw := redisInfoMap(r.Context())
	variable := coerceInfo(raw)
	mem := raw["used_memory_human"]
	if mem == "" {
		mem = raw["used_memory"]
	}
	return g.Map{
		"variable":          variable,
		"info":              variable,
		"uptime_in_seconds": variable["uptime_in_seconds"],
		"uptime_in_days":    variable["uptime_in_days"],
		"connected_clients": variable["connected_clients"],
		"used_memory":       mem,
		"used_memory_human": raw["used_memory_human"],
		"redis_version":     raw["redis_version"],
		"dbSize":            gconv.Int(raw["db0"]),
		"commandStats":      []g.Map{},
	}, nil
}

func RedisMonitor(r *ghttp.Request) (interface{}, error) { return RedisInfo(r) }

func RedisOperations(r *ghttp.Request) (interface{}, error) {
	raw := redisInfoMap(r.Context())
	out := []g.Map{}
	for k, v := range raw {
		if !strings.HasPrefix(k, "cmdstat_") {
			continue
		}
		out = append(out, g.Map{"command": strings.TrimPrefix(k, "cmdstat_"), "raw": v})
	}
	sort.Slice(out, func(i, j int) bool { return gconv.String(out[i]["command"]) < gconv.String(out[j]["command"]) })
	return out, nil
}

func redisScan(ctx context.Context, pattern string) []string {
	if pattern == "" {
		pattern = "*"
	}
	v, err := g.Redis().Do(ctx, "KEYS", pattern)
	if err != nil || v == nil {
		return nil
	}
	keys := v.Strings()
	if len(keys) > 500 {
		keys = keys[:500]
	}
	sort.Strings(keys)
	return keys
}

func RedisKeys(r *ghttp.Request) (interface{}, error) {
	return redisScan(r.Context(), r.Get("pattern", "*").String()), nil
}

func RedisDeleteKeys(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	keys := gconv.Strings(m["keys"])
	if k := reqx.Str(m, "key"); k != "" {
		keys = append(keys, k)
	}
	return g.Map{"deleted": delKeys(r.Context(), keys)}, nil
}

func delKeys(ctx context.Context, keys []string) int {
	if len(keys) == 0 {
		return 0
	}
	args := make([]interface{}, len(keys))
	for i, k := range keys {
		args[i] = k
	}
	n, err := g.Redis().Do(ctx, "DEL", args...)
	if err != nil || n == nil {
		return len(keys)
	}
	return n.Int()
}

func BrowserLevel1(r *ghttp.Request) (interface{}, error) {
	pat := r.Get("pattern", "*").String()
	groups := map[string]int{}
	for _, k := range redisScan(r.Context(), pat) {
		prefix := k
		if i := strings.IndexByte(k, ':'); i > 0 {
			prefix = k[:i]
		}
		groups[prefix]++
	}
	out := make([]g.Map, 0, len(groups))
	for k, n := range groups {
		out = append(out, g.Map{"key": k, "count": n})
	}
	sort.Slice(out, func(i, j int) bool { return gconv.String(out[i]["key"]) < gconv.String(out[j]["key"]) })
	return out, nil
}

func BrowserLevel2(r *ghttp.Request) (interface{}, error) {
	prefix := r.Get("prefix").String()
	keys := redisScan(r.Context(), prefix+"*")
	if len(keys) > 100 {
		keys = keys[:100]
	}
	out := make([]g.Map, 0, len(keys))
	for _, k := range keys {
		out = append(out, keyBrief(r.Context(), k))
	}
	return out, nil
}

func BrowserLevel3(r *ghttp.Request) (interface{}, error) {
	prefix := r.Get("prefix").String()
	keys := redisScan(r.Context(), prefix+"*")
	if len(keys) > 100 {
		keys = keys[:100]
	}
	out := make([]g.Map, 0, len(keys))
	for _, k := range keys {
		ttl, _ := g.Redis().Do(r.Context(), "TTL", k)
		out = append(out, g.Map{"key": k, "ttl": ttl.Int(), "size": redisSize(r.Context(), k, redisType(r.Context(), k))})
	}
	return out, nil
}

func keyBrief(ctx context.Context, key string) g.Map {
	typ := redisType(ctx, key)
	ttl, _ := g.Redis().Do(ctx, "TTL", key)
	return g.Map{"key": key, "fullKey": key, "type": typ, "ttl": ttl.Int()}
}

func redisType(ctx context.Context, key string) string {
	v, err := g.Redis().Do(ctx, "TYPE", key)
	if err != nil || v == nil {
		return "none"
	}
	return v.String()
}

func redisSize(ctx context.Context, key, typ string) int {
	cmd := ""
	switch typ {
	case "string":
		cmd = "STRLEN"
	case "hash":
		cmd = "HLEN"
	case "list":
		cmd = "LLEN"
	case "set":
		cmd = "SCARD"
	case "zset":
		cmd = "ZCARD"
	default:
		return 0
	}
	v, err := g.Redis().Do(ctx, cmd, key)
	if err != nil || v == nil {
		return 0
	}
	return v.Int()
}

func redisValue(ctx context.Context, key, typ string) interface{} {
	switch typ {
	case "string":
		v, err := g.Redis().Do(ctx, "GET", key)
		if err != nil || v == nil || v.IsNil() {
			return ""
		}
		return v.String()
	case "hash":
		v, err := g.Redis().Do(ctx, "HGETALL", key)
		if err != nil || v == nil {
			return g.Map{}
		}
		return v.Map()
	case "list":
		v, _ := g.Redis().Do(ctx, "LRANGE", key, 0, 200)
		if v == nil {
			return []string{}
		}
		return v.Strings()
	case "set":
		v, _ := g.Redis().Do(ctx, "SMEMBERS", key)
		if v == nil {
			return []string{}
		}
		return v.Strings()
	case "zset":
		v, _ := g.Redis().Do(ctx, "ZRANGE", key, 0, 200, "WITHSCORES")
		if v == nil {
			return []string{}
		}
		return v.Strings()
	default:
		return ""
	}
}

func BrowserKeyInfo(r *ghttp.Request) (interface{}, error) {
	key := r.Get("key").String()
	typ := redisType(r.Context(), key)
	ttl, _ := g.Redis().Do(r.Context(), "TTL", key)
	return g.Map{
		"key": key, "type": typ, "ttl": ttl.Int(),
		"size": redisSize(r.Context(), key, typ), "value": redisValue(r.Context(), key, typ),
	}, nil
}

func BrowserDelete(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	if pat := reqx.Str(m, "pattern"); pat != "" {
		keys := redisScan(r.Context(), pat)
		return g.Map{"deleted": delKeys(r.Context(), keys)}, nil
	}
	key := reqx.Str(m, "key")
	if key == "" {
		return g.Map{"deleted": 0}, nil
	}
	return g.Map{"deleted": delKeys(r.Context(), []string{key})}, nil
}
