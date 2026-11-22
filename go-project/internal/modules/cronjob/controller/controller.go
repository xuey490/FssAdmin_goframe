package controller

import (
	"fssadmin/go-project/internal/middleware"
	"fssadmin/go-project/internal/modules/cronjob/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

// cronjob 复用 tool:crontab:* 的按钮 slug（同属定时任务域）：
// 写操作需 tool:crontab:edit，立即执行需 tool:crontab:run。
// 未持有该 slug 的普通登录用户此前可直接执行 shell/http 任务（RCE/SSRF 面），现已收敛。
func Bind(g *ghttp.RouterGroup) {
	p := "/task/cronjob/node"
	g.GET(p+"/types", webx.Wrap(service.NodeTypes))
	g.GET(p+"/options", webx.Wrap(service.Options))
	g.GET(p+"/list", webx.Wrap(service.NodeList))
	g.GET(p+"/detail/:id", webx.Wrap(service.NodeDetail))
	g.GET(p+"/logs/:id", webx.Wrap(service.NodeLogs))
	g.POST(p+"/create", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.NodeCreate))
	g.PUT(p+"/update/:id", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.NodeUpdate))
	g.DELETE(p+"/delete", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.NodeDelete))
	g.DELETE(p+"/clear", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.NodeClear))
	g.PATCH(p+"/status/batch", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.NodeBatch))
	g.POST(p+"/execute/:id", middleware.Permission("tool:crontab:run"), webx.Wrap(service.NodeExecute))

	j := "/task/cronjob/job"
	g.GET(j+"/scheduler/status", webx.Wrap(service.SchedulerStatus))
	g.GET(j+"/scheduler/jobs", webx.Wrap(service.SchedulerJobs))
	g.GET(j+"/scheduler/console", webx.Wrap(service.SchedulerConsole))
	g.POST(j+"/scheduler/start", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.StartScheduler))
	g.POST(j+"/scheduler/pause", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.PauseScheduler))
	g.POST(j+"/scheduler/resume", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.ResumeScheduler))
	g.POST(j+"/scheduler/shutdown", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.ShutdownScheduler))
	g.POST(j+"/scheduler/sync", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.SyncJobs))
	g.DELETE(j+"/scheduler/jobs/clear", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.ClearJobs))
	g.POST(j+"/task/pause/:jobId", middleware.Permission("tool:crontab:run"), webx.Wrap(service.TaskPause))
	g.POST(j+"/task/resume/:jobId", middleware.Permission("tool:crontab:run"), webx.Wrap(service.TaskResume))
	g.POST(j+"/task/run/:jobId", middleware.Permission("tool:crontab:run"), webx.Wrap(service.TaskRun))
	g.DELETE(j+"/task/remove/:jobId", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.TaskRemove))
	g.GET(j+"/log/list", webx.Wrap(service.JobLogList))
	g.GET(j+"/log/detail/:id", webx.Wrap(service.JobLogDetail))
	g.DELETE(j+"/log/delete", middleware.Permission("tool:crontab:edit"), webx.Wrap(service.JobLogDelete))
}
