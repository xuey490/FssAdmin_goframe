package controller

import (
	"fssadmin/go-project/internal/modules/tenant/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/tenant/list", webx.Wrap(service.List))
	g.GET("/system/tenant/detail/:id", webx.Wrap(service.Detail))
	g.POST("/system/tenant/create", webx.Wrap(service.Create))
	g.PUT("/system/tenant/update/:id", webx.Wrap(service.Update))
	g.DELETE("/system/tenant/delete/:id", webx.Wrap(service.Delete))
	g.PUT("/system/tenant/status/:id", webx.Wrap(service.Status))
	g.GET("/system/tenant/users/:id", webx.Wrap(service.Users))
	g.GET("/system/tenant/available-users/:id", webx.Wrap(service.AvailableUsers))
	g.POST("/system/tenant/add-users/:id", webx.Wrap(service.AddUsers))
	g.DELETE("/system/tenant/remove-user/:id/:userId", webx.Wrap(service.RemoveUser))
	g.PUT("/system/tenant/set-admin/:id/:userId", webx.Wrap(service.SetAdmin))
	g.PUT("/system/tenant/set-default/:id/:userId", webx.Wrap(service.SetDefault))
}
