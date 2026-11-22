package authkit

import (
	"context"
	"encoding/json"
	"strings"
	"sync"
	"time"

	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/ctxuser"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/golang-jwt/jwt/v5"
)

type Claims struct {
	UID      int      `json:"uid"`
	Username string   `json:"username"`
	Nickname string   `json:"nickname"`
	TenantID int      `json:"tenant_id"`
	Roles    []string `json:"roles"`
	IsSuper  bool     `json:"is_super"`
	SID      string   `json:"sid"`
	jwt.RegisteredClaims
}

type TokenPair struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	TokenType    string `json:"token_type"`
	ExpiresIn    int    `json:"expires_in"`
	TenantID     int    `json:"tenant_id"`
}

type IssueCtx struct {
	UID           int
	Username      string
	Nickname      string
	TenantID      int
	Roles         []string
	IsSuper       bool
	IP            string
	DeptName      string
	OS            string
	Browser       string
	LoginLocation string
}

// redisOKCached 缓存 5 秒的 Redis 健康态，避免每个请求都先 PING 一次。
var (
	redisOKMu     sync.Mutex
	redisOKAt     time.Time
	redisOKResult bool
)

func redisOK() bool {
	redisOKMu.Lock()
	defer redisOKMu.Unlock()
	if time.Since(redisOKAt) < 5*time.Second {
		return redisOKResult
	}
	_, err := g.Redis().Do(context.Background(), "PING")
	redisOKAt = time.Now()
	redisOKResult = err == nil
	return redisOKResult
}

func Issue(ctx IssueCtx) (TokenPair, error) {
	ttl := conf.AccessTTL()
	sid := RandomHex(16)
	now := time.Now()
	access := jwt.NewWithClaims(jwt.SigningMethodHS256, Claims{
		UID:      ctx.UID,
		Username: ctx.Username,
		Nickname: ctx.Nickname,
		TenantID: ctx.TenantID,
		Roles:    ctx.Roles,
		IsSuper:  ctx.IsSuper,
		SID:      sid,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(now.Add(time.Duration(ttl) * time.Second)),
			IssuedAt:  jwt.NewNumericDate(now),
			ID:        sid,
		},
	})
	at, err := access.SignedString([]byte(conf.Secret()))
	if err != nil {
		return TokenPair{}, err
	}
	refresh := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"uid": ctx.UID, "typ": "refresh", "sid": sid,
		"exp": now.Add(time.Duration(conf.RefreshTTL()) * time.Second).Unix(),
	})
	rt, err := refresh.SignedString([]byte(conf.Secret()))
	if err != nil {
		return TokenPair{}, err
	}
	if redisOK() {
		sess := map[string]interface{}{
			"tokenId": sid, "session_id": sid, "userName": ctx.Username, "user_name": ctx.Username,
			"name": ctx.Nickname, "deptName": ctx.DeptName, "dept_name": ctx.DeptName,
			"user_id": ctx.UID, "tenant_id": ctx.TenantID, "is_superuser": ctx.IsSuper,
			"ipaddr": ctx.IP, "loginLocation": ctx.LoginLocation, "login_location": ctx.LoginLocation,
			"os": ctx.OS, "browser": ctx.Browser,
			"loginTime": now.Format("2006-01-02 15:04:05"), "login_time": now.Format("2006-01-02 15:04:05"),
			"login_type": "PC端",
		}
		// 安全：会话中不存原始 token（Redis 浏览器/运维接口可能读取任意 key 的值）。
		raw, _ := json.Marshal(sess)
		_, _ = g.Redis().Do(context.Background(), "SETEX", "token:session:"+sid, ttl, string(raw))
		_, _ = g.Redis().Do(context.Background(), "SADD", "token:user_sessions:"+itoa(ctx.UID), sid)
		// 会话集合跟随 access TTL 过期，防止登出未 SREM 导致集合无限增长。
		_, _ = g.Redis().Do(context.Background(), "EXPIRE", "token:user_sessions:"+itoa(ctx.UID), ttl)
		_, _ = g.Redis().Do(context.Background(), "SETEX", "token:refresh:"+hashTok(rt), conf.RefreshTTL(), itoa(ctx.UID))
		// 记录该用户名下的 refresh 键，供禁用/踢人时统一吊销。
		_, _ = g.Redis().Do(context.Background(), "SADD", "token:user_refreshes:"+itoa(ctx.UID), hashTok(rt))
		_, _ = g.Redis().Do(context.Background(), "EXPIRE", "token:user_refreshes:"+itoa(ctx.UID), conf.RefreshTTL())
		_, _ = g.Redis().Do(context.Background(), "SETEX", "token:access:"+hashTok(at), ttl, sid)
	}
	return TokenPair{AccessToken: at, RefreshToken: rt, TokenType: "Bearer", ExpiresIn: ttl, TenantID: ctx.TenantID}, nil
}

func ParseAccess(token string) (*Claims, error) {
	// 显式固定签名算法，防算法混淆（none/RS256 等）。
	tok, err := jwt.ParseWithClaims(token, &Claims{}, func(t *jwt.Token) (interface{}, error) {
		return []byte(conf.Secret()), nil
	}, jwt.WithValidMethods([]string{"HS256"}))
	if err != nil {
		return nil, err
	}
	c, ok := tok.Claims.(*Claims)
	if !ok || !tok.Valid {
		return nil, jwt.ErrTokenInvalidClaims
	}
	if redisOK() {
		v, err := g.Redis().Do(context.Background(), "GET", "token:session:"+c.SID)
		if err == nil && v.IsEmpty() {
			// session missing: still accept JWT unless explicitly kicked (key deleted)
		}
		kicked, _ := g.Redis().Do(context.Background(), "GET", "token:kick:"+c.SID)
		if kicked != nil && !kicked.IsEmpty() {
			return nil, jwt.ErrTokenNotValidYet
		}
	}
	return c, nil
}

// getDelScript 原子 GET+DEL：refresh token 与验证码的一次性消费。
// Redis >= 2.6 支持 EVAL，兼容旧版本无需 GETDEL 命令。
var getDelScript = `local v = redis.call('GET', KEYS[1])
if v then redis.call('DEL', KEYS[1]) end
return v`

func getDelKey(key string) (string, bool) {
	v, err := g.Redis().Do(context.Background(), "EVAL", getDelScript, "1", key)
	if err != nil || v == nil || v.IsEmpty() {
		return "", false
	}
	return v.String(), true
}

func ResolveRefresh(refresh string) (int, string, error) {
	tok, err := jwt.Parse(refresh, func(t *jwt.Token) (interface{}, error) {
		return []byte(conf.Secret()), nil
	}, jwt.WithValidMethods([]string{"HS256"}))
	if err != nil || !tok.Valid {
		return 0, "", err
	}
	m, _ := tok.Claims.(jwt.MapClaims)
	uid := 0
	sid := ""
	if v, ok := m["uid"]; ok {
		switch t := v.(type) {
		case float64:
			uid = int(t)
		}
	}
	if v, ok := m["sid"].(string); ok {
		sid = v
	}
	if redisOK() {
		// 一次性消费：原子 GETDEL。键不存在说明已被使用/吊销 → 拒绝重放。
		if _, ok := getDelKey("token:refresh:" + hashTok(refresh)); !ok {
			return 0, "", jwt.ErrTokenExpired
		}
		// 会话已被强制下线时 refresh 一并失效。
		if sid != "" {
			kicked, _ := g.Redis().Do(context.Background(), "GET", "token:kick:"+sid)
			if kicked != nil && !kicked.IsEmpty() {
				return 0, "", jwt.ErrTokenNotValidYet
			}
		}
	}
	return uid, sid, nil
}

func Invalidate(token string) {
	c, err := ParseAccess(token)
	if err != nil || c == nil {
		return
	}
	if redisOK() {
		_, _ = g.Redis().Do(context.Background(), "DEL", "token:session:"+c.SID)
		_, _ = g.Redis().Do(context.Background(), "SETEX", "token:kick:"+c.SID, conf.AccessTTL(), "1")
	}
}

func InvalidateUser(uid int) {
	if !redisOK() {
		return
	}
	v, err := g.Redis().Do(context.Background(), "SMEMBERS", "token:user_sessions:"+itoa(uid))
	if err != nil {
		return
	}
	for _, sid := range v.Strings() {
		_, _ = g.Redis().Do(context.Background(), "DEL", "token:session:"+sid)
		_, _ = g.Redis().Do(context.Background(), "SETEX", "token:kick:"+sid, conf.AccessTTL(), "1")
	}
	_, _ = g.Redis().Do(context.Background(), "DEL", "token:user_sessions:"+itoa(uid))
	// 同时吊销该用户全部 refresh token，防止被踢用户用旧 refresh 重新换取会话。
	rv, err := g.Redis().Do(context.Background(), "SMEMBERS", "token:user_refreshes:"+itoa(uid))
	if err == nil {
		for _, h := range rv.Strings() {
			_, _ = g.Redis().Do(context.Background(), "DEL", "token:refresh:"+h)
		}
	}
	_, _ = g.Redis().Do(context.Background(), "DEL", "token:user_refreshes:"+itoa(uid))
}

// scanKeys 用 SCAN 渐进式遍历代替 KEYS，避免在键空间大时阻塞整个 Redis。
func scanKeys(pattern string) []string {
	var out []string
	cursor := "0"
	for {
		v, err := g.Redis().Do(context.Background(), "SCAN", cursor, "MATCH", pattern, "COUNT", "200")
		if err != nil {
			return out
		}
		// SCAN 回复为 [cursor, [key...]] 的嵌套数组。
		vars := v.Vars()
		if len(vars) < 2 {
			return out
		}
		cursor = vars[0].String()
		for _, k := range vars[1].Vars() {
			out = append(out, k.String())
		}
		if cursor == "0" || cursor == "" {
			return out
		}
	}
}

func ListSessions() []map[string]interface{} {
	if !redisOK() {
		return []map[string]interface{}{}
	}
	keys := scanKeys("token:session:*")
	out := []map[string]interface{}{}
	for _, k := range keys {
		raw, err := g.Redis().Do(context.Background(), "GET", k)
		if err != nil || raw.IsEmpty() {
			continue
		}
		m := map[string]interface{}{}
		if json.Unmarshal([]byte(raw.String()), &m) == nil {
			out = append(out, m)
		}
	}
	return out
}

func DeleteSession(sid string) {
	if redisOK() {
		_, _ = g.Redis().Do(context.Background(), "DEL", "token:session:"+sid)
		_, _ = g.Redis().Do(context.Background(), "SETEX", "token:kick:"+sid, conf.AccessTTL(), "1")
	}
}

func FromClaims(c *Claims, token string) *ctxuser.User {
	return &ctxuser.User{
		ID: c.UID, Username: c.Username, Realname: c.Nickname,
		IsSuper: c.IsSuper, TenantID: c.TenantID, Token: token, Status: 1,
	}
}

func Bearer(header string) string {
	if strings.HasPrefix(strings.ToLower(header), "bearer ") {
		return strings.TrimSpace(header[7:])
	}
	return ""
}

func hashTok(s string) string {
	if len(s) > 32 {
		return s[len(s)-32:]
	}
	return s
}

func itoa(i int) string {
	return strings.TrimSpace(strings.ReplaceAll(g.NewVar(i).String(), " ", ""))
}

func SetCaptcha(uuid, code string) {
	if redisOK() {
		_, _ = g.Redis().Do(context.Background(), "SETEX", "captcha:codes:"+uuid, conf.CaptchaExpire(), strings.ToLower(code))
		return
	}
	captchaMem.Store(uuid, strings.ToLower(code))
}

func VerifyCaptcha(uuid, code string) bool {
	if !conf.CaptchaEnable() {
		return true
	}
	uuid = strings.TrimSpace(uuid)
	code = strings.ToLower(strings.TrimSpace(code))
	if uuid == "" || code == "" {
		return false
	}
	if redisOK() {
		// 原子 GET+DEL：防止并发请求在 DEL 生效前重复读取同一验证码爆破密码。
		v, ok := getDelKey("captcha:codes:" + uuid)
		if !ok {
			return false
		}
		return strings.EqualFold(v, code)
	}
	got, ok := captchaMem.LoadAndDelete(uuid)
	if !ok {
		return false
	}
	return strings.EqualFold(got.(string), code)
}
