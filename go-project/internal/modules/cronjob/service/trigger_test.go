package service

import (
	"errors"
	"testing"
	"time"
)

// mustTime 统一用 Local 解析，与被测代码（gtime 解析节点时间）保持同一时区，
// 避免跨时区比较造成误判。
func mustTime(t *testing.T, v string) time.Time {
	t.Helper()
	parsed, err := time.ParseInLocation("2006-01-02 15:04:05", v, time.Local)
	if err != nil {
		t.Fatalf("时间解析失败 %s: %v", v, err)
	}
	return parsed
}

func TestNormalizeCronExtra(t *testing.T) {
	cases := map[string]string{
		"* * * * *":        "0 * * * * *",
		"0 0 2 * * ?":      "0 0 2 * * ?",
		"0 0 2 * * ? 2026": "0 0 2 * * ?",
		"@daily":           "@daily",
		"  0 0 2 * * *  ":  "0 0 2 * * *",
		"0 2 * *":          "",
		"":                 "",
	}
	for in, want := range cases {
		if got := normalizeCron(in); got != want {
			t.Fatalf("normalizeCron(%q) = %q, want %q", in, got, want)
		}
	}
}

func TestParseScheduleNoTrigger(t *testing.T) {
	if _, err := ParseSchedule("", "", "", ""); !errors.Is(err, ErrNoTrigger) {
		t.Fatalf("空触发器应返回 ErrNoTrigger，实际 %v", err)
	}
}

func TestParseScheduleErrors(t *testing.T) {
	cases := []struct{ name, trigger, args, start, end string }{
		{"cron 段数不足", TriggerCron, "0 2 * *", "", ""},
		{"cron 秒越界", TriggerCron, "70 0 2 * * *", "", ""},
		{"cron 周越界", TriggerCron, "0 0 2 * * 8", "", ""},
		{"interval 段数不足", TriggerInterval, "0 5 0", "", ""},
		{"interval 全零", TriggerInterval, "0 0 0 0 0", "", ""},
		{"date 为空", TriggerDate, "", "", ""},
		{"未知触发器", "hourly", "x", "", ""},
		{"结束早于开始", TriggerCron, "0 0 2 * * *", "2026-01-02 00:00:00", "2026-01-01 00:00:00"},
		{"开始时间非法", TriggerCron, "0 0 2 * * *", "not-a-time", ""},
	}
	for _, c := range cases {
		if _, err := ParseSchedule(c.trigger, c.args, c.start, c.end); err == nil {
			t.Fatalf("%s：应当报错", c.name)
		}
	}
}

func TestParseScheduleWindow(t *testing.T) {
	s, err := ParseSchedule(TriggerCron, "0 0 2 * * *", "2026-01-01 00:00:00", "2026-12-31 23:59:59")
	if err != nil {
		t.Fatal(err)
	}
	if s.Pattern != "0 0 2 * * *" || s.OneShot {
		t.Fatalf("解析结果异常: %+v", s)
	}
	if !s.InWindow(mustTime(t, "2026-06-01 00:00:00")) {
		t.Fatal("窗口内应返回 true")
	}
	if s.InWindow(mustTime(t, "2025-12-31 23:59:59")) || s.InWindow(mustTime(t, "2027-01-01 00:00:00")) {
		t.Fatal("窗口外应返回 false")
	}
}

func TestNextRunCron(t *testing.T) {
	cases := []struct {
		pattern string
		from    string
		want    string
	}{
		// 每天 02:00
		{"0 0 2 * * *", "2026-01-01 01:00:00", "2026-01-01 02:00:00"},
		// 已到触发点时必须顺延到下一次，而不是返回当前时刻
		{"0 0 2 * * *", "2026-01-01 02:00:00", "2026-01-02 02:00:00"},
		// 5 段 crontab 自动补秒
		{"0 2 * * *", "2026-01-01 02:30:00", "2026-01-02 02:00:00"},
		// 每 15 秒
		{"*/15 * * * * *", "2026-01-01 10:00:07", "2026-01-01 10:00:15"},
		// 2026-01-01 是周四，下一个周一 02:00
		{"0 0 2 * * 1", "2026-01-01 00:00:00", "2026-01-05 02:00:00"},
		// 周名称缩写
		{"0 0 12 * * mon", "2026-01-01 00:00:00", "2026-01-05 12:00:00"},
		// 月名称缩写 + 日
		{"0 0 0 1 jan *", "2025-12-31 23:59:59", "2026-01-01 00:00:00"},
		// 小时区间
		{"0 0 9-17 * * *", "2026-01-01 18:00:00", "2026-01-02 09:00:00"},
		// 预定义宏
		{"@daily", "2026-01-01 23:00:00", "2026-01-02 00:00:00"},
		{"@hourly", "2026-01-01 10:30:00", "2026-01-01 11:00:00"},
		// 7 段 Quartz，末位年份被截断
		{"0 0 2 * * ? 2026", "2026-01-01 03:00:00", "2026-01-02 02:00:00"},
		// 跨月
		{"0 0 0 1 * *", "2026-01-31 12:00:00", "2026-02-01 00:00:00"},
	}
	for _, c := range cases {
		from := mustTime(t, c.from)
		got, ok := nextCron(normalizeCron(c.pattern), from)
		if !ok {
			t.Fatalf("%s from %s：未算出下次执行时间", c.pattern, c.from)
		}
		if want := mustTime(t, c.want); !got.Equal(want) {
			t.Fatalf("%s from %s = %s, want %s", c.pattern, c.from, got.Format(time.DateTime), want.Format(time.DateTime))
		}
	}
}

func TestNextRunIntervalAndDate(t *testing.T) {
	interval, err := ParseSchedule(TriggerInterval, "0 5 0 0 0", "", "")
	if err != nil {
		t.Fatal(err)
	}
	if interval.Pattern != "@every 5m0s" {
		t.Fatalf("interval pattern = %s", interval.Pattern)
	}
	from := mustTime(t, "2026-01-01 00:00:00")
	got, ok := NextRun(interval, from)
	if !ok || !got.Equal(from.Add(5*time.Minute)) {
		t.Fatalf("interval next = %s ok=%v", got, ok)
	}

	date, err := ParseSchedule(TriggerDate, "2026-06-01 08:30:00", "", "")
	if err != nil {
		t.Fatal(err)
	}
	if !date.OneShot {
		t.Fatal("date 触发器应为一次性")
	}
	if got, ok := NextRun(date, from); !ok || !got.Equal(mustTime(t, "2026-06-01 08:30:00")) {
		t.Fatalf("date next = %s ok=%v", got, ok)
	}
	if _, ok := NextRun(date, mustTime(t, "2026-06-02 00:00:00")); ok {
		t.Fatal("一次性任务过期后不应再返回下次执行时间")
	}
}

func TestScheduleLabel(t *testing.T) {
	cron, _ := ParseSchedule(TriggerCron, "0 0 2 * * *", "", "")
	if cron.Label() != "cron[0 0 2 * * *]" {
		t.Fatalf("label = %s", cron.Label())
	}
	interval, _ := ParseSchedule(TriggerInterval, "0 0 1 0 0", "", "")
	if interval.Label() != "interval[@every 1h0m0s]" {
		t.Fatalf("label = %s", interval.Label())
	}
}

func TestNodeArgsAndKwargs(t *testing.T) {
	if got := NodeArgsFromString(" a, b ,,c "); len(got) != 3 || got[0] != "a" || got[2] != "c" {
		t.Fatalf("args = %#v", got)
	}
	if got := NodeArgsFromString("  "); len(got) != 0 {
		t.Fatalf("空参数应为空: %#v", got)
	}
	kw := ParseKwargs(`{"days":30,"table":"task_job"}`)
	if len(kw) != 2 || kw["table"] != "task_job" {
		t.Fatalf("kwargs = %#v", kw)
	}
	if got := ParseKwargs("not json"); len(got) != 0 {
		t.Fatalf("非法 JSON 应返回空 map: %#v", got)
	}
}

func TestTextOrJSON(t *testing.T) {
	if TextOrJSON("ok") != "ok" {
		t.Fatal("字符串应原样返回")
	}
	if got := TextOrJSON(map[string]int{"a": 1}); got != `{"a":1}` {
		t.Fatalf("对象应序列化: %s", got)
	}
	if TextOrJSON(nil) != "" {
		t.Fatal("nil 应返回空串")
	}
}
