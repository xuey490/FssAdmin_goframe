package middleware

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gogf/gf/v2/net/ghttp"
)

func TestStripAPIPrefix(t *testing.T) {
	cases := []struct{ in, out string }{
		{"/api/core/login", "/core/login"},
		{"/api/v1/system/user/list", "/system/user/list"},
		{"/api/v1/api/core/login", "/core/login"},
		{"/system/user/list", "/system/user/list"},
	}
	for _, c := range cases {
		got := stripOnce(c.in)
		if got != c.out {
			t.Fatalf("%s -> %s want %s", c.in, got, c.out)
		}
	}
	_ = httptest.NewRequest(http.MethodGet, "/", nil)
	_ = ghttp.Request{}
}

func stripOnce(p string) string {
	for {
		switch {
		case len(p) >= 8 && p[:8] == "/api/v1/" || p == "/api/v1":
			if p == "/api/v1" {
				p = "/"
				continue
			}
			p = p[7:]
		case len(p) >= 5 && p[:5] == "/api/" && (len(p) < 8 || p[:8] != "/api/v1"):
			p = p[4:]
		case p == "/api":
			p = "/"
		default:
			return p
		}
	}
}
