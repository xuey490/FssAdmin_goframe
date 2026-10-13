package controller

import (
	"fssadmin/go-project/internal/modules/notice/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/notice/list", webx.Wrap(service.List))
	g.GET("/system/notice/detail/:id", webx.Wrap(service.Detail))
	g.POST("/system/notice/create", webx.Wrap(service.Create))
	g.PUT("/system/notice/update/:id", webx.Wrap(service.Update))
	g.DELETE("/system/notice/delete/:id", webx.Wrap(service.Delete))
	g.PUT("/system/notice/status/:id", webx.Wrap(service.Status))
}
