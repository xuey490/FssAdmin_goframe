package service

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/gogf/gf/v2/container/gvar"
	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/os/gcron"
	"github.com/gogf/gf/v2/util/gconv"
)

// nodeRecord 构造 task_node 记录，用于在无数据库环境下验证调度器装配逻辑。
func nodeRecord(id int, name, code, handler, trigger, triggerArgs, kwargs string, status int) gdb.Record {
	return gdb.Record{
		"id":            gvar.New(id),
		"name":          gvar.New(name),
		"code":          gvar.New(code),
		"func":          gvar.New(handler),
		"trigger":       gvar.New(trigger),
		"trigger_args":  gvar.New(triggerArgs),
		"args":          gvar.New(""),
		"kwargs":        gvar.New(kwargs),
		"coalesce":      gvar.New(0),
		"max_instances": gvar.New(1),
		"start_date":    gvar.New(""),
		"end_date":      gvar.New(""),
		"status":        gvar.New(status),
		"tenant_id":     gvar.New(1),
	}
}

// resetScheduler 清理测试产生的调度状态，避免污染其它用例。
func resetScheduler(t *testing.T) {
	t.Helper()
	stateMu.Lock()
	stopEntries()
	metas = map[string]*jobMeta{}
	schedState = "停止"
	stateMu.Unlock()
	t.Cleanup(func() {
		stateMu.Lock()
		stopEntries()
		metas = map[string]*jobMeta{}
		stateMu.Unlock()
	})
}

func registerForTest(t *testing.T, rec gdb.Record) *jobMeta {
	t.Helper()
	stateMu.Lock()
	defer stateMu.Unlock()
	m := buildMeta(rec)
	metas[m.ID] = m
	if schedState == "停止" {
		schedState = "运行中"
	}
	registerMeta(context.Background(), m)
	return m
}

func TestBuildMetaCronNode(t *testing.T) {
	resetScheduler(t)
	m := registerForTest(t, nodeRecord(101, "备份节点", "test_backup", backupCode, TriggerCron, "0 0 2 * * *", `{"keep_days":7}`, 0))

	if m.Unsupported != "" {
		t.Fatalf("Cron 节点不应被判定为不可调度: %s", m.Unsupported)
	}
	if m.Pattern != "0 0 2 * * *" || m.Trigger != TriggerCron {
		t.Fatalf("触发器解析异常: %+v", m)
	}
	if m.NextRunTime.IsZero() {
		t.Fatal("注册后应算出下次执行时间")
	}
	if m.NextRunTime.Hour() != 2 {
		t.Fatalf("下次执行时间应在 02:00，实际 %s", m.NextRunTime.Format(time.DateTime))
	}
	if got := m.Kwargs["keep_days"]; got == nil {
		t.Fatalf("kwargs 未解析: %#v", m.Kwargs)
	}
	if e := gcron.Search("101"); e == nil {
		t.Fatal("应按节点 id 注册进 gcron")
	}
}

func TestBuildMetaIntervalNode(t *testing.T) {
	resetScheduler(t)
	m := registerForTest(t, nodeRecord(102, "间隔节点", "test_interval", "log_cleanup", TriggerInterval, "0 5 0 0 0", `{"days":1}`, 0))
	if m.Pattern != "@every 5m0s" {
		t.Fatalf("间隔表达式异常: %s", m.Pattern)
	}
	if m.Unsupported != "" {
		t.Fatalf("间隔节点不应不可调度: %s", m.Unsupported)
	}
	if got := m.NextRunTime.Sub(time.Now()); got < 4*time.Minute || got > 6*time.Minute {
		t.Fatalf("下次执行时间应在 5 分钟后，实际 %s", got)
	}
}

func TestBuildMetaOneShotDateNode(t *testing.T) {
	resetScheduler(t)
	future := time.Now().Add(2 * time.Hour).Format(time.DateTime)
	m := registerForTest(t, nodeRecord(103, "一次性节点", "test_date", "log_cleanup", TriggerDate, future, `{}`, 0))
	if !m.OneShot || m.Unsupported != "" {
		t.Fatalf("一次性任务应可调度: %+v", m)
	}
	if m.NextRunTime.Format(time.DateTime) != future {
		t.Fatalf("下次执行时间应为配置时间，实际 %s", m.NextRunTime.Format(time.DateTime))
	}
	if m.timer == nil {
		t.Fatal("一次性任务应注册 timer")
	}

	past := time.Now().Add(-time.Hour).Format(time.DateTime)
	expired := buildMeta(nodeRecord(104, "过期节点", "test_date_past", "log_cleanup", TriggerDate, past, `{}`, 0))
	if expired.Unsupported == "" || !strings.Contains(expired.Unsupported, "已过执行时间") {
		t.Fatalf("过期的一次性任务应标记不可调度，实际 %q", expired.Unsupported)
	}
}

func TestBuildMetaUnsupportedCases(t *testing.T) {
	resetScheduler(t)
	cases := []struct {
		name    string
		rec     gdb.Record
		keyword string
	}{
		{
			"Python 遗留代码块",
			nodeRecord(105, "遗留节点", "test_py", "def handler(*args, **kwargs):\n    return 1", TriggerCron, "0 0 2 * * *", "", 0),
			"未支持的任务类型",
		},
		{
			"未配置触发器",
			nodeRecord(106, "无触发器", "test_none", backupCode, "", "", "", 0),
			"未配置触发器",
		},
		{
			// 任务类型不可用比缺触发器更根本，应优先提示前者
			"Python 遗留且无触发器",
			nodeRecord(112, "遗留无触发器", "test_py_notrigger", "def handler():\n    pass", "", "", "", 0),
			"未支持的任务类型",
		},
		{
			"非法 Cron",
			nodeRecord(107, "非法 Cron", "test_bad", backupCode, TriggerCron, "0 0 99 * * *", "", 0),
			"Cron",
		},
		{
			"Python 风格触发器",
			nodeRecord(108, "旧触发器", "test_py_cron", backupCode, TriggerCron, "cron[hour='2']", "", 0),
			"",
		},
	}
	for _, c := range cases {
		m := buildMeta(c.rec)
		if m.Unsupported == "" {
			t.Fatalf("%s：应标记不可调度", c.name)
		}
		if c.keyword != "" && !strings.Contains(m.Unsupported, c.keyword) {
			t.Fatalf("%s：提示信息应包含 %q，实际 %q", c.name, c.keyword, m.Unsupported)
		}
		if gcron.Search(m.ID) != nil {
			t.Fatalf("%s：不可调度的节点不应注册进 gcron", c.name)
		}
	}
}

func TestRuntimeOfDerivedStatus(t *testing.T) {
	resetScheduler(t)
	rec := nodeRecord(109, "状态节点", "test_runtime", backupCode, TriggerCron, "0 0 2 * * *", "", 0)
	registerForTest(t, rec)

	got := runtimeOf(109, 0)
	if got["runtime_status"] != "waiting" || got["supported"] != true {
		t.Fatalf("初始运行态异常: %#v", got)
	}
	if got["next_run_time"] == "" {
		t.Fatal("应返回下次执行时间")
	}

	markMetaResult("109", 2, 120, "", time.Now().Add(24*time.Hour))
	got = runtimeOf(109, 0)
	if got["runtime_status"] != "success" || got["last_duration_ms"] != int64(120) {
		t.Fatalf("成功态异常: %#v", got)
	}

	markMetaResult("109", 3, 90, "boom", time.Time{})
	markMetaResult("109", 3, 91, "boom", time.Time{})
	got = runtimeOf(109, 0)
	if got["runtime_status"] != "failed" || got["fail_count"] != 2 {
		t.Fatalf("失败态与连续失败计数异常: %#v", got)
	}

	markMetaRunning("109", true)
	if got = runtimeOf(109, 0); got["runtime_status"] != "running" {
		t.Fatalf("运行中态异常: %#v", got)
	}
	markMetaRunning("109", false)

	if got = runtimeOf(109, 1); got["runtime_status"] != "disabled" {
		t.Fatalf("停用态异常: %#v", got)
	}
	if got = runtimeOf(99999, 0); got["runtime_status"] != "unregistered" {
		t.Fatalf("未注册态异常: %#v", got)
	}
}

func TestSyncNodeKeepsUnsupportedOutOfScheduler(t *testing.T) {
	resetScheduler(t)
	stateMu.Lock()
	schedState = "运行中"
	stateMu.Unlock()

	// 直接投递一个 Python 遗留节点：应只登记元数据，不注册定时器
	rec := nodeRecord(110, "遗留节点", "test_sync_legacy", "def handler():\n    pass", TriggerCron, "0 0 2 * * *", "", 0)
	stateMu.Lock()
	m := buildMeta(rec)
	metas[m.ID] = m
	stateMu.Unlock()

	if m.Unsupported == "" {
		t.Fatal("遗留节点应标记不可调度")
	}
	if gcron.Search("110") != nil {
		t.Fatal("遗留节点不应注册进 gcron")
	}
	if got := runtimeOf(110, 0); got["supported"] != false {
		t.Fatalf("遗留节点 supported 应为 false: %#v", got)
	}
}

// 注册时缓存的下次执行时间会过期；读取时必须按当前时刻重算，避免界面显示过去时间。
func TestRuntimeNextRunRecomputed(t *testing.T) {
	resetScheduler(t)
	registerForTest(t, nodeRecord(120, "重算节点", "test_recalc", backupCode, TriggerCron, "0 0 2 * * *", "", 0))

	stateMu.Lock()
	metas["120"].NextRunTime = time.Now().Add(-time.Hour)
	stateMu.Unlock()

	got := runtimeOf(120, 0)
	raw, _ := got["next_run_time"].(string)
	if raw == "" {
		t.Fatal("应返回下次执行时间")
	}
	next, err := time.ParseInLocation(time.DateTime, raw, time.Local)
	if err != nil {
		t.Fatalf("时间格式异常 %q: %v", raw, err)
	}
	if !next.After(time.Now()) {
		t.Fatalf("下次执行时间不应是过去时间: %s", raw)
	}
	if got["last_status"] != nil {
		t.Fatalf("尚未执行过时 last_status 应为 nil（供回落执行日志），实际 %#v", got["last_status"])
	}
	if got["runtime_status"] != "waiting" {
		t.Fatalf("未执行过应为等待执行，实际 %v", got["runtime_status"])
	}
}

// @every 的展示时间必须锚定注册时刻按固定格点推进，不能随查询时间滑动。
func TestRuntimeIntervalNextRunAnchored(t *testing.T) {
	resetScheduler(t)
	registerForTest(t, nodeRecord(121, "间隔节点", "test_anchor", "log_cleanup", TriggerInterval, "0 5 0 0 0", "", 0))

	// 模拟该任务已注册 3 分钟（间隔 5 分钟，则下一次应在 2 分钟后）
	stateMu.Lock()
	metas["121"].RegisteredAt = time.Now().Add(-3 * time.Minute)
	stateMu.Unlock()

	got := runtimeOf(121, 0)
	raw, _ := got["next_run_time"].(string)
	next, err := time.ParseInLocation(time.DateTime, raw, time.Local)
	if err != nil {
		t.Fatalf("时间格式异常 %q: %v", raw, err)
	}
	remain := next.Sub(time.Now())
	if remain < 90*time.Second || remain > 130*time.Second {
		t.Fatalf("下次执行应约在 2 分钟后（锚点推进），实际 %s（%s）", raw, remain.Round(time.Second))
	}
}

func TestNextEveryRunAnchor(t *testing.T) {
	anchor := time.Date(2026, 9, 25, 10, 0, 0, 0, time.Local)
	at := func(h, m, s int) time.Time {
		return time.Date(2026, 9, 25, h, m, s, 0, time.Local)
	}
	cases := []struct {
		now  time.Time
		want time.Time
	}{
		{anchor, at(10, 5, 0)},
		{at(10, 4, 0), at(10, 5, 0)},
		{at(10, 5, 0), at(10, 10, 0)},
		{at(10, 7, 30), at(10, 10, 0)},
	}
	for _, c := range cases {
		got, ok := NextEveryRun("@every 5m", anchor, c.now)
		if !ok || !got.Equal(c.want) {
			t.Fatalf("锚点 %s now %s：期望 %s，实际 %s", anchor.Format(time.DateTime),
				c.now.Format(time.DateTime), c.want.Format(time.DateTime), got.Format(time.DateTime))
		}
	}
	if _, ok := NextEveryRun("@every 0s", anchor, anchor); ok {
		t.Fatal("0 间隔应无效")
	}
	if _, ok := NextEveryRun("0 0 2 * * *", anchor, anchor); ok {
		t.Fatal("非 @every 表达式应无效")
	}
}

// 前端靠 run_seq 判断「有新执行」并自动刷新，状态接口必须暴露它。
func TestSchedulerStatusExposesRunSeq(t *testing.T) {
	resetScheduler(t)
	stateMu.Lock()
	prevSeq, prevAt := runSeq, lastRunAt
	runSeq = 7
	lastRunAt = time.Now()
	stateMu.Unlock()
	t.Cleanup(func() {
		stateMu.Lock()
		runSeq, lastRunAt = prevSeq, prevAt
		stateMu.Unlock()
	})

	data, err := SchedulerStatus(nil)
	if err != nil {
		t.Fatal(err)
	}
	m, ok := data.(map[string]interface{})
	if !ok {
		t.Fatalf("返回结构异常: %#v", data)
	}
	if gconv.Int64(m["run_seq"]) != 7 {
		t.Fatalf("run_seq 异常: %#v", m["run_seq"])
	}
	if gconv.String(m["last_run_at"]) == "" {
		t.Fatalf("last_run_at 应返回时间字符串: %#v", m["last_run_at"])
	}
}

func TestSchedulerConsoleRecordsEvents(t *testing.T) {
	schedMu.Lock()
	before := len(consoleBuf)
	schedMu.Unlock()
	logConsole("unit-test-event")
	schedMu.Lock()
	defer schedMu.Unlock()
	if len(consoleBuf) == before {
		t.Fatal("控制台应记录事件")
	}
	last := consoleBuf[len(consoleBuf)-1]
	if !strings.Contains(last, "unit-test-event") || len(last) < len("15:04:05 unit-test-event") {
		t.Fatalf("控制台事件格式异常: %s", last)
	}
}

func TestJobStatePayload(t *testing.T) {
	rec := nodeRecord(111, "元数据节点", "test_state", "http_request", TriggerCron, "0 0 2 * * *", `{"url":"http://x"}`, 0)
	task := &Task{NodeID: 111, NodeName: "元数据节点", Code: "test_state", Trigger: TriggerCron, Args: []string{"a"}, Kwargs: ParseKwargs(`{"url":"http://x"}`)}
	started := time.Now().Add(-time.Second)
	state := buildJobState(rec, task, TriggerCron, "0 0 2 * * *", started, time.Now(), 1000, "ok", "", time.Now().Add(time.Hour))
	for _, key := range []string{`"version":2`, `"handler":"http_request"`, `"trigger":"cron"`, `"duration_ms":1000`, `"next_run_time"`, `"node"`} {
		if !strings.Contains(state, key) {
			t.Fatalf("执行元数据缺少 %s：%s", key, state)
		}
	}
}

func TestNodeTypesDictionary(t *testing.T) {
	// NodeTypes 不读取请求上下文，可直接以 nil 调用验证返回结构。
	data, err := NodeTypes(nil)
	if err != nil {
		t.Fatal(err)
	}
	dict, ok := data.(map[string]interface{})
	if !ok {
		t.Fatalf("返回结构异常: %#v", data)
	}
	handlers, ok := dict["handlers"].([]Handler)
	if !ok || len(handlers) < 4 {
		t.Fatalf("handlers 异常: %#v", dict["handlers"])
	}
	if len(dict["triggers"].([]map[string]interface{})) != 4 {
		t.Fatalf("triggers 异常: %#v", dict["triggers"])
	}
	if len(dict["runtime_status"].([]map[string]interface{})) < 4 {
		t.Fatalf("runtime_status 异常: %#v", dict["runtime_status"])
	}
}
