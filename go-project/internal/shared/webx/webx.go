package webx

import (
	"fssadmin/go-project/internal/shared/biz"
	"fssadmin/go-project/internal/shared/response"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
)

func logErr(r *ghttp.Request, err error) {
	// Error 走 glog.printErr：logger.stStatus=1 时附带堆栈。
	g.Log().Error(r.Context(), err)
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
			response.Fail(r, err.Error(), 1)
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
			response.Fail(r, err.Error(), 1)
			return
		}
		response.OK(r, data, msg)
	}
}
