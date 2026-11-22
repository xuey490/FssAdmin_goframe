package controller

import (
	"fssadmin/go-project/internal/middleware"
	"fssadmin/go-project/internal/modules/config/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/core/configGroup/list", webx.Wrap(service.GroupList))
	g.GET("/core/config/list", webx.Wrap(service.ConfigList))
	g.POST("/core/configGroup/save", middleware.Permission("core:config:save"), webx.Wrap(service.GroupSave))
	g.PUT("/core/configGroup/update/:id", middleware.Permission("core:config:update"), webx.Wrap(service.GroupUpdate))
	g.DELETE("/core/configGroup/delete/:id", middleware.Permission("core:config:update"), webx.Wrap(service.GroupDelete))
	g.POST("/core/configGroup/testEmail", middleware.Permission("core:config:update"), webx.Wrap(service.TestEmail))
	g.POST("/core/config/save", middleware.Permission("core:config:save"), webx.Wrap(service.ConfigSave))
	g.PUT("/core/config/update/:id", middleware.Permission("core:config:update"), webx.Wrap(service.ConfigUpdate))
	g.DELETE("/core/config/delete", middleware.Permission("core:config:update"), webx.Wrap(service.ConfigDelete))
	g.POST("/core/config/batchUpdate", middleware.Permission("core:config:update"), webx.Wrap(service.BatchUpdate))
}
