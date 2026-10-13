package controller

import (
	"fssadmin/go-project/internal/modules/user/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/user/list", webx.Wrap(service.List))
	g.GET("/system/user/detail/:id", webx.Wrap(service.Detail))
	g.POST("/system/user/create", webx.Wrap(service.Create))
	g.PUT("/system/user/update/:id", webx.Wrap(service.Update))
	g.DELETE("/system/user/delete/:id", webx.Wrap(service.Delete))
	g.PUT("/system/user/status/:id", webx.Wrap(service.Status))
	g.PUT("/system/user/reset-password/:id", webx.Wrap(service.ResetPassword))
	g.PUT("/system/user/change-password/:id", webx.Wrap(service.ChangePassword))
	g.PUT("/system/user/clear-cache/:id", webx.Wrap(service.ClearCache))
	g.PUT("/system/user/set-home-page/:id", webx.Wrap(service.SetHomePage))
	g.GET("/system/user/menus/:id", webx.Wrap(service.GetMenus))
	g.PUT("/system/user/menus/:id", webx.Wrap(service.SaveMenus))
}
