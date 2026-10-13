package logx

import (
	"testing"

	"github.com/gogf/gf/v2/frame/g"
)

func TestApplyTogglesDebugAndStack(t *testing.T) {
	Apply(false, false)
	quiet := g.Log().GetConfig().Level
	if g.Log().GetConfig().StStatus != 0 {
		t.Fatalf("stack %d", g.Log().GetConfig().StStatus)
	}
	Apply(true, true)
	if g.Log().GetConfig().StStatus != 1 {
		t.Fatalf("stack %d", g.Log().GetConfig().StStatus)
	}
	if g.Log().GetConfig().Level == quiet {
		t.Fatal("debug bit did not change")
	}
}
