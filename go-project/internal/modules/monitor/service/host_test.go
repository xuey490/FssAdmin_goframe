package service

import (
	"strings"
	"testing"
	"time"
)

func TestFormatMonitorText(t *testing.T) {
	if formatPercent(0.5) != "0.5%" || formatPercent(67.42) != "67.42%" || formatPercent(50) != "50%" {
		t.Fatalf("%s %s %s", formatPercent(0.5), formatPercent(67.42), formatPercent(50))
	}
	if formatUptime(26*24*time.Hour+8*time.Hour+18*time.Minute) != "26天 8小时 18分钟" {
		t.Fatal(formatUptime(26*24*time.Hour + 8*time.Hour + 18*time.Minute))
	}
	if !strings.HasSuffix(formatGB(1<<30), " GB") || !strings.HasSuffix(formatMB(1<<20), " MB") {
		t.Fatal(formatGB(1<<30), formatMB(1<<20))
	}
	if busyPercent(25, 100) != 75 {
		t.Fatal(busyPercent(25, 100))
	}
}

func TestServerSnapshotHasHostStats(t *testing.T) {
	snap := serverSnapshot()
	cpu := snap["cpu"].(map[string]any)
	mem := snap["memory"].(map[string]any)
	disk := snap["disk"].(map[string]any)
	sys := snap["system"].(map[string]any)
	rt := snap["runtime"].(map[string]any)
	if cpu["cores"].(int) < 1 {
		t.Fatal("cores")
	}
	if mem["detail"] == "0.00 GB / 0.00 GB" {
		t.Fatal("memory", mem)
	}
	if disk["detail"] == "0.00 GB / 0.00 GB" {
		t.Fatal("disk", disk)
	}
	if sys["hostname"] == "" || sys["os"] == "" || sys["cpuModel"] == "" {
		t.Fatal(sys)
	}
	if sys["processes"].(int) < 1 {
		t.Fatal("processes", sys["processes"])
	}
	if rt["version"] == "" || rt["heapAlloc"] == "" || rt["stackInUse"] == "" {
		t.Fatal(rt)
	}
	if _, ok := snap["goroutines"].(int); !ok {
		t.Fatal("goroutines")
	}
}
