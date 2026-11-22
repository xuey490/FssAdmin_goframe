package controller

import (
	"fssadmin/go-project/internal/middleware"
	"fssadmin/go-project/internal/modules/crontab/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/tool/crontab/list", webx.Wrap(service.List))
	g.GET("/tool/crontab/tasks", webx.Wrap(service.Tasks))
	g.GET("/tool/crontab/detail/:id", webx.Wrap(service.Detail))
	g.GET("/tool/crontab/log/list", webx.Wrap(service.LogList))
	g.POST("/tool/crontab/create", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.Create))
	g.PUT("/tool/crontab/update/:id", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.Update))
	g.DELETE("/tool/crontab/delete", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.Delete))
	g.POST("/tool/crontab/run/:id", middleware.Permission("tool:crontab:run"), webx.Wrap(service.Run))
	g.DELETE("/tool/crontab/log/delete", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.LogDelete))
	g.DELETE("/tool/crontab/log/clean", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.LogClean))
}
