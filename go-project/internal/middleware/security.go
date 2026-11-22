package middleware

import (
	"path/filepath"
	"strings"

	"fssadmin/go-project/internal/shared/conf"

	"github.com/gogf/gf/v2/net/ghttp"
)

// StaticGuard 统一安全响应头：
//  1. 全局 X-Content-Type-Options: nosniff，防止浏览器嗅探猜类型；
//  2. 上传目录内 html/svg/js/xml 等可执行内容的扩展名强制 octet-stream + attachment，
//     即便历史脏数据（旧黑名单时期上传）也不会被浏览器同源渲染为 XSS 载体。
func StaticGuard(r *ghttp.Request) {
	h := r.Response.Header()
	h.Set("X-Content-Type-Options", "nosniff")
	h.Set("X-Frame-Options", "SAMEORIGIN")
	h.Set("Referrer-Policy", "strict-origin-when-cross-origin")
	if isUploadPath(r.URL.Path) {
		if riskyExt(r.URL.Path) {
			h.Set("Content-Type", "application/octet-stream")
			h.Set("Content-Disposition", "attachment")
			h.Set("Content-Security-Policy", "default-src 'none'")
		}
	}
	r.Middleware.Next()
}

func isUploadPath(path string) bool {
	prefixes := []string{"/uploads/", "/static/upload/", strings.TrimRight(conf.UploadPublicPrefix(), "/") + "/"}
	for _, p := range prefixes {
		if strings.HasPrefix(path, p) {
			return true
		}
	}
	return false
}

func riskyExt(path string) bool {
	switch strings.ToLower(strings.TrimPrefix(filepath.Ext(path), ".")) {
	case "html", "htm", "shtml", "xhtml", "svg", "svgz", "xml", "js", "mjs", "swf", "xsl", "xslt":
		return true
	}
	return false
}
