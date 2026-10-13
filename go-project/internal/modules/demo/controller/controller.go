package controller

import (
	"fssadmin/go-project/internal/modules/demo/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/demo/list", webx.Wrap(service.List))
	g.GET("/demo/detail/:id", webx.Wrap(service.Detail))
	g.POST("/demo/create", webx.Wrap(service.Create))
	g.PUT("/demo/update/:id", webx.Wrap(service.Update))
	g.DELETE("/demo/delete", webx.Wrap(service.Delete))
	g.DELETE("/demo/delete/:id", webx.Wrap(service.Delete))
	g.POST("/demo/export", webx.Wrap(service.Export))
}
