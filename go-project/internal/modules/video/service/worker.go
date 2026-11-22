package service

import (
	"bufio"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strconv"
	"sync"
	"time"

	"fssadmin/go-project/internal/modules/video/dao"
	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/lrstanley/go-ytdlp"
)

type runningJob struct {
	cmd    *exec.Cmd
	cancel context.CancelFunc
}

var (
	jobsMu     sync.Mutex
	jobs       = map[int]*runningJob{}
	binOnce    sync.Once
	binPath    string
	binErr     error
	progressRe = regexp.MustCompile(`(\d+(?:\.\d+)?)%`)
	speedRe    = regexp.MustCompile(`at\s+(\S+/s)`)
)

// 并发上限：下载与元数据抓取各自一个信号量池，防止批量任务把 yt-dlp 进程开爆。
var (
	dlSemOnce   sync.Once
	downloadSem chan struct{}
	metaSemOnce sync.Once
	metaSem     chan struct{}
)

func slotPool(once *sync.Once, ch *chan struct{}, n int) chan struct{} {
	once.Do(func() {
		if n < 1 {
			n = 1
		}
		*ch = make(chan struct{}, n)
	})
	return *ch
}

func downloadSlot() chan struct{} {
	return slotPool(&dlSemOnce, &downloadSem, conf.VideoMaxConcurrent())
}

func metaSlot() chan struct{} {
	return slotPool(&metaSemOnce, &metaSem, conf.VideoMaxConcurrent())
}

func EnsureBin() (string, error) {
	binOnce.Do(func() {
		if p := os.Getenv("FSSADMIN_YTDLP_BIN"); p != "" {
			binPath = p
			return
		}
		if p, err := exec.LookPath("yt-dlp"); err == nil {
			binPath = p
			return
		}
		if p, err := exec.LookPath("yt-dlp.exe"); err == nil {
			binPath = p
			return
		}
		ctx, cancel := context.WithTimeout(context.Background(), 3*time.Minute)
		defer cancel()
		resolved, err := ytdlp.Install(ctx, nil)
		if err != nil {
			binErr = err
			return
		}
		binPath = resolved.Executable
	})
	return binPath, binErr
}

func fetchMeta(videoID int, url string) {
	sem := metaSlot()
	sem <- struct{}{}
	defer func() { <-sem }()
	bin, err := EnsureBin()
	if err != nil {
		_, _ = dao.Model().Where("id", videoID).Data(g.Map{
			"status": -1, "error_msg": err.Error(), "update_time": dbx.Now(),
		}).Update()
		return
	}
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Minute)
	defer cancel()
	// "--" 终止选项解析：防止以 "-" 开头的 URL 被当作 yt-dlp 选项（如 --exec）。
	cmd := exec.CommandContext(ctx, bin, "-J", "--no-warnings", "--no-download", "--", url)
	out, err := cmd.Output()
	if err != nil {
		msg := err.Error()
		if ee, ok := err.(*exec.ExitError); ok {
			msg = string(ee.Stderr)
			if len(msg) > 400 {
				msg = msg[:400]
			}
		}
		_, _ = dao.Model().Where("id", videoID).Data(g.Map{
			"status": -1, "error_msg": msg, "update_time": dbx.Now(),
		}).Update()
		return
	}
	var info map[string]interface{}
	if err := json.Unmarshal(out, &info); err != nil {
		_, _ = dao.Model().Where("id", videoID).Data(g.Map{
			"status": -1, "error_msg": "invalid yt-dlp json", "update_time": dbx.Now(),
		}).Update()
		return
	}
	title, _ := info["title"].(string)
	uploader, _ := info["uploader"].(string)
	if uploader == "" {
		uploader, _ = info["channel"].(string)
	}
	thumb, _ := info["thumbnail"].(string)
	extractor, _ := info["extractor_key"].(string)
	dur := 0
	switch v := info["duration"].(type) {
	case float64:
		dur = int(v)
	}
	w, h := 0, 0
	if v, ok := info["width"].(float64); ok {
		w = int(v)
	}
	if v, ok := info["height"].(float64); ok {
		h = int(v)
	}
	res := ""
	if w > 0 && h > 0 {
		res = fmt.Sprintf("%dx%d", w, h)
	}
	raw, _ := json.Marshal(slimInfo(info))
	_, _ = dao.Model().Where("id", videoID).Data(g.Map{
		"title": title, "uploader": uploader, "source": extractor,
		"thumbnail": thumb, "duration": dur, "best_resolution": res,
		"info_json": string(raw), "status": 1, "error_msg": nil, "update_time": dbx.Now(),
	}).Update()
}

func slimInfo(info map[string]interface{}) map[string]interface{} {
	keep := []string{"id", "title", "ext", "width", "height", "duration", "uploader", "channel", "thumbnail", "webpage_url", "extractor_key", "formats"}
	out := map[string]interface{}{}
	for _, k := range keep {
		if v, ok := info[k]; ok {
			out[k] = v
		}
	}
	if fmts, ok := info["formats"].([]interface{}); ok && len(fmts) > 40 {
		out["formats"] = fmts[:40]
	}
	return out
}

func startDownload(jobID, videoID int, url, mode string, opts map[string]interface{}) {
	// 并发上限：排队等待空闲槽位，避免每个请求无限开 yt-dlp 进程。
	sem := downloadSlot()
	sem <- struct{}{}
	defer func() { <-sem }()
	bin, err := EnsureBin()
	if err != nil {
		failJob(jobID, videoID, err.Error())
		return
	}
	dir := filepath.Join(conf.VideoDir(), fmt.Sprintf("%d_%d", videoID, jobID))
	_ = os.MkdirAll(dir, 0755)
	args := []string{"-P", dir, "--newline", "--no-warnings"}
	switch mode {
	case "audio":
		args = append(args, "-x", "--audio-format", "mp3")
	case "subs":
		args = append(args, "--skip-download", "--write-subs", "--write-auto-subs")
	default:
		if fid, _ := opts["format_id"].(string); fid != "" {
			af, _ := opts["audio_format"].(string)
			if af != "" {
				args = append(args, "-f", fid+"+"+af)
			} else {
				args = append(args, "-f", fid)
			}
		} else if h, ok := opts["height"]; ok {
			args = append(args, "-f", fmt.Sprintf("bv*[height<=%v]+ba/b", h))
		} else {
			args = append(args, "-f", "bv*+ba/b")
		}
	}
	// "--" 终止选项解析，防 URL 被当作 yt-dlp 选项注入。
	args = append(args, "--", url)
	// 单个下载总超时 2 小时：挂死的下载不再永久占用槽位与进程。
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Hour)
	defer cancel()
	cmd := exec.CommandContext(ctx, bin, args...)
	stdout, _ := cmd.StdoutPipe()
	stderr, _ := cmd.StderrPipe()
	// 先占位注册 cancel，再启动进程：消除 pause/stop 查不到 cancel 的窗口竞态。
	jobsMu.Lock()
	jobs[jobID] = &runningJob{cmd: cmd, cancel: cancel}
	jobsMu.Unlock()
	if err := cmd.Start(); err != nil {
		jobsMu.Lock()
		delete(jobs, jobID)
		jobsMu.Unlock()
		failJob(jobID, videoID, err.Error())
		return
	}
	_, _ = dao.JobModel().Where("id", jobID).Data(g.Map{
		"status": 1, "local_dir": dir, "started_at": dbx.Now(), "update_time": dbx.Now(),
	}).Update()
	_, _ = dao.Model().Where("id", videoID).Data(g.Map{
		"active_job_id": jobID, "local_dir": dir, "update_time": dbx.Now(),
	}).Update()
	g.Log().Infof(ctx, "[video-dl job=%d video=%d] start", jobID, videoID)
	go parseProgress(jobID, io.MultiReader(stdout, stderr))
	err = cmd.Wait()
	jobsMu.Lock()
	delete(jobs, jobID)
	jobsMu.Unlock()
	if ctx.Err() == context.DeadlineExceeded {
		g.Log().Warningf(ctx, "[video-dl job=%d] timeout", jobID)
		failJob(jobID, videoID, "下载超时（2 小时）")
		return
	}
	if ctx.Err() == context.Canceled {
		g.Log().Infof(ctx, "[video-dl job=%d] canceled", jobID)
		return
	}
	if err != nil {
		g.Log().Warningf(ctx, "[video-dl job=%d] fail %s", jobID, err)
		failJob(jobID, videoID, err.Error())
		return
	}
	g.Log().Infof(ctx, "[video-dl job=%d] 100%% done", jobID)
	_, _ = dao.JobModel().Where("id", jobID).Data(g.Map{
		"status": 3, "progress": 100, "finished_at": dbx.Now(), "update_time": dbx.Now(),
	}).Update()
	_, _ = dao.Model().Where("id", videoID).Data(g.Map{
		"local_dir": dir, "active_job_id": jobID, "update_time": dbx.Now(),
	}).Update()
}

func parseProgress(jobID int, r io.Reader) {
	sc := bufio.NewScanner(r)
	lastPct := -1
	var lastPrint time.Time
	var lastDB time.Time
	for sc.Scan() {
		line := sc.Text()
		prog := 0.0
		if m := progressRe.FindStringSubmatch(line); len(m) > 1 {
			prog, _ = strconv.ParseFloat(m[1], 64)
		}
		speed := ""
		if m := speedRe.FindStringSubmatch(line); len(m) > 1 {
			speed = m[1]
		}
		if prog > 0 {
			pct := int(prog)
			now := time.Now()
			// ponytail: \r 同行刷新；1% 或 300ms 节流，避免刷屏
			if pct != lastPct || now.Sub(lastPrint) >= 300*time.Millisecond {
				lastPct = pct
				lastPrint = now
			}
		}
		// DB 进度写节流：yt-dlp --newline 每个分片都输出一行，逐行 UPDATE 会形成写风暴。
		now := time.Now()
		if now.Sub(lastDB) < 300*time.Millisecond {
			continue
		}
		lastDB = now
		data := g.Map{"update_time": dbx.Now()}
		if prog > 0 {
			data["progress"] = prog
		}
		if speed != "" {
			data["speed"] = speed
		}
		_, _ = dao.JobModel().Where("id", jobID).Data(data).Update()
	}
}

func failJob(jobID, videoID int, msg string) {
	if len(msg) > 400 {
		msg = msg[:400]
	}
	_, _ = dao.JobModel().Where("id", jobID).Data(g.Map{
		"status": -1, "error_msg": msg, "finished_at": dbx.Now(), "update_time": dbx.Now(),
	}).Update()
}

func pauseJob(jobID int) {
	jobsMu.Lock()
	j := jobs[jobID]
	jobsMu.Unlock()
	if j != nil && j.cancel != nil {
		j.cancel()
	}
	_, _ = dao.JobModel().Where("id", jobID).Data(g.Map{"status": 2, "update_time": dbx.Now()}).Update()
}

func stopJob(jobID int) {
	jobsMu.Lock()
	j := jobs[jobID]
	jobsMu.Unlock()
	if j != nil && j.cancel != nil {
		j.cancel()
	}
	_, _ = dao.JobModel().Where("id", jobID).Data(g.Map{
		"status": 4, "finished_at": dbx.Now(), "update_time": dbx.Now(),
	}).Update()
}

func resumeJob(jobID int) {
	rec, err := dao.JobModel().Where("id", jobID).One()
	if err != nil || rec.IsEmpty() {
		return
	}
	vid := rec["video_id"].Int()
	v, _ := dao.Model().Where("id", vid).One()
	if v.IsEmpty() {
		return
	}
	opts := map[string]interface{}{}
	_ = json.Unmarshal([]byte(rec["options_json"].String()), &opts)
	_, _ = dao.JobModel().Where("id", jobID).Data(g.Map{"status": 0, "update_time": dbx.Now()}).Update()
	go startDownload(jobID, vid, v["url"].String(), rec["mode"].String(), opts)
}

func formatsFromJSON(raw string) []map[string]interface{} {
	if raw == "" {
		return nil
	}
	var info map[string]interface{}
	if json.Unmarshal([]byte(raw), &info) != nil {
		return nil
	}
	fmts, _ := info["formats"].([]interface{})
	out := make([]map[string]interface{}, 0, len(fmts))
	for _, f := range fmts {
		m, _ := f.(map[string]interface{})
		if m == nil {
			continue
		}
		out = append(out, m)
	}
	return out
}

func tenantID(u *ctxuser.User) int {
	if u != nil && u.TenantID > 0 {
		return u.TenantID
	}
	return 1
}
