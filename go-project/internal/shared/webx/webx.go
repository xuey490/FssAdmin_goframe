package webx

import (
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
)

func logErr(r *ghttp.Request, err error) {
	// Error 走 glog.printErr：logger.stStatus=1 时附带堆栈。
	g.Log().Error(r.Context(), err)
}

// clientErrMsg 非 biz 错误对外的提示：细节（SQL、路径、Redis 报错等）只进日志，
// 避免内部信息泄露；debug 模式保留原始错误便于联调。
func clientErrMsg(err error) string {
	if conf.Debug() {
		return err.Error()
	}
	return "系统异常，请联系管理员"
}

func Wrap(fn func(r *ghttp.Request) (interface{}, error)) func(r *ghttp.Request) {
	return func(r *ghttp.Request) {
		data, err := fn(r)
		if err != nil {
			if e, ok := biz.As(err); ok {
				response.FailHTTP(r, e.HTTPStatus, e.Code, e.Msg)
				return
			}
			logErr(r, err)
			response.Fail(r, clientErrMsg(err), 1)
			return
		}
		response.OK(r, data)
	}
}

func WrapMsg(msg string, fn func(r *ghttp.Request) (interface{}, error)) func(r *ghttp.Request) {
	return func(r *ghttp.Request) {
		data, err := fn(r)
		if err != nil {
			if e, ok := biz.As(err); ok {
				response.FailHTTP(r, e.HTTPStatus, e.Code, e.Msg)
				return
			}
			logErr(r, err)
			response.Fail(r, clientErrMsg(err), 1)
			return
		}
		response.OK(r, data, msg)
	}
}
