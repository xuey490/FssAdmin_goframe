package controller

import (
	"fssadmin/go-project/internal/modules/monitor/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/monitor/online/list", webx.Wrap(service.OnlineList))
	g.DELETE("/monitor/online/:token", webx.Wrap(service.ForceLogout))
	g.GET("/core/server/monitor", webx.Wrap(service.ServerMonitor))
	g.GET("/core/server/cache", webx.Wrap(service.CacheList))
	g.POST("/core/server/clear", webx.Wrap(service.CacheClear))
	g.GET("/core/server/redis", webx.Wrap(service.RedisMonitor))
	g.GET("/core/redis/info", webx.Wrap(service.RedisInfo))
	g.GET("/core/redis/operations", webx.Wrap(service.RedisOperations))
	g.GET("/core/redis/keys", webx.Wrap(service.RedisKeys))
	g.DELETE("/core/redis/deleteKeys", webx.Wrap(service.RedisDeleteKeys))
	g.GET("/core/server/redis/browser/level1", webx.Wrap(service.BrowserLevel1))
	g.GET("/core/server/redis/browser/level2", webx.Wrap(service.BrowserLevel2))
	g.GET("/core/server/redis/browser/level3", webx.Wrap(service.BrowserLevel3))
	g.GET("/core/server/redis/browser/key-info", webx.Wrap(service.BrowserKeyInfo))
	g.DELETE("/core/server/redis/browser/delete", webx.Wrap(service.BrowserDelete))
}
