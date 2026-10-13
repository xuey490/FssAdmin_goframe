package controller

import (
	"fssadmin/go-project/internal/modules/config/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/core/configGroup/list", webx.Wrap(service.GroupList))
	g.POST("/core/configGroup/save", webx.Wrap(service.GroupSave))
	g.PUT("/core/configGroup/update/:id", webx.Wrap(service.GroupUpdate))
	g.DELETE("/core/configGroup/delete/:id", webx.Wrap(service.GroupDelete))
	g.POST("/core/configGroup/testEmail", webx.Wrap(service.TestEmail))
	g.GET("/core/config/list", webx.Wrap(service.ConfigList))
	g.POST("/core/config/save", webx.Wrap(service.ConfigSave))
	g.PUT("/core/config/update/:id", webx.Wrap(service.ConfigUpdate))
	g.DELETE("/core/config/delete", webx.Wrap(service.ConfigDelete))
	g.POST("/core/config/batchUpdate", webx.Wrap(service.BatchUpdate))
}
