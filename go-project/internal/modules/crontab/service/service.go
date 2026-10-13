package service

import (
	"fssadmin/go-project/internal/modules/crontab/dao"
	"fssadmin/go-project/internal/shared/crud"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/reqx"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
)

var spec = crud.Spec{
	Table: dao.Table, AsPage: true, Like: []string{"name", "target"},
	Allow: []string{"name", "type", "target", "parameter", "task_style", "rule", "singleton", "status", "remark"},
}
var logSpec = crud.Spec{Table: dao.LogTable, AsPage: true, Like: []string{"name", "target"}}

func List(r *ghttp.Request) (interface{}, error)   { return spec.List(r) }
func Detail(r *ghttp.Request) (interface{}, error) { return spec.Detail(r) }
func Create(r *ghttp.Request) (interface{}, error) { return spec.Create(r) }
func Update(r *ghttp.Request) (interface{}, error) { return spec.Update(r) }
func Delete(r *ghttp.Request) (interface{}, error) { return spec.Delete(r) }

func Tasks(r *ghttp.Request) (interface{}, error) {
	return []string{"task.noParams", "task.params", "task.backupDatabase"}, nil
}

func Run(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	rec, _ := dao.Model().Where("id", id).One()
	name := ""
	target := ""
	if !rec.IsEmpty() {
		name = rec["name"].String()
		target = rec["target"].String()
	}
	_, _ = dbx.Model(dao.LogTable).Data(g.Map{
		"crontab_id": id, "name": name, "target": target, "status": 1,
		"create_time": dbx.Now(), "update_time": dbx.Now(),
	}).Insert()
	return g.Map{"ok": true}, nil
}

func LogList(r *ghttp.Request) (interface{}, error) { return logSpec.List(r) }
func LogDelete(r *ghttp.Request) (interface{}, error) {
	ids := reqx.Ints(reqx.Merge(r), "ids")
	return g.Map{}, dbx.SoftDeleteIDs(dao.LogTable, ids)
}
func LogClean(r *ghttp.Request) (interface{}, error) {
	_, err := dao.LogModel().Data(g.Map{"delete_time": dbx.Now()}).Update()
	return g.Map{}, err
}
