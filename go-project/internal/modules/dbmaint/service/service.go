package service

import (
	"fmt"
	"regexp"
	"strings"

	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

var tableIdent = regexp.MustCompile(`^[A-Za-z0-9_]+$`)

func guard() error {
	if !conf.Debug() {
		return biz.Forbidden("数据库维护仅 debug 模式可用")
	}
	return nil
}

func tableName(r *ghttp.Request) string {
	return strings.TrimSpace(r.Get("table", r.Get("table_name", r.Get("name"))).String())
}

func validTable(name string) bool { return tableIdent.MatchString(name) }

func formatBytes(n int) string {
	if n <= 0 {
		return "0 B"
	}
	if n < 1024 {
		return fmt.Sprintf("%d B", n)
	}
	if n < 1024*1024 {
		return fmt.Sprintf("%.2f KB", float64(n)/1024)
	}
	if n < 1024*1024*1024 {
		return fmt.Sprintf("%.2f MB", float64(n)/1024/1024)
	}
	return fmt.Sprintf("%.2f GB", float64(n)/1024/1024/1024)
}

func pick(m map[string]interface{}, keys ...string) interface{} {
	for _, k := range keys {
		if v, ok := m[k]; ok && v != nil && gconv.String(v) != "" {
			return v
		}
	}
	for _, k := range keys {
		if v, ok := m[k]; ok && v != nil {
			return v
		}
	}
	return nil
}

func mapTableStatus(m map[string]interface{}) g.Map {
	dataFree := gconv.Int(pick(m, "Data_free", "data_free"))
	dataLen := gconv.Int(pick(m, "Data_length", "data_length")) + gconv.Int(pick(m, "Index_length", "index_length"))
	return g.Map{
		"name":        gconv.String(pick(m, "Name", "name")),
		"comment":     gconv.String(pick(m, "Comment", "comment")),
		"engine":      gconv.String(pick(m, "Engine", "engine")),
		"rows":        gconv.Int(pick(m, "Rows", "rows")),
		"data_free":   formatBytes(dataFree),
		"data_length": formatBytes(dataLen),
		"collation":   gconv.String(pick(m, "Collation", "collation")),
		"create_time": gconv.String(pick(m, "Create_time", "create_time")),
		"update_time": gconv.String(pick(m, "Update_time", "update_time")),
	}
}

func mapColumn(m map[string]interface{}) g.Map {
	nullable := strings.EqualFold(gconv.String(pick(m, "Null", "null")), "YES")
	return g.Map{
		"column_name":    gconv.String(pick(m, "Field", "field")),
		"column_type":    gconv.String(pick(m, "Type", "type")),
		"column_key":     gconv.String(pick(m, "Key", "key")),
		"is_nullable":    nullable,
		"column_default": pick(m, "Default", "default"),
		"column_comment": gconv.String(pick(m, "Comment", "comment")),
	}
}

func TableList(r *ghttp.Request) (interface{}, error) {
	rows, err := g.DB().Raw("SHOW TABLE STATUS").All()
	if err != nil {
		return nil, err
	}
	kw := strings.ToLower(r.Get("name", r.Get("table_name")).String())
	list := make([]g.Map, 0, len(rows))
	for _, rec := range dbx.ToMaps(rows) {
		item := mapTableStatus(rec)
		name := strings.ToLower(gconv.String(item["name"]))
		if kw != "" && !strings.Contains(name, kw) {
			continue
		}
		list = append(list, item)
	}
	return g.Map{"list": list, "total": len(list)}, nil
}

func DataSource(r *ghttp.Request) (interface{}, error) {
	if err := guard(); err != nil {
		return nil, err
	}
	return g.Map{"driver": "mysql", "database": g.DB().GetConfig().Name}, nil
}

func Detailed(r *ghttp.Request) (interface{}, error) {
	if err := guard(); err != nil {
		return nil, err
	}
	name := tableName(r)
	if !validTable(name) {
		return nil, biz.Bad("表名格式不正确")
	}
	rows, err := g.DB().Raw("SHOW FULL COLUMNS FROM `" + name + "`").All()
	if err != nil {
		return nil, err
	}
	cols := make([]g.Map, 0, len(rows))
	for _, rec := range dbx.ToMaps(rows) {
		cols = append(cols, mapColumn(rec))
	}
	return g.Map{"columns": cols}, nil
}

func RecycleList(r *ghttp.Request) (interface{}, error) {
	if err := guard(); err != nil {
		return nil, err
	}
	table := tableName(r)
	if table == "" || !validTable(table) {
		return response.Page([]g.Map{}, 0, 1, 20), nil
	}
	pg, limit := page.Parse(r)
	m := dbx.Model(table).Where("delete_time IS NOT NULL")
	total, _ := m.Clone().Count()
	rows, err := m.Page(pg, limit).All()
	if err != nil {
		return nil, err
	}
	return response.Page(dbx.ToMaps(rows), total, pg, limit), nil
}

func RecycleDestroy(r *ghttp.Request) (interface{}, error) {
	if err := guard(); err != nil {
		return nil, err
	}
	m := reqx.Merge(r)
	table := reqx.Str(m, "table_name", "table")
	ids := reqx.Ints(m, "ids")
	if table == "" || len(ids) == 0 {
		return g.Map{}, nil
	}
	_, err := dbx.Model(table).WhereIn("id", ids).Delete()
	return g.Map{}, err
}

func RecycleRecovery(r *ghttp.Request) (interface{}, error) {
	if err := guard(); err != nil {
		return nil, err
	}
	m := reqx.Merge(r)
	table := reqx.Str(m, "table_name", "table")
	ids := reqx.Ints(m, "ids")
	_, err := dbx.Model(table).WhereIn("id", ids).Data(g.Map{"delete_time": nil}).Update()
	return g.Map{}, err
}

func Optimize(r *ghttp.Request) (interface{}, error) {
	return tableCmd(r, "OPTIMIZE TABLE")
}
func Fragment(r *ghttp.Request) (interface{}, error) {
	return tableCmd(r, "ANALYZE TABLE")
}

func tableCmd(r *ghttp.Request, cmd string) (interface{}, error) {
	if err := guard(); err != nil {
		return nil, err
	}
	m := reqx.Merge(r)
	tables := gconv.Strings(m["tables"])
	if t := reqx.Str(m, "table_name", "table"); t != "" {
		tables = append(tables, t)
	}
	for _, t := range tables {
		if !validTable(t) {
			continue
		}
		_, _ = g.DB().Exec(r.Context(), fmt.Sprintf("%s `%s`", cmd, t))
	}
	return g.Map{"ok": true}, nil
}

func CreateSQL(r *ghttp.Request) (interface{}, error) {
	if err := guard(); err != nil {
		return nil, err
	}
	name := tableName(r)
	if !validTable(name) {
		return nil, biz.Bad("表名格式不正确")
	}
	row, err := g.DB().Raw("SHOW CREATE TABLE `" + name + "`").One()
	if err != nil {
		return nil, err
	}
	sql := ""
	if v, ok := row["Create Table"]; ok {
		sql = v.String()
	} else {
		for k, v := range row {
			if strings.Contains(strings.ToLower(k), "create") {
				sql = v.String()
			}
		}
	}
	return g.Map{"sql": sql, "table": name}, nil
}
