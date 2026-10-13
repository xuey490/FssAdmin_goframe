package service

import (
	"os"
	"path/filepath"
	"testing"
)

func TestFormatsFromJSON(t *testing.T) {
	raw := `{"formats":[{"format_id":"1","url":"http://x","height":720}]}`
	got := formatsFromJSON(raw)
	if len(got) != 1 || got[0]["format_id"] != "1" {
		t.Fatalf("%v", got)
	}
}

func TestServeRangeHelpers(t *testing.T) {
	dir := t.TempDir()
	p := filepath.Join(dir, "a.bin")
	if err := os.WriteFile(p, []byte("hello-world"), 0644); err != nil {
		t.Fatal(err)
	}
	if !fileExists(p) {
		t.Fatal("expected file")
	}
}
