package service

import (
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/gogf/gf/v2/os/gtime"
	"github.com/gogf/gf/v2/util/gconv"
)

// 触发器类型，与 task_node.trigger / task_job.trigger_type 的取值对齐。
const (
	TriggerNow      = "now"      // 调试用：立即执行一次
	TriggerCron     = "cron"     // Cron 表达式
	TriggerInterval = "interval" // 时间间隔（"秒 分 时 天 周"）
	TriggerDate     = "date"     // 固定日期，一次性
	TriggerManual   = "manual"   // 仅作为 task_job.trigger_type 使用
)

// ErrNoTrigger 表示节点没有配置触发器（不参与调度，但保留定义）。
var ErrNoTrigger = errors.New("未配置触发器")

// Schedule 描述节点「何时执行」，是触发器的唯一解析结果。
// Pattern 是最终交给 gcron 的表达式；OneShot 为真时只执行一次。
type Schedule struct {
	Trigger   string
	Pattern   string
	OneShot   bool
	RunAt     time.Time
	StartDate *time.Time
	EndDate   *time.Time
}

// Label 返回与旧版一致的触发方式描述，如 cron[0 0 2 * * *] / interval[@every 5m0s] / date[2026-09-25 10:00:00]。
func (s *Schedule) Label() string {
	if s == nil {
		return ""
	}
	switch s.Trigger {
	case TriggerCron:
		return "cron[" + s.Pattern + "]"
	case TriggerInterval:
		return "interval[" + s.Pattern + "]"
	case TriggerDate:
		return "date[" + s.RunAt.Format("2006-01-02 15:04:05") + "]"
	case TriggerNow:
		return TriggerManual
	}
	return s.Trigger
}

// InWindow 判断时刻 t 是否落在 [start_date, end_date] 之内（两端为 nil 表示不限制）。
func (s *Schedule) InWindow(t time.Time) bool {
	if s == nil {
		return false
	}
	if s.StartDate != nil && t.Before(*s.StartDate) {
		return false
	}
	if s.EndDate != nil && t.After(*s.EndDate) {
		return false
	}
	return true
}

// ParseSchedule 解析节点触发器。trigger 为空时返回 ErrNoTrigger。
func ParseSchedule(trigger, triggerArgs, startDate, endDate string) (*Schedule, error) {
	s := &Schedule{Trigger: strings.ToLower(strings.TrimSpace(trigger))}
	var err error
	if s.StartDate, err = parseTimeArg(startDate); err != nil {
		return nil, fmt.Errorf("开始时间格式不正确：%s", startDate)
	}
	if s.EndDate, err = parseTimeArg(endDate); err != nil {
		return nil, fmt.Errorf("结束时间格式不正确：%s", endDate)
	}
	if s.StartDate != nil && s.EndDate != nil && s.EndDate.Before(*s.StartDate) {
		return nil, errors.New("结束时间不能早于开始时间")
	}

	switch s.Trigger {
	case "":
		return nil, ErrNoTrigger
	case TriggerNow:
		s.OneShot = true
		s.RunAt = time.Now()
	case TriggerCron:
		pattern := normalizeCron(triggerArgs)
		if pattern == "" {
			return nil, errors.New("Cron 表达式格式不正确，需 5~7 段（秒 分 时 日 月 周）")
		}
		// gcron 原生支持 @every，用于表达「真正的每 N 秒/分/时」间隔：
		// cron 的 */N 只在字段起点对齐（如秒位 */59 = 第 0 秒与第 59 秒各跑一次），
		// 无法表达任意间隔，因此这里放行 @every。
		if strings.HasPrefix(pattern, "@every ") {
			d, derr := time.ParseDuration(strings.TrimSpace(strings.TrimPrefix(pattern, "@every ")))
			if derr != nil || d <= 0 {
				return nil, errors.New("间隔写法不正确，应形如 @every 59s / @every 10m / @every 6h")
			}
			s.Pattern = "@every " + d.String()
			return s, nil
		}
		if err = validateCronPattern(pattern); err != nil {
			return nil, err
		}
		s.Pattern = pattern
	case TriggerInterval:
		pattern := intervalPattern(triggerArgs)
		if pattern == "" {
			return nil, errors.New("时间间隔格式不正确，需 5 段：秒 分 时 天 周")
		}
		s.Pattern = pattern
	case TriggerDate:
		at, err := parseTimeArg(triggerArgs)
		if err != nil || at == nil {
			return nil, errors.New("执行时间格式不正确，需 YYYY-MM-DD HH:mm:ss")
		}
		s.OneShot = true
		s.RunAt = *at
	default:
		return nil, fmt.Errorf("不支持的触发器：%s", trigger)
	}
	return s, nil
}

// NextRun 计算 from 之后的下一次执行时刻；返回 false 表示不会再执行。
func NextRun(s *Schedule, from time.Time) (time.Time, bool) {
	if s == nil {
		return time.Time{}, false
	}
	if s.OneShot {
		if s.RunAt.After(from) {
			return s.RunAt, true
		}
		return time.Time{}, false
	}
	if d, err := everyDuration(s.Pattern); err == nil {
		return from.Add(d), true
	}
	return nextCron(s.Pattern, from)
}

// everyDuration 解析 @every 表达式的间隔。
func everyDuration(pattern string) (time.Duration, error) {
	if !strings.HasPrefix(pattern, "@every ") {
		return 0, errors.New("不是 @every 表达式")
	}
	d, err := time.ParseDuration(strings.TrimSpace(strings.TrimPrefix(pattern, "@every ")))
	if err != nil {
		return 0, err
	}
	if d <= 0 {
		return 0, errors.New("间隔必须大于 0")
	}
	return d, nil
}

// NextEveryRun 计算 @every 的下次触发时刻。
// gcron 的 @every 定时器以「注册时刻」为锚点按固定间隔推进，不随每次执行重置，
// 也不会随查询时间滑动，因此这里用注册时刻推进到 now 之后的第一个格点。
func NextEveryRun(pattern string, anchor, now time.Time) (time.Time, bool) {
	d, err := everyDuration(pattern)
	if err != nil {
		return time.Time{}, false
	}
	if anchor.IsZero() || anchor.After(now) {
		return now.Add(d), true
	}
	steps := now.Sub(anchor)/d + 1
	return anchor.Add(steps * d), true
}

// normalizeCron 把 5/6/7 段表达式规范化为 gcron 需要的 6 段（秒 分 时 日 月 周）。
// 5 段按 crontab 习惯补 0 秒；7 段（Quartz，末位为年）截断为 6 段；@ 宏原样透传。
func normalizeCron(expr string) string {
	expr = strings.TrimSpace(expr)
	if expr == "" || strings.HasPrefix(expr, "@") {
		return expr
	}
	f := strings.Fields(expr)
	switch len(f) {
	case 5:
		return "0 " + strings.Join(f, " ")
	case 6:
		return strings.Join(f, " ")
	case 7:
		return strings.Join(f[:6], " ")
	default:
		return ""
	}
}

// intervalPattern 把「秒 分 时 天 周」换算为 gcron 的 @every 表达式。
func intervalPattern(args string) string {
	f := strings.Fields(strings.TrimSpace(args))
	if len(f) != 5 {
		return ""
	}
	sec, min, hour, day, week := atoi(f[0]), atoi(f[1]), atoi(f[2]), atoi(f[3]), atoi(f[4])
	d := time.Duration(sec)*time.Second + time.Duration(min)*time.Minute + time.Duration(hour)*time.Hour + time.Duration(day)*24*time.Hour + time.Duration(week)*7*24*time.Hour
	if d <= 0 {
		return ""
	}
	return "@every " + d.String()
}

func atoi(s string) int { n, _ := strconv.Atoi(s); return n }

// parseTimeArg 解析可选时间参数，空字符串返回 nil。
func parseTimeArg(v string) (*time.Time, error) {
	v = strings.TrimSpace(v)
	if v == "" {
		return nil, nil
	}
	if t, err := time.Parse(time.RFC3339, v); err == nil {
		return &t, nil
	}
	gt, err := gtime.StrToTime(v)
	if err != nil {
		return nil, err
	}
	t := gt.Time
	return &t, nil
}

// ---------------------------------------------------------------------------
// Cron 表达式：校验与「下次执行时间」
//
// gcron 的 6 段顺序是「秒 分 时 日 月 周」，秒位允许用 # 表示标准 5 段 crontab；
// 日/周位允许 ?，月/周位支持 jan..dec / sun..sat 缩写。此处与之保持一致，
// 避免出现「注册用一套、展示用一套」而下次执行时间对不上。
// ---------------------------------------------------------------------------

type cronSpec struct {
	second, minute, hour, day, month, week map[int]struct{}
	ignoreSecond                           bool
}

var (
	cronSpecCache sync.Map // pattern -> *cronSpec
	macroPatterns = map[string]string{
		"@yearly":   "# 0 0 1 1 *",
		"@annually": "# 0 0 1 1 *",
		"@monthly":  "# 0 0 1 * *",
		"@weekly":   "# 0 0 * * 0",
		"@daily":    "# 0 0 * * *",
		"@midnight": "# 0 0 * * *",
		"@hourly":   "# 0 * * * *",
	}
	monthNames = map[string]int{
		"jan": 1, "feb": 2, "mar": 3, "apr": 4, "may": 5, "jun": 6,
		"jul": 7, "aug": 8, "sep": 9, "oct": 10, "nov": 11, "dec": 12,
	}
	weekNames = map[string]int{
		"sun": 0, "mon": 1, "tue": 2, "wed": 3, "thu": 4, "fri": 5, "sat": 6,
	}
)

// validateCronPattern 校验表达式能否被解析出下一次执行时间。
func validateCronPattern(pattern string) error {
	if _, err := parseCronSpec(pattern); err != nil {
		return fmt.Errorf("Cron 表达式不正确：%s（%s）", pattern, err.Error())
	}
	return nil
}

func parseCronSpec(pattern string) (*cronSpec, error) {
	pattern = strings.TrimSpace(pattern)
	if cached, ok := cronSpecCache.Load(pattern); ok {
		spec, _ := cached.(*cronSpec)
		return spec, nil
	}
	spec, err := buildCronSpec(pattern)
	if err != nil {
		return nil, err
	}
	cronSpecCache.Store(pattern, spec)
	return spec, nil
}

func buildCronSpec(pattern string) (*cronSpec, error) {
	if pattern == "" {
		return nil, errors.New("表达式为空")
	}
	if strings.HasPrefix(pattern, "@") {
		if v, ok := macroPatterns[strings.ToLower(pattern)]; ok {
			pattern = v
		} else if strings.HasPrefix(pattern, "@every ") {
			return nil, errors.New("@every 表达式请使用时间间隔触发器")
		} else {
			return nil, fmt.Errorf("未知的预定义表达式 %s", pattern)
		}
	}
	f := strings.Fields(pattern)
	if len(f) != 6 {
		return nil, errors.New("需要 6 段：秒 分 时 日 月 周")
	}
	spec := &cronSpec{}
	var err error
	if f[0] == "#" {
		spec.ignoreSecond = true
		spec.second = setOf(0, 0)
	} else if spec.second, err = parseCronField(f[0], 0, 59, false, nil); err != nil {
		return nil, fmt.Errorf("秒字段 %s: %w", f[0], err)
	}
	if spec.minute, err = parseCronField(f[1], 0, 59, false, nil); err != nil {
		return nil, fmt.Errorf("分字段 %s: %w", f[1], err)
	}
	if spec.hour, err = parseCronField(f[2], 0, 23, false, nil); err != nil {
		return nil, fmt.Errorf("时字段 %s: %w", f[2], err)
	}
	if spec.day, err = parseCronField(f[3], 1, 31, true, nil); err != nil {
		return nil, fmt.Errorf("日字段 %s: %w", f[3], err)
	}
	if spec.month, err = parseCronField(f[4], 1, 12, false, monthNames); err != nil {
		return nil, fmt.Errorf("月字段 %s: %w", f[4], err)
	}
	if spec.week, err = parseCronField(f[5], 0, 6, true, weekNames); err != nil {
		return nil, fmt.Errorf("周字段 %s: %w", f[5], err)
	}
	return spec, nil
}

// parseCronField 支持 *、?、a、a-b、a,b,c、*/n、a-b/n 以及月/周名称缩写。
func parseCronField(item string, min, max int, allowQuestion bool, names map[string]int) (map[int]struct{}, error) {
	item = strings.TrimSpace(item)
	if item == "" {
		return nil, errors.New("字段为空")
	}
	if item == "*" || (allowQuestion && item == "?") {
		return setOf(min, max), nil
	}
	out := map[int]struct{}{}
	for _, part := range strings.Split(item, ",") {
		part = strings.TrimSpace(part)
		if part == "" {
			return nil, errors.New("存在空的分段")
		}
		step := 1
		body := part
		if idx := strings.Index(part, "/"); idx >= 0 {
			body = part[:idx]
			n, err := strconv.Atoi(part[idx+1:])
			if err != nil || n <= 0 {
				return nil, fmt.Errorf("步长非法 %s", part)
			}
			step = n
		}
		from, to := min, max
		if body != "*" && body != "" {
			if idx := strings.Index(body, "-"); idx >= 0 {
				a, err1 := cronValue(body[:idx], names)
				b, err2 := cronValue(body[idx+1:], names)
				if err1 != nil || err2 != nil {
					return nil, fmt.Errorf("区间非法 %s", part)
				}
				from, to = a, b
			} else {
				v, err := cronValue(body, names)
				if err != nil {
					return nil, err
				}
				from, to = v, v
			}
		}
		if from < min || to > max || from > to {
			return nil, fmt.Errorf("取值超出范围 %s（%d-%d）", part, min, max)
		}
		for i := from; i <= to; i += step {
			out[i] = struct{}{}
		}
	}
	if len(out) == 0 {
		return nil, errors.New("没有匹配值")
	}
	return out, nil
}

func cronValue(s string, names map[string]int) (int, error) {
	s = strings.TrimSpace(s)
	if names != nil {
		if v, ok := names[strings.ToLower(s)]; ok {
			return v, nil
		}
	}
	v, err := strconv.Atoi(s)
	if err != nil {
		return 0, fmt.Errorf("非法取值 %s", s)
	}
	return v, nil
}

func setOf(from, to int) map[int]struct{} {
	out := make(map[int]struct{}, to-from+1)
	for i := from; i <= to; i++ {
		out[i] = struct{}{}
	}
	return out
}

// nextCron 计算 from 之后的下一次执行时刻，最多向后搜索 5 年。
func nextCron(pattern string, from time.Time) (time.Time, bool) {
	spec, err := parseCronSpec(pattern)
	if err != nil {
		return time.Time{}, false
	}
	loc := from.Location()
	t := from.Truncate(time.Second).Add(time.Second)
	limit := from.AddDate(5, 0, 0)
	for t.Before(limit) {
		if !hit(spec.month, int(t.Month())) || !hit(spec.day, t.Day()) || !hit(spec.week, int(t.Weekday())) {
			t = time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, loc).AddDate(0, 0, 1)
			continue
		}
		if !hit(spec.hour, t.Hour()) {
			t = time.Date(t.Year(), t.Month(), t.Day(), t.Hour(), 0, 0, 0, loc).Add(time.Hour)
			continue
		}
		if !hit(spec.minute, t.Minute()) {
			t = t.Truncate(time.Minute).Add(time.Minute)
			continue
		}
		if !spec.ignoreSecond && !hit(spec.second, t.Second()) {
			t = t.Add(time.Second)
			continue
		}
		return t, true
	}
	return time.Time{}, false
}

func hit(m map[int]struct{}, v int) bool {
	if len(m) == 0 {
		return false
	}
	_, ok := m[v]
	return ok
}

// SchedulerPatternLabel 用于控制台/列表展示表达式的友好名称。
func SchedulerPatternLabel(pattern string) string {
	if strings.HasPrefix(pattern, "@every ") {
		return "interval[" + pattern + "]"
	}
	return "cron[" + pattern + "]"
}

// NodeArgsFromString 解析 task_node.args（逗号分隔的位置参数）。
// 空参数返回空切片而非 nil，保证 json 序列化后是 [] 而不是 null。
func NodeArgsFromString(args string) []string {
	args = strings.TrimSpace(args)
	if args == "" {
		return []string{}
	}
	parts := strings.Split(args, ",")
	out := make([]string, 0, len(parts))
	for _, p := range parts {
		if p = strings.TrimSpace(p); p != "" {
			out = append(out, p)
		}
	}
	return out
}

// ParseKwargs 解析 task_node.kwargs（JSON 对象），失败或为空时返回空 map。
func ParseKwargs(raw string) map[string]interface{} {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return map[string]interface{}{}
	}
	var m map[string]interface{}
	if err := json.Unmarshal([]byte(raw), &m); err != nil || m == nil {
		return map[string]interface{}{}
	}
	out := make(map[string]interface{}, len(m))
	for k, v := range m {
		out[k] = v
	}
	return out
}

// Shorten 按字符截断文本，用于 UI 标签（超长追加省略号）。
func Shorten(s string, n int) string {
	if n <= 0 {
		n = 24
	}
	r := []rune(strings.TrimSpace(s))
	if len(r) <= n {
		return string(r)
	}
	return string(r[:n]) + "…"
}

// TextOrJSON 把任意返回值转成可入库的文本。
func TextOrJSON(v interface{}) string {
	switch t := v.(type) {
	case nil:
		return ""
	case string:
		return t
	case []byte:
		return string(t)
	case error:
		return t.Error()
	default:
		if b, err := json.Marshal(v); err == nil {
			return string(b)
		}
		return gconv.String(v)
	}
}
