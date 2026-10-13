package controller

import (
	"fssadmin/go-project/internal/modules/crontab/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/tool/crontab/list", webx.Wrap(service.List))
	g.GET("/tool/crontab/tasks", webx.Wrap(service.Tasks))
	g.GET("/tool/crontab/detail/:id", webx.Wrap(service.Detail))
	g.POST("/tool/crontab/create", webx.Wrap(service.Create))
	g.PUT("/tool/crontab/update/:id", webx.Wrap(service.Update))
	g.DELETE("/tool/crontab/delete", webx.Wrap(service.Delete))
	g.POST("/tool/crontab/run/:id", webx.Wrap(service.Run))
	g.GET("/tool/crontab/log/list", webx.Wrap(service.LogList))
	g.DELETE("/tool/crontab/log/delete", webx.Wrap(service.LogDelete))
	g.DELETE("/tool/crontab/log/clean", webx.Wrap(service.LogClean))
}
