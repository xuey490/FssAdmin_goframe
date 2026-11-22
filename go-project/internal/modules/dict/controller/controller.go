package controller

import (
	"fssadmin/go-project/internal/middleware"
	"fssadmin/go-project/internal/modules/dict/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/system/dict/type/list", webx.Wrap(service.TypeList))
	g.GET("/system/dict/data/list", webx.Wrap(service.DataList))
	g.GET("/system/dict/data/code/:code", webx.Wrap(service.DataByCode))
	g.POST("/system/dict/type/create", middleware.Permission("core:dict:edit"), webx.Wrap(service.TypeCreate))
	g.PUT("/system/dict/type/update/:id", middleware.Permission("core:dict:edit"), webx.Wrap(service.TypeUpdate))
	g.DELETE("/system/dict/type/delete/:id", middleware.Permission("core:dict:edit"), webx.Wrap(service.TypeDelete))
	g.PUT("/system/dict/type/status/:id", middleware.Permission("core:dict:edit"), webx.Wrap(service.TypeStatus))
	g.POST("/system/dict/data/create", middleware.Permission("core:dict:edit"), webx.Wrap(service.DataCreate))
	g.PUT("/system/dict/data/update/:id", middleware.Permission("core:dict:edit"), webx.Wrap(service.DataUpdate))
	g.DELETE("/system/dict/data/delete/:id", middleware.Permission("core:dict:edit"), webx.Wrap(service.DataDelete))
	g.DELETE("/system/dict/data/batchDelete", middleware.Permission("core:dict:edit"), webx.Wrap(service.DataBatchDelete))
	g.PUT("/system/dict/data/status/:id", middleware.Permission("core:dict:edit"), webx.Wrap(service.DataStatus))
}
