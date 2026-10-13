package bootstrap

import (
	"context"
	"fmt"
	"os"
	"runtime"
	"strings"
	"time"

	cronsvc "fssadmin/go-project/internal/modules/cronjob/service"
	"fssadmin/go-project/internal/shared/conf"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gfile"
)

// ApplyLogRotation 让应用日志与 WebServer 日志按大小滚动。
// 两者是各自独立的 glog 实例，因此需要分别配置；大小/备份数/保留期来自 logger.* 配置。
func ApplyLogRotation(ctx context.Context, s *ghttp.Server) {
	cfg := g.Map{
		"rotateSize":          conf.LogRotateSize(),
		"rotateBackupLimit":   conf.LogRotateBackupLimit(),
		"rotateBackupExpire":  conf.LogRotateBackupExpire(),
		"rotateCheckInterval": conf.LogRotateCheckInterval(),
	}
	if err := g.Log().SetConfigWithMap(cfg); err != nil {
		g.Log().Warningf(ctx, "应用日志滚动配置失败: %v", err)
	}
	if err := s.Logger().SetConfigWithMap(cfg); err != nil {
		g.Log().Warningf(ctx, "WebServer 日志滚动配置失败: %v", err)
	}
}

// PrintStartupInfo 输出启动自检信息：依赖状态、关键配置与运行时资源占用。
// 全量内容打印到控制台，同时把要点写入日志文件，便于线上排查。
func PrintStartupInfo(ctx context.Context, since time.Time) {
	env := fmt.Sprintf("%s %s/%s | %d 核 | PID %d | 主机 %s | 启动耗时 %s",
		runtime.Version(), runtime.GOOS, runtime.GOARCH, runtime.NumCPU(),
		os.Getpid(), hostname(), durationText(time.Since(since)))
	app := fmt.Sprintf("%s %s | 调试=%s | 时区 %s | 调度器=%s",
		conf.AppName(), conf.AppVersion(), onOff(conf.Debug()),
		conf.Timezone(), onOff(conf.SchedulerOn()))
	listen := fmt.Sprintf("%s%s | OpenAPI %s | Swagger %s",
		conf.ServerAddress(), listenHint(conf.ServerAddress()),
		conf.OpenapiPath(), conf.SwaggerPath())
	mysql, redis := mysqlSummary(ctx), redisSummary(ctx)
	scheduler, runtimeInfo, dirs := schedulerSummary(), runtimeSummary(), dirSummary()

	pairs := [][2]string{
		{"运行环境", env},
		{"应用", app},
		{"配置", ConfigFile()},
		{"监听", listen},
		{"MySQL", mysql},
		{"Redis", redis},
		{"调度器", scheduler},
		{"运行占用", runtimeInfo},
		{"目录", dirs},
	}

	rows := alignPairs(pairs)
	width := 0
	for _, line := range rows {
		if n := displayWidth(line); n > width {
			width = n
		}
	}
	border := strings.Repeat("─", width+2)

	var b strings.Builder
	b.WriteString("\n" + border + "\n")
	for _, line := range rows {
		b.WriteString(" " + line + "\n")
	}
	b.WriteString(border + "\n")
	// 走 stdout：启动自检需要稳定出现在控制台
	fmt.Print(b.String())

	// 同一份信息写入日志文件，便于线上排查
	g.Log().Infof(ctx, "startup info pid=%d config=%s listen=%s mysql=%s redis=%s scheduler=%s runtime=%s dirs=%s",
		os.Getpid(), ConfigFile(), listen, mysql, redis, scheduler, runtimeInfo, dirs)
}

// alignPairs 按终端显示宽度对齐标签（CJK 按 2 列），中英文混排也能对齐。
func alignPairs(pairs [][2]string) []string {
	width := 0
	for _, p := range pairs {
		if n := displayWidth(p[0]); n > width {
			width = n
		}
	}
	lines := make([]string, 0, len(pairs))
	for _, p := range pairs {
		pad := strings.Repeat(" ", width-displayWidth(p[0]))
		lines = append(lines, p[0]+pad+"  "+p[1])
	}
	return lines
}

// displayWidth 估算字符串在等宽终端里的列数：CJK/全角按 2 列，其余按 1 列。
func displayWidth(s string) int {
	width := 0
	for _, r := range s {
		switch {
		case r >= 0x1100 && (r <= 0x115F || // Hangul Jamo
			r == 0x2329 || r == 0x232A ||
			(r >= 0x2E80 && r <= 0xA4CF && r != 0x303F) || // CJK 部首~注音
			(r >= 0xAC00 && r <= 0xD7A3) || // Hangul 音节
			(r >= 0xF900 && r <= 0xFAFF) || // CJK 兼容表意
			(r >= 0xFE30 && r <= 0xFE6F) || // CJK 兼容形式
			(r >= 0xFF00 && r <= 0xFF60) || // 全角
			(r >= 0xFFE0 && r <= 0xFFE6) ||
			(r >= 0x20000 && r <= 0x3FFFD)): // CJK 扩展
			width += 2
		default:
			width++
		}
	}
	return width
}

// ---------------------------------------------------------------------------
// 各项摘要
// ---------------------------------------------------------------------------

func mysqlSummary(ctx context.Context) string {
	cfg := g.DB().GetConfig()
	target := fmt.Sprintf("%s:%s/%s 用户=%s(密码已隐藏)", cfg.Host, cfg.Port, cfg.Name, cfg.User)
	start := time.Now()
	version, err := g.DB().GetValue(ctx, "SELECT VERSION()")
	if err != nil {
		return target + " | " + mark(false) + " " + shorten(err.Error(), 80)
	}
	maxIdle := g.Cfg().MustGet(ctx, "database.default.maxIdle").Int()
	maxOpen := g.Cfg().MustGet(ctx, "database.default.maxOpen").Int()
	return fmt.Sprintf("%s | 版本 %s | 查询耗时 %s | 连接池 空闲 %d 最大 %d",
		target, version.String(), durationText(time.Since(start)), maxIdle, maxOpen)
}

func redisSummary(ctx context.Context) string {
	target := fmt.Sprintf("%s db=%d", conf.RedisAddress(), conf.RedisDB())
	start := time.Now()
	info, err := g.Redis().Do(ctx, "INFO", "server")
	if err != nil {
		return target + " | " + mark(false) + " " + shorten(err.Error(), 80)
	}
	cost := time.Since(start)
	version := ""
	for _, line := range strings.Split(info.String(), "\n") {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "redis_version:") {
			version = strings.TrimSpace(strings.TrimPrefix(line, "redis_version:"))
			break
		}
	}
	if version == "" {
		version = "未知"
	}
	keys := ""
	if size, kerr := g.Redis().Do(ctx, "DBSIZE"); kerr == nil {
		keys = fmt.Sprintf(" | 键 %s 个", size.String())
	}
	return fmt.Sprintf("%s | 版本 %s | 查询耗时 %s%s", target, version, durationText(cost), keys)
}

func schedulerSummary() string {
	snap := cronsvc.StatusSnapshot()
	return fmt.Sprintf("%v | 任务 %v 个（参与调度 %v）| 本次启动已执行 %v 次",
		snap["status"], snap["job_count"], snap["active_count"], snap["run_seq"])
}

func runtimeSummary() string {
	var m runtime.MemStats
	runtime.ReadMemStats(&m)
	return fmt.Sprintf("协程 %d | 内存 堆 %s / 系统 %s | GC %d 次",
		runtime.NumGoroutine(), bytesText(m.Alloc), bytesText(m.Sys), m.NumGC)
}

func dirSummary() string {
	dirs := []string{
		"resource/public", conf.UploadDir(), conf.VideoDir(), conf.BackupDir(),
		"logs", "logs/server",
	}
	parts := make([]string, 0, len(dirs))
	for _, d := range dirs {
		status := "✘"
		if writable(d) {
			status = "✔"
		}
		parts = append(parts, d+status)
	}
	return strings.Join(parts, "  ")
}

// writable 判断目录是否存在且可写（写一个探针文件再删除）。
func writable(dir string) bool {
	if !gfile.Exists(dir) {
		return false
	}
	probe := gfile.Join(dir, ".write_probe")
	if err := gfile.PutContents(probe, "1"); err != nil {
		return false
	}
	_ = gfile.Remove(probe)
	return true
}

// ---------------------------------------------------------------------------
// 格式化工具
// ---------------------------------------------------------------------------

func mark(ok bool) string {
	if ok {
		return "正常"
	}
	return "异常"
}

func onOff(b bool) string {
	if b {
		return "开"
	}
	return "关"
}

func hostname() string {
	name, err := os.Hostname()
	if err != nil {
		return "未知"
	}
	return name
}

func durationText(d time.Duration) string {
	switch {
	case d <= 0:
		// Windows 计时精度不足时会测到 0，用 <1ms 表达更诚实
		return "<1ms"
	case d < time.Millisecond:
		return fmt.Sprintf("%dµs", d.Microseconds())
	case d < time.Second:
		return fmt.Sprintf("%dms", d.Milliseconds())
	default:
		return d.Round(time.Millisecond).String()
	}
}

func listenHint(addr string) string {
	if strings.HasPrefix(addr, "127.0.0.1") || strings.HasPrefix(addr, "localhost") {
		return "（仅本机，外网请走 Nginx 反代）"
	}
	return ""
}

func bytesText(b uint64) string {
	const unit = 1024
	if b < unit {
		return fmt.Sprintf("%d B", b)
	}
	units := []string{"KB", "MB", "GB", "TB"}
	v := float64(b)
	i := -1
	for v >= unit && i < len(units)-1 {
		v /= unit
		i++
	}
	return fmt.Sprintf("%.1f %s", v, units[i])
}

func shorten(s string, n int) string {
	r := []rune(strings.TrimSpace(s))
	if len(r) <= n {
		return string(r)
	}
	return string(r[:n]) + "…"
}
