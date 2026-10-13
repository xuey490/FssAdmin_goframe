package service

import (
	"sync"

	"fssadmin/go-project/internal/modules/demo/models"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
)

var (
	mu   sync.Mutex
	seq  = 1
	rows = []models.Demo{{Id: 1, Title: "hello demo", Status: 1}}
)

func List(r *ghttp.Request) (interface{}, error) {
	pg, limit := page.Parse(r)
	mu.Lock()
	defer mu.Unlock()
	return response.PageNo(rows, len(rows), pg, limit), nil
}

func Detail(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	mu.Lock()
	defer mu.Unlock()
	for _, d := range rows {
		if d.Id == id {
			return d, nil
		}
	}
	return nil, biz.NotFound("记录不存在")
}

func Create(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	mu.Lock()
	defer mu.Unlock()
	seq++
	d := models.Demo{Id: seq, Title: reqx.Str(m, "title", "name"), Status: 1}
	if st := reqx.Int(m, "status"); st != 0 {
		d.Status = st
	}
	rows = append(rows, d)
	return d, nil
}

func Update(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	m := reqx.Merge(r)
	mu.Lock()
	defer mu.Unlock()
	for i := range rows {
		if rows[i].Id == id {
			if t := reqx.Str(m, "title", "name"); t != "" {
				rows[i].Title = t
			}
			if st := reqx.Int(m, "status"); st != 0 || m["status"] != nil {
				rows[i].Status = reqx.Int(m, "status")
			}
			return rows[i], nil
		}
	}
	return nil, biz.NotFound("记录不存在")
}

func Delete(r *ghttp.Request) (interface{}, error) {
	ids := reqx.Ints(reqx.Merge(r), "ids")
	id := r.Get("id").Int()
	if id > 0 {
		ids = append(ids, id)
	}
	mu.Lock()
	defer mu.Unlock()
	keep := rows[:0]
	for _, d := range rows {
		drop := false
		for _, x := range ids {
			if d.Id == x {
				drop = true
				break
			}
		}
		if !drop {
			keep = append(keep, d)
		}
	}
	rows = keep
	return g.Map{}, nil
}

func Export(r *ghttp.Request) (interface{}, error) {
	return g.Map{"ok": true}, nil
}
