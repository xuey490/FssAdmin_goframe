package controller

import (
	"fssadmin/go-project/internal/middleware"
	"fssadmin/go-project/internal/modules/tenant/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/tenant/list", webx.Wrap(service.List))
	g.GET("/system/tenant/detail/:id", webx.Wrap(service.Detail))
	g.GET("/system/tenant/users/:id", webx.Wrap(service.Users))
	g.GET("/system/tenant/available-users/:id", webx.Wrap(service.AvailableUsers))
	g.POST("/system/tenant/create", middleware.Permission("core:tenant:save"), webx.Wrap(service.Create))
	g.PUT("/system/tenant/update/:id", middleware.Permission("core:tenant:update"), webx.Wrap(service.Update))
	g.DELETE("/system/tenant/delete/:id", middleware.Permission("core:tenant:destroy"), webx.Wrap(service.Delete))
	g.PUT("/system/tenant/status/:id", middleware.Permission("core:tenant:update"), webx.Wrap(service.Status))
	g.POST("/system/tenant/add-users/:id", middleware.Permission("core:tenant:update"), webx.Wrap(service.AddUsers))
	g.DELETE("/system/tenant/remove-user/:id/:userId", middleware.Permission("core:tenant:update"), webx.Wrap(service.RemoveUser))
	// 租户管理员/默认管理员变更属于高危操作：非超管（未持有专用 slug）一律拒绝。
	g.PUT("/system/tenant/set-admin/:id/:userId", middleware.Permission("core:tenant:admin"), webx.Wrap(service.SetAdmin))
	g.PUT("/system/tenant/set-default/:id/:userId", middleware.Permission("core:tenant:admin"), webx.Wrap(service.SetDefault))
}
