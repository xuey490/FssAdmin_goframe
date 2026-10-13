package controller

import (
	"fssadmin/go-project/internal/modules/wsai/service"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/ws/ai", service.Handle)
}
