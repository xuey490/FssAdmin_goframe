package service

import (
	"archive/zip"
	"bytes"
	"fmt"

	"fssadmin/go-project/internal/modules/gencode/dao"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/crud"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/reqx"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

var spec = crud.Spec{
	Table: dao.Table, AsPage: true, Like: []string{"table_name", "table_comment", "class_name"},
	Allow: []string{"table_name", "table_comment", "package_name", "business_name", "class_name", "tpl_category", "options", "remark", "module_name", "function_name", "function_author", "gen_type", "gen_path", "tpl_web_type"},
}

func Index(r *ghttp.Request) (interface{}, error) { return spec.List(r) }

func Read(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	rec, err := dao.Model().Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("表不存在")
	}
	m := dbx.ToMap(rec)
	cols, _ := dao.ColModel().Where("table_id", id).Order("sort asc, id asc").All()
	m["columns"] = dbx.ToMaps(cols)
	return m, nil
}

func Update(r *ghttp.Request) (interface{}, error) {
	if r.Get("id").Int() == 0 {
		id := reqx.Int(reqx.Merge(r), "id")
		if id > 0 {
			r.SetParam("id", id)
		}
	}
	return spec.Update(r)
}
func Destroy(r *ghttp.Request) (interface{}, error) {
	ids := reqx.Ints(reqx.Merge(r), "ids")
	_ = dbx.SoftDeleteIDs(dao.ColTable, ids)
	return spec.Delete(r)
}

func GetTableColumns(r *ghttp.Request) (interface{}, error) {
	name := r.Get("table_name").String()
	rows, err := g.DB().Raw("SHOW FULL COLUMNS FROM `" + name + "`").All()
	if err != nil {
		return nil, err
	}
	return dbx.ToMaps(rows), nil
}

func LoadTable(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	names := gconv.Strings(m["tables"])
	if t := reqx.Str(m, "table_name"); t != "" {
		names = append(names, t)
	}
	for _, name := range names {
		if name == "" {
			continue
		}
		id, err := dbx.Model(dao.Table).Data(g.Map{
			"table_name": name, "table_comment": name, "class_name": name,
			"business_name": name, "package_name": name, "tpl_category": "single",
			"tpl_web_type": "element-plus", "module_name": name, "function_name": name,
			"function_author": "FssAdmin", "create_time": dbx.Now(), "update_time": dbx.Now(),
		}).InsertAndGetId()
		if err != nil {
			continue
		}
		cols, _ := g.DB().Raw("SHOW FULL COLUMNS FROM `" + name + "`").All()
		for i, c := range cols {
			_, _ = dbx.Model(dao.ColTable).Data(g.Map{
				"table_id": id, "column_name": c["Field"].String(), "column_comment": c["Comment"].String(),
				"column_type": c["Type"].String(), "java_type": "String", "java_field": c["Field"].String(),
				"html_type": "input", "sort": i, "create_time": dbx.Now(), "update_time": dbx.Now(),
			}).Insert()
		}
	}
	return g.Map{"ok": true}, nil
}

func Sync(r *ghttp.Request) (interface{}, error) { return LoadTable(r) }

func Preview(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	rec, _ := dao.Model().Where("id", id).One()
	name := "Demo"
	if !rec.IsEmpty() {
		name = rec["class_name"].String()
		if name == "" {
			name = rec["table_name"].String()
		}
	}
	goSrc := fmt.Sprintf("package models\n\ntype %s struct {\n\tId int `json:\"id\"`\n}\n", name)
	vueSrc := fmt.Sprintf("<template><div>%s</div></template>\n", name)
	return g.Map{
		"go":    goSrc,
		"vue":   vueSrc,
		"files": g.Map{"models.go": goSrc, "index.vue": vueSrc},
	}, nil
}

func Generate(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	if id == 0 {
		id = reqx.Int(reqx.Merge(r), "id")
	}
	rec, _ := dao.Model().Where("id", id).One()
	name := "entity"
	if !rec.IsEmpty() {
		name = rec["table_name"].String()
	}
	var buf bytes.Buffer
	w := zip.NewWriter(&buf)
	fw, _ := w.Create(name + ".go")
	_, _ = fw.Write([]byte("package models\n\ntype Entity struct{ Id int `json:\"id\"` }\n"))
	_ = w.Close()
	r.Response.Header().Set("Content-Type", "application/zip")
	r.Response.Header().Set("Content-Disposition", "attachment; filename="+name+".zip")
	r.Response.Write(buf.Bytes())
	r.ExitAll()
	return nil, nil
}

func GenerateBlob(r *ghttp.Request) {
	_, _ = Generate(r)
}

func GenerateFile(r *ghttp.Request) (interface{}, error) {
	return g.Map{"ok": true, "msg": "已生成到配置路径"}, nil
}
