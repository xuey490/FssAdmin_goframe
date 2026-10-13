<div align="center">

# FssAdmin (golang版)

基于 [GoFrame](https://goframe.org) 的企业级中后台：**一套 REST API + 两套 Vue 3 前台**。

JWT 鉴权、多租户、RBAC、定时任务、监控运维、附件与视频队列。后端无 CGO，可交叉编译为单一静态二进制。

[![Go](https://img.shields.io/badge/Go-1.27.1-00ADD8?logo=go)](go-project/go.mod)
[![GoFrame](https://img.shields.io/badge/GoFrame-2.10.x-blue)](https://goframe.org)
[![Vue](https://img.shields.io/badge/Vue-3.5-42b883?logo=vue.js)](https://vuejs.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**[Soybean Admin 演示](https://gf.phpframe.org)** · **[Art Design Pro 演示](https://goframe.phpframe.org/)** · [后端说明](go-project/README.md) · [Linux 部署](go-project/deploy/Install.md)

</div>

## 在线演示

| 前台 | 地址 | 说明 |
| --- | --- | --- |
| Soybean Admin | https://gf.phpframe.org | `Soybean/`，清新布局、elegant-router |
| Art Design Pro | https://goframe.phpframe.org/ | `web/`，多布局、Tailwind + UnoCSS |

两套前台对接同一套 Go 后端（默认 `:8787`）。演示账号以站点提示为准，本地默认多为 `admin` / `123456`。

OpenAPI：`/api.json`　Swagger：`/docs`

## 特性

- **双前台可选**：Art Design Pro 与 Soybean Admin 共用 API，按团队 UI 偏好选一套或并行维护
- **权限与组织**：JWT + 刷新令牌、验证码、RBAC、部门 / 岗位 / 多租户数据隔离
- **开箱业务**：用户角色菜单、字典配置、附件上传、操作日志、通知、文章 CMS、插件配置
- **运维能力**：主机 / Redis / 在线用户监控、进程内定时调度、数据库备份还原、代码生成
- **安全默认**：CSRF、XSS 过滤、限流、IP 黑白名单；密码哈希兼容 PHP `$2y$` bcrypt
- **可部署**：Windows / Linux 交叉编译脚本、systemd + Nginx 一键部署；后端 `CGO_ENABLED=0`

## 架构

```
浏览器
  ├─ Soybean Admin     :9527  (开发)  ──┐
  └─ Art Design Pro    :5730  (开发)  ──┤  /api  /core  /ws
                                        ▼
                              GoFrame API  :8787
                              (生产反代后 :8181)
                                        │
                         ┌──────────────┼──────────────┐
                         ▼              ▼              ▼
                      MySQL          Redis          可选
                    fssoa-net         db 4      yt-dlp / ffmpeg
```

生产推荐：Nginx（80/443）托管前端 `dist`，反代 `/api`、`/core`、`/ws` 到本机后端。

## 技术栈

| 层 | 选型 |
| --- | --- |
| 后端 | Go 1.27.1、[GoFrame v2](https://github.com/gogf/gf) 2.10.x、MySQL 5.7/8.0、Redis 5+ |
| 认证 / 安全 | JWT（HS256）、bcrypt、CSRF、bluemonday XSS、限流、IP 名单 |
| 实时 / 媒体 | Gorilla WebSocket（`/ws/ai`）、go-ytdlp + 系统 `yt-dlp` / `ffmpeg` |
| 前台 `web/` | Vue 3.5、Vite、TypeScript、Element Plus、vxe-table、Pinia、vue-i18n、TailwindCSS v4、UnoCSS |
| 前台 `Soybean/` | Vue 3.5、Vite、TypeScript、Element Plus、UnoCSS、Pinia、elegant-router、pnpm workspace（`@sa/*`） |

## 仓库结构

```
.
├── go-project/                 # GoFrame 后端
│   ├── main.go
│   ├── manifest/config/        # 运行时配置（生产密钥勿入库）
│   ├── internal/modules/       # 业务模块：router → controller → service → dao → models
│   ├── scripts/                # 编译 / 启停
│   └── deploy/                 # systemd、Nginx、一键部署
├── web/                        # Art Design Pro 前台（开发端口 5730）
└── Soybean/                    # Soybean Admin 前台（开发端口 9527）
```

后端模块一览见 [go-project/README.md](go-project/README.md)。公共能力在 `internal/authkit`、`internal/middleware`、`internal/shared`。

## 功能模块

| 模块 | 说明 |
| --- | --- |
| `auth` | 登录、验证码、令牌刷新、按用户名查租户 |
| `menu` / `user` / `role` / `dept` / `post` / `tenant` | 权限与组织 |
| `dict` / `config` | 字典与系统配置 |
| `attachment` / `file` | 附件与上传 |
| `logmod` / `notice` | 操作日志、通知 |
| `plugin` | 插件注册与配置 |
| `article` | 文章 CMS |
| `video` | 视频解析与下载队列 |
| `monitor` | 主机、Redis、在线用户 |
| `cronjob` / `crontab` | 任务节点、进程内调度、执行日志 |
| `gencode` | 代码生成 |
| `dbmaint` | 数据库维护（仅 `app.debug=true`） |
| `health` | `/health`、`/health/ready` |
| `wsai` | WebSocket AI 通道（未绑定外部 LLM） |
| `demo` / `flow` | 演示接口；工作流为占位（空列表） |

## 快速开始

### 环境

- Go 1.27.1+
- MySQL 5.7 / 8.0（库名默认 `fssoa-net`）
- Redis 5.0+（默认 **db 4**）
- Node.js ≥ 20.19、pnpm ≥ 8.8（跑前台时）
- 可选：`yt-dlp`、`ffmpeg`（视频）、`mysqldump`（备份）

### 1. 后端

准备 MySQL / Redis，导入结构与初始数据（如 `go-project/static/restore/init.sql`），再改 `go-project/manifest/config/config.yaml`（**生产密钥不要提交**）。

```bash
cd go-project
# 国内可改 GOPROXY=https://goproxy.cn,direct
export GOPROXY=https://proxy.golang.org,direct
go mod tidy
go run .
```

默认：http://127.0.0.1:8787

Windows：`scripts\start.bat` / `scripts\stop.bat`  
Linux：`bash scripts/start.sh` / `bash scripts/stop.sh`  
热重载：`gf run main.go`（需 [GoFrame CLI](https://goframe.org/docs/cli)）

常用覆盖：`GF_GCFG_FILE`、`FSSADMIN_DB_LINK`、`FSSADMIN_YTDLP_BIN`。

```bash
go test ./...
curl -s http://127.0.0.1:8787/health
```

### 2. 前台（二选一）

两端开发代理都指向 `http://127.0.0.1:8787`，请先启动后端。

**Art Design Pro（`web/`）**

```bash
cd web
pnpm install
pnpm dev
```

浏览器：http://127.0.0.1:5730  
生产构建：`pnpm build`

**Soybean Admin（`Soybean/`）**

```bash
cd Soybean
pnpm install
pnpm dev
```

浏览器：http://127.0.0.1:9527  
生产构建：`pnpm build`　路由生成：`pnpm gen-route`

## 编译与部署

后端无 CGO，统一 `CGO_ENABLED=0`。脚本默认 `GOPROXY=https://goproxy.cn,direct`。

| 场景 | 命令 | 产物 |
| --- | --- | --- |
| Windows 本机 | `scripts\build-windows.bat` | `bin/fssadmin.exe` |
| Windows → Linux | `scripts\build-linux.bat` | `bin/fssadmin-linux-amd64` |
| Linux 本机 | `bash scripts/build.sh` | `bin/fssadmin` |
| Linux → Windows | `bash scripts/build.sh windows` | `bin/fssadmin.exe` |

```bash
# 手动交叉编译 Linux amd64
cd go-project
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags "-s -w" -o bin/fssadmin .
```

Linux 生产请用 `go-project/deploy/`（systemd + Nginx），不要用 `scripts/start.sh` 长期托管：

```bash
chmod +x deploy/deploy.sh
sudo DOMAIN=admin.example.com ./deploy/deploy.sh all
```

分步命令、环境变量与发布包清单见 [deploy/Install.md](go-project/deploy/Install.md)。`deploy.sh` 默认后端端口 **8181**（仅本机），本地开发仍是 **8787**。

未内置 Dockerfile：交叉编译出目标二进制，挂载 `manifest/`、`static/`、`logs/` 即可。外部配置优先于 `gf build` 打进二进制的默认配置。

## 配置要点

主配置：`go-project/manifest/config/config.yaml`。生产建议：

- `server.address` 只监听本机，由 Nginx 对外
- `app.debug: false`（关闭调试类接口）
- `app.secretKey`、数据库与 Redis 密码用强随机值，通过环境变量或部署脚本注入
- `app.schedulerEnable: true` 时启用内置备份 cron（默认每天 02:00，输出 `static/bakup`）

## 参与贡献

1. Fork 本仓库，创建分支 `feature/xxx`
2. 后端改动请先 `cd go-project && go test ./...`
3. 提交并发起 Pull Request

问题与讨论请走 GitHub Issues。提交前不要把生产密钥、`.env` 实密、数据库 dump 打进仓库。

## 致谢

- [GoFrame](https://github.com/gogf/gf)
- [Art Design Pro](https://github.com/Daymychen/art-design-pro)（`web/`）
- [Soybean Admin](https://github.com/soybeanjs/soybean-admin)（`Soybean/`）

## 许可证

本仓库采用 [MIT License](LICENSE)。前台目录保留各自上游的版权声明。
