package controller

import (
	"fssadmin/go-project/internal/modules/article/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/article/list", webx.Wrap(service.List))
	g.GET("/article/detail/:id", webx.Wrap(service.Detail))
	g.POST("/article/create", webx.Wrap(service.Create))
	g.PUT("/article/update/:id", webx.Wrap(service.Update))
	g.DELETE("/article/delete", webx.Wrap(service.Delete))
	g.PUT("/article/status/:id", webx.Wrap(service.Status))
	g.GET("/article/category/list", webx.Wrap(service.CategoryList))
	g.POST("/article/category/create", webx.Wrap(service.CategoryCreate))
	g.PUT("/article/category/update/:id", webx.Wrap(service.CategoryUpdate))
	g.DELETE("/article/category/delete/:id", webx.Wrap(service.CategoryDelete))
	g.GET("/article/banner/list", webx.Wrap(service.BannerList))
}
