package bootstrap

import (
	"context"
	"os"
	"path/filepath"
	"time"

	"fssadmin/go-project/internal/middleware"
	articler "fssadmin/go-project/internal/modules/article/router"
	attachr "fssadmin/go-project/internal/modules/attachment/router"
	authr "fssadmin/go-project/internal/modules/auth/router"
	configr "fssadmin/go-project/internal/modules/config/router"
	cronr "fssadmin/go-project/internal/modules/cronjob/router"
	cronsvc "fssadmin/go-project/internal/modules/cronjob/service"
	crontabr "fssadmin/go-project/internal/modules/crontab/router"
	dbmr "fssadmin/go-project/internal/modules/dbmaint/router"
	demor "fssadmin/go-project/internal/modules/demo/router"
	deptr "fssadmin/go-project/internal/modules/dept/router"
	dictr "fssadmin/go-project/internal/modules/dict/router"
	filer "fssadmin/go-project/internal/modules/file/router"
	flowr "fssadmin/go-project/internal/modules/flow/router"
	gencr "fssadmin/go-project/internal/modules/gencode/router"
	healthr "fssadmin/go-project/internal/modules/health/router"
	logmodr "fssadmin/go-project/internal/modules/logmod/router"
	menur "fssadmin/go-project/internal/modules/menu/router"
	monitorr "fssadmin/go-project/internal/modules/monitor/router"
	noticer "fssadmin/go-project/internal/modules/notice/router"
	pluginr "fssadmin/go-project/internal/modules/plugin/router"
	postr "fssadmin/go-project/internal/modules/post/router"
	roler "fssadmin/go-project/internal/modules/role/router"
	tenantr "fssadmin/go-project/internal/modules/tenant/router"
	userr "fssadmin/go-project/internal/modules/user/router"
	videor "fssadmin/go-project/internal/modules/video/router"
	wsair "fssadmin/go-project/internal/modules/wsai/router"
	"fssadmin/go-project/internal/shared/cachex"
	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/logx"
	"fssadmin/go-project/internal/shared/openapi"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gctx"
	"github.com/gogf/gf/v2/os/gfile"
)

func Bind(s *ghttp.Server) {
	logx.Apply(conf.Debug(), conf.LogStack())
	s.Logger().SetDebug(conf.Debug())
	s.Logger().SetStack(conf.LogStack())
	// 日志按大小滚动（应用日志与 WebServer 日志各自独立）
	ApplyLogRotation(gctx.New(), s)
	s.BindHookHandler("/*", ghttp.HookBeforeServe, middleware.RewriteAPIPrefix)
	s.Use(
		middleware.CORS,
		middleware.CSRF,
		middleware.IPBan,
		middleware.RateLimit,
		middleware.XSS,
		middleware.Debug,
		middleware.Correlation,
		middleware.Gzip,
		middleware.Recover,
		middleware.DemoGuard,
		middleware.Auth,
		middleware.Tenant,
		middleware.OperLog,
	)
	mount := func(group *ghttp.RouterGroup) {
		healthr.Register(group)
		authr.Register(group)
		userr.Register(group)
		roler.Register(group)
		menur.Register(group)
		deptr.Register(group)
		postr.Register(group)
		tenantr.Register(group)
		dictr.Register(group)
		configr.Register(group)
		attachr.Register(group)
		noticer.Register(group)
		logmodr.Register(group)
		pluginr.Register(group)
		articler.Register(group)
		videor.Register(group)
		monitorr.Register(group)
		dbmr.Register(group)
		cronr.Register(group)
		crontabr.Register(group)
		gencr.Register(group)
		filer.Register(group)
		demor.Register(group)
		flowr.Register(group)
		wsair.Register(group)
	}
	s.Group("/", mount)
	s.Group("/api", mount)
	s.Group("/api/v1", mount)
	upload := conf.UploadDir()
		_ = os.MkdirAll(upload, 0755)
		_ = os.MkdirAll(conf.VideoDir(), 0755)
		s.AddStaticPath("/uploads", upload)
		s.AddStaticPath("/static", "resource/public")
		if gfile.Exists("static") {
			s.AddStaticPath("/static/upload", "static/upload")
			s.AddStaticPath("/static/videos", "static/videos")
		}
		if prefix := conf.UploadPublicPrefix(); prefix != "" && prefix != "/uploads" && prefix != "/static/upload" {
			s.AddStaticPath(prefix, upload)
		}
	if dir := g.Cfg().MustGet(gctx.New(), "server.logPath").String(); dir != "" {
		_ = os.MkdirAll(dir, 0755)
	}
	s.BindHookHandler("/api.json", ghttp.HookBeforeServe, func(r *ghttp.Request) {
		openapi.Publish(s)
	})
}

func Ready() {
	ctx := gctx.New()
	logx.Apply(conf.Debug(), conf.LogStack())
	pingDB(ctx)
	if pingRedis(ctx) {
		cachex.Warm(ctx)
	}
	if conf.SchedulerOn() {
		if err := cronsvc.Boot(ctx); err != nil {
			g.Log().Warningf(ctx, "scheduler: %v", err)
		}
	}
}

func pingDB(ctx context.Context) {
	deadline := time.Now().Add(8 * time.Second)
	for {
		_, err := g.DB().Raw("SELECT 1").One()
		if err == nil {
			g.Log().Info(ctx, "mysql ready")
			return
		}
		if time.Now().After(deadline) {
			g.Log().Warningf(ctx, "mysql not ready: %v (degraded)", err)
			return
		}
		time.Sleep(500 * time.Millisecond)
	}
}

func pingRedis(ctx context.Context) bool {
	_, err := g.Redis().Do(ctx, "PING")
	if err != nil {
		g.Log().Warningf(ctx, "redis not ready: %v (session fallback to jwt)", err)
		return false
	}
	g.Log().Info(ctx, "redis ready")
	return true
}

func ConfigFile() string {
	cands := []string{
		"manifest/config/config.yaml",
		filepath.Join("manifest", "config", "config.yaml"),
		os.Getenv("GF_GCFG_FILE"),
	}
	for _, c := range cands {
		if c != "" && gfile.Exists(c) {
			return c
		}
	}
	return "manifest/config/config.yaml"
}
