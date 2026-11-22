package controller

import (
	"fssadmin/go-project/internal/middleware"
	"fssadmin/go-project/internal/modules/monitor/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/monitor/online/list", middleware.Permission("core:server:monitor"), webx.Wrap(service.OnlineList))
	g.DELETE("/monitor/online/:token", middleware.Permission("core:server:monitor"), webx.Wrap(service.ForceLogout))
	g.GET("/core/server/monitor", middleware.Permission("core:server:monitor"), webx.Wrap(service.ServerMonitor))
	g.GET("/core/server/cache", middleware.Permission("core:server:cache"), webx.Wrap(service.CacheList))
	g.POST("/core/server/clear", middleware.Permission("core:server:clear"), webx.Wrap(service.CacheClear))
	g.GET("/core/server/redis", middleware.Permission("core:server:redis"), webx.Wrap(service.RedisMonitor))
	g.GET("/core/redis/info", middleware.Permission("core:server:redis"), webx.Wrap(service.RedisInfo))
	g.GET("/core/redis/operations", middleware.Permission("core:server:redis"), webx.Wrap(service.RedisOperations))
	g.GET("/core/redis/keys", middleware.Permission("core:server:redis"), webx.Wrap(service.RedisKeys))
	// Redis 写操作（删键）与浏览器只读分开管控。
	g.DELETE("/core/redis/deleteKeys", middleware.Permission("core:server:redis:manage"), webx.Wrap(service.RedisDeleteKeys))
	g.GET("/core/server/redis/browser/level1", middleware.Permission("core:server:redis"), webx.Wrap(service.BrowserLevel1))
	g.GET("/core/server/redis/browser/level2", middleware.Permission("core:server:redis"), webx.Wrap(service.BrowserLevel2))
	g.GET("/core/server/redis/browser/level3", middleware.Permission("core:server:redis"), webx.Wrap(service.BrowserLevel3))
	g.GET("/core/server/redis/browser/key-info", middleware.Permission("core:server:redis"), webx.Wrap(service.BrowserKeyInfo))
	g.DELETE("/core/server/redis/browser/delete", middleware.Permission("core:server:redis:manage"), webx.Wrap(service.BrowserDelete))
}
