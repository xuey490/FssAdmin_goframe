package controller

import (
	"fssadmin/go-project/internal/modules/dept/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/dept/all-enabled", webx.Wrap(service.AllEnabled))
	g.GET("/system/dept/list", webx.Wrap(service.List))
	g.GET("/system/dept/tree", webx.Wrap(service.Tree))
	g.GET("/system/dept/detail/:id", webx.Wrap(service.Detail))
	g.POST("/system/dept/create", webx.Wrap(service.Create))
	g.PUT("/system/dept/update/:id", webx.Wrap(service.Update))
	g.DELETE("/system/dept/delete/:id", webx.Wrap(service.Delete))
	g.PUT("/system/dept/status/:id", webx.Wrap(service.Status))
	g.GET("/system/dept/children/:id", webx.Wrap(service.Children))
	g.GET("/system/dept/access-dept", webx.Wrap(service.AccessDept))
}
