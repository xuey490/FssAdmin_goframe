package controller

import (
	"fssadmin/go-project/internal/modules/video/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/platform/video/list", webx.Wrap(service.List))
	g.GET("/platform/video/progress", webx.Wrap(service.Progress))
	g.POST("/platform/video/create", webx.Wrap(service.Create))
	g.PUT("/platform/video/update/:id", webx.Wrap(service.Update))
	g.POST("/platform/video/refresh/:id", webx.Wrap(service.Refresh))
	g.DELETE("/platform/video/delete/:id", webx.Wrap(service.Delete))
	g.GET("/platform/video/preview/:id", webx.Wrap(service.Preview))
	g.GET("/platform/video/formats/:id", webx.Wrap(service.Formats))
	g.GET("/platform/video/files/:id", webx.Wrap(service.LocalFiles))
	g.POST("/platform/video/download/:id", webx.Wrap(service.Download))
	g.GET("/platform/video/download/queue", webx.Wrap(service.Queue))
	g.POST("/platform/video/download/job/:jobId/pause", webx.Wrap(service.PauseJob))
	g.POST("/platform/video/download/job/:jobId/resume", webx.Wrap(service.ResumeJob))
	g.POST("/platform/video/download/job/:jobId/stop", webx.Wrap(service.StopJob))
	g.POST("/platform/video/download/queue/pause-all", webx.Wrap(service.PauseAll))
	g.POST("/platform/video/download/queue/resume-all", webx.Wrap(service.ResumeAll))
	g.GET("/platform/video/stream/:id", service.Stream)
}
