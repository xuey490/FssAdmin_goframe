package authkit

import (
	"context"
	"encoding/json"
	"strings"
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

func redisOK() bool {
	_, err := g.Redis().Do(context.Background(), "PING")
	return err == nil
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
			"login_type": "PC端", "token": at,
		}
		raw, _ := json.Marshal(sess)
		_, _ = g.Redis().Do(context.Background(), "SETEX", "token:session:"+sid, ttl, string(raw))
		_, _ = g.Redis().Do(context.Background(), "SADD", "token:user_sessions:"+itoa(ctx.UID), sid)
		_, _ = g.Redis().Do(context.Background(), "SETEX", "token:refresh:"+hashTok(rt), conf.RefreshTTL(), itoa(ctx.UID))
		_, _ = g.Redis().Do(context.Background(), "SETEX", "token:access:"+hashTok(at), ttl, sid)
	}
	return TokenPair{AccessToken: at, RefreshToken: rt, TokenType: "Bearer", ExpiresIn: ttl, TenantID: ctx.TenantID}, nil
}

func ParseAccess(token string) (*Claims, error) {
	tok, err := jwt.ParseWithClaims(token, &Claims{}, func(t *jwt.Token) (interface{}, error) {
		return []byte(conf.Secret()), nil
	})
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

func ResolveRefresh(refresh string) (int, string, error) {
	tok, err := jwt.Parse(refresh, func(t *jwt.Token) (interface{}, error) {
		return []byte(conf.Secret()), nil
	})
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
		_, _ = g.Redis().Do(context.Background(), "DEL", "token:refresh:"+hashTok(refresh))
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
}

func ListSessions() []map[string]interface{} {
	if !redisOK() {
		return []map[string]interface{}{}
	}
	keys, err := g.Redis().Do(context.Background(), "KEYS", "token:session:*")
	if err != nil {
		return []map[string]interface{}{}
	}
	out := []map[string]interface{}{}
	for _, k := range keys.Strings() {
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
		v, err := g.Redis().Do(context.Background(), "GET", "captcha:codes:"+uuid)
		_, _ = g.Redis().Do(context.Background(), "DEL", "captcha:codes:"+uuid)
		if err != nil || v.IsEmpty() {
			return false
		}
		return strings.EqualFold(v.String(), code)
	}
	got, ok := captchaMem.LoadAndDelete(uuid)
	if !ok {
		return false
	}
	return strings.EqualFold(got.(string), code)
}
