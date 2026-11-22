package controller

import (
	"fssadmin/go-project/internal/middleware"
	"fssadmin/go-project/internal/modules/post/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/post/list", webx.Wrap(service.List))
	g.GET("/system/post/enabled", webx.Wrap(service.Enabled))
	g.GET("/system/post/detail/:id", webx.Wrap(service.Detail))
	g.GET("/system/post/access-post", webx.Wrap(service.AccessPost))
	g.POST("/system/post/create", middleware.Permission("core:post:save"), webx.Wrap(service.Create))
	g.PUT("/system/post/update/:id", middleware.Permission("core:post:update"), webx.Wrap(service.Update))
	g.DELETE("/system/post/delete/:id", middleware.Permission("core:post:destroy"), webx.Wrap(service.Delete))
	g.PUT("/system/post/status/:id", middleware.Permission("core:post:update"), webx.Wrap(service.Status))
}
