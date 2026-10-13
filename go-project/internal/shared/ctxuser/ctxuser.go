package ctxuser

import (
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
