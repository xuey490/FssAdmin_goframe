package middleware

import (
	"strings"
	"testing"
	"time"
)

func TestFilterXSS(t *testing.T) {
	cases := []struct{ in, not string }{
		{`<script>alert(1)</script>hello`, `<script`},
		{`<p onclick="alert(1)">ok</p>`, `onclick`},
		{`<iframe src="x"></iframe>`, `<iframe`},
		{`javascript:alert(1)`, `javascript:`},
		{`<img src=x onerror=alert(1)>`, `onerror`},
	}
	for _, c := range cases {
		got := FilterXSS(c.in)
		if strings.Contains(strings.ToLower(got), strings.ToLower(c.not)) {
			t.Fatalf("FilterXSS(%q)=%q still contains %q", c.in, got, c.not)
		}
	}
	safe := FilterXSS(`<p>正常内容</p>`)
	if !strings.Contains(safe, "正常内容") || strings.Contains(strings.ToLower(safe), "script") {
		t.Fatalf("safe html: %q", safe)
	}
	if FilterXSS("") != "" {
		t.Fatal("empty")
	}
	if FilterXSS("admin") != "admin" {
		t.Fatal("plain")
	}
	raw := []byte(`{"name":"<script>x</script>ok","n":1}`)
	out := string(sanitizeBody("application/json", raw))
	if strings.Contains(out, "<script") || !strings.Contains(out, "ok") {
		t.Fatalf("json xss: %s", out)
	}
}

func TestIPAllowed(t *testing.T) {
	ok, _ := IPAllowed("1.1.1.1", nil, nil)
	if !ok {
		t.Fatal("empty lists should allow")
	}
	ok, msg := IPAllowed("1.1.1.1", nil, []string{"1.1.1.1"})
	if ok || msg != "IP已被封禁" {
		t.Fatalf("blacklist %v %s", ok, msg)
	}
	ok, _ = IPAllowed("10.0.0.8", nil, []string{"10.0.0.0/8"})
	if ok {
		t.Fatal("cidr blacklist")
	}
	ok, msg = IPAllowed("2.2.2.2", []string{"1.1.1.1"}, nil)
	if ok || msg != "IP不在白名单" {
		t.Fatalf("whitelist %v %s", ok, msg)
	}
	ok, _ = IPAllowed("1.1.1.1", []string{"1.1.1.1"}, nil)
	if !ok {
		t.Fatal("whitelist hit")
	}
	ok, _ = IPAllowed("127.0.0.1:8080", []string{"127.0.0.1"}, nil)
	if !ok {
		t.Fatal("strip port")
	}
}

func TestCorsOrigin(t *testing.T) {
	got, ok := corsOrigin("http://localhost:5173", []string{"http://localhost:5173"})
	if !ok || got != "http://localhost:5173" {
		t.Fatalf("%s %v", got, ok)
	}
	got, ok = corsOrigin("http://evil.example", []string{"http://localhost:5173"})
	if ok || got != "" {
		t.Fatalf("should deny unmatched origin, got %q", got)
	}
	got, ok = corsOrigin("http://anywhere", []string{"*"})
	if !ok || got != "http://anywhere" {
		t.Fatal("star should reflect origin")
	}
}

func TestMemHitWindow(t *testing.T) {
	key := "t:" + time.Now().Format("15:04:05.000")
	a := memHit(key, 60)
	b := memHit(key, 60)
	if a != 1 || b != 2 {
		t.Fatalf("%d %d", a, b)
	}
}

func TestSkipLimit(t *testing.T) {
	if !skipLimit("/health") || skipLimit("/core/login") {
		t.Fatal("skip paths")
	}
}
