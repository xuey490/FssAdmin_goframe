package router

import (
	"fssadmin/go-project/internal/modules/attachment/controller"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Register(g *ghttp.RouterGroup) { controller.Bind(g) }
