package service

import (
	"fmt"
	"math"
	"os"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"time"
)

// appStarted is the process start, used as 应用运行时长.
var appStarted = time.Now()

type hostRaw struct {
	memTotal, memUsed   uint64
	diskTotal, diskUsed uint64
	osName, cpuModel    string
	uptime              time.Duration
	processes           int
	partitions          []Partition
}

// Partition 描述一个磁盘分区的信息。
type Partition struct {
	Device      string `json:"device"`      // 盘符/挂载点，如 C: 或 /
	Mountpoint  string `json:"mountpoint"`  // 挂载路径
	Fstype      string `json:"fstype"`      // 文件系统类型，如 NTFS, ext4
	Total       string `json:"total"`       // 总大小
	Used        string `json:"used"`        // 已使用
	Free        string `json:"free"`        // 可用
	UsedPercent string `json:"usedPercent"` // 使用率
}

type cpuPoint struct {
	idle, total uint64
	at          time.Time
}

var (
	cpuMu   sync.Mutex
	cpuPrev cpuPoint
)

func serverSnapshot() map[string]any {
	raw := readHost()
	cpu := round2(sampleCPU(readCPU))
	memPct := percentOf(raw.memUsed, raw.memTotal)
	diskPct := percentOf(raw.diskUsed, raw.diskTotal)
	host, _ := os.Hostname()
	var ms runtime.MemStats
	runtime.ReadMemStats(&ms)
	lastGC := "—"
	if ms.LastGC > 0 {
		lastGC = time.Unix(0, int64(ms.LastGC)).Format("2006-01-02 15:04:05")
	}
	n := runtime.NumGoroutine()
	return map[string]any{
		"cpu": map[string]any{
			"percent": cpu,
			"text":    formatPercent(cpu),
			"cores":   runtime.NumCPU(),
			"detail":  fmt.Sprintf("%d 核心", runtime.NumCPU()),
			"model":   raw.cpuModel,
		},
		"memory": map[string]any{
			"percent": memPct,
			"text":    formatPercent(memPct),
			"detail":  formatGB(raw.memUsed) + " / " + formatGB(raw.memTotal),
		},
		"disk": map[string]any{
			"percent": diskPct,
			"text":    formatPercent(diskPct),
			"detail":  formatGB(raw.diskUsed) + " / " + formatGB(raw.diskTotal),
		},
		"goroutines": n,
		"processes":  raw.processes,
		"partitions": raw.partitions,
		"system": map[string]any{
			"hostname":  host,
			"os":        raw.osName,
			"arch":      runtime.GOARCH,
			"cpuModel":  raw.cpuModel,
			"uptime":    formatUptime(raw.uptime),
			"appUptime": formatUptime(time.Since(appStarted)),
			"processes": raw.processes,
		},
		"runtime": map[string]any{
			"version":    runtime.Version(),
			"goroutines": n,
			"heapAlloc":  formatMB(ms.HeapAlloc),
			"heapSys":    formatMB(ms.HeapSys),
			"stackInUse": formatMB(ms.StackInuse),
			"numGC":      ms.NumGC,
			"lastGC":     lastGC,
		},
	}
}

// sampleCPU turns two counter reads into a busy percent.
// The first call waits briefly so the page is not stuck at 0.
func sampleCPU(read func() (idle, total uint64, ok bool)) float64 {
	idle, total, ok := read()
	if !ok || total == 0 {
		return 0
	}
	cpuMu.Lock()
	prev := cpuPrev
	cpuPrev = cpuPoint{idle, total, time.Now()}
	cpuMu.Unlock()
	if prev.total > 0 && total > prev.total && time.Since(prev.at) >= 100*time.Millisecond {
		return busyPercent(idle-prev.idle, total-prev.total)
	}
	time.Sleep(200 * time.Millisecond)
	idle2, total2, ok := read()
	if !ok || total2 <= total {
		return 0
	}
	cpuMu.Lock()
	cpuPrev = cpuPoint{idle2, total2, time.Now()}
	cpuMu.Unlock()
	return busyPercent(idle2-idle, total2-total)
}

func busyPercent(idleDelta, totalDelta uint64) float64 {
	if totalDelta == 0 {
		return 0
	}
	if idleDelta > totalDelta {
		idleDelta = totalDelta
	}
	return (1 - float64(idleDelta)/float64(totalDelta)) * 100
}

func percentOf(used, total uint64) float64 {
	if total == 0 {
		return 0
	}
	return round2(float64(used) / float64(total) * 100)
}

func round2(v float64) float64 {
	if v < 0 {
		v = 0
	}
	if v > 100 {
		v = 100
	}
	return math.Round(v*100) / 100
}

func formatPercent(v float64) string {
	s := strconv.FormatFloat(round2(v), 'f', 2, 64)
	s = strings.TrimRight(strings.TrimRight(s, "0"), ".")
	return s + "%"
}

func formatGB(n uint64) string {
	return fmt.Sprintf("%.2f GB", float64(n)/1024/1024/1024)
}

func formatMB(n uint64) string {
	return fmt.Sprintf("%.2f MB", float64(n)/1024/1024)
}

func formatUptime(d time.Duration) string {
	if d < 0 {
		d = 0
	}
	d = d.Round(time.Minute)
	days := d / (24 * time.Hour)
	d -= days * 24 * time.Hour
	hours := d / time.Hour
	d -= hours * time.Hour
	mins := d / time.Minute
	return fmt.Sprintf("%d天 %d小时 %d分钟", days, hours, mins)
}
