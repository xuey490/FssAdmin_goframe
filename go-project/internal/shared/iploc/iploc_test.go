package iploc

import (
	"context"
	"sync/atomic"
	"testing"
	"time"

	"github.com/gogf/gf/v2/database/gredis"
	"github.com/gogf/gf/v2/os/gctx"
)

// setup 替换依赖：不触网、不触库，返回还原函数。
func setup(t *testing.T, enabled bool, lookup func(context.Context, string) string) {
	t.Helper()
	prevEnabled, prevLookup, prevRedis := enabledFn, lookupFn, redisFn
	enabledFn = func() bool { return enabled }
	redisFn = func() *gredis.Redis { return nil }
	if lookup != nil {
		lookupFn = lookup
	}
	t.Cleanup(func() {
		enabledFn, lookupFn, redisFn = prevEnabled, prevLookup, prevRedis
		memMu.Lock()
		mem = map[string]memEntry{}
		memMu.Unlock()
	})
}

func TestNormalize(t *testing.T) {
	cases := map[string]string{
		"127.0.0.1:8080": "127.0.0.1",
		" 8.8.8.8 ":      "8.8.8.8",
		"[::1]:8080":     "::1",
		"::1":            "::1",
		"":               "",
		"abc":            "",
		"1.2.3":          "",
	}
	for raw, want := range cases {
		if got := Normalize(raw); got != want {
			t.Fatalf("Normalize(%q) = %q, want %q", raw, got, want)
		}
	}
}

func TestIsPrivate(t *testing.T) {
	private := []string{"127.0.0.1", "10.0.0.5", "192.168.1.10", "172.16.0.9", "::1", "fe80::1"}
	for _, ip := range private {
		if !IsPrivate(ip) {
			t.Fatalf("%s 应判定为内网/本机", ip)
		}
	}
	public := []string{"8.8.8.8", "114.114.114.114", "11.0.0.1", "2001:4860:4860::8888"}
	for _, ip := range public {
		if IsPrivate(ip) {
			t.Fatalf("%s 不应判定为内网", ip)
		}
	}
	if IsPrivate("not-an-ip") {
		t.Fatal("非法地址不应判定为内网")
	}
}

// 内网与空地址不需要外网查询，也不受开关影响。
func TestSyncPrivateAndEmpty(t *testing.T) {
	setup(t, true, func(context.Context, string) string { return "SHOULD_NOT_CALL" })
	if got := Sync(gctx.New(), ""); got != "" {
		t.Fatalf("空 IP 应返回空串，实际 %q", got)
	}
	if got := Sync(gctx.New(), "192.168.1.1"); got != LocationPrivate {
		t.Fatalf("内网 IP 应返回 %q，实际 %q", LocationPrivate, got)
	}
}

// 关闭开关后公网 IP 不再查询，直接标注未解析。
func TestSyncDisabled(t *testing.T) {
	var called int32
	setup(t, false, func(context.Context, string) string {
		atomic.AddInt32(&called, 1)
		return "中国-北京"
	})
	if got := Sync(gctx.New(), "8.8.8.8"); got != LocationDisabled {
		t.Fatalf("关闭开关应返回 %q，实际 %q", LocationDisabled, got)
	}
	time.Sleep(100 * time.Millisecond)
	if n := atomic.LoadInt32(&called); n != 0 {
		t.Fatalf("关闭开关不应触发外网查询，实际调用 %d 次", n)
	}
}

// 首次同步返回「归属地查询中」，异步补齐后再次读取应拿到结果。
func TestSyncResolvesAsync(t *testing.T) {
	setup(t, true, func(context.Context, string) string { return "中国-北京-电信" })
	ctx := gctx.New()
	if got := Sync(ctx, "8.8.8.8"); got != LocationResolving {
		t.Fatalf("首次应返回 %q，实际 %q", LocationResolving, got)
	}

	deadline := time.Now().Add(2 * time.Second)
	for time.Now().Before(deadline) {
		if got := Sync(ctx, "8.8.8.8"); got == "中国-北京-电信" {
			return
		}
		time.Sleep(20 * time.Millisecond)
	}
	t.Fatalf("异步解析结果未生效，实际 %q", Sync(ctx, "8.8.8.8"))
}

// 命中缓存后不再重复查询。
func TestResolveUsesCache(t *testing.T) {
	var called int32
	setup(t, true, func(context.Context, string) string {
		atomic.AddInt32(&called, 1)
		return "中国-上海"
	})
	ctx := gctx.New()
	if got := Resolve(ctx, "114.114.114.114"); got != "中国-上海" {
		t.Fatalf("Resolve = %q", got)
	}
	if got := Resolve(ctx, "114.114.114.114"); got != "中国-上海" {
		t.Fatalf("第二次 Resolve = %q", got)
	}
	if n := atomic.LoadInt32(&called); n != 1 {
		t.Fatalf("缓存命中后不应重复查询，实际调用 %d 次", n)
	}
}

// 查询失败时降级为「未知」，不 panic、不阻塞。
func TestResolveUnknown(t *testing.T) {
	setup(t, true, func(context.Context, string) string { return LocationUnknown })
	if got := Resolve(gctx.New(), "1.1.1.1"); got != LocationUnknown {
		t.Fatalf("Resolve = %q", got)
	}
}
