package service

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"fssadmin/go-project/internal/modules/video/dao"
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"
	"fssadmin/go-project/internal/shared/page"
	"fssadmin/go-project/internal/shared/reqx"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/util/gconv"
)

func List(r *ghttp.Request) (interface{}, error) {
	pg, limit := page.Parse(r)
	m := dao.Model()
	q := reqx.Merge(r)
	m = dbx.FilterLike(m, "title", reqx.Str(q, "title"))
	m = dbx.FilterLike(m, "url", reqx.Str(q, "url"))
	if st := reqx.Str(q, "status"); st != "" {
		m = m.Where("status", st)
	}
	total, _ := m.Clone().Count()
	rows, err := m.Order("id desc").Page(pg, limit).All()
	if err != nil {
		return nil, err
	}
	return response.PageNo(dbx.ToMaps(rows), total, pg, limit), nil
}

func Progress(r *ghttp.Request) (interface{}, error) {
	ids := reqx.Ints(reqx.Merge(r), "ids")
	if s := r.Get("ids").String(); s != "" && len(ids) == 0 {
		ids = reqx.Ints(g.Map{"ids": s}, "ids")
	}
	if len(ids) == 0 {
		return []g.Map{}, nil
	}
	videos, _ := dao.Model().WhereIn("id", ids).All()
	out := []g.Map{}
	for _, v := range videos {
		item := g.Map{
			"video_id": v["id"].Int(), "status": v["status"].Int(),
			"title": v["title"].String(), "uploader": v["uploader"].String(),
			"source": v["source"].String(), "best_resolution": v["best_resolution"].String(),
			"thumbnail": v["thumbnail"].String(), "duration": v["duration"].Int(),
			"error_msg": v["error_msg"].String(), "active_job_id": v["active_job_id"].Int(),
			"local_dir": v["local_dir"].String(),
		}
		jid := v["active_job_id"].Int()
		if jid > 0 {
			job, _ := dao.JobModel().Where("id", jid).One()
			if !job.IsEmpty() {
				item["active_job_status"] = job["status"].Int()
				item["job_status"] = job["status"].Int()
				item["job_progress"] = job["progress"].Float64()
				item["job_speed"] = job["speed"].String()
				item["job_mode"] = job["mode"].String()
				item["job_error_msg"] = job["error_msg"].String()
				item["job_local_dir"] = job["local_dir"].String()
			}
		}
		out = append(out, item)
	}
	return out, nil
}

func Create(r *ghttp.Request) (interface{}, error) {
	m := reqx.Merge(r)
	urls := gconv.Strings(m["urls"])
	if u := reqx.Str(m, "url"); u != "" {
		urls = append(urls, u)
	}
	enqueue := gconv.Bool(m["enqueue"])
	tid := tenantID(ctxuser.Get(r))
	created := []g.Map{}
	for _, url := range urls {
		url = strings.TrimSpace(url)
		if url == "" {
			continue
		}
		id, err := dbx.Model(dao.Table).Data(g.Map{
			"url": url, "status": 0, "tenant_id": tid,
			"create_time": dbx.Now(), "update_time": dbx.Now(),
		}).InsertAndGetId()
		if err != nil {
			return nil, err
		}
		go fetchMeta(int(id), url)
		if enqueue {
			EnqueueDownload(int(id), "best", nil)
		}
		rec, _ := dao.Model().Where("id", id).One()
		created = append(created, dbx.ToMap(rec))
	}
	return created, nil
}

func Update(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	url := reqx.Str(reqx.Merge(r), "url")
	if url == "" {
		return nil, biz.Bad("url 必填")
	}
	_, err := dao.Model().Where("id", id).Data(g.Map{
		"url": url, "status": 0, "title": nil, "error_msg": nil, "update_time": dbx.Now(),
	}).Update()
	if err != nil {
		return nil, err
	}
	go fetchMeta(id, url)
	rec, _ := dao.Model().Where("id", id).One()
	return dbx.ToMap(rec), nil
}

func Refresh(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	rec, err := dao.Model().Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("视频不存在")
	}
	_, _ = dao.Model().Where("id", id).Data(g.Map{"status": 0, "update_time": dbx.Now()}).Update()
	go fetchMeta(id, rec["url"].String())
	return g.Map{"ok": true}, nil
}

func Delete(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	return g.Map{}, dbx.SoftDeleteIDs(dao.Table, []int{id})
}

func Preview(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	rec, err := dao.Model().Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("视频不存在")
	}
	fmts := formatsFromJSON(rec["info_json"].String())
	qualities := []g.Map{}
	for _, f := range fmts {
		u, _ := f["url"].(string)
		if u == "" {
			continue
		}
		h, _ := f["height"].(float64)
		label := gconv.String(f["format_note"])
		if label == "" {
			label = gconv.String(f["format_id"])
		}
		qualities = append(qualities, g.Map{
			"label": label, "height": int(h), "url": u, "format_id": f["format_id"],
		})
		if len(qualities) >= 8 {
			break
		}
	}
	return g.Map{
		"stream_url": fmt.Sprintf("/api/platform/video/stream/%d", id),
		"page_url":   rec["url"].String(),
		"thumbnail":  rec["thumbnail"].String(),
		"title":      rec["title"].String(),
		"qualities":  qualities,
	}, nil
}

func Formats(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	rec, err := dao.Model().Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("视频不存在")
	}
	return formatsFromJSON(rec["info_json"].String()), nil
}

func LocalFiles(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	rec, err := dao.Model().Where("id", id).One()
	if err != nil || rec.IsEmpty() {
		return nil, biz.NotFound("视频不存在")
	}
	dir := rec["local_dir"].String()
	files := []g.Map{}
	if dir != "" {
		entries, _ := os.ReadDir(dir)
		for _, e := range entries {
			if e.IsDir() {
				continue
			}
			info, _ := e.Info()
			size := int64(0)
			mtime := ""
			if info != nil {
				size = info.Size()
				mtime = info.ModTime().Format("2006-01-02 15:04:05")
			}
			files = append(files, g.Map{
				"name": e.Name(), "size": size, "mtime": mtime,
				"ext": strings.TrimPrefix(filepath.Ext(e.Name()), "."),
				"url": fmt.Sprintf("/api/platform/video/stream/%d?file=%s", id, e.Name()),
			})
		}
	}
	return g.Map{"local_dir": dir, "title": rec["title"].String(), "files": files}, nil
}

func EnqueueDownload(videoID int, mode string, opts map[string]interface{}) int {
	if mode == "" {
		mode = "best"
	}
	raw, _ := json.Marshal(opts)
	tid := 1
	v, _ := dao.Model().Where("id", videoID).One()
	if !v.IsEmpty() {
		tid = v["tenant_id"].Int()
	}
	id, err := dbx.Model(dao.JobTable).Data(g.Map{
		"video_id": videoID, "mode": mode, "options_json": string(raw),
		"status": 0, "progress": 0, "downloaded_bytes": 0, "priority": 0,
		"tenant_id": tid, "create_time": dbx.Now(), "update_time": dbx.Now(),
	}).InsertAndGetId()
	if err != nil {
		return 0
	}
	url := ""
	if !v.IsEmpty() {
		url = v["url"].String()
	}
	go startDownload(int(id), videoID, url, mode, opts)
	return int(id)
}

func Download(r *ghttp.Request) (interface{}, error) {
	id := r.Get("id").Int()
	m := reqx.Merge(r)
	mode := reqx.Str(m, "mode")
	if mode == "" {
		mode = "best"
	}
	opts := map[string]interface{}{}
	for k, v := range m {
		if k != "mode" && k != "id" {
			opts[k] = v
		}
	}
	jid := EnqueueDownload(id, mode, opts)
	return g.Map{"job_id": jid}, nil
}

func Queue(r *ghttp.Request) (interface{}, error) {
	pg, limit := page.Parse(r)
	m := dao.JobModel()
	q := reqx.Merge(r)
	if vid := reqx.Int(q, "video_id"); vid > 0 {
		m = m.Where("video_id", vid)
	}
	if st := reqx.Str(q, "status"); st != "" {
		m = m.Where("status", st)
	}
	total, _ := m.Clone().Count()
	rows, err := m.Order("id desc").Page(pg, limit).All()
	if err != nil {
		return nil, err
	}
	return response.PageNo(dbx.ToMaps(rows), total, pg, limit), nil
}

func PauseJob(r *ghttp.Request) (interface{}, error) {
	pauseJob(r.Get("jobId").Int())
	return g.Map{"ok": true}, nil
}
func ResumeJob(r *ghttp.Request) (interface{}, error) {
	resumeJob(r.Get("jobId").Int())
	return g.Map{"ok": true}, nil
}
func StopJob(r *ghttp.Request) (interface{}, error) {
	stopJob(r.Get("jobId").Int())
	return g.Map{"ok": true}, nil
}
func PauseAll(r *ghttp.Request) (interface{}, error) {
	rows, _ := dao.JobModel().WhereIn("status", g.Slice{0, 1}).Fields("id").All()
	for _, rec := range rows {
		pauseJob(rec["id"].Int())
	}
	return g.Map{"ok": true}, nil
}
func ResumeAll(r *ghttp.Request) (interface{}, error) {
	rows, _ := dao.JobModel().Where("status", 2).Fields("id").All()
	for _, rec := range rows {
		resumeJob(rec["id"].Int())
	}
	return g.Map{"ok": true}, nil
}

func Stream(r *ghttp.Request) {
	id := r.Get("id").Int()
	rec, _ := dao.Model().Where("id", id).One()
	if rec.IsEmpty() {
		r.Response.WriteStatus(404)
		return
	}
	dir := rec["local_dir"].String()
	name := r.Get("file").String()
	path := ""
	if dir != "" {
		if name != "" {
			path = filepath.Join(dir, filepath.Base(name))
		} else {
			entries, _ := os.ReadDir(dir)
			for _, e := range entries {
				if !e.IsDir() {
					path = filepath.Join(dir, e.Name())
					break
				}
			}
		}
	}
	if path != "" && fileExists(path) {
		serveRange(r, path)
		return
	}
	raw := rec["info_json"].String()
	fmts := formatsFromJSON(raw)
	for _, f := range fmts {
		u, _ := f["url"].(string)
		if u != "" {
			http.Redirect(r.Response.Writer, r.Request, u, http.StatusFound)
			return
		}
	}
	r.Response.WriteStatus(404)
}

func fileExists(p string) bool {
	st, err := os.Stat(p)
	return err == nil && !st.IsDir()
}

func serveRange(r *ghttp.Request, path string) {
	f, err := os.Open(path)
	if err != nil {
		r.Response.WriteStatus(404)
		return
	}
	defer f.Close()
	st, _ := f.Stat()
	size := st.Size()
	rng := r.Header.Get("Range")
	r.Response.Header().Set("Accept-Ranges", "bytes")
	r.Response.Header().Set("Content-Type", "video/mp4")
	if rng == "" {
		r.Response.Header().Set("Content-Length", fmt.Sprintf("%d", size))
		r.Response.WriteStatus(200)
		_, _ = io.Copy(r.Response.Writer, f)
		return
	}
	var start, end int64
	end = size - 1
	fmt.Sscanf(rng, "bytes=%d-%d", &start, &end)
	if start < 0 {
		start = 0
	}
	if end <= 0 || end >= size {
		end = size - 1
	}
	if start > end {
		r.Response.WriteStatus(416)
		return
	}
	length := end - start + 1
	r.Response.Header().Set("Content-Range", fmt.Sprintf("bytes %d-%d/%d", start, end, size))
	r.Response.Header().Set("Content-Length", fmt.Sprintf("%d", length))
	r.Response.WriteStatus(206)
	_, _ = f.Seek(start, 0)
	_, _ = io.CopyN(r.Response.Writer, f, length)
}
