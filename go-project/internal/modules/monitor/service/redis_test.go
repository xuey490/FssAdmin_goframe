package service

import "testing"

func TestCoerceInfoNumbers(t *testing.T) {
	got := coerceInfo(map[string]string{
		"used_memory": "1024", "mem_fragmentation_ratio": "1.25",
		"redis_version": "7.2.0", "used_memory_human": "1.00K",
	})
	if got["used_memory"] != int64(1024) {
		t.Fatalf("mem %T %v", got["used_memory"], got["used_memory"])
	}
	if got["mem_fragmentation_ratio"] != 1.25 {
		t.Fatalf("frag %v", got["mem_fragmentation_ratio"])
	}
	if got["redis_version"] != "7.2.0" || got["used_memory_human"] != "1.00K" {
		t.Fatalf("%v", got)
	}
}
