package service

import (
	"testing"
	"time"
)

func TestLoginChartSeriesFills30Days(t *testing.T) {
	now := time.Date(2026, 9, 21, 15, 0, 0, 0, time.Local)
	counts := map[string]int{"2026-09-21": 4, "2026-09-01": 1}
	dates, vals := loginChartSeries(now, counts)
	if len(dates) != 30 || len(vals) != 30 {
		t.Fatalf("len %d %d", len(dates), len(vals))
	}
	if dates[0] != "2026-08-23" || dates[29] != "2026-09-21" {
		t.Fatalf("range %s %s", dates[0], dates[29])
	}
	if vals[29] != 4 || vals[9] != 1 {
		t.Fatalf("vals %+v", vals)
	}
}

func TestLoginBarSeriesFills12Months(t *testing.T) {
	now := time.Date(2026, 9, 21, 15, 0, 0, 0, time.Local)
	counts := map[string]int{"2026-09": 8, "2025-10": 2}
	months, vals := loginBarSeries(now, counts)
	if len(months) != 12 || months[0] != "2025-10" || months[11] != "2026-09" {
		t.Fatalf("%v", months)
	}
	if vals[0] != 2 || vals[11] != 8 {
		t.Fatalf("%v", vals)
	}
}

func TestYmd(t *testing.T) {
	if ymd("2026-09-21 00:00:00") != "2026-09-21" {
		t.Fatal(ymd("2026-09-21 00:00:00"))
	}
}
