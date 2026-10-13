package controller

import (
	"fssadmin/go-project/internal/modules/menu/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/menu/list", webx.Wrap(service.List))
	g.GET("/system/menu/tree", webx.Wrap(service.Tree))
	g.GET("/system/menu/user-tree", webx.Wrap(service.UserTree))
	g.GET("/system/menu/user-permissions", webx.Wrap(service.Perms))
	g.GET("/system/menu/permission-tree", webx.Wrap(service.PermissionTree))
	g.GET("/system/menu/access-menu", webx.Wrap(service.AccessMenu))
	g.GET("/system/menu/assignable-tree", webx.Wrap(service.AssignableTree))
	g.GET("/system/menu/detail/:id", webx.Wrap(service.Detail))
	g.POST("/system/menu/create", webx.Wrap(service.Create))
	g.PUT("/system/menu/update/:id", webx.Wrap(service.Update))
	g.DELETE("/system/menu/delete/:id", webx.Wrap(service.Delete))
	g.PUT("/system/menu/status/:id", webx.Wrap(service.Status))
}
