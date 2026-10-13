package crud

import "testing"

func TestSpecDefaults(t *testing.T) {
	s := Spec{Table: "t", AsPage: true, Like: []string{"name"}}
	if s.Table != "t" || !s.AsPage {
		t.Fatal("spec")
	}
}
