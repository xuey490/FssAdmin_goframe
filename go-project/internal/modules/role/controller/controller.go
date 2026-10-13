package controller

import (
	"fssadmin/go-project/internal/modules/role/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/role/list", webx.Wrap(service.List))
	g.GET("/system/role/all", webx.Wrap(service.All))
	g.GET("/system/role/tree", webx.Wrap(service.Tree))
	g.GET("/system/role/detail/:id", webx.Wrap(service.Detail))
	g.POST("/system/role/create", webx.Wrap(service.Create))
	g.PUT("/system/role/update/:id", webx.Wrap(service.Update))
	g.DELETE("/system/role/delete/:id", webx.Wrap(service.Delete))
	g.PUT("/system/role/status/:id", webx.Wrap(service.Status))
	g.PUT("/system/role/assign-menus/:id", webx.Wrap(service.AssignMenus))
	g.GET("/system/role/access-role", webx.Wrap(service.AccessRole))
	g.GET("/system/role/menu-by-role/:id", webx.Wrap(service.MenuByRole))
	g.PUT("/system/role/menu-permission/:id", webx.Wrap(service.MenuPermission))
}
