package controller

import (
	"fssadmin/go-project/internal/middleware"
	"fssadmin/go-project/internal/modules/plugin/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

// core:plugin:manage 为系统级 slug（未分配给任何菜单按钮），即仅超管可执行安装/卸载等操作。
const pluginManage = "core:plugin:manage"

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/plugin/list", webx.Wrap(service.List))
	g.GET("/system/plugin/detail/:name", webx.Wrap(service.Detail))
	g.GET("/system/plugin/config/:name", webx.Wrap(service.GetConfig))
	g.GET("/system/plugin/doctor", webx.Wrap(service.Doctor))
	g.GET("/plugin/list", webx.Wrap(service.List))
	g.POST("/system/plugin/create", middleware.Permission(pluginManage), webx.Wrap(service.Create))
	g.POST("/system/plugin/install", middleware.Permission(pluginManage), webx.Wrap(service.Install))
	g.POST("/system/plugin/uninstall", middleware.Permission(pluginManage), webx.Wrap(service.Uninstall))
	g.PUT("/system/plugin/enable/:name", middleware.Permission(pluginManage), webx.Wrap(service.Enable))
	g.PUT("/system/plugin/disable/:name", middleware.Permission(pluginManage), webx.Wrap(service.Disable))
	g.PUT("/system/plugin/config/:name", middleware.Permission(pluginManage), webx.Wrap(service.UpdateConfig))
}
