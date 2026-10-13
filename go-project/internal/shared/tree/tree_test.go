package tree

import "testing"

func TestBuild(t *testing.T) {
	rows := []map[string]interface{}{
		{"id": 1, "parent_id": 0, "name": "a"},
		{"id": 2, "parent_id": 1, "name": "b"},
	}
	roots := Build(rows, "id", "parent_id", "children")
	if len(roots) != 1 {
		t.Fatalf("roots %d", len(roots))
	}
	kids, _ := roots[0]["children"].([]map[string]interface{})
	if len(kids) != 1 {
		t.Fatalf("kids %d", len(kids))
	}
}
