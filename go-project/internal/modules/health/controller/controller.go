package controller

import (
	"fssadmin/go-project/internal/modules/health/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/health", webx.Wrap(service.Health))
	g.GET("/health/live", webx.Wrap(service.Live))
	g.GET("/health/ready", webx.Wrap(service.Ready))
	g.GET("/common/health", webx.Wrap(service.Health))
	g.GET("/common/live", webx.Wrap(service.Live))
	g.GET("/common/ready", webx.Wrap(service.Ready))
	g.GET("/live", webx.Wrap(service.Live))
	g.GET("/ready", webx.Wrap(service.Ready))
}
