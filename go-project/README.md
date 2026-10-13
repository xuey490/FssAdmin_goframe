<div align="center">

# FssAdmin后台管理系统(goframe版)

基于 [GoFrame](https://goframe.org) 的企业级管理后台 **REST API** 服务：JWT 鉴权、多租户、RBAC、定时任务、监控与运维能力。默认监听 `:8787`，提供 OpenAPI（`/api.json`）与 Swagger（`/docs`）。

[![Go Version](https://img.shields.io/badge/Go-1.27.1-00ADD8?logo=go)](go.mod)
[![GoFrame](https://img.shields.io/badge/GoFrame-2.10.x-blue)](https://goframe.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

</div>

## 演示地址：https://gf.phpframe.org （适配 SoyAdmin）  https://goframe.phpframe.org/ （适配 Art Design Pro）

            

## 技术栈

| 类别 | 选型 |
| --- | --- |
| 语言 / 运行时 | Go 1.27.1 |
| Web 框架 | [GoFrame v2](https://github.com/gogf/gf) 2.10.x |
| 数据库 | MySQL 5.7 / 8.0（驱动 `contrib/drivers/mysql`） |
| 缓存 | Redis（`contrib/nosql/redis`） |
| 认证 | JWT（`golang-jwt/jwt`）、bcrypt（兼容 PHP `$2y$`） |
| 安全 | CSRF、XSS 过滤（bluemonday）、限流、IP 黑白名单 |
| 视频 | [go-ytdlp](https://github.com/lrstanley/go-ytdlp) + 系统 `yt-dlp` / `ffmpeg` |
| 实时 | Gorilla WebSocket（`/ws/ai` 鉴权事件协议） |

后端 **无 CGO 依赖**（MySQL 驱动、密码哈希均为纯 Go），可使用 `CGO_ENABLED=0` 交叉编译为单一静态二进制。

## 功能模块

业务代码位于 `internal/modules/<name>/`，标准mvc分层：`router` → `controller` → `service` → `dao` → `models`。

| 模块 | 说明 |
| --- | --- |
| `auth` | 登录、验证码、令牌刷新、租户按用户名查询 |
| `menu` / `user` / `role` / `dept` / `post` / `tenant` | 系统权限与组织 |
| `dict` / `config` | 字典与系统配置 |
| `attachment` / `file` | 附件与上传 |
| `logmod` / `notice` | 操作日志、通知 |
| `plugin` | 插件注册与配置 |
| `article` | 文章 CMS |
| `video` | 视频解析与下载队列（`platform_video*` 表） |
| `monitor` | 主机信息、Redis 监控、在线用户 |
| `dbmaint` | 数据库维护（仅 `app.debug=true`） |
| `cronjob` / `crontab` | 任务节点、进程内调度器、执行日志 |
| `gencode` | 代码生成 |
| `health` | 健康检查 `/health`、`/health/ready` |
| `demo` / `flow` | 演示接口；工作流为无表占位（空列表） |
| `wsai` | WebSocket AI 聊天通道（无外部 LLM 绑定） |

公共能力：`internal/authkit`（JWT / 验证码）、`internal/middleware`（鉴权、租户、CSRF、API 前缀）、`internal/shared`（统一响应、分页、CRUD、数据权限、雪花 ID 等）。

## 目录结构

```
go-project/
├── main.go
├── hack/config.yaml              # GoFrame CLI（gf gen dao / gf build）
├── manifest/config/config.yaml   # 运行时配置（生产请用环境变量覆盖密钥）
├── resource/                     # 静态资源、插件目录
├── static/                       # upload / videos / bakup（可写）
├── scripts/                      # 编译 / 交叉编译 / 一键启停
├── deploy/                       # Linux 部署脚本、systemd、Nginx 模板
└── internal/
    ├── bootstrap/                # 路由注册、启动自检
    ├── middleware/
    ├── authkit/
    └── modules/<mod>/...
```

## 环境要求

- **Go** 1.27.1+
- **MySQL** 5.7 或 8.0，库名默认 `fssoa-net`（需事先导入业务 SQL）
- **Redis** 5.0+（默认配置使用 **db 4**）
- 可选（视频模块）：`yt-dlp`、`ffmpeg`
- 可选（备份任务）：`mysqldump` 在 `PATH` 中

## 快速开始（本地开发）

1. 准备 MySQL 与 Redis，导入数据库结构及初始数据。
2. 复制并按环境修改 `manifest/config/config.yaml`（**勿将生产密钥提交到仓库**）。
3. 安装依赖并运行：

```bash
cd go-project
export GOPROXY=https://proxy.golang.org,direct   # 国内可用 https://goproxy.cn,direct
go mod tidy
go run .
```

服务默认地址：`http://127.0.0.1:8787`（见 `manifest/config/config.yaml` 的 `server.address`）。

或用脚本后台启动 / 停止（见下方「一键启动 / 停止」）。

热重载（需安装 [GoFrame CLI](https://goframe.org/docs/cli)）：

```bash
gf run main.go
```

### 常用环境变量

| 变量 | 说明 |
| --- | --- |
| `GF_GCFG_FILE` | 指定外部配置文件路径 |
| `FSSADMIN_DB_LINK` | 覆盖数据库 DSN |
| `FSSADMIN_YTDLP_BIN` | 指定 `yt-dlp` 可执行文件路径 |

## 测试

```bash
go test ./...
```

## 编译（Windows / Linux / 交叉编译）

无 CGO，统一 `CGO_ENABLED=0`，产物为单一静态二进制。脚本默认 `GOPROXY=https://goproxy.cn,direct`。

| 场景 | 命令 | 产物 |
| --- | --- | --- |
| Windows 本机编译 | `scripts\build-windows.bat` 或 `powershell -File scripts/build.ps1` | `bin/fssadmin.exe` |
| Windows 交叉编译 Linux | `scripts\build-linux.bat` 或 `powershell -File scripts/build.ps1 -Target linux` | `bin/fssadmin-linux-amd64` |
| Windows 同时编两个平台 | `powershell -File scripts/build.ps1 -Target all` | 上面两个 |
| Linux 本机编译 | `bash scripts/build.sh` | `bin/fssadmin` |
| Linux 交叉编译 Windows | `bash scripts/build.sh windows` | `bin/fssadmin.exe` |
| Linux 同时编两个平台 | `bash scripts/build.sh all` | `bin/fssadmin` + `bin/fssadmin.exe` |

手动等价命令：

```bash
# Linux amd64
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags "-s -w" -o bin/fssadmin .

# Windows amd64
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -trimpath -ldflags "-s -w" -o bin/fssadmin.exe .
```

使用 GoFrame 打包（内嵌 `manifest/config` 与 `resource`，见 `hack/config.yaml`）：

```bash
gf build
```

默认产物目录 `./bin`，目标 `windows` / `linux` + `amd64`。

发布包建议包含：二进制、`manifest/`、`resource/`、可写目录 `static/upload`、`static/videos`、`static/bakup`、`logs/`、数据库 SQL、`deploy/`。

## 一键启动 / 停止

脚本在 **go-project 根目录** 启动进程（`manifest/config`、`resource`、`static`、`logs` 都按相对路径解析）。缺二进制时会先编译本机目标。PID 写在 `bin/fssadmin.pid`，控制台日志 `logs/console.out.log`。

**Windows：**

```bat
scripts\start.bat
scripts\stop.bat
```

或：

```powershell
powershell -File scripts/start.ps1
powershell -File scripts/stop.ps1
```

**Linux：**

```bash
chmod +x scripts/*.sh
bash scripts/start.sh
bash scripts/stop.sh
```

启动成功后访问：

- API：`http://127.0.0.1:8787`
- OpenAPI：`http://127.0.0.1:8787/api.json`
- Swagger：`http://127.0.0.1:8787/docs`

生产环境 Linux 请用 `deploy/` 的 systemd，不要用 `scripts/start.sh` 长期托管。

## 部署

### Linux（推荐）

`deploy/` 提供 systemd 单元、`nginx-fssadmin.conf` 与 `deploy.sh`（依赖安装、建库导入、生成配置、安装服务、Nginx、健康检查）。

```bash
# 解压发布包后
chmod +x deploy/deploy.sh
sudo DOMAIN=admin.example.com ./deploy/deploy.sh all
```

分步与子命令、环境变量说明见 **[deploy/Install.md](deploy/Install.md)**。

典型拓扑：Nginx（80/443）→ 反代 `/api`、`/core`、`/ws` → 本机 `127.0.0.1:8181`（`deploy.sh` 默认 `APP_PORT=8181`）；静态前端由 Nginx 单独托管。本地开发默认端口是 **8787**。

### Windows

1. `scripts\build-windows.bat` 得到 `bin\fssadmin.exe`（工作目录保持为 `go-project` 根，以便读到 `manifest` / `resource` / `static`）。
2. 配置 `manifest/config/config.yaml` 中的 MySQL / Redis。
3. 开发：`scripts\start.bat` / `scripts\stop.bat`。长期运行可用任务计划程序 / NSSM 注册 `bin\fssadmin.exe`。

### Docker / 其他平台

项目未内置 Dockerfile；可按交叉编译步骤生成目标平台二进制，挂载配置与 `static`、`logs` 卷即可。配置以外部 `manifest/config/config.yaml` 为准（优先于内嵌资源）。

### 部署后验证

本地（默认 8787）：

```bash
curl -s http://127.0.0.1:8787/health
curl -s http://127.0.0.1:8787/health/ready
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8787/core/captcha
```

`deploy.sh` 生产端口默认 8181，把上面的端口换成 `APP_PORT` 即可。

## 配置说明

主配置文件：`manifest/config/config.yaml`。生产环境建议：

- `server.address` 仅监听本机（由反向代理对外）
- `app.debug: false`（关闭数据库维护等调试接口）
- `app.secretKey`、数据库与 Redis 密码使用强随机值，并通过环境变量或部署脚本注入
- `app.schedulerEnable: true` 时启用内置备份 cron（默认每天 02:00，输出到 `static/bakup`）

外部配置文件会覆盖 `gf build` 打包进二进制的默认配置。

## 参与贡献

1. Fork 本仓库
2. 创建特性分支（`git checkout -b feature/xxx`）
3. 提交变更（`git commit -am 'Add xxx'`）
4. 推送分支（`git push origin feature/xxx`）
5. 发起 Pull Request

提交前请运行 `go test ./...`。

## 许可证

本项目采用 [MIT License](LICENSE) 开源。
