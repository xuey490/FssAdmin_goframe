package controller

import (
	"fssadmin/go-project/internal/middleware"
	"fssadmin/go-project/internal/modules/role/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/role/list", webx.Wrap(service.List))
	g.GET("/system/role/all", webx.Wrap(service.All))
	g.GET("/system/role/tree", webx.Wrap(service.Tree))
	g.GET("/system/role/detail/:id", webx.Wrap(service.Detail))
	g.GET("/system/role/access-role", webx.Wrap(service.AccessRole))
	g.GET("/system/role/menu-by-role/:id", webx.Wrap(service.MenuByRole))
	g.POST("/system/role/create", middleware.Permission("core:role:save"), webx.Wrap(service.Create))
	g.PUT("/system/role/update/:id", middleware.Permission("core:role:update"), webx.Wrap(service.Update))
	g.DELETE("/system/role/delete/:id", middleware.Permission("core:role:destroy"), webx.Wrap(service.Delete))
	g.PUT("/system/role/status/:id", middleware.Permission("core:role:update"), webx.Wrap(service.Status))
	g.PUT("/system/role/assign-menus/:id", middleware.Permission("core:role:menu"), webx.Wrap(service.AssignMenus))
	g.PUT("/system/role/menu-permission/:id", middleware.Permission("core:role:menu"), webx.Wrap(service.MenuPermission))
}
