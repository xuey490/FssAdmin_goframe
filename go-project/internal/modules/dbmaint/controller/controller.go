package controller

import (
	"fssadmin/go-project/internal/modules/dbmaint/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/core/database/table/list", webx.Wrap(service.TableList))
	g.GET("/core/database/table/dataSource", webx.Wrap(service.DataSource))
	g.GET("/core/database/table/detailed", webx.Wrap(service.Detailed))
	g.GET("/core/database/recycle/list", webx.Wrap(service.RecycleList))
	g.POST("/core/database/recycle/destroy", webx.Wrap(service.RecycleDestroy))
	g.POST("/core/database/recycle/recovery", webx.Wrap(service.RecycleRecovery))
	g.POST("/core/database/table/optimize", webx.Wrap(service.Optimize))
	g.POST("/core/database/table/fragment", webx.Wrap(service.Fragment))
	g.GET("/core/database/table/createSql", webx.Wrap(service.CreateSQL))
}
