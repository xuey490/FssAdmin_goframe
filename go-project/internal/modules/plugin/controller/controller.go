package controller

import (
	"fssadmin/go-project/internal/modules/plugin/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/plugin/list", webx.Wrap(service.List))
	g.GET("/system/plugin/detail/:name", webx.Wrap(service.Detail))
	g.POST("/system/plugin/create", webx.Wrap(service.Create))
	g.POST("/system/plugin/install", webx.Wrap(service.Install))
	g.POST("/system/plugin/uninstall", webx.Wrap(service.Uninstall))
	g.PUT("/system/plugin/enable/:name", webx.Wrap(service.Enable))
	g.PUT("/system/plugin/disable/:name", webx.Wrap(service.Disable))
	g.GET("/system/plugin/config/:name", webx.Wrap(service.GetConfig))
	g.PUT("/system/plugin/config/:name", webx.Wrap(service.UpdateConfig))
	g.GET("/system/plugin/doctor", webx.Wrap(service.Doctor))
	g.GET("/plugin/list", webx.Wrap(service.List))
}
