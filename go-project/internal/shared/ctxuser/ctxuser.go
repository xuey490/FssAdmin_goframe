package ctxuser

import (
	"context"

	"github.com/gogf/gf/v2/net/ghttp"
)

type User struct {
	ID       int
	Username string
	Realname string
	Avatar   string
	IsSuper  bool
	Status   int
	DeptID   int
	TenantID int
	Token    string
}

const key = "auth.user"

func Set(r *ghttp.Request, u *User) { r.SetCtxVar(key, u) }

func Get(r *ghttp.Request) *User {
	v := r.GetCtxVar(key)
	if v == nil || v.IsNil() {
		return nil
	}
	if u, ok := v.Interface().(*User); ok {
		return u
	}
	return nil
}

func Must(r *ghttp.Request) *User {
	u := Get(r)
	if u == nil {
		return &User{}
	}
	return u
}

// FromCtx 从纯 context 中取当前用户。
// 中间件通过 SetCtxVar 写入的值会进入请求 context，后台任务
// （cronjob handler 等）拿不到 *ghttp.Request，只能从这里取。
// context.WithoutCancel 会保留 values，手工执行的任务也能取到触发者身份。
func FromCtx(ctx context.Context) (*User, bool) {
	if ctx == nil {
		return nil, false
	}
	if u, ok := ctx.Value(key).(*User); ok && u != nil {
		return u, true
	}
	return nil, false
}

// WithUser 把用户写入 context，供后台任务/测试构造带身份的 ctx。
func WithUser(ctx context.Context, u *User) context.Context {
	return context.WithValue(ctx, key, u)
}
