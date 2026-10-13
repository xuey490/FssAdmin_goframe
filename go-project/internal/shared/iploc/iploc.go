// Package iploc 解析 IP 归属地（对齐 Python 版 app/utils/ip_local_util.py）：
// 内网直判 → 进程内 L1 / Redis L2 缓存 → 外网主备接口查询（硬超时、降级）。
//
// 登录等主流程只调用 Sync：它永不阻塞（未命中缓存时返回「归属地查询中」并异步补齐），
// 在线用户列表每次刷新都会重新取一次，因此异步结果会在下一次刷新时自动出现。
package iploc

import (
	"context"
	"fmt"
	"net"
	"strings"
	"sync"
	"time"

	"fssadmin/go-project/internal/shared/conf"

	"github.com/gogf/gf/v2/database/gredis"
	"github.com/gogf/gf/v2/encoding/gjson"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/gclient"
	"github.com/gogf/gf/v2/os/gctx"
)

const (
	// LocationPrivate 内网/本机地址
	LocationPrivate = "内网IP"
	// LocationDisabled 关闭归属地查询后的公网地址
	LocationDisabled = "未解析(已关闭归属地查询)"
	// LocationResolving 已触发异步查询，稍后再看
	LocationResolving = "归属地查询中"
	// LocationUnknown 查询失败或地址非法
	LocationUnknown = "未知"

	cacheKeyPattern = "ip:location:%s"
)

// 外部接口：主备各一个，任一成功即返回（与 Python 版保持一致）。
var providers = []struct {
	name   string
	url    func(ip string) string
	parser func(j *gjson.Json) string
}{
	{
		name: "ip9.com.cn",
		url:  func(ip string) string { return "https://ip9.com.cn/get?ip=" + ip },
		parser: func(j *gjson.Json) string {
			if j.Get("ret").Int() != 200 {
				return ""
			}
			return joinParts(
				j.Get("data.country").String(),
				j.Get("data.prov").String(),
				j.Get("data.city").String(),
				j.Get("data.area").String(),
				j.Get("data.isp").String(),
			)
		},
	},
	{
		name: "ip-api.com",
		url:  func(ip string) string { return "https://ip-api.com/json/" + ip + "?lang=zh-CN" },
		parser: func(j *gjson.Json) string {
			if j.Get("status").String() != "success" {
				return ""
			}
			return joinParts(
				j.Get("country").String(),
				j.Get("regionName").String(),
				j.Get("city").String(),
				j.Get("isp").String(),
			)
		},
	},
}

// 可替换依赖：生产走配置与真实查询，测试里替换以避免触网/触库。
var (
	enabledFn    = conf.IPLocationEnable
	timeoutFn    = conf.IPLocationTimeout
	cacheHoursFn = conf.IPLocationCacheHours
	lookupFn     = query
	redisFn      = func() *gredis.Redis { return g.Redis() }
)

type memEntry struct {
	value  string
	expire time.Time
}

var (
	memMu sync.RWMutex
	mem   = map[string]memEntry{}
	// inflight 保证同一个 IP 只有一个后台查询在跑
	inflight sync.Map
)

// Sync 只返回当前立即可得的结果：空 IP、内网、关闭开关、命中缓存；
// 未命中时触发一次后台解析并返回「归属地查询中」，绝不阻塞调用方。
func Sync(ctx context.Context, ip string) string {
	ip = Normalize(ip)
	if ip == "" {
		return ""
	}
	if IsPrivate(ip) {
		return LocationPrivate
	}
	if !enabledFn() {
		return LocationDisabled
	}
	if v, ok := cacheGet(ctx, ip); ok {
		return v
	}
	resolveAsync(ip)
	return LocationResolving
}

// Resolve 完整解析：内网直判 → 缓存 → 外网查询（带超时）→ 回写缓存。
// 供后台任务与需要立即拿到结果的场景使用。
func Resolve(ctx context.Context, ip string) string {
	ip = Normalize(ip)
	if ip == "" {
		return ""
	}
	if IsPrivate(ip) {
		return LocationPrivate
	}
	if !enabledFn() {
		return LocationDisabled
	}
	if v, ok := cacheGet(ctx, ip); ok {
		return v
	}
	value := lookupFn(ctx, ip)
	cacheSet(ctx, ip, value)
	return value
}

// resolveAsync 后台解析一次并写入缓存。
func resolveAsync(ip string) {
	if _, loaded := inflight.LoadOrStore(ip, struct{}{}); loaded {
		return
	}
	go func() {
		defer inflight.Delete(ip)
		ctx, cancel := context.WithTimeout(gctx.New(), time.Duration(timeoutSeconds()+2)*time.Second)
		defer cancel()
		cacheSet(ctx, ip, lookupFn(ctx, ip))
	}()
}

// query 依次尝试主备接口，全部失败返回「未知」。
func query(ctx context.Context, ip string) string {
	timeout := time.Duration(timeoutSeconds()) * time.Second
	for _, p := range providers {
		if value := queryOne(ctx, p.url(ip), p.parser, timeout, p.name); value != "" {
			return value
		}
	}
	return LocationUnknown
}

func queryOne(ctx context.Context, url string, parse func(*gjson.Json) string, timeout time.Duration, name string) string {
	qctx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()
	client := gclient.New().SetTimeout(timeout)
	resp, err := client.Get(qctx, url)
	if err != nil {
		g.Log().Debugf(ctx, "iploc: %s 查询失败 url=%s: %v", name, url, err)
		return ""
	}
	defer func() { _ = resp.Close() }()
	if resp.StatusCode != 200 {
		return ""
	}
	body := resp.ReadAllString()
	if body == "" {
		return ""
	}
	return parse(gjson.New(body))
}

func timeoutSeconds() int {
	if n := timeoutFn(); n > 0 {
		return n
	}
	return 3
}

func cacheHours() int {
	if n := cacheHoursFn(); n > 0 {
		return n
	}
	return 168
}

// ---------------------------------------------------------------------------
// 缓存：L1 进程内 + L2 Redis
// ---------------------------------------------------------------------------

func cacheGet(ctx context.Context, ip string) (string, bool) {
	memMu.RLock()
	if e, ok := mem[ip]; ok && time.Now().Before(e.expire) {
		memMu.RUnlock()
		return e.value, true
	}
	memMu.RUnlock()

	redis := redisFn()
	if redis == nil {
		return "", false
	}
	v, err := redis.Do(ctx, "GET", fmt.Sprintf(cacheKeyPattern, ip))
	if err != nil || v == nil || v.IsEmpty() {
		return "", false
	}
	value := v.String()
	memSet(ip, value)
	return value, true
}

func cacheSet(ctx context.Context, ip, value string) {
	if value == "" {
		return
	}
	memSet(ip, value)
	redis := redisFn()
	if redis == nil {
		return
	}
	if _, err := redis.Do(ctx, "SETEX", fmt.Sprintf(cacheKeyPattern, ip), cacheHours()*3600, value); err != nil {
		g.Log().Debugf(ctx, "iploc: 缓存写入失败 ip=%s: %v", ip, err)
	}
}

func memSet(ip, value string) {
	memMu.Lock()
	mem[ip] = memEntry{value: value, expire: time.Now().Add(time.Duration(cacheHours()) * time.Hour)}
	// 兜底清理，避免长期运行累积过多键
	if len(mem) > 4096 {
		now := time.Now()
		for k, v := range mem {
			if now.After(v.expire) {
				delete(mem, k)
			}
		}
	}
	memMu.Unlock()
}

// ---------------------------------------------------------------------------
// IP 判定与规整
// ---------------------------------------------------------------------------

// Normalize 去掉端口、方括号与空白，返回可解析的 IP 字符串（不可解析时返回空串）。
func Normalize(raw string) string {
	s := strings.TrimSpace(raw)
	if s == "" {
		return ""
	}
	if strings.HasPrefix(s, "[") { // IPv6 带方括号：[::1]:8080
		if end := strings.Index(s, "]"); end > 0 {
			s = s[1:end]
		}
	} else if host, _, err := net.SplitHostPort(s); err == nil {
		s = host
	}
	ip := net.ParseIP(strings.TrimSpace(s))
	if ip == nil {
		return ""
	}
	return ip.String()
}

// IsPrivate 判断是否为内网/本机/链路本地地址（这类地址无归属地可查）。
func IsPrivate(raw string) bool {
	ip := net.ParseIP(strings.TrimSpace(raw))
	if ip == nil {
		return false
	}
	return ip.IsPrivate() || ip.IsLoopback() || ip.IsUnspecified() ||
		ip.IsLinkLocalUnicast() || ip.IsLinkLocalMulticast()
}

func joinParts(parts ...string) string {
	out := make([]string, 0, len(parts))
	for _, p := range parts {
		if p = strings.TrimSpace(p); p != "" {
			out = append(out, p)
		}
	}
	return strings.Join(out, "-")
}
