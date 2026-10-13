package service

import (
	"net/url"
	"path"
	"path/filepath"
	"regexp"
	"strings"

	"fssadmin/go-project/internal/shared/conf"

	"github.com/gogf/gf/v2/frame/g"
)

var dateFileRe = regexp.MustCompile(`(\d{4}/\d{2}/\d{2})/([^/?#]+)`)

func joinPublicURL(domain, prefix, day, name string) string {
	prefix = "/" + strings.Trim(prefix, "/")
	p := prefix + "/" + strings.Trim(day, "/") + "/" + strings.TrimLeft(name, "/")
	if domain = strings.TrimRight(strings.TrimSpace(domain), "/"); domain != "" {
		return domain + p
	}
	return p
}

func PublicURL(day, name string) string {
	return joinPublicURL(conf.UploadDomain(), conf.UploadPublicPrefix(), day, name)
}

func rewritePublicURL(raw, domain, prefix string) string {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return raw
	}
	if u, err := url.Parse(raw); err == nil && u.Host != "" {
		raw = u.Path
		if raw == "" {
			raw = "/"
		}
	}
	if m := dateFileRe.FindStringSubmatch(raw); len(m) == 3 {
		return joinPublicURL(domain, prefix, m[1], m[2])
	}
	return raw
}

// RewritePublicURL 把历史 /uploads、/static/upload、localhost:8181/profile 等统一成当前对外地址。
func RewritePublicURL(raw string) string {
	return rewritePublicURL(raw, conf.UploadDomain(), conf.UploadPublicPrefix())
}

func decorateURLMap(m map[string]interface{}) map[string]interface{} {
	if m == nil {
		return m
	}
	if v, ok := m["url"]; ok {
		m["url"] = RewritePublicURL(g.NewVar(v).String())
	}
	return m
}

func decorateResult(out interface{}) interface{} {
	switch t := out.(type) {
	case map[string]interface{}:
		decorateListField(t)
		return decorateURLMap(t)
	case []map[string]interface{}:
		for i := range t {
			t[i] = decorateURLMap(t[i])
		}
		return t
	default:
		return out
	}
}

func decorateListField(t map[string]interface{}) {
	if list, ok := t["list"].([]map[string]interface{}); ok {
		for i := range list {
			list[i] = decorateURLMap(list[i])
		}
		t["list"] = list
		t["data"] = list
		return
	}
	if list, ok := t["list"].([]g.Map); ok {
		for i := range list {
			list[i] = decorateURLMap(list[i])
		}
		t["list"] = list
		t["data"] = list
	}
}

func dayAndName(rel string) (day, name string) {
	rel = filepath.ToSlash(strings.Trim(rel, "/"))
	if m := dateFileRe.FindStringSubmatch(rel); len(m) == 3 {
		return m[1], m[2]
	}
	return "", path.Base(rel)
}
