package controller

import (
	"fssadmin/go-project/internal/modules/dict/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/dict/type/list", webx.Wrap(service.TypeList))
	g.POST("/system/dict/type/create", webx.Wrap(service.TypeCreate))
	g.PUT("/system/dict/type/update/:id", webx.Wrap(service.TypeUpdate))
	g.DELETE("/system/dict/type/delete/:id", webx.Wrap(service.TypeDelete))
	g.PUT("/system/dict/type/status/:id", webx.Wrap(service.TypeStatus))
	g.GET("/system/dict/data/list", webx.Wrap(service.DataList))
	g.GET("/system/dict/data/code/:code", webx.Wrap(service.DataByCode))
	g.POST("/system/dict/data/create", webx.Wrap(service.DataCreate))
	g.PUT("/system/dict/data/update/:id", webx.Wrap(service.DataUpdate))
	g.DELETE("/system/dict/data/delete/:id", webx.Wrap(service.DataDelete))
	g.DELETE("/system/dict/data/batchDelete", webx.Wrap(service.DataBatchDelete))
	g.PUT("/system/dict/data/status/:id", webx.Wrap(service.DataStatus))
}
