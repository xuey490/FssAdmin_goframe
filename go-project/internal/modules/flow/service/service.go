package service

import (
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
)

func emptyPage(r *ghttp.Request) (interface{}, error) {
	pg, limit := page.Parse(r)
	return response.PageNo([]g.Map{}, 0, pg, limit), nil
}

func StartMeta(r *ghttp.Request) (interface{}, error) {
	return g.Map{"template_id": r.Get("templateId").String(), "fields": []g.Map{}}, nil
}
func ResubmitMeta(r *ghttp.Request) (interface{}, error) {
	return g.Map{"instance_id": r.Get("instanceId").String(), "fields": []g.Map{}}, nil
}
func Start(r *ghttp.Request) (interface{}, error) {
	return g.Map{"id": 0, "status": "created"}, nil
}
func Resubmit(r *ghttp.Request) (interface{}, error)  { return g.Map{"ok": true}, nil }
func MyStarted(r *ghttp.Request) (interface{}, error) { return emptyPage(r) }
func All(r *ghttp.Request) (interface{}, error)       { return emptyPage(r) }
func Detail(r *ghttp.Request) (interface{}, error) {
	return g.Map{"id": r.Get("id").Int(), "status": "none"}, nil
}
func Cancel(r *ghttp.Request) (interface{}, error)    { return g.Map{"ok": true}, nil }
func Terminate(r *ghttp.Request) (interface{}, error) { return g.Map{"ok": true}, nil }
