package controller

import (
	"fssadmin/go-project/internal/modules/flow/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/flow/instance/start-meta/:templateId", webx.Wrap(service.StartMeta))
	g.GET("/flow/instance/resubmit-meta/:instanceId", webx.Wrap(service.ResubmitMeta))
	g.POST("/flow/instance/start", webx.Wrap(service.Start))
	g.POST("/flow/instance/resubmit", webx.Wrap(service.Resubmit))
	g.GET("/flow/instance/my-started", webx.Wrap(service.MyStarted))
	g.GET("/flow/instance/all", webx.Wrap(service.All))
	g.GET("/flow/instance/detail/:id", webx.Wrap(service.Detail))
	g.POST("/flow/instance/cancel/:id", webx.Wrap(service.Cancel))
	g.POST("/flow/instance/terminate/:id", webx.Wrap(service.Terminate))
}
