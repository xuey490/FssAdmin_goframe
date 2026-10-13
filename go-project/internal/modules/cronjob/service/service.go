package service

import (
	"context"
	"encoding/json"
	"strings"
	"sync"
	"time"

	"fssadmin/go-project/internal/modules/cronjob/dao"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/crud"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
	"github.com/gogf/gf/v2/util/guid"
)

// nodeSpec：存储器/执行器是 APScheduler 概念，Go 侧不使用，故不在 Allow 中。
var nodeSpec = crud.Spec{
	Table:  dao.NodeTable,
	Tenant: true,
	Like:   []string{"name", "code"},
	Allow: []string{
		"name", "code", "trigger", "trigger_args", "func", "args", "kwargs",
		"coalesce", "max_instances", "start_date", "end_date", "status", "description",
	},
}

var (
	schedMu    sync.Mutex
	consoleBuf []string
)

// logConsole 记录调度器控制台事件（环形缓冲，最多 200 条）。
func logConsole(s string) {
	schedMu.Lock()
	defer schedMu.Unlock()
	consoleBuf = append(consoleBuf, time.Now().Format("15:04:05")+" "+s)
	if len(consoleBuf) > 200 {
		consoleBuf = consoleBuf[len(consoleBuf)-200:]
	}
}

// ---------------------------------------------------------------------------
// 任务类型字典
// ---------------------------------------------------------------------------

// NodeTypes 返回可用的任务类型与参数规格，供前端动态渲染表单。
func NodeTypes(r *ghttp.Request) (interface{}, error) {
	return g.Map{
		"handlers": AllHandlers(),
		"triggers": []g.Map{
			{"value": "", "label": "不启用", "hint": "仅保存定义，不参与调度"},
			{"value": TriggerCron, "label": "Cron 表达式", "hint": "支持 5~7 段（秒 分 时 日 月 周），如 0 0 2 * * *"},
			{"value": TriggerInterval, "label": "时间间隔", "hint": "5 段：秒 分 时 天 周，如 0 5 0 0 0（每 5 分钟）"},
			{"value": TriggerDate, "label": "固定日期", "hint": "一次性执行，如 2026-01-01 08:00:00"},
		},
		"runtime_status": []g.Map{
			{"value": "waiting", "label": "等待执行", "type": "info"},
			{"value": "running", "label": "运行中", "type": "primary"},
			{"value": "success", "label": "成功", "type": "success"},
			{"value": "failed", "label": "失败", "type": "danger"},
			{"value": "paused", "label": "已暂停", "type": "warning"},
			{"value": "disabled", "label": "停用", "type": "info"},
			{"value": "unconfigured", "label": "未配置触发器", "type": "warning"},
			{"value": "unsupported", "label": "未支持类型", "type": "danger"},
			{"value": "unregistered", "label": "未注册", "type": "warning"},
		},
	}, nil
}

// ---------------------------------------------------------------------------
// 节点 CRUD
// ---------------------------------------------------------------------------

func Options(r *ghttp.Request) (interface{}, error) {
	rows, err := dao.NodeModel().Fields("id,name,code,func,args,kwargs").All()
	if err != nil {
		return nil, err
	}
	return dbx.ToMaps(rows), nil
}

func NodeList(r *ghttp.Request) (interface{}, error) {
	pg, limit := page.Parse(r)
	m := dao.NodeModel()
	q := reqx.Merge(r)
	m = dbx.FilterLike(m, "name", reqx.Str(q, "name"))
	m = dbx.FilterLike(m, "code", reqx.Str(q, "code"))
	if fn := reqx.Str(q, "func"); fn != "" {
		m = m.Where("func", fn)
	}
	if st := reqx.Str(q, "status"); st != "" {
		m = m.Where("status", st)
	}
	total, _ := m.Clone().Count()
	rows, err := m.Order("id desc").Page(pg, limit).All()
	if err != nil {
		return nil, err
	}
	items := dbx.ToMaps(rows)
	for _, item := range items {
		mergeRuntime(item)
	}
	fillLastRuns(r.Context(), items)
	return response.PageNo(items, total, pg, limit), nil
}

func NodeDetail(r *ghttp.Request) (interface{}, error) {
	data, err := nodeSpec.Detail(r)
	if err != nil {
		return nil, err
	}
	if item, ok := data.(map[string]interface{}); ok {
		mergeRuntime(item)
		fillLastRuns(r.Context(), []map[string]interface{}{item})
	}
	return data, nil
}

// fillLastRuns 用 task_job 中最近一条执行记录补齐内存里没有的「最近执行」信息。
// 调度器状态在进程内，重启后会清空；这里回落到执行日志，列表不会再显示成「从未执行」。
// 采用一次批量查询，避免逐行查库。
func fillLastRuns(ctx context.Context, items []map[string]interface{}) {
	ids := make([]string, 0, len(items))
	pending := make(map[string]map[string]interface{}, len(items))
	for _, it := range items {
		if it == nil || it["last_status"] != nil {
			continue
		}
		id := gconv.String(it["id"])
		if id == "" || id == "0" {
			continue
		}
		ids = append(ids, id)
		pending[id] = it
	}
	if len(ids) == 0 {
		return
	}
	rows, err := g.DB().Model(dao.JobTable).Ctx(ctx).
		WhereIn("job_id", ids).WhereNull("delete_time").
		Fields("job_id,status,error,result,job_state,create_time").
		Order("id desc").All()
	if err != nil {
		g.Log().Warningf(ctx, "cronjob: 读取最近执行记录失败: %v", err)
		return
	}
	for _, rec := range rows {
		jobID := rec["job_id"].String()
		it := pending[jobID]
		if it == nil {
			continue
		}
		// 已按 id desc 排序，每个节点取第一条即最近一次
		delete(pending, jobID)
		status := rec["status"].Int()
		it["last_run_time"] = rec["create_time"].String()
		it["last_status"] = status
		it["last_error"] = rec["error"].String()
		if raw := rec["job_state"].String(); raw != "" {
			var state struct {
				DurationMs int64 `json:"duration_ms"`
			}
			if json.Unmarshal([]byte(raw), &state) == nil && state.DurationMs > 0 {
				it["last_duration_ms"] = state.DurationMs
			}
		}
		if it["runtime_status"] != "waiting" {
			continue
		}
		switch {
		case status == 1:
			it["runtime_status"], it["runtime_status_text"] = "running", "执行中"
		case status == 2:
			it["runtime_status"], it["runtime_status_text"] = "success", "成功"
		case status >= 3:
			it["runtime_status"], it["runtime_status_text"] = "failed", "失败"
		}
	}
}

// mergeRuntime 把内存运行态合并进节点记录，供列表/详情展示。
func mergeRuntime(item map[string]interface{}) {
	if item == nil {
		return
	}
	dbStatus := gconv.Int(item["status"])
	for k, v := range runtimeOf(gconv.Int(item["id"]), dbStatus) {
		item[k] = v
	}
	handler := strings.TrimSpace(gconv.String(item["func"]))
	if h, ok := GetHandler(handler); ok {
		item["handler_title"] = h.Title
		item["handler_enabled"] = h.Enabled
	} else {
		item["handler_title"] = "未支持类型"
		item["handler_enabled"] = false
	}
	item["trigger_type"] = strings.TrimSpace(gconv.String(item["trigger"]))
}

func validateNodePayload(m g.Map, requireName bool) (string, error) {
	if requireName && reqx.Str(m, "name") == "" {
		return "", biz.Bad("节点名称不能为空")
	}
	handler := strings.TrimSpace(reqx.Str(m, "func"))
	if handler == "" {
		return "", biz.Bad("请选择任务类型")
	}
	if _, ok := GetHandler(handler); !ok {
		return "", biz.Bad("未支持的任务类型：" + handler)
	}
	trigger := strings.ToLower(strings.TrimSpace(reqx.Str(m, "trigger")))
	if trigger != "" {
		if _, err := ParseSchedule(trigger, reqx.Str(m, "trigger_args"),
			reqx.Str(m, "start_date"), reqx.Str(m, "end_date")); err != nil {
			return "", biz.Bad(err.Error())
		}
	}
	return trigger, nil
}

func NodeCreate(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	if reqx.Str(m, "name") == "" {
		return nil, biz.Bad("节点名称不能为空")
	}
	if reqx.Str(m, "code") == "" {
		return nil, biz.Bad("节点编码不能为空")
	}
	if _, err := validateNodePayload(m, true); err != nil {
		return nil, err
	}
	code := reqx.Str(m, "code")
	exist, _ := dao.NodeModel().Where("code", code).One()
	if !exist.IsEmpty() {
		return nil, biz.Bad("创建失败，该节点编码已存在")
	}

	u := ctxuser.Get(r)
	tid := 1
	if u != nil && u.TenantID > 0 {
		tid = u.TenantID
	}
	data := g.Map{
		"name": reqx.Str(m, "name"), "code": code,
		"trigger":      strings.ToLower(strings.TrimSpace(reqx.Str(m, "trigger"))),
		"trigger_args": reqx.Str(m, "trigger_args"),
		"func":         reqx.Str(m, "func"), "args": reqx.Str(m, "args"), "kwargs": reqx.Str(m, "kwargs"),
		"coalesce": reqx.Int(m, "coalesce"), "max_instances": reqx.Int(m, "max_instances"),
		"start_date": reqx.Str(m, "start_date"), "end_date": reqx.Str(m, "end_date"),
		"status":      reqx.Int(m, "status"),
		"description": reqx.Str(m, "description"), "uuid": guid.S(),
		"create_time": dbx.Now(), "update_time": dbx.Now(), "tenant_id": tid,
	}
	if data["max_instances"] == 0 {
		data["max_instances"] = 1
	}
	if u != nil {
		data["created_by"] = u.ID
	}
	id, err := dbx.Model(dao.NodeTable).Data(data).InsertAndGetId()
	if err != nil {
		return nil, err
	}
	syncNode(r.Context(), int(id), false)
	logConsole("create node " + reqx.Str(m, "name"))
	rec, _ := dao.NodeModel().Where("id", id).One()
	out := dbx.ToMap(rec)
	mergeRuntime(out)
	return out, nil
}

func NodeUpdate(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	rec, err := dao.NodeModel().Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("节点不存在")
	}
	m := reqx.Merge(r)
	if _, err := validateNodePayload(m, false); err != nil {
		return nil, err
	}
	data := g.Map{"update_time": dbx.Now()}
	if u := ctxuser.Get(r); u != nil {
		data["updated_by"] = u.ID
	}
	for _, k := range nodeSpec.Allow {
		if v, ok := m[k]; ok {
			data[k] = v
		}
	}
	if v, ok := data["trigger"]; ok {
		data["trigger"] = strings.ToLower(strings.TrimSpace(gconv.String(v)))
	}
	if _, err := dao.NodeModel().Where("id", id).Data(data).Update(); err != nil {
		return nil, err
	}
	syncNode(r.Context(), id, false)
	logConsole("update node " + rec["name"].String())
	cur, _ := dao.NodeModel().Where("id", id).One()
	out := dbx.ToMap(cur)
	mergeRuntime(out)
	return out, nil
}

func NodeDelete(r *ghttp.Request) (interface{}, error) {
	ids := reqx.Ints(reqx.Merge(r), "ids")
	if len(ids) == 0 {
		return g.Map{}, nil
	}
	if err := dbx.SoftDeleteIDsScopedRequest(r, dao.NodeTable, ids); err != nil {
		return nil, err
	}
	for _, id := range ids {
		syncNode(r.Context(), id, true)
	}
	logConsole("delete node " + gconv.String(ids))
	return g.Map{}, nil
}

func NodeClear(r *ghttp.Request) (interface{}, error) {
	if _, err := dao.NodeModel().Data(g.Map{"delete_time": dbx.Now()}).Update(); err != nil {
		return nil, err
	}
	resyncAll(r.Context())
	logConsole("clear nodes")
	return g.Map{}, nil
}

func NodeBatch(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	ids := reqx.Ints(m, "ids")
	st := reqx.Int(m, "status")
	if len(ids) == 0 {
		return g.Map{}, biz.Bad("请选择要操作的数据")
	}
	if _, err := dao.NodeModel().WhereIn("id", ids).
		Data(g.Map{"status": st, "update_time": dbx.Now()}).Update(); err != nil {
		return nil, err
	}
	resyncAll(r.Context())
	logConsole("batch status " + gconv.String(ids) + " -> " + gconv.String(st))
	return g.Map{}, nil
}

// ---------------------------------------------------------------------------
// 调试 / 注册
// ---------------------------------------------------------------------------

// NodeExecute 调试节点：
//   - now：立即执行一次并写日志；
//   - cron / interval / date：把该节点注册（或覆盖）进调度器长期运行，
//     同时把触发器写回节点并置为启用，保证进程重启后仍按此触发器注册。
func NodeExecute(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	rec, err := dao.NodeModel().Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("节点不存在")
	}
	m := reqx.Merge(r)
	trigger := strings.ToLower(strings.TrimSpace(reqx.Str(m, "trigger")))
	if trigger == "" {
		trigger = TriggerNow
	}
	if trigger == TriggerNow {
		result, runErr := runNodeOnce(r.Context(), id, TriggerManual, "", time.Now())
		if runErr != nil {
			return nil, biz.Bad(runErr.Error())
		}
		logConsole("execute node " + rec["name"].String())
		return g.Map{
			"job_id": id, "status": 2, "trigger": TriggerNow, "result": result,
		}, nil
	}

	triggerArgs := reqx.Str(m, "trigger_args")
	startDate := reqx.Str(m, "start_date")
	endDate := reqx.Str(m, "end_date")
	sched, err := ParseSchedule(trigger, triggerArgs, startDate, endDate)
	if err != nil {
		return nil, biz.Bad(err.Error())
	}
	if sched.OneShot && !sched.RunAt.After(time.Now()) {
		return nil, biz.Bad("执行时间必须晚于当前时间")
	}
	handler := strings.TrimSpace(rec["func"].String())
	if _, ok := GetHandler(handler); !ok {
		return nil, biz.Bad("未支持的任务类型：" + handler + "，请先修改节点选择内置任务类型")
	}

	if _, err := dao.NodeModel().Where("id", id).Data(g.Map{
		"trigger": trigger, "trigger_args": triggerArgs,
		"start_date": startDate, "end_date": endDate,
		"status": 0, "update_time": dbx.Now(),
	}).Update(); err != nil {
		return nil, err
	}
	syncNode(r.Context(), id, false)
	logConsole("register node " + rec["name"].String() + " " + sched.Label())

	next, _ := NextRun(sched, time.Now())
	out := g.Map{
		"job_id": id, "status": 1, "trigger": trigger, "registered": true,
		"node_status": 0, "trigger_label": sched.Label(), "node_display_name": rec["name"].String(),
	}
	if !next.IsZero() {
		out["next_run_time"] = next.Format(time.DateTime)
	}
	return out, nil
}

// ---------------------------------------------------------------------------
// 执行日志（task_job）
// ---------------------------------------------------------------------------

// openJobLog 插入「执行中」日志，返回日志主键（失败返回 0 并记录原因）。
func openJobLog(ctx context.Context, nodeID int, name, triggerType, pattern string, plannedAt time.Time,
	rec gdb.Record, task *Task, started time.Time) int64 {
	tenantID := 1
	if rec != nil && rec["tenant_id"].Int() > 0 {
		tenantID = rec["tenant_id"].Int()
	}
	state := g.Map{
		"version": 2,
		"node":    g.Map{"id": nodeID, "code": task.Code, "name": task.NodeName},
		"handler": strings.TrimSpace(rec["func"].String()),
		"trigger": triggerType, "pattern": pattern,
		"args": task.Args, "kwargs": task.Kwargs,
		"started_at": started.Format(time.DateTime),
	}
	raw, _ := json.Marshal(state)
	jobID, err := dbx.Model(dao.JobTable).Data(g.Map{
		"job_id": gconv.String(nodeID), "job_name": name, "trigger_type": triggerType,
		"status": 1, "next_run_time": fmtTime(plannedAt), "job_state": string(raw),
		"uuid": guid.S(), "create_time": dbx.Now(), "update_time": dbx.Now(), "tenant_id": tenantID,
	}).InsertAndGetId()
	if err != nil {
		g.Log().Warningf(ctx, "cronjob: 写入执行日志失败 node=%d: %v", nodeID, err)
		logConsole("joblog fail node=" + gconv.String(nodeID) + " " + err.Error())
		return 0
	}
	return jobID
}

// finishJobLog 把日志更新为完成态。
func finishJobLog(logID int64, status int, result, errMsg, jobState string, next time.Time) {
	if logID <= 0 {
		return
	}
	_, _ = dbx.Model(dao.JobTable).Where("id", logID).Data(g.Map{
		"status": status, "result": result, "error": errMsg,
		"job_state": jobState, "next_run_time": fmtTime(next), "update_time": dbx.Now(),
	}).Update()
}

func NodeLogs(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	pg, limit := page.Parse(r)
	q := reqx.Merge(r)
	m := dao.JobModel().Where("job_id", gconv.String(id))
	if st := reqx.Str(q, "status"); st != "" {
		m = m.Where("status", st)
	}
	if tt := reqx.Str(q, "trigger_type"); tt != "" {
		m = m.Where("trigger_type", tt)
	}
	total, _ := m.Clone().Count()
	rows, err := m.Order("id desc").Page(pg, limit).All()
	if err != nil {
		return nil, err
	}
	return response.PageNo(dbx.ToMaps(rows), total, pg, limit), nil
}

func JobLogList(r *ghttp.Request) (interface{}, error) {
	pg, limit := page.Parse(r)
	m := dao.JobModel()
	q := reqx.Merge(r)
	if jid := reqx.Str(q, "job_id"); jid != "" {
		m = m.Where("job_id", jid)
	}
	m = dbx.FilterLike(m, "job_name", reqx.Str(q, "job_name"))
	if st := reqx.Str(q, "status"); st != "" {
		m = m.Where("status", st)
	}
	if tt := reqx.Str(q, "trigger_type"); tt != "" {
		m = m.Where("trigger_type", tt)
	}
	total, _ := m.Clone().Count()
	rows, err := m.Order("id desc").Page(pg, limit).All()
	if err != nil {
		return nil, err
	}
	return response.PageNo(dbx.ToMaps(rows), total, pg, limit), nil
}

func JobLogDetail(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	rec, err := dao.JobModel().Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("记录不存在")
	}
	return dbx.ToMap(rec), nil
}

func JobLogDelete(r *ghttp.Request) (interface{}, error) {
	ids := reqx.Ints(reqx.Merge(r), "ids")
	return g.Map{}, dbx.SoftDeleteIDs(dao.JobTable, ids)
}
