package service

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	"fssadmin/go-project/internal/modules/attachment/dao"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/crud"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/tree"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gfile"
	"github.com/gogf/gf/v2/util/gconv"
	"github.com/gogf/gf/v2/util/grand"
)

var spec = crud.Spec{Table: dao.Table, AsPage: true, Like: []string{"origin_name"}, Allow: []string{"origin_name", "category_id", "remark"}}
var catSpec = crud.Spec{Table: dao.CatTable, Tree: true, Like: []string{"category_name"}, Allow: []string{"parent_id", "category_name", "status", "sort", "remark", "level"}}

func List(r *ghttp.Request) (interface{}, error) {
	m := dao.Model()
	q := reqx.Merge(r)
	if cid := reqx.Int(q, "category_id"); cid > 0 {
		m = m.Where("category_id", cid)
	}
	m = dbx.FilterLike(m, "origin_name", reqx.Str(q, "origin_name", "name"))
	s := spec
	_ = s
	out, err := spec.List(r)
	if err != nil {
		return nil, err
	}
	return decorateResult(out), nil
}

func Detail(r *ghttp.Request) (interface{}, error) {
	out, err := spec.Detail(r)
	if err != nil {
		return nil, err
	}
	if m, ok := out.(map[string]interface{}); ok {
		return decorateURLMap(m), nil
	}
	return out, nil
}
func Update(r *ghttp.Request) (interface{}, error) { return spec.Update(r) }
func Delete(r *ghttp.Request) (interface{}, error) { return spec.Delete(r) }

func BatchDelete(r *ghttp.Request) (interface{}, error) {
	ids := reqx.Ints(reqx.Merge(r), "ids")
	return g.Map{}, dbx.SoftDeleteIDs(dao.Table, ids)
}

func Move(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	ids := reqx.Ints(m, "ids")
	cid := reqx.Int(m, "category_id")
	_, err := dao.Model().WhereIn("id", ids).Data(g.Map{"category_id": cid, "update_time": dbx.Now()}).Update()
	return g.Map{}, err
}

func Stats(r *ghttp.Request) (interface{}, error) {
	n, _ := dao.Model().Count()
	sum, _ := dao.Model().Sum("size_byte")
	return g.Map{"count": n, "size": sum}, nil
}

func CategoryList(r *ghttp.Request) (interface{}, error) {
	q := reqx.Merge(r)
	rows, err := dao.CatModel().Order("sort asc, id asc").All()
	if err != nil {
		return nil, err
	}
	maps := dbx.ToMaps(rows)
	for _, m := range maps {
		m["name"] = m["category_name"]
		m["label"] = m["category_name"]
	}
	if gconv.String(q["tree"]) == "true" || gconv.Bool(q["tree"]) {
		return tree.Build(maps, "id", "parent_id", "children"), nil
	}
	return maps, nil
}

func CategoryDetail(r *ghttp.Request) (interface{}, error) { return catSpec.Detail(r) }
func CategoryCreate(r *ghttp.Request) (interface{}, error) { return catSpec.Create(r) }
func CategoryUpdate(r *ghttp.Request) (interface{}, error) { return catSpec.Update(r) }
func CategoryDelete(r *ghttp.Request) (interface{}, error) { return catSpec.Delete(r) }

// uploadAllowedExt 上传扩展名白名单。
// 安全：原实现仅黑名单（php/exe/sh/bat），html/svg 等可被上传后在同源静态目录
// 被浏览器渲染为 XSS 载体。改为白名单后，可执行内容一律拒绝；
// svg 因可携带 script 虽常用于图标，仍从默认白名单移除（有需要可加入并配合 StaticGuard）。
var uploadAllowedExt = map[string]struct{}{
	"jpg": {}, "jpeg": {}, "png": {}, "gif": {}, "bmp": {}, "webp": {}, "ico": {},
	"txt": {}, "md": {}, "csv": {}, "pdf": {},
	"doc": {}, "docx": {}, "xls": {}, "xlsx": {}, "ppt": {}, "pptx": {}, "wps": {},
	"zip": {}, "rar": {}, "7z": {}, "gz": {},
	"mp4": {}, "mp3": {}, "wav": {}, "webm": {},
	"pem": {}, "crt": {},
}

func Upload(r *ghttp.Request) (interface{}, error) {
	file := r.GetUploadFile("file")
	if file == nil {
		return nil, biz.Bad("请选择要上传的文件")
	}
	if int(file.Size) > conf.MaxFileSize() {
		return nil, biz.Bad("文件过大")
	}
	ext := strings.ToLower(strings.TrimPrefix(filepath.Ext(file.Filename), "."))
	if _, ok := uploadAllowedExt[ext]; !ok {
		return nil, biz.Bad("不允许的文件类型")
	}
	day := time.Now().Format("2006/01/02")
	dir := filepath.Join(conf.UploadDir(), day)
	_ = os.MkdirAll(dir, 0o755)
	name := fmt.Sprintf("%d_%s.%s", time.Now().UnixMilli(), grand.S(8), ext)
	saved, err := file.Save(dir, false)
	if err != nil {
		return nil, err
	}
	final := filepath.Join(dir, name)
	// 落盘名与库里的记录必须一致：改名失败还往下走会让 URL 指向不存在的文件。
	if err := os.Rename(filepath.Join(dir, saved), final); err != nil {
		return nil, err
	}
	rel := filepath.ToSlash(filepath.Join(day, name))
	pub := PublicURL(day, name)
	u := ctxuser.Must(r)
	cid := gconv.Int(r.GetForm("category_id", 1))
	id, err := dbx.Model(dao.Table).Data(g.Map{
		"category_id": cid, "storage_mode": 1, "origin_name": gfile.Basename(file.Filename),
		"object_name": name, "mime_type": file.Header.Get("Content-Type"),
		"storage_path": rel, "suffix": ext, "size_byte": file.Size,
		"size_info": fmt.Sprintf("%.1fKB", float64(file.Size)/1024),
		"url":       pub, "created_by": u.ID, "create_time": dbx.Now(), "update_time": dbx.Now(),
	}).InsertAndGetId()
	if err != nil {
		return nil, err
	}
	rec, _ := dao.Model().Where("id", id).One()
	return decorateURLMap(dbx.ToMap(rec)), nil
}

func ChunkUpload(r *ghttp.Request) (interface{}, error) {
	return Upload(r)
}

func Download(r *ghttp.Request) {
	id := gconv.Int(r.Get("id"))
	rec, _ := dao.Model().Where("id", id).One()
	if rec.IsEmpty() {
		r.Response.WriteStatus(404)
		return
	}
	p := rec["storage_path"].String()
		candidates := []string{p, filepath.Join(conf.UploadDir(), p)}
		if day, name := dayAndName(p); day != "" {
			candidates = append(candidates, filepath.Join(conf.UploadDir(), day, name))
		}
		if day, name := dayAndName(rec["url"].String()); day != "" {
			candidates = append(candidates, filepath.Join(conf.UploadDir(), day, name))
		}
		found := p
		for _, c := range candidates {
			if c != "" && gfile.Exists(c) {
				found = c
				break
			}
		}
		r.Response.ServeFileDownload(found, rec["origin_name"].String())
	}
