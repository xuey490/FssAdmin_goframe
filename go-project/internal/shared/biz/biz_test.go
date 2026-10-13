package biz

import "testing"

func TestAs(t *testing.T) {
	e := NotFound("x")
	got, ok := As(e)
	if !ok || got.Code != 404 {
		t.Fatal(got)
	}
	if _, ok := As(nil); ok {
		t.Fatal("nil")
	}
}
