package controller

import (
	"fssadmin/go-project/internal/modules/file/service"
	"fssadmin/go-project/internal/shared/webx"

	"github.com/gogf/gf/v2/net/ghttp"
)

func Bind(g *ghttp.RouterGroup) {
	g.POST("/file/upload", webx.WrapMsg("上传文件成功", service.Upload))
	g.POST("/file/download", webx.Wrap(service.Download))
	g.POST("/common/file/upload", webx.WrapMsg("上传文件成功", service.Upload))
	g.POST("/common/upload/wangeditor", webx.Wrap(service.WangEditor))
}
