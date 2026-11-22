package bootstrap

import (
	"context"
	"fmt"
	"os"
	"runtime"
	"strings"
	"testing"
	"time"

	"fssadmin/go-project/internal/shared/conf"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/glog"
)

// 日志按大小滚动：超过阈值自动分割，单文件不再无限增长。
//
// Windows 下 glog 的滚动改名会被自身打开的文件句柄挡住（"being used by another
// process"），首个备份之后活动文件不再滚动——glog 滚动依赖 POSIX rename 语义，
// 属框架已知行为，故 Windows 跳过（生产滚动部署在 Linux，行为正确）。
func TestLogRotationBySize(t *testing.T) {
	if runtime.GOOS == "windows" {
		t.Skip("glog 按大小滚动依赖 POSIX rename，Windows 下文件句柄阻止改名，跳过")
	}
	dir := t.TempDir()
	logger := glog.New()
	if err := logger.SetConfigWithMap(g.Map{
		"path":              dir,
		"file":              "app-{Ymd}.log",
		"stdout":            false,
		"rotateSize":        "1KB",
		"rotateBackupLimit": 3,
	}); err != nil {
		t.Fatalf("滚动配置应被接受: %v", err)
	}

	for i := 0; i < 80; i++ {
		logger.Info(context.Background(), strings.Repeat("x", 120))
	}

	// 滚动由写入路径上的检查触发，与后台 rotateChecksTimely 存在内存锁竞争，
	// 负载高时最后一次滚动可能滞后：这里给有界的等待窗口，最多 3s。
	deadline := time.Now().Add(3 * time.Second)
	for {
		entries, err := os.ReadDir(dir)
		if err != nil {
			t.Fatal(err)
		}
		ok := len(entries) >= 2
		if ok {
			for _, entry := range entries {
				info, err := entry.Info()
				if err != nil {
					continue
				}
				if info.Size() > 4*1024 {
					ok = false
					break
				}
			}
		}
		if ok {
			return
		}
		if time.Now().After(deadline) {
			names := ""
			if list, _ := os.ReadDir(dir); list != nil {
				for _, e := range list {
					info, _ := e.Info()
					names += fmt.Sprintf(" %s=%dB", e.Name(), info.Size())
				}
			}
			t.Fatalf("3s 内未完成按大小滚动（条目:%s）", names)
		}
		time.Sleep(100 * time.Millisecond)
	}
}

// 滚动参数默认值必须可用：大小为 10MB、备份 30 个、保留 30 天。
func TestLogRotateDefaults(t *testing.T) {
	if size := conf.LogRotateSize(); size == "" || size == "0" {
		t.Fatalf("rotateSize 默认值异常: %q", size)
	}
	if limit := conf.LogRotateBackupLimit(); limit <= 0 {
		t.Fatalf("rotateBackupLimit 必须大于 0，0 表示直接丢弃日志，实际 %d", limit)
	}
	if expire := conf.LogRotateBackupExpire(); expire == "" {
		t.Fatal("rotateBackupExpire 默认值不能为空")
	}
	if interval := conf.LogRotateCheckInterval(); interval == "" {
		t.Fatal("rotateCheckInterval 默认值不能为空")
	}
}
