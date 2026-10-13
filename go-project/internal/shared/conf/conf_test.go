package conf

import (
	"testing"

	"github.com/gogf/gf/v2/container/gvar"
)

func TestBoolOrExplicitFalse(t *testing.T) {
	v := gvar.New(false)
	if !v.IsEmpty() {
		t.Fatal("precondition: gvar.IsEmpty(false) should be true")
	}
	if boolOr(v, nil, true) {
		t.Fatal("yaml false must not fall back to default true")
	}
}

func TestBoolOrMissingUsesDefault(t *testing.T) {
	if !boolOr(nil, nil, true) {
		t.Fatal("missing value should use default true")
	}
	if boolOr(gvar.New(nil), nil, false) {
		t.Fatal("nil var should use default false")
	}
}

func TestBoolOrTrue(t *testing.T) {
	if !boolOr(gvar.New(true), nil, false) {
		t.Fatal("explicit true must win")
	}
}
