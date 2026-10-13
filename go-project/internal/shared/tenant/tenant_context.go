// Package tenant 提供请求级的租户上下文管理，对标 PHP TenantContext。
//
// 核心能力：
//   - FromContext: 从 context 提取当前租户 ID
//   - WithIgnore: 闭包内临时忽略租户隔离（超管模式）
//   - ShouldApply: 判断是否启用租户隔离
package tenant

import (
	"context"

	"fssadmin/go-project/internal/shared/ctxuser"

	"github.com/gogf/gf/v2/net/ghttp"
)

// ctxKey 用作 context.Context 的键，避免冲突
type ctxKey struct{}

const keyStr = "tenant.context"

// tenantCtx 租户上下文数据
type tenantCtx struct {
	TenantID int  // 当前租户 ID
	Ignore   bool // 是否忽略租户隔离（超管或 WithIgnore 时为 true）
}

// WithContext 将租户上下文写入 context.Context。
// 主要由 middleware.Auth 调用，登录后设置。
func WithContext(ctx context.Context, tenantID int, isSuper bool) context.Context {
	tc := &tenantCtx{
		TenantID: tenantID,
		Ignore:   isSuper,
	}
	return context.WithValue(ctx, ctxKey{}, tc)
}

// SetToRequest 将租户上下文写入 ghttp.Request 的上下文中。
// 供 middleware.Auth 调用，对标 PHP TenantContext 请求级设置。
func SetToRequest(r *ghttp.Request, tenantID int, isSuper bool) {
	r.SetCtxVar(keyStr, &tenantCtx{
		TenantID: tenantID,
		Ignore:   isSuper,
	})
}

// FromContext 从 context.Context 提取租户上下文。
// 如果不存在则返回零值（TenantID=0, Ignore=false）。
func FromContext(ctx context.Context) *tenantCtx {
	v := ctx.Value(ctxKey{})
	if v == nil {
		return &tenantCtx{}
	}
	if tc, ok := v.(*tenantCtx); ok {
		return tc
	}
	return &tenantCtx{}
}

// FromRequest 从 ghttp.Request 提取租户上下文。
// 优先从 GoFrame 请求上下文获取（SetCtxVar 设置的），兜底从 ctxuser 获取。
func FromRequest(r *ghttp.Request) *tenantCtx {
	// 优先从 GoFrame 的请求上下文获取
	v := r.GetCtxVar(keyStr)
	if v != nil && !v.IsNil() {
		if tc, ok := v.Interface().(*tenantCtx); ok && tc != nil {
			return tc
		}
	}
	// 兜底：从 ctxuser 获取
	u := ctxuser.Get(r)
	if u != nil {
		return &tenantCtx{
			TenantID: u.TenantID,
			Ignore:   u.IsSuper,
		}
	}
	return &tenantCtx{}
}

// ShouldApply 判断是否应该启用租户隔离。
// 返回 false 时（超管或 WithIgnore），查询不加租户条件。
// 对标 PHP shouldApplyTenant。
func ShouldApply(ctx context.Context) bool {
	tc := FromContext(ctx)
	if tc.Ignore {
		return false
	}
	return tc.TenantID > 0
}

// ShouldApplyRequest 与 ShouldApply 相同，但接受 *ghttp.Request。
func ShouldApplyRequest(r *ghttp.Request) bool {
	return ShouldApply(r.Context())
}

// TenantID 从 context.Context 获取当前租户 ID。
func TenantID(ctx context.Context) int {
	return FromContext(ctx).TenantID
}

// TenantIDFromRequest 从 *ghttp.Request 获取当前租户 ID。
func TenantIDFromRequest(r *ghttp.Request) int {
	return FromRequest(r).TenantID
}

// IsIgnore 判断当前上下文是否处于忽略租户隔离状态（超管模式）。
func IsIgnore(ctx context.Context) bool {
	return FromContext(ctx).Ignore
}

// IsIgnoreRequest 与 IsIgnore 相同，但接受 *ghttp.Request。
func IsIgnoreRequest(r *ghttp.Request) bool {
	return FromRequest(r).Ignore
}

// WithIgnore 在闭包 fn 内临时忽略租户隔离，对标 PHP TenantContext::ignore() / withIgnore()。
// 闭包执行完毕后恢复原上下文。
//
// 用法:
//
//	tenant.WithIgnore(r.Context(), func(ctx context.Context) error {
//	    // 此闭包内的查询不受租户隔离限制
//	    _, err := dbx.Model("some_table").Ctx(ctx).All()
//	    return err
//	})
func WithIgnore(ctx context.Context, fn func(ctx context.Context) error) error {
	tc := FromContext(ctx)
	ignoreCtx := context.WithValue(ctx, ctxKey{}, &tenantCtx{
		TenantID: tc.TenantID,
		Ignore:   true,
	})
	return fn(ignoreCtx)
}

// WithIgnoreRequest 在闭包 fn 内临时忽略租户隔离（接受 *ghttp.Request）。
func WithIgnoreRequest(r *ghttp.Request, fn func(ctx context.Context) error) error {
	return WithIgnore(r.Context(), fn)
}
