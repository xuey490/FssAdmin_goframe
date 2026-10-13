package main

import (
	"os"
	"time"

	"fssadmin/go-project/internal/bootstrap"
	_ "github.com/gogf/gf/contrib/drivers/mysql/v2"
	_ "github.com/gogf/gf/contrib/nosql/redis/v2"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gctx"
	"github.com/gogf/gf/v2/os/gfile"
)

func main() {
	startedAt := time.Now()
	ctx := gctx.GetInitCtx()
	cfg := bootstrap.ConfigFile()
	if gfile.Exists(cfg) && os.Getenv("GF_GCFG_FILE") == "" {
		_ = os.Setenv("GF_GCFG_PATH", gfile.Dir(cfg))
	}
	s := g.Server()
	bootstrap.Bind(s)
	bootstrap.Ready()
	// 启动自检：依赖状态、关键配置、运行占用（控制台 + 日志文件各一份）
	bootstrap.PrintStartupInfo(ctx, startedAt)
	g.Log().Infof(ctx, "FssAdmin GoFrame listening")
	s.Run()
}
