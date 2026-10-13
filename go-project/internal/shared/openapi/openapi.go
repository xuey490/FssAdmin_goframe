package openapi

import (
	"strings"

	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/net/goai"
)

// Publish fills GoFrame's OpenAPI object from registered routes.
// Strict g.Meta routes are merged later by the server; plain handlers are listed here
// so /docs is not empty. Only the /api prefix is kept; / and /api/v1 are the same handlers.
func Publish(s *ghttp.Server) {
	oa := s.GetOpenApi()
	oa.Info.Title = "FssAdmin"
	oa.Info.Version = "0.1.0"
	oa.Info.Description = "由 WebServer 已注册路由生成。浏览器打开 /docs ，规范文件是 /api.json。"
	if oa.Paths == nil {
		oa.Paths = goai.Paths{}
	}
	for _, item := range s.GetRoutes() {
		if !includeRoute(string(item.Type), item.Method, item.Route) {
			continue
		}
		p := oa.Paths[item.Route]
		op := &goai.Operation{
			Tags:    []string{tagOf(item.Route)},
			Summary: item.Method + " " + item.Route,
			Responses: goai.Responses{
				"200": {Value: &goai.Response{Description: "OK"}},
			},
		}
		switch strings.ToUpper(item.Method) {
		case "GET":
			p.Get = op
		case "POST":
			p.Post = op
		case "PUT":
			p.Put = op
		case "PATCH":
			p.Patch = op
		case "DELETE":
			p.Delete = op
		case "HEAD":
			p.Head = op
		case "OPTIONS":
			p.Options = op
		default:
			continue
		}
		oa.Paths[item.Route] = p
	}
}

func includeRoute(typ, method, route string) bool {
	if typ == string(ghttp.HandlerTypeMiddleware) || typ == string(ghttp.HandlerTypeHook) {
		return false
	}
	if method == "" || method == "ALL" || strings.Contains(route, "*") {
		return false
	}
	if route == "/api.json" || strings.HasPrefix(route, "/docs") || strings.HasPrefix(route, "/swagger") {
		return false
	}
	return strings.HasPrefix(route, "/api/") && !strings.HasPrefix(route, "/api/v1")
}

func tagOf(route string) string {
	p := strings.TrimPrefix(route, "/api/")
	if i := strings.IndexByte(p, '/'); i > 0 {
		return p[:i]
	}
	if p == "" {
		return "default"
	}
	return p
}
