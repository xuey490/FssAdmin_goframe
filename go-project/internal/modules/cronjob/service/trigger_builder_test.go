package service

import (
	"testing"
	"time"
)

// TestCronFormatsFromBuilder 锁定前后端契约：
// web/src/utils/cron.ts 的可视化定时规则会产出下列表达式，后端必须都能解析出下次执行时间。
func TestCronFormatsFromBuilder(t *testing.T) {
	cases := []struct {
		name      string
		style     string
		expr      string
		wantHour  int
		wantMonth time.Month
		wantDay   int
		wantWeek  time.Weekday
	}{
		{"每天 02:30", "每天", "0 30 2 * * *", 2, 0, 0, 0},
		{"每小时第15分", "每小时", "0 15 * * * *", -1, 0, 0, 0},
		{"每6小时", "N小时", "0 5 */6 * * *", -1, 0, 0, 0},
		{"每10分钟", "N分钟", "0 */10 * * * *", -1, 0, 0, 0},
		{"每30秒", "N秒", "*/30 * * * * *", -1, 0, 0, 0},
		{"每周一 09:00", "每周", "0 0 9 * * 1", 9, 0, 0, time.Monday},
		{"每月15日 03:00", "每月", "0 0 3 15 * *", 3, 0, 15, 0},
		{"每年3月1日 04:00", "每年", "0 0 4 1 3 *", 4, time.March, 1, 0},
	}

	from := time.Date(2026, 1, 1, 0, 0, 0, 0, time.Local)
	for _, c := range cases {
		s, err := ParseSchedule(TriggerCron, c.expr, "", "")
		if err != nil {
			t.Fatalf("%s(%s)：表达式应被接受，实际 %v", c.style, c.expr, err)
		}
		if s.Pattern != c.expr {
			t.Fatalf("%s：规范化后应与原式一致，实际 %q", c.style, s.Pattern)
		}
		next, ok := NextRun(s, from)
		if !ok {
			t.Fatalf("%s(%s)：应能算出下次执行时间", c.style, c.expr)
		}
		if !next.After(from) {
			t.Fatalf("%s：下次执行时间必须晚于基准时间，实际 %s", c.style, next.Format(time.DateTime))
		}
		if c.wantHour >= 0 && next.Hour() != c.wantHour {
			t.Fatalf("%s：小时应为 %d，实际 %d", c.style, c.wantHour, next.Hour())
		}
		if c.wantMonth > 0 && next.Month() != c.wantMonth {
			t.Fatalf("%s：月份应为 %d，实际 %d", c.style, c.wantMonth, next.Month())
		}
		if c.wantDay > 0 && next.Day() != c.wantDay {
			t.Fatalf("%s：日期应为 %d，实际 %d", c.style, c.wantDay, next.Day())
		}
		if c.wantWeek > 0 && next.Weekday() != c.wantWeek {
			t.Fatalf("%s：星期应为 %s，实际 %s", c.style, c.wantWeek, next.Weekday())
		}
		// 前端 isValidCron 允许 5/7 段，后端也应接受
	}
}

// 前端「自定义表达式」可能保存 5 段标准 crontab 或 7 段 Quartz 表达式。
func TestCronFormatsFromBuilderCompatible(t *testing.T) {
	s, err := ParseSchedule(TriggerCron, "30 2 * * *", "", "")
	if err != nil {
		t.Fatalf("5 段表达式应被接受：%v", err)
	}
	if s.Pattern != "0 30 2 * * *" {
		t.Fatalf("5 段应补 0 秒，实际 %q", s.Pattern)
	}
	next, ok := NextRun(s, time.Date(2026, 1, 1, 3, 0, 0, 0, time.Local))
	if !ok || next.Hour() != 2 || next.Minute() != 30 {
		t.Fatalf("5 段下次执行时间异常：%s", next.Format(time.DateTime))
	}

	q, err := ParseSchedule(TriggerCron, "0 0 4 1 3 * 2027", "", "")
	if err != nil {
		t.Fatalf("7 段表达式应被接受：%v", err)
	}
	if q.Pattern != "0 0 4 1 3 *" {
		t.Fatalf("7 段应丢弃年份字段，实际 %q", q.Pattern)
	}
}

// 前端「N秒/N分钟/N小时」规则产出 @every：cron 的 */N 只在字段起点对齐，
// 无法表达「每 59 秒」，因此 cron 触发器需要放行 @every 真间隔写法。
func TestCronTriggerAcceptsEvery(t *testing.T) {
	from := time.Date(2026, 9, 25, 10, 0, 0, 0, time.Local)
	cases := []struct {
		expr string
		want string
		gap  time.Duration
	}{
		{"@every 59s", "@every 59s", 59 * time.Second},
		{"@every 10m", "@every 10m0s", 10 * time.Minute},
		{"@every 6h", "@every 6h0m0s", 6 * time.Hour},
	}
	for _, c := range cases {
		s, err := ParseSchedule(TriggerCron, c.expr, "", "")
		if err != nil {
			t.Fatalf("%s 应被接受：%v", c.expr, err)
		}
		if s.Pattern != c.want {
			t.Fatalf("%s 规范化后应为 %q，实际 %q", c.expr, c.want, s.Pattern)
		}
		next, ok := NextRun(s, from)
		if !ok || next.Sub(from) != c.gap {
			t.Fatalf("%s 下次执行时间应为 %s 后，实际 %s", c.expr, c.gap, next.Sub(from))
		}
	}

	for _, bad := range []string{"@every 0s", "@every abc", "@every "} {
		if _, err := ParseSchedule(TriggerCron, bad, "", ""); err == nil {
			t.Fatalf("%q 应被拒绝", bad)
		}
	}
}
