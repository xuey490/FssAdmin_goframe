package service

import (
	"os"
	"path/filepath"
	"strings"

	asvc "fssadmin/go-project/internal/modules/attachment/service"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/conf"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
)

func Upload(r *ghttp.Request) (interface{}, error) {
	return asvc.Upload(r)
}

func Download(r *ghttp.Request) (interface{}, error) {
	p := r.Get("file_path").String()
	if p == "" {
		p = r.Get("path").String()
	}
	if p == "" {
		return nil, biz.Bad("缺少文件路径")
	}
	clean := filepath.Clean(p)
	if strings.Contains(clean, "..") {
		return nil, biz.Bad("非法路径")
	}
	root, _ := filepath.Abs(conf.UploadDir())
	full := clean
	if !filepath.IsAbs(full) {
		full = filepath.Join(root, clean)
	}
	abs, _ := filepath.Abs(full)
	// 前缀必须落在分隔符边界上：否则同级目录 static/upload2 可绕过前缀检查。
	if abs != root && !strings.HasPrefix(abs, root+string(os.PathSeparator)) {
		return nil, biz.Bad("非法路径")
	}
	if _, err := os.Stat(abs); err != nil {
		return nil, biz.NotFound("文件不存在")
	}
	r.Response.ServeFile(abs)
	// ServeFile 已写响应体；ExitAll 阻断外层 Wrap 再追加 JSON，避免重复响应体。
	r.ExitAll()
	return nil, nil
}

func WangEditor(r *ghttp.Request) (interface{}, error) {
	data, err := asvc.Upload(r)
	if err != nil {
		return g.Map{"errno": 1, "message": err.Error()}, nil
	}
	url := ""
	if m, ok := data.(map[string]interface{}); ok {
		url = g.NewVar(m["url"]).String()
	}
	return g.Map{"errno": 0, "data": g.Map{"url": url, "alt": "", "href": url}}, nil
}
