package page

import (
	"strconv"

	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

func Parse(r *ghttp.Request) (page, limit int) {
	page = firstInt(r, 1, "page", "page_no", "pageNo", "current_page")
	limit = firstInt(r, 20, "limit", "page_size", "pageSize", "size", "per_page")
	if page < 1 {
		page = 1
	}
	if limit < 1 {
		limit = 20
	}
	if limit > 500 {
		limit = 500
	}
	return
}

func firstInt(r *ghttp.Request, def int, keys ...string) int {
	for _, k := range keys {
		if v := r.Get(k); !v.IsEmpty() {
			n := gconv.Int(v.String())
			if n > 0 {
				return n
			}
			if i, err := strconv.Atoi(v.String()); err == nil && i > 0 {
				return i
			}
		}
	}
	return def
}
