package bootstrap

import (
	"context"
	"os"
	"strings"
	"testing"

	"fssadmin/go-project/internal/shared/conf"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/glog"
)

// 日志按大小滚动：超过阈值自动分割，单文件不再无限增长。
func TestLogRotationBySize(t *testing.T) {
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

	entries, err := os.ReadDir(dir)
	if err != nil {
		t.Fatal(err)
	}
	if len(entries) < 2 {
		t.Fatalf("超过阈值后应产生滚动文件，实际只有 %d 个", len(entries))
	}
	for _, entry := range entries {
		info, err := entry.Info()
		if err != nil {
			continue
		}
		if info.Size() > 4*1024 {
			t.Fatalf("滚动后单文件仍然过大：%s = %d 字节", entry.Name(), info.Size())
		}
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
