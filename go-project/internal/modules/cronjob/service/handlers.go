package service

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	"runtime"
	"sort"
	"strings"
	"time"
	"unicode/utf8"

	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/util/gconv"
)

// maxOutputLen 单次执行写入日志的最大输出长度，避免把库写爆。
const maxOutputLen = 4096

var (
	// ErrHandlerTimeout 任务执行超时（映射 task_job.status=4）。
	ErrHandlerTimeout = errors.New("任务执行超时")
	// ErrUnknownHandler 未注册的任务类型（通常是 Python 遗留的 func）。
	ErrUnknownHandler = errors.New("未支持的任务类型")
)

// ParamSpec 描述一个任务参数，同时是 GET /task/cronjob/node/types 的返回契约。
type ParamSpec struct {
	Name     string `json:"name"`
	Title    string `json:"title"`
	Type     string `json:"type"` // string|text|number|bool|json|select
	Required bool   `json:"required"`
	Default  any    `json:"default"`
	Options  []any  `json:"options,omitempty"` // type=select 时的候选值
	Help     string `json:"help,omitempty"`
}

// Task 是 handler 的执行上下文，由调度器在触发时构造。
type Task struct {
	NodeID   int
	NodeName string
	Code     string
	Trigger  string
	LogID    int64
	Args     []string
	Kwargs   map[string]interface{}
}

func (t *Task) Str(key string) string {
	if t == nil || t.Kwargs == nil {
		return ""
	}
	v, ok := t.Kwargs[key]
	if !ok || v == nil {
		return ""
	}
	if s, ok := v.(string); ok {
		return strings.TrimSpace(s)
	}
	return strings.TrimSpace(gconv.String(v))
}

func (t *Task) Int(key string, def int) int {
	if s := t.Str(key); s != "" {
		return gconv.Int(s)
	}
	return def
}

func (t *Task) Bool(key string, def bool) bool {
	if s := t.Str(key); s != "" {
		return gconv.Bool(s)
	}
	return def
}

// Map 取对象型参数，前端传 JSON 字符串或 JSON 对象都能识别。
func (t *Task) Map(key string) map[string]interface{} {
	if t == nil || t.Kwargs == nil {
		return nil
	}
	v, ok := t.Kwargs[key]
	if !ok || v == nil {
		return nil
	}
	switch m := v.(type) {
	case map[string]interface{}:
		return m
	case string:
		return ParseKwargs(m)
	default:
		return ParseKwargs(TextOrJSON(v))
	}
}

// Timeout 取 kwargs.timeout（秒），未配置时用 def。
func (t *Task) Timeout(def time.Duration) time.Duration {
	if sec := t.Int("timeout", 0); sec > 0 {
		return time.Duration(sec) * time.Second
	}
	return def
}

// Handler 是一个可被定时任务节点引用的任务类型。
// Enabled 是运行期计算的输出字段（见 resolveEnabled），注册时不必填写。
type Handler struct {
	Name          string      `json:"name"`
	Title         string      `json:"title"`
	Category      string      `json:"category"`
	Description   string      `json:"description"`
	NeedsRoot     bool        `json:"needs_root"`
	Params        []ParamSpec `json:"params"`
	DefaultSecond int         `json:"default_timeout_second"`
	Enabled       bool        `json:"enabled"`
	DisabledHint  string      `json:"disabled_hint,omitempty"`

	// Disabled / gate 为运行期开关，不参与序列化。
	// gate 在每次读取时求值，确保读到的是已加载的配置（不能在 init 里读配置）。
	Disabled bool                                                    `json:"-"`
	gate     func() bool                                             `json:"-"`
	run      func(ctx context.Context, t *Task) (interface{}, error) `json:"-"`
}

func (h Handler) resolveEnabled() bool {
	if h.Disabled {
		return false
	}
	if h.gate != nil {
		return h.gate()
	}
	return true
}

// Timeout 返回默认超时。
func (h Handler) Timeout() time.Duration {
	if h.DefaultSecond > 0 {
		return time.Duration(h.DefaultSecond) * time.Second
	}
	return 300 * time.Second
}

var handlerRegistry = map[string]Handler{}

// RegisterHandler 注册任务类型，同名覆盖。
func RegisterHandler(h Handler) { handlerRegistry[h.Name] = h }

// GetHandler 按名称取任务类型，Enabled 已按当前配置计算。
func GetHandler(name string) (Handler, bool) {
	h, ok := handlerRegistry[strings.TrimSpace(name)]
	if !ok {
		return Handler{}, false
	}
	h.Enabled = h.resolveEnabled()
	return h, true
}

// AllHandlers 返回全部任务类型（按分类、名称排序），供前端动态渲染参数表单。
func AllHandlers() []Handler {
	out := make([]Handler, 0, len(handlerRegistry))
	for _, h := range handlerRegistry {
		h.Enabled = h.resolveEnabled()
		out = append(out, h)
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].Category == out[j].Category {
			return out[i].Name < out[j].Name
		}
		return out[i].Category < out[j].Category
	})
	return out
}

// ExecuteHandler 统一执行入口：校验类型、按超时执行、兜底 panic。
func ExecuteHandler(ctx context.Context, name string, t *Task) (interface{}, error) {
	h, ok := GetHandler(name)
	if !ok {
		return nil, fmt.Errorf("%w：%s", ErrUnknownHandler, name)
	}
	if !h.Enabled {
		hint := h.DisabledHint
		if hint == "" {
			hint = "该任务类型已被禁用"
		}
		return nil, errors.New(hint)
	}
		timeout := t.Timeout(h.Timeout())
		// 手工执行挂在 HTTP ctx 上：浏览器一超时/关页就会 cancel，
		// 还原这种长任务会被掐断，连接也废了。超时只跟任务自己的 deadline 走。
		cctx, cancel := context.WithTimeout(context.WithoutCancel(ctx), timeout)
		defer cancel()

	type outcome struct {
		v   interface{}
		err error
	}
	// 缓冲 1：超时后 goroutine 仍可把结果/panic 送出而不阻塞。
	ch := make(chan outcome, 1)
	go func() {
		defer func() {
			if rec := recover(); rec != nil {
				ch <- outcome{nil, fmt.Errorf("任务执行 panic：%v", rec)}
			}
		}()
		v, err := h.run(cctx, t)
		ch <- outcome{v, err}
	}()

	select {
	case <-cctx.Done():
		if errors.Is(cctx.Err(), context.DeadlineExceeded) {
			return nil, fmt.Errorf("%w（超过 %s）", ErrHandlerTimeout, timeout)
		}
		return nil, cctx.Err()
	case o := <-ch:
		return o.v, o.err
	}
}

// IsTimeout 判断错误是否为超时。
func IsTimeout(err error) bool { return errors.Is(err, ErrHandlerTimeout) }

// IsUnknownHandler 判断错误是否为未注册的任务类型。
func IsUnknownHandler(err error) bool { return errors.Is(err, ErrUnknownHandler) }

// Truncate 按字节截断输出（保证不截断 UTF-8 字符），超出部分标注省略。
func Truncate(s string, limit int) string {
	if limit <= 0 {
		limit = maxOutputLen
	}
	if len(s) <= limit {
		return s
	}
	cut := s[:limit]
	for len(cut) > 0 && !utf8.ValidString(cut) {
		cut = cut[:len(cut)-1]
	}
	return cut + fmt.Sprintf("...(已截断，共 %d 字节)", len(s))
}

func resultOf(kind string, extra g.Map) g.Map {
	out := g.Map{"kind": kind, "ok": true}
	for k, v := range extra {
		out[k] = v
	}
	return out
}

func resultFail(kind string, extra g.Map) g.Map {
	out := resultOf(kind, extra)
	out["ok"] = false
	return out
}

// ---------------------------------------------------------------------------
// 内置任务类型
// ---------------------------------------------------------------------------

func init() { registerBuiltinHandlers() }

func registerBuiltinHandlers() {
	RegisterHandler(Handler{
		Name:          backupCode,
		Title:         "数据库备份",
		Category:      "系统维护",
		Description:   "导出当前数据库为 .sql.gz 备份文件，并清理超过保留天数的历史备份。",
		DefaultSecond: 900,
		Params: []ParamSpec{
			{Name: "dir", Title: "备份目录", Type: "string", Help: "留空使用配置项 app.backupDir"},
			{Name: "keep_days", Title: "保留天数", Type: "number", Default: 30, Help: "早于该天数的备份会被删除"},
			{Name: "timeout", Title: "超时(秒)", Type: "number", Default: 900},
		},
		run: func(ctx context.Context, t *Task) (interface{}, error) {
			dir := t.Str("dir")
			if dir == "" {
				dir = conf.BackupDir()
			}
			return backupTo(ctx, dir, t.Int("keep_days", 30))
		},
	})

	RegisterHandler(Handler{
		Name:          restoreCode,
		Title:         "数据库还原",
		Category:      "系统维护",
		Description:   "用 init.sql 覆盖当前数据库，并清空 Redis 缓存。用于演示环境定时重置，会删除现有业务数据。",
		NeedsRoot:     true,
		DefaultSecond: 600,
		Params: []ParamSpec{
			{Name: "file", Title: "还原脚本", Type: "string", Help: "留空使用配置项 app.restoreFile"},
			{Name: "flush_redis", Title: "清空 Redis", Type: "bool", Default: true, Help: "还原后 FLUSHDB 当前 Redis 库"},
			{Name: "timeout", Title: "超时(秒)", Type: "number", Default: 600},
		},
		run: func(ctx context.Context, t *Task) (interface{}, error) {
			file := t.Str("file")
			if file == "" {
				file = conf.RestoreFile()
			}
			return restoreTo(ctx, file, t.Bool("flush_redis", true))
		},
	})

	RegisterHandler(Handler{
		Name:          "log_cleanup",
		Title:         "日志清理",
		Category:      "系统维护",
		Description:   "软删除指定表中超过保留天数的历史日志。",
		DefaultSecond: 300,
		Params: []ParamSpec{
			{
				Name: "table", Title: "数据表", Type: "select", Required: true,
				Default: "sa_system_oper_log",
				Options: []any{"sa_system_oper_log", "sa_system_login_log", "task_job"},
				Help:    "仅允许清理日志类表",
			},
			{Name: "days", Title: "保留天数", Type: "number", Default: 30, Help: "早于该天数的记录会被软删除"},
			{Name: "timeout", Title: "超时(秒)", Type: "number", Default: 300},
		},
		run: logCleanupHandler,
	})

	RegisterHandler(Handler{
		Name:          "http_request",
		Title:         "HTTP 请求",
		Category:      "业务任务",
		Description:   "定时调用一个 HTTP 接口，可按响应状态码判定成功失败。",
		DefaultSecond: 60,
		Params: []ParamSpec{
			{Name: "url", Title: "请求地址", Type: "string", Required: true, Help: "http/https 完整地址"},
			{Name: "method", Title: "请求方法", Type: "select", Default: "GET", Options: []any{"GET", "POST", "PUT", "DELETE"}},
			{Name: "headers", Title: "请求头", Type: "json", Help: `JSON 对象，如 {"Authorization":"Bearer xxx"}`},
			{Name: "body", Title: "请求体", Type: "text"},
			{Name: "expect_status", Title: "期望状态码", Type: "number", Default: 200, Help: "填 0 表示不校验"},
			{Name: "timeout", Title: "超时(秒)", Type: "number", Default: 60},
		},
		run: httpRequestHandler,
	})

	RegisterHandler(Handler{
		Name:          "shell_command",
		Title:         "Shell 命令",
		Category:      "系统维护",
		Description:   "在服务器上执行 Shell 命令（Windows 走 cmd /C），输出截断保留 4KB。",
		NeedsRoot:     true,
		DefaultSecond: 300,
		DisabledHint:  "Shell 任务已禁用，请在 config.yaml 中设置 app.shellTaskEnable = true",
		gate:          conf.ShellTaskEnable,
		Params: []ParamSpec{
			{Name: "command", Title: "命令", Type: "text", Required: true, Help: "执行的命令，注意权限与副作用"},
			{Name: "workdir", Title: "工作目录", Type: "string", Help: "留空使用进程当前目录"},
			{Name: "timeout", Title: "超时(秒)", Type: "number", Default: 300},
		},
		run: shellCommandHandler,
	})
}

// logCleanupTables 允许清理的表白名单，避免表名被注入。
var logCleanupTables = map[string]string{
	"sa_system_oper_log":  "create_time",
	"sa_system_login_log": "create_time",
	"task_job":            "create_time",
}

func logCleanupHandler(ctx context.Context, t *Task) (interface{}, error) {
	table := t.Str("table")
	col, ok := logCleanupTables[table]
	if !ok {
		return nil, fmt.Errorf("不允许清理该表：%s", table)
	}
	days := t.Int("days", 30)
	if days <= 0 {
		return nil, errors.New("保留天数必须大于 0")
	}
	cutoff := dbx.Now().AddDate(0, 0, -days)
	res, err := dbx.Alive(dbx.Model(table)).Ctx(ctx).
		Where(col+" < ?", cutoff).
		Data(g.Map{"delete_time": dbx.Now()}).
		Update()
	if err != nil {
		return nil, err
	}
	affected, _ := res.RowsAffected()
	return resultOf("log_cleanup", g.Map{
		"table": table, "days": days, "deleted": affected,
		"cutoff": cutoff.Format("2006-01-02 15:04:05"),
	}), nil
}

func httpRequestHandler(ctx context.Context, t *Task) (interface{}, error) {
	url := t.Str("url")
	if url == "" {
		return nil, errors.New("缺少请求地址 url")
	}
	if !strings.HasPrefix(url, "http://") && !strings.HasPrefix(url, "https://") {
		return nil, errors.New("请求地址必须以 http:// 或 https:// 开头")
	}
	method := strings.ToUpper(t.Str("method"))
	if method == "" {
		method = http.MethodGet
	}
	var body io.Reader
	if raw := t.Str("body"); raw != "" {
		body = strings.NewReader(raw)
	}
	req, err := http.NewRequestWithContext(ctx, method, url, body)
	if err != nil {
		return nil, err
	}
	for k, v := range t.Map("headers") {
		req.Header.Set(k, gconv.String(v))
	}
	if req.Header.Get("Content-Type") == "" && body != nil {
		req.Header.Set("Content-Type", "application/json")
	}
	resp, err := (&http.Client{}).Do(req)
	if err != nil {
		if ctx.Err() != nil {
			return nil, fmt.Errorf("请求失败：%v", ctx.Err())
		}
		return nil, fmt.Errorf("请求失败：%v", err)
	}
	defer func() { _ = resp.Body.Close() }()
	raw, readErr := io.ReadAll(io.LimitReader(resp.Body, maxOutputLen))
	out := resultOf("http_request", g.Map{
		"status": resp.StatusCode, "body": Truncate(string(raw), maxOutputLen),
	})
	if readErr != nil && readErr != io.EOF {
		out = resultFail("http_request", g.Map{"status": resp.StatusCode, "body": Truncate(string(raw), maxOutputLen)})
		return out, fmt.Errorf("读取响应失败：%v", readErr)
	}
	expect := t.Int("expect_status", 200)
	if expect > 0 && resp.StatusCode != expect {
		out["ok"] = false
		return out, fmt.Errorf("响应状态码 %d 与期望 %d 不一致", resp.StatusCode, expect)
	}
	return out, nil
}

func shellCommandHandler(ctx context.Context, t *Task) (interface{}, error) {
	if !conf.ShellTaskEnable() {
		return nil, errors.New("Shell 任务已禁用，请在 config.yaml 中设置 app.shellTaskEnable = true")
	}
	command := t.Str("command")
	if command == "" {
		return nil, errors.New("缺少命令 command")
	}
	var cmd *exec.Cmd
	if runtime.GOOS == "windows" {
		cmd = exec.CommandContext(ctx, "cmd", "/C", command)
	} else {
		cmd = exec.CommandContext(ctx, "/bin/sh", "-c", command)
	}
	if dir := t.Str("workdir"); dir != "" {
		if st, err := os.Stat(dir); err != nil || !st.IsDir() {
			return nil, fmt.Errorf("工作目录无效：%s", dir)
		}
		cmd.Dir = dir
	}
	output, err := cmd.CombinedOutput()
	exitCode := 0
	if err != nil {
		if ee, ok := err.(*exec.ExitError); ok {
			exitCode = ee.ExitCode()
		} else {
			exitCode = -1
		}
	}
	extra := g.Map{
		"command": command, "exit_code": exitCode,
		"output": Truncate(string(output), maxOutputLen),
	}
	if err != nil {
		return resultFail("shell_command", extra), fmt.Errorf("命令执行失败：%v", err)
	}
	return resultOf("shell_command", extra), nil
}
