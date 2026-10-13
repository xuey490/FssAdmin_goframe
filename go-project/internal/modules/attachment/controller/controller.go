package controller

import (
	"fssadmin/go-project/internal/modules/attachment/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/attachment/list", webx.Wrap(service.List))
	g.GET("/system/attachment/detail/:id", webx.Wrap(service.Detail))
	g.POST("/system/attachment/upload", webx.WrapMsg("上传成功", service.Upload))
	g.PUT("/system/attachment/update/:id", webx.Wrap(service.Update))
	g.DELETE("/system/attachment/delete/:id", webx.Wrap(service.Delete))
	g.DELETE("/system/attachment/batchDelete", webx.Wrap(service.BatchDelete))
	g.PUT("/system/attachment/move", webx.Wrap(service.Move))
	g.GET("/system/attachment/download/:id", service.Download)
	g.GET("/system/attachment/stats", webx.Wrap(service.Stats))
	g.GET("/system/attachment-category/list", webx.Wrap(service.CategoryList))
	g.GET("/system/attachment-category/detail/:id", webx.Wrap(service.CategoryDetail))
	g.POST("/system/attachment-category/create", webx.Wrap(service.CategoryCreate))
	g.PUT("/system/attachment-category/update/:id", webx.Wrap(service.CategoryUpdate))
	g.DELETE("/system/attachment-category/delete/:id", webx.Wrap(service.CategoryDelete))
}
