package service

import (
	"encoding/json"
	"strings"

	"fssadmin/go-project/internal/modules/config/dao"
	"fssadmin/go-project/internal/shared/cachex"
	"fssadmin/go-project/internal/shared/crud"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

var groupSpec = crud.Spec{Table: dao.GroupTable, AsPage: true, Like: []string{"name", "code"}, Allow: []string{"name", "code", "remark"}}

func GroupList(r *ghttp.Request) (interface{}, error)   { return groupSpec.List(r) }
func GroupSave(r *ghttp.Request) (interface{}, error)   { return groupSpec.Create(r) }
func GroupUpdate(r *ghttp.Request) (interface{}, error) { return groupSpec.Update(r) }
func GroupDelete(r *ghttp.Request) (interface{}, error) { return groupSpec.Delete(r) }

func ConfigList(r *ghttp.Request) (interface{}, error) {
	q := reqx.Merge(r)
	m := dao.Model()
	if gid := reqx.Int(q, "group_id"); gid > 0 {
		m = m.Where("group_id", gid)
	}
	m = dbx.FilterLike(m, "name", reqx.Str(q, "name"))
	m = dbx.FilterLike(m, "`key`", reqx.Str(q, "key"))
	m = m.Order("sort asc, id desc")
	noPage := reqx.Int(q, "group_id") > 0 && reqx.Str(q, "page") == "" && reqx.Str(q, "page_no") == ""
	if noPage {
		rows, err := m.All()
		if err != nil {
			return nil, err
		}
		return decorateConfigs(dbx.ToMaps(rows)), nil
	}
	pg, limit := page.Parse(r)
	total, _ := m.Clone().Count()
	rows, err := m.Page(pg, limit).All()
	if err != nil {
		return nil, err
	}
	return response.Page(decorateConfigs(dbx.ToMaps(rows)), total, pg, limit), nil
}

func decorateConfigs(rows []map[string]interface{}) []map[string]interface{} {
	for _, item := range rows {
		item["config_select_data"] = decodeSelect(item["config_select_data"])
	}
	return rows
}

func ConfigSave(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	data := g.Map{"create_time": dbx.Now(), "update_time": dbx.Now()}
	for _, k := range []string{"group_id", "key", "value", "name", "input_type", "sort", "remark"} {
		if v, ok := m[k]; ok {
			data[k] = v
		}
	}
	if v, ok := m["config_select_data"]; ok {
		data["config_select_data"] = encodeSelect(v)
	}
	id, err := dbx.Model(dao.Table).Data(data).InsertAndGetId()
	if err != nil {
		return nil, err
	}
	_ = cachex.RefreshConfig(r.Context())
	return configDetail(int(id))
}

func ConfigUpdate(r *ghttp.Request) (interface{}, error) {
	id := gconv.Int(r.Get("id"))
	m := reqx.Merge(r)
	data := g.Map{"update_time": dbx.Now()}
	for _, k := range []string{"group_id", "key", "value", "name", "input_type", "sort", "remark"} {
		if v, ok := m[k]; ok {
			data[k] = v
		}
	}
	if v, ok := m["config_select_data"]; ok {
		data["config_select_data"] = encodeSelect(v)
	}
	if _, err := dao.Model().Where("id", id).Data(data).Update(); err != nil {
		return nil, err
	}
	_ = cachex.RefreshConfig(r.Context())
	return configDetail(id)
}

func configDetail(id int) (interface{}, error) {
	rec, _ := dao.Model().Where("id", id).One()
	out := dbx.ToMap(rec)
	if out != nil {
		out["config_select_data"] = decodeSelect(out["config_select_data"])
	}
	return out, nil
}

func decodeSelect(raw interface{}) []interface{} {
	if raw == nil {
		return []interface{}{}
	}
	switch t := raw.(type) {
	case []interface{}:
		return t
	case []map[string]interface{}:
		out := make([]interface{}, 0, len(t))
		for _, x := range t {
			out = append(out, x)
		}
		return out
	}
	s := strings.TrimSpace(gconv.String(raw))
	if s == "" {
		return []interface{}{}
	}
	var out []interface{}
	if err := json.Unmarshal([]byte(s), &out); err != nil || out == nil {
		return []interface{}{}
	}
	return out
}

func encodeSelect(val interface{}) string {
	if val == nil {
		return ""
	}
	if s, ok := val.(string); ok {
		return s
	}
	b, err := json.Marshal(val)
	if err != nil {
		return ""
	}
	return string(b)
}

func ConfigDelete(r *ghttp.Request) (interface{}, error) {
	ids := reqx.Ints(reqx.Merge(r), "ids")
	err := dbx.SoftDeleteIDs(dao.Table, ids)
	if err == nil {
		_ = cachex.RefreshConfig(r.Context())
	}
	return g.Map{}, err
}

func BatchUpdate(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	items := gconv.Interfaces(m["config"])
	if len(items) == 0 {
		items = gconv.Interfaces(m["configs"])
	}
	for _, it := range items {
		row := gconv.Map(it)
		id := gconv.Int(row["id"])
		if id <= 0 {
			continue
		}
		if _, ok := row["value"]; !ok {
			continue
		}
		_, _ = dao.Model().Where("id", id).Data(g.Map{"value": row["value"], "update_time": dbx.Now()}).Update()
	}
	_ = cachex.RefreshConfig(r.Context())
	return g.Map{}, nil
}

func TestEmail(r *ghttp.Request) (interface{}, error) {
	return g.Map{"ok": true, "msg": "邮件测试已受理（Go 侧占位）"}, nil
}
