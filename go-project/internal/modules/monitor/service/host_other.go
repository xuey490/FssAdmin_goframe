//go:build !linux && !windows

package service

import "runtime"

func readHost() hostRaw {
	return hostRaw{osName: runtime.GOOS}
}

func readCPU() (idle, total uint64, ok bool) {
	return 0, 0, false
}

func listPartitions() []Partition {
	return nil
}
