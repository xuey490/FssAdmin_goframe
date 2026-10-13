package controller

import (
	asvc "fssadmin/go-project/internal/modules/attachment/service"
	"fssadmin/go-project/internal/modules/auth/service"
	usvc "fssadmin/go-project/internal/modules/user/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.GET("/core/captcha", webx.Wrap(service.Captcha))
	g.POST("/core/login", webx.Wrap(service.Login))
	g.POST("/system/auth/login", webx.Wrap(service.Login))
	g.POST("/core/refresh", webx.Wrap(service.Refresh))
	g.POST("/core/logout", webx.Wrap(service.Logout))
	g.GET("/core/tenants-by-username", webx.Wrap(service.TenantsByUsername))
	g.GET("/core/user-tenants", webx.Wrap(service.TenantsByUsername))
	g.POST("/core/switch-tenant", webx.Wrap(service.SwitchTenant))
	g.GET("/core/system/user", webx.Wrap(service.CurrentUser))
	g.GET("/core/system/menu", webx.Wrap(service.UserMenus))
	g.GET("/core/system/permissions", webx.Wrap(service.Permissions))
	g.GET("/core/system/dictAll", webx.Wrap(service.DictAll))
	g.GET("/core/system/getUserSelectorList", webx.Wrap(usvc.Selector))
	g.GET("/core/system/getUserList", webx.Wrap(usvc.List))
	g.GET("/core/system/getResourceCategory", webx.Wrap(asvc.CategoryList))
	g.GET("/core/system/getResourceList", webx.Wrap(asvc.List))
	g.POST("/core/system/uploadImage", webx.WrapMsg("上传成功", asvc.Upload))
	g.POST("/core/system/uploadFile", webx.WrapMsg("上传成功", asvc.Upload))
	g.POST("/core/system/chunkUpload", webx.Wrap(asvc.ChunkUpload))
	g.POST("/core/user/updateInfo", webx.Wrap(service.UpdateInfo))
	g.POST("/core/user/modifyPassword", webx.Wrap(service.ModifyPassword))
	g.GET("/core/system/getLoginLogList", webx.Wrap(service.PersonalLogs("sa_system_login_log")))
	g.GET("/core/system/getOperationLogList", webx.Wrap(service.PersonalLogs("sa_system_oper_log")))
	g.GET("/core/system/clearAllCache", webx.Wrap(service.ClearCache))
	g.GET("/core/system/statistics", webx.Wrap(service.Statistics))
	g.GET("/core/system/loginChart", webx.Wrap(service.LoginChart))
	g.GET("/core/system/loginBarChart", webx.Wrap(service.LoginBarChart))
	g.GET("/core/config/public/:key", webx.Wrap(service.PublicConfig))
}
