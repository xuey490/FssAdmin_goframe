package controller

import (
	"fssadmin/go-project/internal/modules/cronjob/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	p := "/task/cronjob/node"
	g.GET(p+"/types", webx.Wrap(service.NodeTypes))
	g.GET(p+"/options", webx.Wrap(service.Options))
	g.GET(p+"/list", webx.Wrap(service.NodeList))
	g.GET(p+"/detail/:id", webx.Wrap(service.NodeDetail))
	g.POST(p+"/create", webx.Wrap(service.NodeCreate))
	g.PUT(p+"/update/:id", webx.Wrap(service.NodeUpdate))
	g.DELETE(p+"/delete", webx.Wrap(service.NodeDelete))
	g.DELETE(p+"/clear", webx.Wrap(service.NodeClear))
	g.PATCH(p+"/status/batch", webx.Wrap(service.NodeBatch))
	g.POST(p+"/execute/:id", webx.Wrap(service.NodeExecute))
	g.GET(p+"/logs/:id", webx.Wrap(service.NodeLogs))

	j := "/task/cronjob/job"
	g.GET(j+"/scheduler/status", webx.Wrap(service.SchedulerStatus))
	g.GET(j+"/scheduler/jobs", webx.Wrap(service.SchedulerJobs))
	g.POST(j+"/scheduler/start", webx.Wrap(service.StartScheduler))
	g.POST(j+"/scheduler/pause", webx.Wrap(service.PauseScheduler))
	g.POST(j+"/scheduler/resume", webx.Wrap(service.ResumeScheduler))
	g.POST(j+"/scheduler/shutdown", webx.Wrap(service.ShutdownScheduler))
	g.DELETE(j+"/scheduler/jobs/clear", webx.Wrap(service.ClearJobs))
	g.GET(j+"/scheduler/console", webx.Wrap(service.SchedulerConsole))
	g.POST(j+"/scheduler/sync", webx.Wrap(service.SyncJobs))
	g.POST(j+"/task/pause/:jobId", webx.Wrap(service.TaskPause))
	g.POST(j+"/task/resume/:jobId", webx.Wrap(service.TaskResume))
	g.POST(j+"/task/run/:jobId", webx.Wrap(service.TaskRun))
	g.DELETE(j+"/task/remove/:jobId", webx.Wrap(service.TaskRemove))
	g.GET(j+"/log/list", webx.Wrap(service.JobLogList))
	g.GET(j+"/log/detail/:id", webx.Wrap(service.JobLogDetail))
	g.DELETE(j+"/log/delete", webx.Wrap(service.JobLogDelete))
}
