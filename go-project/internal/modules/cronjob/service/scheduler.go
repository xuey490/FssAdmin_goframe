package service

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"

	"fssadmin/go-project/internal/modules/cronjob/dao"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gcron"
	"github.com/gogf/gf/v2/util/gconv"
	"github.com/gogf/gf/v2/util/guid"
)

// unsupportedNoTrigger 表示节点没有配置触发器：可保存，但不参与调度。
const unsupportedNoTrigger = "未配置触发器"

// jobMeta 是节点在调度器内存中的运行期元数据，同时承载「派生运行态」。
type jobMeta struct {
	ID      string
	Name    string
	Code    string
	Handler string
	Trigger string
	Pattern string
	Args    []string
	Kwargs  map[string]interface{}
	OneShot bool
	RunAt   time.Time
	Paused  bool

	StartDate *time.Time
	EndDate   *time.Time

	// Unsupported 非空表示该节点无法调度（Python 遗留、任务类型未注册、触发器无效等），
	// 内容为给前端展示的原因。
	Unsupported string

	// 运行态
	Running      int
	LastRunTime  time.Time
	LastStatus   int
	LastDuration int64
	LastError    string
	FailCount    int
	NextRunTime  time.Time
	RegisteredAt time.Time

	sem   chan struct{}
	timer *time.Timer
}

var (
	stateMu    sync.Mutex
	schedState = "停止"
	metas      = map[string]*jobMeta{}
	// runSeq 统计进程启动以来完成的执行次数，前端据此判断「有任务执行过」并自动刷新
	runSeq    int64
	lastRunAt time.Time
)

// ---------------------------------------------------------------------------
// 生命周期
// ---------------------------------------------------------------------------

// Boot 由 bootstrap 在 app.schedulerEnable=true 时调用。
func Boot(ctx context.Context) error { return startScheduler(ctx) }

func ensureBackupNode(ctx context.Context) error {
	rec, err := dao.NodeModel().Ctx(ctx).Where("code", backupCode).One()
	if err != nil {
		return err
	}
	if !rec.IsEmpty() {
		return nil
	}
	_, err = dbx.Model(dao.NodeTable).Ctx(ctx).Data(g.Map{
		"name": "数据库定时备份", "code": backupCode,
		"trigger": TriggerCron, "trigger_args": conf.BackupCron(),
		"func": backupCode, "kwargs": fmt.Sprintf(`{"dir":%q,"keep_days":30}`, conf.BackupDir()),
		"coalesce": 1, "max_instances": 1, "status": 0,
		"description": "每天备份数据库到 " + conf.BackupDir(),
		"uuid":        guid.S(), "create_time": dbx.Now(), "update_time": dbx.Now(), "tenant_id": 1,
	}).Insert()
	return err
}

func ensureRestoreNode(ctx context.Context) error {
	rec, err := dao.NodeModel().Ctx(ctx).Where("code", restoreCode).One()
	if err != nil {
		return err
	}
	if !rec.IsEmpty() {
		return nil
	}
	// ponytail: 默认暂停。demoEnable=true 才自动跑，避免开发库被每小时抹掉。
	st := 1
	if conf.DemoEnable() {
		st = 0
	}
	_, err = dbx.Model(dao.NodeTable).Ctx(ctx).Data(g.Map{
		"name": "数据库还原", "code": restoreCode,
		"trigger": TriggerInterval, "trigger_args": "0 0 1 0 0",
		"func": restoreCode, "kwargs": fmt.Sprintf(`{"file":%q,"flush_redis":true}`, conf.RestoreFile()),
		"coalesce": 1, "max_instances": 1, "status": st,
		"description": "演示环境每小时用 " + conf.RestoreFile() + " 还原数据库并清空 Redis（会覆盖现有数据）",
		"uuid":        guid.S(), "create_time": dbx.Now(), "update_time": dbx.Now(), "tenant_id": 1,
	}).Insert()
	return err
}

// stopMeta 移除单个节点的调度注册（gcron 条目 + 一次性定时器）。调用方需持有 stateMu。
func stopMeta(id string) {
	gcron.Remove(id)
	if m := metas[id]; m != nil && m.timer != nil {
		m.timer.Stop()
		m.timer = nil
	}
}

// stopEntries 停掉全部已注册的定时器。调用方需持有 stateMu。
func stopEntries() {
	for _, e := range gcron.Entries() {
		gcron.Remove(e.Name)
	}
	for _, m := range metas {
		if m.timer != nil {
			m.timer.Stop()
			m.timer = nil
		}
	}
}

// startScheduler 从数据库全量重建调度注册表。
func startScheduler(ctx context.Context) error {
	if err := ensureBackupNode(ctx); err != nil {
		return err
	}
	if err := ensureRestoreNode(ctx); err != nil {
		return err
	}
	rows, err := dao.NodeModel().Ctx(ctx).Where("status", 0).All()
	if err != nil {
		return err
	}
	// 先全部构建，再统一注册，避免中途失败留下半状态。
	fresh := map[string]*jobMeta{}
	pending := make([]*jobMeta, 0, len(rows))
	for _, rec := range rows {
		if m := buildMeta(rec); m != nil {
			fresh[m.ID] = m
			pending = append(pending, m)
		}
	}

	stateMu.Lock()
	defer stateMu.Unlock()
	stopEntries()
	metas = fresh
	for _, m := range pending {
		registerMeta(ctx, m)
	}
	schedState = "运行中"
	gcron.Start()
	logConsole(fmt.Sprintf("scheduler start jobs=%d", len(metas)))
	return nil
}

// syncFromDB 重新加载节点定义；调度器原本处于暂停态时保持暂停。
func syncFromDB(ctx context.Context) error {
	stateMu.Lock()
	paused := schedState == "暂停"
	stateMu.Unlock()

	if err := startScheduler(ctx); err != nil {
		return err
	}
	if paused {
		stateMu.Lock()
		gcron.Stop()
		schedState = "暂停"
		stateMu.Unlock()
	}
	return nil
}

// buildMeta 把节点记录转成运行期元数据（不注册定时器）。
func buildMeta(rec gdb.Record) *jobMeta {
	id := gconv.String(rec["id"].Int())
	m := &jobMeta{
		ID:      id,
		Name:    rec["name"].String(),
		Code:    rec["code"].String(),
		Handler: strings.TrimSpace(rec["func"].String()),
		Args:    NodeArgsFromString(rec["args"].String()),
		Kwargs:  ParseKwargs(rec["kwargs"].String()),
	}
	// 合并运行时并发为 1；否则按最大实例数限制并发。
	maxInstances := rec["max_instances"].Int()
	if maxInstances < 1 {
		maxInstances = 1
	}
	if gconv.Int(rec["coalesce"].Int()) > 0 || gconv.Bool(rec["coalesce"].String()) {
		maxInstances = 1
	}
	m.sem = make(chan struct{}, maxInstances)

	// 先判任务类型：Python 遗留节点的 func 无法执行，这是比缺触发器更根本的问题，
	// 提示要指向可操作的修复动作（重新选择任务类型）。
	if _, ok := GetHandler(m.Handler); !ok {
		m.Unsupported = "未支持的任务类型：" + Shorten(m.Handler, 24)
		m.Paused = true
		return m
	}

	sched, err := ParseSchedule(rec["trigger"].String(), rec["trigger_args"].String(),
		rec["start_date"].String(), rec["end_date"].String())
	if err != nil {
		if errors.Is(err, ErrNoTrigger) {
			m.Unsupported = unsupportedNoTrigger
		} else {
			m.Unsupported = err.Error()
		}
		m.Paused = true
		return m
	}
	m.Trigger = sched.Trigger
	m.Pattern = sched.Pattern
	m.OneShot = sched.OneShot
	m.RunAt = sched.RunAt
	m.StartDate = sched.StartDate
	m.EndDate = sched.EndDate

	if m.OneShot && !m.RunAt.After(time.Now()) {
		m.Unsupported = "一次性任务已过执行时间"
		m.Paused = true
		return m
	}
	return m
}

// registerMeta 把元数据注册到 gcron 或一次性定时器。调用方需持有 stateMu。
func registerMeta(ctx context.Context, m *jobMeta) {
	if m.Unsupported != "" {
		return
	}
	if m.OneShot {
		delay := time.Until(m.RunAt)
		if delay < 0 {
			delay = 0
		}
		id := m.ID
		m.NextRunTime = m.RunAt
		m.timer = time.AfterFunc(delay, func() {
			runScheduled(context.Background(), id)
			stateMu.Lock()
			if cur := metas[id]; cur != nil {
				if cur.timer != nil {
					cur.timer.Stop()
					cur.timer = nil
				}
				cur.NextRunTime = time.Time{}
			}
			stateMu.Unlock()
		})
		return
	}
	if m.Pattern == "" {
		m.Unsupported = "触发器为空"
		m.Paused = true
		return
	}
	m.RegisteredAt = time.Now()
	m.NextRunTime, _ = NextRun(scheduleOf(m), m.RegisteredAt)

	job := func(ctx context.Context) { runScheduled(ctx, m.ID) }
	var err error
	if cap(m.sem) <= 1 {
		_, err = gcron.AddSingleton(ctx, m.Pattern, job, m.ID)
	} else {
		_, err = gcron.Add(ctx, m.Pattern, job, m.ID)
	}
	if err != nil {
		m.Paused = true
		m.Unsupported = "触发器无效：" + err.Error()
		logConsole("cron " + m.Name + " " + err.Error())
	}
}

// scheduleOf 由 meta 还原 Schedule，用于计算下次执行时间。
func scheduleOf(m *jobMeta) *Schedule {
	return &Schedule{
		Trigger:   m.Trigger,
		Pattern:   m.Pattern,
		OneShot:   m.OneShot,
		RunAt:     m.RunAt,
		StartDate: m.StartDate,
		EndDate:   m.EndDate,
	}
}

// ---------------------------------------------------------------------------
// 执行
// ---------------------------------------------------------------------------

// runScheduled 调度器回调入口：窗口校验 + 并发闸门。
func runScheduled(ctx context.Context, id string) {
	stateMu.Lock()
	m := metas[id]
	if m == nil {
		stateMu.Unlock()
		return
	}
	name, trigger, pattern := m.Name, m.Trigger, m.Pattern
	paused, unsupported, sem := m.Paused, m.Unsupported, m.sem
	stateMu.Unlock()
	if paused || unsupported != "" {
		return
	}
	if !inWindow(id, time.Now()) {
		logConsole("skip " + name + " 不在执行窗口内")
		return
	}
	select {
	case sem <- struct{}{}:
		defer func() { <-sem }()
	default:
		logConsole("skip " + name + " 已达最大实例数")
		return
	}
	if _, err := runNodeOnce(ctx, parseInt(id), trigger, pattern, time.Now()); err != nil {
		logConsole("fail " + name + " " + err.Error())
		return
	}
	logConsole("ok " + name)
}

func inWindow(id string, now time.Time) bool {
	stateMu.Lock()
	defer stateMu.Unlock()
	m := metas[id]
	if m == nil {
		return false
	}
	return scheduleOf(m).InWindow(now)
}

func parseInt(id string) int { n, _ := strconv.Atoi(id); return n }

// runNodeOnce 读取节点最新定义并执行一次，写两阶段执行日志并维护运行态。
// triggerType 取值 cron/interval/date/manual；pattern 仅用于执行元数据展示。
func runNodeOnce(ctx context.Context, nodeID int, triggerType, pattern string, plannedAt time.Time) (string, error) {
	rec, err := dao.NodeModel().Ctx(ctx).Where("id", nodeID).One()
	if err != nil {
		return "", err
	}
	if rec.IsEmpty() {
		return "", biz.NotFound("节点不存在")
	}
	handler := strings.TrimSpace(rec["func"].String())
	task := &Task{
		NodeID:   nodeID,
		NodeName: rec["name"].String(),
		Code:     rec["code"].String(),
		Trigger:  triggerType,
		Args:     NodeArgsFromString(rec["args"].String()),
		Kwargs:   ParseKwargs(rec["kwargs"].String()),
	}
	if plannedAt.IsZero() {
		plannedAt, _ = NextRun(mustSchedule(rec), time.Now())
	}

	id := strconv.Itoa(nodeID)
	markMetaRunning(id, true)
	defer markMetaRunning(id, false)

	started := time.Now()
	task.LogID = openJobLog(ctx, nodeID, task.NodeName, triggerType, pattern, plannedAt, rec, task, started)

	result, runErr := ExecuteHandler(ctx, handler, task)
	finished := time.Now()
	duration := finished.Sub(started).Milliseconds()

	status, errMsg := 2, ""
	if runErr != nil {
		errMsg = runErr.Error()
		if IsTimeout(runErr) {
			status = 4
		} else {
			status = 3
		}
	}
	next := nextAfterRun(rec, finished)
	resultText := Truncate(TextOrJSON(result), maxOutputLen)
	state := buildJobState(rec, task, triggerType, pattern, started, finished, duration, resultText, errMsg, next)

	finishJobLog(task.LogID, status, resultText, errMsg, state, next)
	markMetaResult(id, status, duration, errMsg, next)
	// 每完成一次执行递增序号：前端以它作为「有新执行」的信号做自动刷新
	stateMu.Lock()
	runSeq++
	lastRunAt = finished
	stateMu.Unlock()
	return resultText, runErr
}

// mustSchedule 解析节点触发器，失败时返回空 Schedule（用于计算下次执行时间）。
func mustSchedule(rec gdb.Record) *Schedule {
	s, err := ParseSchedule(rec["trigger"].String(), rec["trigger_args"].String(),
		rec["start_date"].String(), rec["end_date"].String())
	if err != nil {
		return &Schedule{}
	}
	return s
}

// nextAfterRun 计算本次执行之后的下次执行时间；一次性任务返回零值。
func nextAfterRun(rec gdb.Record, from time.Time) time.Time {
	s := mustSchedule(rec)
	if s.OneShot {
		return time.Time{}
	}
	next, ok := NextRun(s, from)
	if !ok {
		return time.Time{}
	}
	return next
}

// buildJobState 生成 Go 版执行上下文（task_job.job_state）。
func buildJobState(rec gdb.Record, task *Task, triggerType, pattern string, started, finished time.Time, duration int64, result, errMsg string, next time.Time) string {
	state := g.Map{
		"version":     2,
		"node":        g.Map{"id": task.NodeID, "code": task.Code, "name": task.NodeName},
		"handler":     strings.TrimSpace(rec["func"].String()),
		"trigger":     triggerType,
		"pattern":     pattern,
		"args":        task.Args,
		"kwargs":      task.Kwargs,
		"started_at":  started.Format(time.DateTime),
		"finished_at": finished.Format(time.DateTime),
		"duration_ms": duration,
		"result":      Truncate(result, 1024),
		"error":       errMsg,
	}
	if !next.IsZero() {
		state["next_run_time"] = next.Format(time.DateTime)
	}
	b, err := json.Marshal(state)
	if err != nil {
		return ""
	}
	return string(b)
}

// ---------------------------------------------------------------------------
// 运行态
// ---------------------------------------------------------------------------

func markMetaRunning(id string, running bool) {
	stateMu.Lock()
	defer stateMu.Unlock()
	m := metas[id]
	if m == nil {
		return
	}
	if running {
		m.Running++
		m.LastRunTime = time.Now()
	} else if m.Running > 0 {
		m.Running--
	}
}

func markMetaResult(id string, status int, duration int64, errMsg string, next time.Time) {
	stateMu.Lock()
	defer stateMu.Unlock()
	m := metas[id]
	if m == nil {
		return
	}
	m.LastStatus = status
	m.LastDuration = duration
	m.LastError = errMsg
	m.NextRunTime = next
	switch status {
	case 2:
		m.FailCount = 0
	case 3, 4:
		m.FailCount++
	}
}

// runtimeOf 返回节点的派生运行态，供列表/详情接口合并输出。
func runtimeOf(nodeID int, dbStatus int) g.Map {
	now := time.Now()
	stateMu.Lock()
	sched := schedState
	var snap *jobMeta
	if m := metas[strconv.Itoa(nodeID)]; m != nil {
		copyMeta := *m
		snap = &copyMeta
	}
	stateMu.Unlock()

	out := g.Map{
		"next_run_time":       "",
		"last_run_time":       "",
		"last_status":         nil,
		"last_duration_ms":    nil,
		"fail_count":          0,
		"last_error":          "",
		"running":             false,
		"supported":           true,
		"scheduler_state":     sched,
		"runtime_status":      "waiting",
		"runtime_status_text": "等待执行",
	}
	if dbStatus != 0 {
		out["runtime_status"] = "disabled"
		out["runtime_status_text"] = "停用"
		return out
	}
	if snap == nil {
		out["supported"] = false
		out["runtime_status"] = "unregistered"
		out["runtime_status_text"] = "未注册"
		return out
	}
	if snap.Unsupported != "" {
		out["supported"] = false
		out["unsupported_reason"] = snap.Unsupported
		if snap.Unsupported == unsupportedNoTrigger {
			out["runtime_status"] = "unconfigured"
			out["runtime_status_text"] = "未配置触发器"
		} else {
			out["runtime_status"] = "unsupported"
			out["runtime_status_text"] = "未支持类型"
		}
		return out
	}
	// 下次执行时间按「当前时刻」重算：注册时的缓存值在任务停摆/进程重启后会变成过去时间。
	if next := nextRunOf(snap, now); !next.IsZero() {
		out["next_run_time"] = next.Format(time.DateTime)
	}
	if !snap.LastRunTime.IsZero() {
		out["last_run_time"] = snap.LastRunTime.Format(time.DateTime)
		out["last_status"] = snap.LastStatus
	}
	out["last_duration_ms"] = snap.LastDuration
	out["fail_count"] = snap.FailCount
	out["last_error"] = snap.LastError
	out["running"] = snap.Running > 0
	switch {
	case snap.Running > 0:
		out["runtime_status"] = "running"
		out["runtime_status_text"] = "运行中"
	case snap.LastStatus == 2:
		out["runtime_status"] = "success"
		out["runtime_status_text"] = "成功"
	case snap.LastStatus == 3 || snap.LastStatus == 4 || snap.LastStatus == 5:
		out["runtime_status"] = "failed"
		out["runtime_status_text"] = "失败"
	case snap.Paused:
		out["runtime_status"] = "paused"
		out["runtime_status_text"] = "已暂停"
	}
	return out
}

// syncNode 在节点被新建/修改/删除后同步单个节点进调度器。
func syncNode(ctx context.Context, nodeID int, deleted bool) {
	if nodeID <= 0 {
		return
	}
	id := strconv.Itoa(nodeID)
	stateMu.Lock()
	defer stateMu.Unlock()
	if schedState == "停止" {
		return
	}
	stopMeta(id)
	delete(metas, id)
	if deleted {
		return
	}
	rec, err := dao.NodeModel().Ctx(ctx).Where("id", nodeID).One()
	if err != nil || rec.IsEmpty() || rec["status"].Int() != 0 {
		return
	}
	m := buildMeta(rec)
	if m == nil {
		return
	}
	metas[id] = m
	registerMeta(ctx, m)
}

// resyncAll 全量重建（批量启停、清空后使用）。
func resyncAll(ctx context.Context) {
	if err := syncFromDB(ctx); err != nil {
		logConsole("sync fail " + err.Error())
	}
}

// ---------------------------------------------------------------------------
// HTTP 接口
// ---------------------------------------------------------------------------

// StatusSnapshot 返回调度器状态快照，供启动自检等内部逻辑使用。
func StatusSnapshot() g.Map {
	stateMu.Lock()
	defer stateMu.Unlock()
	active := 0
	for _, m := range metas {
		if m.Unsupported == "" && !m.Paused {
			active++
		}
	}
	return g.Map{
		"status":       schedState,
		"is_running":   schedState == "运行中",
		"job_count":    len(metas),
		"active_count": active,
		// 前端用 run_seq 判断调度器是否有新执行，从而自动刷新列表
		"run_seq":     runSeq,
		"last_run_at": fmtTime(lastRunAt),
	}
}

func SchedulerStatus(r *ghttp.Request) (interface{}, error) {
	return StatusSnapshot(), nil
}

func SchedulerJobs(r *ghttp.Request) (interface{}, error) {
	stateMu.Lock()
	items := make([]*jobMeta, 0, len(metas))
	for _, m := range metas {
		copyMeta := *m
		items = append(items, &copyMeta)
	}
	sched := schedState
	stateMu.Unlock()

	sort.Slice(items, func(i, j int) bool { return parseInt(items[i].ID) < parseInt(items[j].ID) })
	now := time.Now()
	out := make([]g.Map, 0, len(items))
	for _, m := range items {
		// status 语义与前端保持一致：0=运行中 1=暂停中 2=已停止
		status, label := 0, "运行中"
		switch {
		case sched == "停止":
			status, label = 2, "已停止"
		case m.Unsupported != "":
			status, label = 1, Shorten(m.Unsupported, 24)
		case m.Paused || sched == "暂停":
			status, label = 1, "暂停中"
		case m.Running > 0:
			status, label = 0, "执行中"
		case m.LastStatus == 3 || m.LastStatus == 4:
			status, label = 1, "上次失败"
		}
		out = append(out, g.Map{
			"id":                 m.ID,
			"name":               m.Name,
			"handler":            m.Handler,
			"trigger":            triggerLabel(m),
			"next_run_time":      fmtTime(nextRunOf(m, now)),
			"status":             status,
			"status_text":        label,
			"running":            m.Running > 0,
			"fail_count":         m.FailCount,
			"last_run_time":      fmtTime(m.LastRunTime),
			"last_error":         m.LastError,
			"unsupported_reason": m.Unsupported,
		})
	}
	// 进程重启后内存里的最近执行会丢失，用执行日志补齐
	lastRuns := make([]map[string]interface{}, 0, len(out))
	for _, item := range out {
		lastRuns = append(lastRuns, item)
	}
	fillLastRuns(r.Context(), lastRuns)
	return out, nil
}

// nextRunOf 计算下次执行时间：一次性任务取配置时间，周期任务按当前时刻重算，
// 避免展示注册时缓存下来的、已经过去的时间。
// @every（N秒/N分钟/N小时、时间间隔触发器）以注册时刻为锚点推进，不会随查询时间滑动。
func nextRunOf(m *jobMeta, now time.Time) time.Time {
	if m == nil || m.Unsupported != "" {
		return time.Time{}
	}
	if m.OneShot {
		if m.RunAt.After(now) {
			return m.RunAt
		}
		return time.Time{}
	}
	if strings.HasPrefix(m.Pattern, "@every ") {
		if next, ok := NextEveryRun(m.Pattern, m.RegisteredAt, now); ok {
			return next
		}
		return time.Time{}
	}
	if next, ok := NextRun(scheduleOf(m), now); ok {
		return next
	}
	return time.Time{}
}

func triggerLabel(m *jobMeta) string {
	if m.Unsupported != "" {
		return Shorten(m.Unsupported, 32)
	}
	if m.OneShot {
		return "date[" + m.RunAt.Format(time.DateTime) + "]"
	}
	if strings.HasPrefix(m.Pattern, "@every") {
		return "interval[" + m.Pattern + "]"
	}
	return "cron[" + m.Pattern + "]"
}

func fmtTime(t time.Time) string {
	if t.IsZero() {
		return ""
	}
	return t.Format(time.DateTime)
}

func StartScheduler(r *ghttp.Request) (interface{}, error) {
	if err := startScheduler(r.Context()); err != nil {
		return nil, err
	}
	return g.Map{"ok": true}, nil
}

func PauseScheduler(r *ghttp.Request) (interface{}, error) {
	stateMu.Lock()
	defer stateMu.Unlock()
	gcron.Stop()
	schedState = "暂停"
	logConsole("scheduler pause")
	return g.Map{"ok": true}, nil
}

func ResumeScheduler(r *ghttp.Request) (interface{}, error) {
	stateMu.Lock()
	empty := len(metas) == 0
	stateMu.Unlock()
	if empty {
		return StartScheduler(r)
	}
	stateMu.Lock()
	gcron.Start()
	schedState = "运行中"
	stateMu.Unlock()
	logConsole("scheduler resume")
	return g.Map{"ok": true}, nil
}

func ShutdownScheduler(r *ghttp.Request) (interface{}, error) {
	stateMu.Lock()
	defer stateMu.Unlock()
	stopEntries()
	metas = map[string]*jobMeta{}
	gcron.Stop()
	schedState = "停止"
	logConsole("scheduler shutdown")
	return g.Map{"ok": true}, nil
}

func ClearJobs(r *ghttp.Request) (interface{}, error) {
	stateMu.Lock()
	defer stateMu.Unlock()
	stopEntries()
	metas = map[string]*jobMeta{}
	logConsole("scheduler clear")
	return g.Map{"ok": true}, nil
}

func SchedulerConsole(r *ghttp.Request) (interface{}, error) {
	schedMu.Lock()
	defer schedMu.Unlock()
	return strings.Join(consoleBuf, "\n"), nil
}

func SyncJobs(r *ghttp.Request) (interface{}, error) {
	if err := syncFromDB(r.Context()); err != nil {
		return nil, err
	}
	stateMu.Lock()
	n := len(metas)
	stateMu.Unlock()
	return n, nil
}

func TaskPause(r *ghttp.Request) (interface{}, error) {
	id := r.Get("jobId").String()
	stateMu.Lock()
	if m := metas[id]; m != nil {
		m.Paused = true
	}
	gcron.Stop(id)
	stateMu.Unlock()
	logConsole("pause " + id)
	return g.Map{}, nil
}

func TaskResume(r *ghttp.Request) (interface{}, error) {
	id := r.Get("jobId").String()
	rec, err := dao.NodeModel().Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return g.Map{}, err
	}
	stateMu.Lock()
	if schedState == "停止" {
		stateMu.Unlock()
		return g.Map{}, nil
	}
	m := metas[id]
	if m == nil {
		m = buildMeta(rec)
		metas[id] = m
		registerMeta(r.Context(), m)
	}
	if m.Unsupported != "" {
		reason := m.Unsupported
		stateMu.Unlock()
		return nil, biz.Bad(reason)
	}
	m.Paused = false
	paused := schedState == "暂停"
	if paused {
		schedState = "运行中"
	}
	stateMu.Unlock()

	if paused {
		gcron.Start()
	} else {
		gcron.Start(id)
	}
	logConsole("resume " + id)
	return g.Map{}, nil
}

func TaskRun(r *ghttp.Request) (interface{}, error) {
	id := r.Get("jobId").String()
	nodeID := parseInt(id)
	if rec, err := dao.NodeModel().Where("id", nodeID).One(); err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("节点不存在")
	}
	result, runErr := runNodeOnce(r.Context(), nodeID, TriggerManual, "", time.Now())
	if runErr != nil {
		logConsole("fail " + id + " " + runErr.Error())
		return nil, biz.Bad(runErr.Error())
	}
	logConsole("run " + id)
	return g.Map{"result": result}, nil
}

func TaskRemove(r *ghttp.Request) (interface{}, error) {
	id := r.Get("jobId").String()
	stateMu.Lock()
	stopMeta(id)
	delete(metas, id)
	stateMu.Unlock()
	logConsole("remove " + id)
	return g.Map{}, nil
}
