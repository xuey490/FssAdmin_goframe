package controller

import (
	"fssadmin/go-project/internal/middleware"
	"fssadmin/go-project/internal/modules/user/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/user/list", webx.Wrap(service.List))
	g.GET("/system/user/detail/:id", webx.Wrap(service.Detail))
	// 写操作按菜单按钮 slug 校验权限（Permission 内超管直通），
	// 与前端按钮级权限标识一致，防止任何登录用户执行管理操作。
	g.POST("/system/user/create", middleware.Permission("core:user:save"), webx.Wrap(service.Create))
	g.PUT("/system/user/update/:id", middleware.Permission("core:user:update"), webx.Wrap(service.Update))
	g.DELETE("/system/user/delete/:id", middleware.Permission("core:user:destroy"), webx.Wrap(service.Delete))
	g.PUT("/system/user/status/:id", middleware.Permission("core:user:update"), webx.Wrap(service.Status))
	g.PUT("/system/user/reset-password/:id", middleware.Permission("core:user:password"), webx.Wrap(service.ResetPassword))
	g.PUT("/system/user/change-password/:id", middleware.Permission("core:user:password"), webx.Wrap(service.ChangePassword))
	g.PUT("/system/user/clear-cache/:id", middleware.Permission("core:user:cache"), webx.Wrap(service.ClearCache))
	g.PUT("/system/user/set-home-page/:id", middleware.Permission("core:user:update"), webx.Wrap(service.SetHomePage))
	g.GET("/system/user/menus/:id", webx.Wrap(service.GetMenus))
	g.PUT("/system/user/menus/:id", middleware.Permission("core:user:menu"), webx.Wrap(service.SaveMenus))
}
