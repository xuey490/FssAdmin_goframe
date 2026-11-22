package controller

import (
	"fssadmin/go-project/internal/middleware"
	"fssadmin/go-project/internal/modules/gencode/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/tool/code/index", webx.Wrap(service.Index))
	g.GET("/tool/code/read", webx.Wrap(service.Read))
	g.GET("/tool/code/preview", webx.Wrap(service.Preview))
	g.GET("/gencode/list", webx.Wrap(service.Index))
	g.PUT("/tool/code/update", middleware.Permission("tool:code:edit"), webx.Wrap(service.Update))
	g.DELETE("/tool/code/destroy", middleware.Permission("tool:code:edit"), webx.Wrap(service.Destroy))
	g.GET("/tool/code/getTableColumns", middleware.Permission("tool:code:edit"), webx.Wrap(service.GetTableColumns))
	g.POST("/tool/code/loadTable", middleware.Permission("tool:code:edit"), webx.Wrap(service.LoadTable))
	g.POST("/tool/code/sync", middleware.Permission("tool:code:edit"), webx.Wrap(service.Sync))
	g.POST("/tool/code/generate", middleware.Permission("tool:code:edit"), service.GenerateBlob)
	g.POST("/tool/code/generateFile", middleware.Permission("tool:code:edit"), webx.Wrap(service.GenerateFile))
}
