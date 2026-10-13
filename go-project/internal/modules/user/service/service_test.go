package service

import "testing"

func TestIdsOf(t *testing.T) {
	got := idsOf([]map[string]interface{}{{"id": 2}, {"id": "8"}, {"id": 0}})
	if len(got) != 2 || got[0] != 2 || got[1] != 8 {
		t.Fatalf("%v", got)
	}
}
