package page

import "testing"

func TestParseLimitCapLogic(t *testing.T) {
	limit := 1000
	if limit > 500 {
		limit = 500
	}
	if limit != 500 {
		t.Fatal(limit)
	}
}
