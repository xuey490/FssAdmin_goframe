//go:build linux

package service

import (
	"os"
	"strconv"
	"strings"
	"time"

	"golang.org/x/sys/unix"
)

func readHost() hostRaw {
	memTotal, memUsed := memoryUsage()
	diskTotal, diskUsed := diskUsage()
	return hostRaw{
		memTotal:   memTotal,
		memUsed:    memUsed,
		diskTotal:  diskTotal,
		diskUsed:   diskUsed,
		osName:     linuxName(),
		cpuModel:   cpuName(),
		uptime:     linuxUptime(),
		processes:  processCount(),
		partitions: listPartitions(),
	}
}

func readCPU() (idle, total uint64, ok bool) {
	b, err := os.ReadFile("/proc/stat")
	if err != nil {
		return 0, 0, false
	}
	line, _, _ := strings.Cut(string(b), "\n")
	f := strings.Fields(line)
	if len(f) < 5 || f[0] != "cpu" {
		return 0, 0, false
	}
	nums := make([]uint64, 0, len(f)-1)
	for _, s := range f[1:] {
		n, err := strconv.ParseUint(s, 10, 64)
		if err != nil {
			break
		}
		nums = append(nums, n)
	}
	if len(nums) < 4 {
		return 0, 0, false
	}
	var sum uint64
	for _, n := range nums {
		sum += n
	}
	idle = nums[3]
	if len(nums) > 4 {
		idle += nums[4]
	}
	return idle, sum, sum > 0
}

func memoryUsage() (total, used uint64) {
	b, err := os.ReadFile("/proc/meminfo")
	if err != nil {
		return 0, 0
	}
	var memTotal, avail uint64
	for _, line := range strings.Split(string(b), "\n") {
		f := strings.Fields(line)
		if len(f) < 2 {
			continue
		}
		n, err := strconv.ParseUint(f[1], 10, 64)
		if err != nil {
			continue
		}
		switch strings.TrimSuffix(f[0], ":") {
		case "MemTotal":
			memTotal = n * 1024
		case "MemAvailable":
			avail = n * 1024
		}
	}
	if memTotal == 0 || avail > memTotal {
		return memTotal, 0
	}
	return memTotal, memTotal - avail
}

func diskUsage() (total, used uint64) {
	var st unix.Statfs_t
	if err := unix.Statfs("/", &st); err != nil || st.Blocks == 0 || st.Bsize <= 0 {
		return 0, 0
	}
	bsize := uint64(st.Bsize)
	total = st.Blocks * bsize
	free := st.Bavail * bsize
	if free > total {
		return total, 0
	}
	return total, total - free
}

func linuxName() string {
	b, err := os.ReadFile("/etc/os-release")
	if err != nil {
		return "linux"
	}
	vals := map[string]string{}
	for _, line := range strings.Split(string(b), "\n") {
		k, v, ok := strings.Cut(line, "=")
		if !ok {
			continue
		}
		vals[k] = strings.Trim(v, `"`)
	}
	name := strings.ToLower(vals["NAME"])
	if ver := vals["VERSION_ID"]; ver != "" && name != "" {
		return name + " " + ver
	}
	if pretty := vals["PRETTY_NAME"]; pretty != "" {
		return pretty
	}
	if name != "" {
		return name
	}
	return "linux"
}

func cpuName() string {
	b, err := os.ReadFile("/proc/cpuinfo")
	if err != nil {
		return ""
	}
	for _, line := range strings.Split(string(b), "\n") {
		k, v, ok := strings.Cut(line, ":")
		if ok && strings.TrimSpace(k) == "model name" {
			return strings.TrimSpace(v)
		}
	}
	return ""
}

func linuxUptime() time.Duration {
	b, err := os.ReadFile("/proc/uptime")
	if err != nil {
		return 0
	}
	f := strings.Fields(string(b))
	if len(f) == 0 {
		return 0
	}
	sec, err := strconv.ParseFloat(f[0], 64)
	if err != nil {
		return 0
	}
	return time.Duration(sec * float64(time.Second))
}

func processCount() int {
	ents, err := os.ReadDir("/proc")
	if err != nil {
		return 0
	}
	n := 0
	for _, e := range ents {
		name := e.Name()
		if name == "" || name[0] < '0' || name[0] > '9' {
			continue
		}
		if _, err := strconv.Atoi(name); err == nil {
			n++
		}
	}
	return n
}

// listPartitions 从 /proc/mounts 读取真实挂载的分区信息。
func listPartitions() []Partition {
	b, err := os.ReadFile("/proc/mounts")
	if err != nil {
		return nil
	}
	seen := map[string]bool{}
	var result []Partition
	for _, line := range strings.Split(string(b), "\n") {
		f := strings.Fields(line)
		if len(f) < 3 {
			continue
		}
		device := f[0]
		mount := f[1]
		fstype := f[2]
		// 跳过虚拟/伪文件系统
		if strings.HasPrefix(device, "none") ||
			strings.HasPrefix(mount, "/proc") ||
			strings.HasPrefix(mount, "/sys") ||
			strings.HasPrefix(mount, "/dev/shm") ||
			strings.Contains(fstype, "tmpfs") ||
			strings.Contains(fstype, "proc") ||
			strings.Contains(fstype, "sysfs") ||
			strings.Contains(fstype, "cgroup") ||
			strings.Contains(fstype, "devpts") ||
			strings.Contains(fstype, "squashfs") {
			continue
		}
		if seen[device+mount] {
			continue
		}
		seen[device+mount] = true
		var st unix.Statfs_t
		if err := unix.Statfs(mount, &st); err != nil || st.Blocks == 0 || st.Bsize <= 0 {
			continue
		}
		bsize := uint64(st.Bsize)
		total := st.Blocks * bsize
		free := st.Bavail * bsize
		if free > total {
			free = total
		}
		used := total - free
		result = append(result, Partition{
			Device:      device,
			Mountpoint:  mount,
			Fstype:      fstype,
			Total:       formatGB(total),
			Used:        formatGB(used),
			Free:        formatGB(free),
			UsedPercent: formatPercent(percentOf(used, total)),
		})
	}
	return result
}
