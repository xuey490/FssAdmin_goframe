package service

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/gogf/gf/v2/container/gvar"
	"github.com/gogf/gf/v2/database/gdb"
)

func TestProgressReFromYtDlpLine(t *testing.T) {
	line := "[download]  45.3% of  12.00MiB at  1.20MiB/s ETA 00:04"
	m := progressRe.FindStringSubmatch(line)
	if len(m) < 2 || m[1] != "45.3" {
		t.Fatalf("progress %v", m)
	}
	sm := speedRe.FindStringSubmatch(line)
	if len(sm) < 2 || sm[1] != "1.20MiB/s" {
		t.Fatalf("speed %v", sm)
	}
}

func TestFillJobFields(t *testing.T) {
	item := map[string]interface{}{"active_job_id": 48}
	fillJobFields(item, gdb.Record{
		"status":   gvar.New(1),
		"progress": gvar.New(36.5),
		"speed":    gvar.New("303.98KiB/s"),
		"mode":     gvar.New("best"),
	})
	if item["job_status"] != 1 || item["job_progress"] != 36.5 || item["job_mode"] != "best" {
		t.Fatalf("%v", item)
	}
}

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
