//go:build windows

package service

import (
	"os"
	"path/filepath"
	"strings"
	"unsafe"

	"golang.org/x/sys/windows"
	"golang.org/x/sys/windows/registry"
)

var (
	procGlobalMemoryStatusEx = windows.NewLazySystemDLL("kernel32.dll").NewProc("GlobalMemoryStatusEx")
	procGetSystemTimes       = windows.NewLazySystemDLL("kernel32.dll").NewProc("GetSystemTimes")
)

func readHost() hostRaw {
	memTotal, memUsed := memoryUsage()
	diskTotal, diskUsed := diskUsage()
	return hostRaw{
		memTotal:   memTotal,
		memUsed:    memUsed,
		diskTotal:  diskTotal,
		diskUsed:   diskUsed,
		osName:     windowsName(),
		cpuModel:   cpuName(),
		uptime:     windows.DurationSinceBoot(),
		processes:  processCount(),
		partitions: listPartitions(),
	}
}

func readCPU() (idle, total uint64, ok bool) {
	var i, k, u windows.Filetime
	r, _, _ := procGetSystemTimes.Call(
		uintptr(unsafe.Pointer(&i)),
		uintptr(unsafe.Pointer(&k)),
		uintptr(unsafe.Pointer(&u)),
	)
	if r == 0 {
		return 0, 0, false
	}
	idle = filetime(i)
	// kernel time already includes idle.
	total = filetime(k) + filetime(u)
	return idle, total, total > 0
}

func filetime(ft windows.Filetime) uint64 {
	return uint64(ft.HighDateTime)<<32 | uint64(uint32(ft.LowDateTime))
}

func memoryUsage() (total, used uint64) {
	type memStatusEx struct {
		cbSize                  uint32
		dwMemoryLoad            uint32
		ullTotalPhys            uint64
		ullAvailPhys            uint64
		ullTotalPageFile        uint64
		ullAvailPageFile        uint64
		ullTotalVirtual         uint64
		ullAvailVirtual         uint64
		ullAvailExtendedVirtual uint64
	}
	var m memStatusEx
	m.cbSize = uint32(unsafe.Sizeof(m))
	r, _, _ := procGlobalMemoryStatusEx.Call(uintptr(unsafe.Pointer(&m)))
	if r == 0 || m.ullTotalPhys == 0 {
		return 0, 0
	}
	if m.ullAvailPhys > m.ullTotalPhys {
		return m.ullTotalPhys, 0
	}
	return m.ullTotalPhys, m.ullTotalPhys - m.ullAvailPhys
}

func diskUsage() (total, used uint64) {
	dir, err := os.Getwd()
	if err != nil || dir == "" {
		dir = `C:\`
	}
	if vol := filepath.VolumeName(dir); vol != "" {
		dir = vol + `\`
	}
	p, err := windows.UTF16PtrFromString(dir)
	if err != nil {
		return 0, 0
	}
	var freeAvail, totalBytes, freeBytes uint64
	if err = windows.GetDiskFreeSpaceEx(p, &freeAvail, &totalBytes, &freeBytes); err != nil || totalBytes == 0 {
		return 0, 0
	}
	if freeBytes > totalBytes {
		return totalBytes, 0
	}
	return totalBytes, totalBytes - freeBytes
}

func windowsName() string {
	v := windows.RtlGetVersion()
	name := "Windows"
	switch {
	case v.MajorVersion >= 10 && v.BuildNumber >= 22000:
		name = "Windows 11"
	case v.MajorVersion == 10:
		name = "Windows 10"
	case v.MajorVersion == 6 && v.MinorVersion == 3:
		name = "Windows 8.1"
	case v.MajorVersion == 6 && v.MinorVersion == 1:
		name = "Windows 7"
	}
	return name
}

func cpuName() string {
	k, err := registry.OpenKey(registry.LOCAL_MACHINE, `HARDWARE\DESCRIPTION\System\CentralProcessor\0`, registry.QUERY_VALUE)
	if err != nil {
		return ""
	}
	defer k.Close()
	name, _, err := k.GetStringValue("ProcessorNameString")
	if err != nil {
		return ""
	}
	return strings.TrimSpace(name)
}

func processCount() int {
	snap, err := windows.CreateToolhelp32Snapshot(windows.TH32CS_SNAPPROCESS, 0)
	if err != nil {
		return 0
	}
	defer windows.CloseHandle(snap)
	var e windows.ProcessEntry32
	e.Size = uint32(unsafe.Sizeof(e))
	if err = windows.Process32First(snap, &e); err != nil {
		return 0
	}
	n := 1
	for windows.Process32Next(snap, &e) == nil {
		n++
	}
	return n
}

// listPartitions 枚举 Windows 所有盘符的分区信息。
func listPartitions() []Partition {
	var result []Partition
	bitmask, _ := windows.GetLogicalDrives()
	for ch := byte('A'); ch <= 'Z'; ch++ {
		if bitmask&(1<<(ch-'A')) == 0 {
			continue
		}
		root := string(ch) + `:\`
		p, err := windows.UTF16PtrFromString(root)
		if err != nil {
			continue
		}
		var freeAvail, totalBytes, freeBytes uint64
		if err = windows.GetDiskFreeSpaceEx(p, &freeAvail, &totalBytes, &freeBytes); err != nil || totalBytes == 0 {
			continue
		}
		used := totalBytes - freeBytes
		if freeBytes > totalBytes {
			used = 0
		}
		result = append(result, Partition{
			Device:      string(ch) + ":",
			Mountpoint:  root,
			Fstype:      windowsVolumeType(root),
			Total:       formatGB(totalBytes),
			Used:        formatGB(used),
			Free:        formatGB(freeBytes),
			UsedPercent: formatPercent(percentOf(used, totalBytes)),
		})
	}
	if result == nil {
		// 兜底：至少返回当前盘
		total, used := diskUsage()
		dir, _ := os.Getwd()
		vol := filepath.VolumeName(dir)
		if vol == "" {
			vol = "C:"
		}
		result = []Partition{{
			Device:      vol,
			Mountpoint:  vol + `\`,
			Fstype:      "NTFS",
			Total:       formatGB(total),
			Used:        formatGB(used),
			Free:        formatGB(total - used),
			UsedPercent: formatPercent(percentOf(used, total)),
		}}
	}
	return result
}

// windowsVolumeType 获取 Windows 分区文件系统类型。
func windowsVolumeType(root string) string {
	p, err := windows.UTF16PtrFromString(root)
	if err != nil {
		return "unknown"
	}
	buf := make([]uint16, 256)
	err = windows.GetVolumeInformation(p, nil, 0, nil, nil, nil, &buf[0], uint32(len(buf)))
	if err != nil || len(buf) == 0 {
		return "unknown"
	}
	s := windows.UTF16ToString(buf)
	if s == "" {
		return "unknown"
	}
	return s
}
