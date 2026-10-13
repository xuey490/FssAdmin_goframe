package controller

import (
	"fssadmin/go-project/internal/modules/logmod/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/core/logs/getLoginLogPageList", webx.Wrap(service.LoginList))
	g.DELETE("/core/logs/deleteLoginLog", webx.Wrap(service.LoginDelete))
	g.GET("/core/logs/getOperLogPageList", webx.Wrap(service.OperList))
	g.DELETE("/core/logs/deleteOperLog", webx.Wrap(service.OperDelete))
	g.GET("/core/email/index", webx.Wrap(service.EmailList))
	g.DELETE("/core/email/destroy", webx.Wrap(service.EmailDelete))
	g.GET("/system/log/login/list", webx.Wrap(service.LoginList))
	g.DELETE("/system/log/login/delete", webx.Wrap(service.LoginDelete))
	g.GET("/system/log/operation/list", webx.Wrap(service.OperList))
	g.DELETE("/system/log/operation/delete", webx.Wrap(service.OperDelete))
	g.GET("/system/log/email/list", webx.Wrap(service.EmailList))
	g.DELETE("/system/log/email/delete/:id", webx.Wrap(service.EmailDelete))
	g.POST("/system/log/email/resend/:id", webx.Wrap(service.EmailResend))
}
