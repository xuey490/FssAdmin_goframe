package controller

import (
	"fssadmin/go-project/internal/modules/post/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/post/list", webx.Wrap(service.List))
	g.GET("/system/post/enabled", webx.Wrap(service.Enabled))
	g.GET("/system/post/detail/:id", webx.Wrap(service.Detail))
	g.POST("/system/post/create", webx.Wrap(service.Create))
	g.PUT("/system/post/update/:id", webx.Wrap(service.Update))
	g.DELETE("/system/post/delete/:id", webx.Wrap(service.Delete))
	g.PUT("/system/post/status/:id", webx.Wrap(service.Status))
	g.GET("/system/post/access-post", webx.Wrap(service.AccessPost))
}
