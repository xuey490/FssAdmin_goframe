package response

import (
	"net/http"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
)

// Envelope matches Python SuccessResponse / web interceptors.
type Envelope struct {
	Code       int         `json:"code"`
	Msg        string      `json:"msg"`
	Message    string      `json:"message"`
	Data       interface{} `json:"data"`
	StatusCode int         `json:"status_code"`
	Success    bool        `json:"success"`
}

func write(r *ghttp.Request, httpStatus, code int, msg string, data interface{}, success bool) {
	if data == nil {
		data = g.Map{}
	}
	r.Response.WriteHeader(httpStatus)
	r.Response.Header().Set("Content-Type", "application/json; charset=utf-8")
	r.Response.WriteJson(Envelope{
		Code:       code,
		Msg:        msg,
		Message:    msg,
		Data:       data,
		StatusCode: httpStatus,
		Success:    success,
	})
}

func OK(r *ghttp.Request, data interface{}, msg ...string) {
	m := "success"
	if len(msg) > 0 && msg[0] != "" {
		m = msg[0]
	}
	write(r, http.StatusOK, 200, m, data, true)
}

func Fail(r *ghttp.Request, msg string, code int) {
	if code == 0 {
		code = 1
	}
	httpStatus := http.StatusOK
	if code == 401 {
		httpStatus = http.StatusUnauthorized
	}
	write(r, httpStatus, code, msg, g.Map{}, false)
}

func FailHTTP(r *ghttp.Request, httpStatus, code int, msg string) {
	if code == 0 {
		code = 1
	}
	write(r, httpStatus, code, msg, g.Map{}, false)
}

func Page(rows interface{}, total, page, limit int) g.Map {
	if rows == nil {
		rows = []interface{}{}
	}
	return g.Map{
		"list":         rows,
		"data":         rows,
		"total":        total,
		"page":         page,
		"current_page": page,
		"limit":        limit,
		"per_page":     limit,
		"size":         limit,
	}
}

func PageNo(items interface{}, total, pageNo, pageSize int) g.Map {
	if items == nil {
		items = []interface{}{}
	}
	hasNext := int64(pageNo)*int64(pageSize) < int64(total)
	return g.Map{
		"items":     items,
		"total":     total,
		"page_no":   pageNo,
		"page_size": pageSize,
		"has_next":  hasNext,
	}
}
