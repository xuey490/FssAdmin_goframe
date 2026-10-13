package response_test

import (
	"testing"

	"fssadmin/go-project/internal/shared/response"
)

func TestPageEnvelope(t *testing.T) {
	p := response.Page([]int{1}, 10, 1, 20)
	if p["total"] != 10 {
		t.Fatalf("total %v", p["total"])
	}
	if p["list"] == nil || p["data"] == nil {
		t.Fatal("missing dual list/data")
	}
}

func TestPageNo(t *testing.T) {
	p := response.PageNo([]int{1, 2}, 30, 1, 10)
	if p["page_no"] != 1 || p["page_size"] != 10 {
		t.Fatalf("%v", p)
	}
	if p["has_next"] != true {
		t.Fatal("expected has_next")
	}
}
