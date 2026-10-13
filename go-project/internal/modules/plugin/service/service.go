package service

import (
	"encoding/json"
	"os"
	"path/filepath"
	"sync"

	"fssadmin/go-project/internal/modules/plugin/models"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/reqx"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gfile"
)

var (
	mu   sync.Mutex
	path = filepath.Join("resource", "plugins", "registry.json")
)

func load() []models.Plugin {
	if !gfile.Exists(path) {
		return []models.Plugin{
			{Name: "module_example", Title: "示例插件", Version: "0.1.0", Author: "FssAdmin", Installed: true, Enabled: true, StatusText: "已启用"},
			{Name: "module_task", Title: "任务调度", Version: "0.1.0", Author: "FssAdmin", Installed: true, Enabled: true, StatusText: "已启用"},
			{Name: "module_generator", Title: "代码生成", Version: "0.1.0", Author: "FssAdmin", Installed: true, Enabled: true, StatusText: "已启用"},
		}
	}
	b, _ := os.ReadFile(path)
	var list []models.Plugin
	_ = json.Unmarshal(b, &list)
	return list
}

func save(list []models.Plugin) {
	_ = os.MkdirAll(filepath.Dir(path), 0755)
	b, _ := json.MarshalIndent(list, "", "  ")
	_ = os.WriteFile(path, b, 0644)
}

func List(r *ghttp.Request) (interface{}, error) {
	mu.Lock()
	defer mu.Unlock()
	return load(), nil
}

func Detail(r *ghttp.Request) (interface{}, error) {
	name := r.Get("name").String()
	mu.Lock()
	defer mu.Unlock()
	for _, p := range load() {
		if p.Name == name {
			return p, nil
		}
	}
	return nil, biz.NotFound("插件不存在")
}

func Create(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	p := models.Plugin{
		Name: reqx.Str(m, "name"), Title: reqx.Str(m, "title"), Version: reqx.Str(m, "version", "version"),
		Author: reqx.Str(m, "author"), Installed: false, Enabled: false, StatusText: "未安装",
		Description: reqx.Str(m, "description"),
	}
	if p.Version == "" {
		p.Version = "0.0.1"
	}
	mu.Lock()
	defer mu.Unlock()
	list := load()
	list = append(list, p)
	save(list)
	return p, nil
}

func find(name string) (int, []models.Plugin) {
	list := load()
	for i, p := range list {
		if p.Name == name {
			return i, list
		}
	}
	return -1, list
}

func Install(r *ghttp.Request) (interface{}, error) {
	name := reqx.Str(reqx.Merge(r), "name")
	mu.Lock()
	defer mu.Unlock()
	i, list := find(name)
	if i < 0 {
		list = append(list, models.Plugin{Name: name, Title: name, Version: "0.1.0", Installed: true, Enabled: true, StatusText: "已启用"})
	} else {
		list[i].Installed = true
		list[i].Enabled = true
		list[i].StatusText = "已启用"
	}
	save(list)
	return g.Map{"ok": true}, nil
}

func Uninstall(r *ghttp.Request) (interface{}, error) {
	name := reqx.Str(reqx.Merge(r), "name")
	mu.Lock()
	defer mu.Unlock()
	i, list := find(name)
	if i >= 0 {
		list[i].Installed = false
		list[i].Enabled = false
		list[i].StatusText = "未安装"
		save(list)
	}
	return g.Map{"ok": true}, nil
}

func Enable(r *ghttp.Request) (interface{}, error) {
	return setEnabled(r.Get("name").String(), true)
}
func Disable(r *ghttp.Request) (interface{}, error) {
	return setEnabled(r.Get("name").String(), false)
}

func setEnabled(name string, on bool) (interface{}, error) {
	mu.Lock()
	defer mu.Unlock()
	i, list := find(name)
	if i < 0 {
		return nil, biz.NotFound("插件不存在")
	}
	list[i].Enabled = on
	if on {
		list[i].StatusText = "已启用"
	} else {
		list[i].StatusText = "已停用"
	}
	save(list)
	return g.Map{"ok": true}, nil
}

func GetConfig(r *ghttp.Request) (interface{}, error) {
	return g.Map{}, nil
}
func UpdateConfig(r *ghttp.Request) (interface{}, error) {
	return g.Map{"ok": true}, nil
}
func Doctor(r *ghttp.Request) (interface{}, error) {
	return g.Map{"ok": true, "checks": []g.Map{{"name": "registry", "status": "ok"}}}, nil
}
