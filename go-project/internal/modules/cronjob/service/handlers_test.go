package service

import (
	"context"
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"fssadmin/go-project/internal/shared/conf"
	"github.com/gogf/gf/v2/frame/g"
)

func TestBuiltinHandlersRegistered(t *testing.T) {
	for _, name := range []string{backupCode, restoreCode, "log_cleanup", "http_request", "shell_command"} {
		h, ok := GetHandler(name)
		if !ok {
			t.Fatalf("内置任务类型未注册: %s", name)
		}
		if h.Title == "" || h.run == nil {
			t.Fatalf("任务类型定义不完整: %s", name)
		}
	}
	if _, ok := GetHandler("def handler(*args, **kwargs)"); ok {
		t.Fatal("未知类型不应命中注册表")
	}
	if len(AllHandlers()) < 5 {
		t.Fatalf("任务类型数量异常: %d", len(AllHandlers()))
	}
}

func TestUnknownHandlerError(t *testing.T) {
	_, err := ExecuteHandler(context.Background(), "python_legacy_handler", &Task{})
	if !IsUnknownHandler(err) {
		t.Fatalf("未知类型应返回 ErrUnknownHandler，实际 %v", err)
	}
}

func TestHandlerTimeoutAndPanic(t *testing.T) {
	RegisterHandler(Handler{
		Name: "test_slow", DefaultSecond: 1,
		run: func(ctx context.Context, _ *Task) (interface{}, error) {
			<-ctx.Done()
			return nil, ctx.Err()
		},
	})
	RegisterHandler(Handler{
		Name: "test_panic", DefaultSecond: 5,
		run: func(context.Context, *Task) (interface{}, error) { panic("boom") },
	})

	start := time.Now()
	_, err := ExecuteHandler(context.Background(), "test_slow", &Task{})
	if !IsTimeout(err) {
		t.Fatalf("应返回超时错误，实际 %v", err)
	}
	if elapsed := time.Since(start); elapsed > 3*time.Second {
		t.Fatalf("超时未按 1 秒生效，耗时 %s", elapsed)
	}

	if _, err := ExecuteHandler(context.Background(), "test_panic", &Task{}); err == nil || !strings.Contains(err.Error(), "panic") {
		t.Fatalf("panic 应被兜底捕获，实际 %v", err)
	}
}

func TestExecuteHandlerIgnoresParentCancel(t *testing.T) {
	RegisterHandler(Handler{
		Name: "test_parent_cancel", DefaultSecond: 5,
		run: func(ctx context.Context, _ *Task) (interface{}, error) {
			select {
			case <-ctx.Done():
				return nil, ctx.Err()
			case <-time.After(30 * time.Millisecond):
				return "ok", nil
			}
		},
	})
	parent, cancel := context.WithCancel(context.Background())
	cancel()
	v, err := ExecuteHandler(parent, "test_parent_cancel", &Task{})
	if err != nil || v != "ok" {
		t.Fatalf("父 ctx 取消不应打断任务：%v %v", v, err)
	}
}

func TestTaskAccessors(t *testing.T) {
	task := &Task{Kwargs: map[string]interface{}{
		"days": 7, "flag": true, "headers": `{"X-A":"1"}`, "obj": map[string]interface{}{"b": 2},
	}}
	if task.Int("days", 30) != 7 || task.Int("missing", 30) != 30 {
		t.Fatal("Int 取值异常")
	}
	if !task.Bool("flag", false) || task.Bool("missing", true) != true {
		t.Fatal("Bool 取值异常")
	}
	if m := task.Map("headers"); m["X-A"] != "1" {
		t.Fatalf("Map 未解析 JSON 字符串: %#v", m)
	}
	if m := task.Map("obj"); m["b"] != 2 {
		t.Fatalf("Map 未识别对象: %#v", m)
	}
	if _, ok := task.Kwargs["missing"]; ok {
		t.Fatal("不应凭空产生参数")
	}
}

func TestLogCleanupRejectsUnknownTable(t *testing.T) {
	_, err := logCleanupHandler(context.Background(), &Task{Kwargs: map[string]interface{}{"table": "sa_system_user"}})
	if err == nil || !strings.Contains(err.Error(), "不允许清理") {
		t.Fatalf("非白名单表应被拒绝，实际 %v", err)
	}
	if _, err := logCleanupHandler(context.Background(), &Task{Kwargs: map[string]interface{}{"table": "task_job", "days": 0}}); err == nil {
		t.Fatal("保留天数为 0 应报错")
	}
}

func TestHTTPRequestHandler(t *testing.T) {
	var gotHeader, gotBody string
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		gotHeader = r.Header.Get("X-Token")
		buf := make([]byte, 64)
		n, _ := r.Body.Read(buf)
		gotBody = string(buf[:n])
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte("pong"))
	}))
	defer srv.Close()

	_, err := httpRequestHandler(context.Background(), &Task{Kwargs: map[string]interface{}{
		"url": srv.URL, "method": "POST", "headers": `{"X-Token":"t1"}`,
		"body": "hello", "expect_status": 200,
	}})
	if err != nil {
		t.Fatalf("请求应成功: %v", err)
	}
	if gotHeader != "t1" || gotBody != "hello" {
		t.Fatalf("请求未按参数发送: header=%q body=%q", gotHeader, gotBody)
	}

	res, err := httpRequestHandler(context.Background(), &Task{Kwargs: map[string]interface{}{
		"url": srv.URL, "expect_status": 500,
	}})
	if err == nil || !strings.Contains(err.Error(), "不一致") {
		t.Fatalf("状态码不匹配应报错，实际 %v", err)
	}
	m, _ := res.(g.Map)
	if m["ok"] != false || m["kind"] != "http_request" || m["status"] != 200 {
		t.Fatalf("失败结果结构异常: %#v", res)
	}

	if _, err = httpRequestHandler(context.Background(), &Task{Kwargs: map[string]interface{}{"url": "ftp://x"}}); err == nil {
		t.Fatal("非 http(s) 地址应被拒绝")
	}
	if _, err = httpRequestHandler(context.Background(), &Task{}); err == nil {
		t.Fatal("缺少 url 应报错")
	}
}

func TestHTTPRequestTimeout(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		select {
		case <-r.Context().Done():
			return
		case <-time.After(2 * time.Second):
		}
	}))
	defer srv.Close()
	ctx, cancel := context.WithTimeout(context.Background(), 80*time.Millisecond)
	defer cancel()
	_, err := httpRequestHandler(ctx, &Task{Kwargs: map[string]interface{}{"url": srv.URL, "expect_status": 0}})
	if err == nil {
		t.Fatal("应因上下文超时失败")
	}
}

func TestShellCommandHandler(t *testing.T) {
	res, err := shellCommandHandler(context.Background(), &Task{Kwargs: map[string]interface{}{"command": "echo fssadmin-ok"}})
	if err != nil {
		t.Fatalf("命令应执行成功: %v", err)
	}
	text := TextOrJSON(res)
	if !strings.Contains(text, "fssadmin-ok") || !strings.Contains(text, `"exit_code":0`) {
		t.Fatalf("输出未包含预期内容: %s", text)
	}
	res, err = shellCommandHandler(context.Background(), &Task{Kwargs: map[string]interface{}{"command": "exit 3"}})
	if err == nil {
		t.Fatal("非零退出码应视为失败")
	}
	m, _ := res.(g.Map)
	if m["ok"] != false || m["exit_code"] != 3 {
		t.Fatalf("失败退出码应写入结果: %#v", res)
	}
	if _, err = shellCommandHandler(context.Background(), &Task{}); err == nil {
		t.Fatal("缺少命令应报错")
	}
	if _, err = shellCommandHandler(context.Background(), &Task{Kwargs: map[string]interface{}{
		"command": "echo x", "workdir": filepath.Join(t.TempDir(), "missing"),
	}}); err == nil {
		t.Fatal("无效工作目录应报错")
	}
}

func TestShellCommandCanceled(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	_, err := shellCommandHandler(ctx, &Task{Kwargs: map[string]interface{}{"command": "echo x"}})
	if err == nil {
		t.Fatal("已取消的上下文应失败")
	}
}

func TestShellHandlerGateFollowsConfig(t *testing.T) {
	h, _ := GetHandler("shell_command")
	if h.Enabled != conf.ShellTaskEnable() {
		t.Fatalf("shell 类型可用性应与配置一致: enabled=%v conf=%v", h.Enabled, conf.ShellTaskEnable())
	}
}

func TestTruncateKeepsValidUTF8(t *testing.T) {
	long := strings.Repeat("中文测试", 200)
	got := Truncate(long, 11)
	if !strings.Contains(got, "已截断") {
		t.Fatalf("应带截断标记: %s", got)
	}
	if strings.ContainsRune(got, '\uFFFD') {
		t.Fatalf("截断产生了非法 UTF-8: %q", got)
	}
	if Truncate("短", maxOutputLen) != "短" {
		t.Fatal("未超长时不应改动")
	}
}
