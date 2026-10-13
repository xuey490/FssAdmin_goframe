package controller

import (
	"fssadmin/go-project/internal/modules/gencode/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/tool/code/index", webx.Wrap(service.Index))
	g.GET("/tool/code/read", webx.Wrap(service.Read))
	g.PUT("/tool/code/update", webx.Wrap(service.Update))
	g.DELETE("/tool/code/destroy", webx.Wrap(service.Destroy))
	g.GET("/tool/code/getTableColumns", webx.Wrap(service.GetTableColumns))
	g.POST("/tool/code/loadTable", webx.Wrap(service.LoadTable))
	g.POST("/tool/code/sync", webx.Wrap(service.Sync))
	g.GET("/tool/code/preview", webx.Wrap(service.Preview))
	g.POST("/tool/code/generate", service.GenerateBlob)
	g.POST("/tool/code/generateFile", webx.Wrap(service.GenerateFile))
	g.GET("/gencode/list", webx.Wrap(service.Index))
}
