package controller

import (
	"fssadmin/go-project/internal/middleware"
	"fssadmin/go-project/internal/modules/dbmaint/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

// core:database:manage 为系统级 slug：硬删除/恢复等破坏性操作仅超管可执行（且需 debug 模式）。
const dbManage = "core:database:manage"

func Bind(g *ghttp.RouterGroup) {
	g.GET("/core/database/table/list", middleware.Permission("core:database:index"), webx.Wrap(service.TableList))
	g.GET("/core/database/table/dataSource", middleware.Permission("core:database:index"), webx.Wrap(service.DataSource))
	g.GET("/core/database/table/detailed", middleware.Permission("core:database:index"), webx.Wrap(service.Detailed))
	g.GET("/core/database/recycle/list", middleware.Permission("core:recycle:index"), webx.Wrap(service.RecycleList))
	g.POST("/core/database/recycle/destroy", middleware.Permission(dbManage), webx.Wrap(service.RecycleDestroy))
	g.POST("/core/database/recycle/recovery", middleware.Permission(dbManage), webx.Wrap(service.RecycleRecovery))
	g.POST("/core/database/table/optimize", middleware.Permission("core:database:edit"), webx.Wrap(service.Optimize))
	g.POST("/core/database/table/fragment", middleware.Permission("core:database:edit"), webx.Wrap(service.Fragment))
	g.GET("/core/database/table/createSql", middleware.Permission("core:database:index"), webx.Wrap(service.CreateSQL))
}
