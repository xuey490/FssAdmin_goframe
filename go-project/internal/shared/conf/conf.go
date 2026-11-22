package conf

import (
	"strings"

	"github.com/gogf/gf/v2/container/gvar"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gcfg"
	"github.com/gogf/gf/v2/os/gctx"
)

func get(path string, def ...interface{}) string {
	v, err := gcfg.Instance().Get(gctx.New(), path)
	if err != nil || v.IsEmpty() {
		if len(def) > 0 {
			return g.NewVar(def[0]).String()
		}
		return ""
	}
	return v.String()
}

func getInt(path string, def int) int {
	v, err := gcfg.Instance().Get(gctx.New(), path)
	if err != nil || v.IsEmpty() {
		return def
	}
	return v.Int()
}

func getBool(path string, def bool) bool {
	v, err := gcfg.Instance().Get(gctx.New(), path)
	return boolOr(v, err, def)
}

// boolOr 不用 IsEmpty：gvar 把 false 当成空，显式 false 会被默认 true 盖掉。
func boolOr(v *gvar.Var, err error, def bool) bool {
	if err != nil || v == nil || v.IsNil() {
		return def
	}
	return v.Bool()
}

func Secret() string        { return get("app.secretKey", "fssadmin-dev-secret") }
func AccessTTL() int        { return getInt("app.accessTTL", 7200) }
func RefreshTTL() int       { return getInt("app.refreshTTL", 43200) }
func SessionType() string   { return get("app.sessionType", "jwt") }
func CaptchaEnable() bool   { return getBool("app.captchaEnable", true) }
func CaptchaExpire() int    { return getInt("app.captchaExpire", 600) }
func DemoEnable() bool      { return getBool("app.demoEnable", false) }
func Debug() bool           { return getBool("app.debug", false) }
func CORSEnable() bool      { return getBool("app.corsEnable", true) }
func CORSMaxAge() int       { return getInt("app.corsMaxAge", 600) }
func CSRFEnable() bool      { return getBool("app.csrfEnable", true) }
func GzipEnable() bool      { return getBool("app.gzipEnable", true) }
func XSSEnable() bool       { return getBool("app.xssEnable", true) }
func SchedulerOn() bool     { return getBool("app.schedulerEnable", false) }
func RateLimitOn() bool     { return getBool("app.rateLimitEnable", false) }
func RateLimitTimes() int   { return getInt("app.rateLimitTimes", 1000) }
func RateLimitSeconds() int { return getInt("app.rateLimitSeconds", 60) }
func RateLimitPrefix() string {
	return get("app.rateLimitPrefix", "fssadmin:rl:")
}
func UploadDir() string  { return get("app.uploadDir", "static/upload") }

// UploadDomain 附件对外域名，空则返回相对路径（由当前站点 / 反代提供）。
func UploadDomain() string { return strings.TrimRight(strings.TrimSpace(get("app.uploadDomain", "")), "/") }

// UploadPublicPrefix 附件对外 URL 前缀。磁盘仍是 uploadDir，Apache 把此前缀 rewrite/反代过来。
func UploadPublicPrefix() string {
	p := strings.TrimSpace(get("app.uploadPublicPrefix", "/profile/static/upload"))
	if p == "" {
		p = "/static/upload"
	}
	p = "/" + strings.Trim(p, "/")
	return p
}
func VideoDir() string { return get("app.videoDir", "static/videos") }

// VideoMaxConcurrent 同一时刻 yt-dlp 下载/元数据抓取的最大并发进程数。
func VideoMaxConcurrent() int { return getInt("app.videoMaxConcurrent", 2) }
func BackupDir() string       { return get("app.backupDir", "static/bakup") }
func BackupCron() string { return get("app.backupCron", "0 0 2 * * *") }
func RestoreFile() string {
	return get("app.restoreFile", "static/restore/init.sql")
}
func CacheExpire() int   { return getInt("cache.expire", 3600) }
func CachePrefix() string {
	p := get("cache.prefix", "cache")
	if p == "" {
		return "cache"
	}
	return p
}
func LogStack() bool { return getInt("logger.stStatus", 1) != 0 }

// ShellTaskEnable 是否允许 shell_command 任务类型执行服务器命令。
// 安全默认关闭：shell 任务等同 RCE，须显式开启并配合权限中间件 + 超管身份。
func ShellTaskEnable() bool { return getBool("app.shellTaskEnable", false) }

// TrustedProxies 可信代理 CIDR/IP 列表。
// 仅当直连地址命中该列表时才信任 X-Forwarded-For / X-Real-IP，
// 默认信任本机回环（本机 Nginx 反代的典型部署）；直连客户端伪造的头会被忽略。
func TrustedProxies() []string { return csv("app.trustedProxies", "127.0.0.1,::1") }

// PublicConfigKeys 允许免登录读取的系统配置 key（/core/config/public/:key）。
// 未列入的 key 一律拒绝，防止枚举 SMTP 密码等敏感配置。
func PublicConfigKeys() []string {
	return csv("app.publicConfigKeys", "site_name,site_logo,site_desc,site_keywords,site_copyright,site_record_number")
}

// LoginMaxFails 连续登录失败锁定阈值（按 用户名+租户 维度计数，Redis）。
func LoginMaxFails() int { return getInt("app.loginMaxFails", 5) }

// LoginLockSeconds 登录失败达到阈值后的锁定秒数。
func LoginLockSeconds() int { return getInt("app.loginLockSeconds", 600) }

// IP 归属地解析：登录/在线用户列表用。
// 关闭后不再请求外网，仅标注「内网IP」或「未解析(已关闭归属地查询)」。
func IPLocationEnable() bool { return getBool("app.ipLocationEnable", true) }

// IPLocationCacheHours 归属地缓存时长（小时），IP 属地几乎不变，默认 7 天。
func IPLocationCacheHours() int { return getInt("app.ipLocationCacheHours", 168) }

// IPLocationTimeout 单次外网归属地查询的硬超时（秒）。
func IPLocationTimeout() int { return getInt("app.ipLocationTimeout", 3) }

func MaxFileSize() int { return getInt("app.maxFileSize", 10*1024*1024) }
func Timezone() string { return get("app.timezone", "Asia/Shanghai") }

func AppName() string    { return get("app.name", "FssAdmin") }
func AppVersion() string { return get("app.version", "0.0.0") }

func ServerAddress() string { return get("server.address", "127.0.0.1:8181") }
func OpenapiPath() string   { return get("server.openapiPath", "/api.json") }
func SwaggerPath() string   { return get("server.swaggerPath", "/docs") }

func RedisAddress() string { return get("redis.default.address", "127.0.0.1:6379") }
func RedisDB() int         { return getInt("redis.default.db", 0) }

// 日志滚动：单文件超过 rotateSize 自动分割，备份数量与保留期可配。
// 大小支持 10MB / 512KB 这类写法，时长支持 Go 间隔写法（720h）。
func LogRotateSize() string { return get("logger.rotateSize", "10MB") }
func LogRotateBackupLimit() int {
	return getInt("logger.rotateBackupLimit", 30)
}
func LogRotateBackupExpire() string { return get("logger.rotateBackupExpire", "720h") }
func LogRotateCheckInterval() string {
	return get("logger.rotateCheckInterval", "1h")
}
func IPWhiteList() []string {
	return csv("app.ipWhiteList", "")
}
func IPBlackList() []string {
	return csv("app.ipBlackList", "")
}

func CORSOrigins() []string {
	return csv("app.corsOrigins", "*")
}

func TenantWhitelist() []string {
	return csv("app.tenantWhitelist", "/core/login,/core/captcha")
}

func csv(path, def string) []string {
	raw := get(path, def)
	parts := strings.Split(raw, ",")
	out := make([]string, 0, len(parts))
	for _, p := range parts {
		p = strings.TrimSpace(p)
		if p != "" {
			out = append(out, p)
		}
	}
	return out
}
