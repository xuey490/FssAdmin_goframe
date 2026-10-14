# FssAdmin (go-project) Linux 部署手册

适用对象：把 `go-project`（GoFrame 2.10 + MySQL + Redis 的纯 Go 后端）部署到 Linux 服务器，并由 Nginx 或 Apache 对外提供前端与 API 服务。

本目录文件：

| 文件 | 说明 |
| --- | --- |
| `deploy.sh` | 一键/分步部署脚本（装依赖、建库导入、生成配置、装服务、配 Nginx、健康检查） |
| `fssadmin.service` | systemd 服务单元（含 `FSSADMIN_YTDLP_BIN`） |
| `nginx-fssadmin.conf` | Nginx 反代 + 前端站点配置模板（占位符由 `deploy.sh` 渲染） |
| `apache-fssadmin.conf` | Apache 反代模板（手工部署；视频进度走 HTTP 轮询，不是 WebSocket） |
| `Install.md` | 本文档 |

---

## 1. 架构与组件清单

```
浏览器 ──80/443──▶ Nginx 或 Apache ──/api、/core、/ws ──▶ 127.0.0.1:8181 (fssadmin)
                     │                              ├── MySQL 127.0.0.1:3306  fssoa-net
                     └── 前端 dist（/var/www/fssadmin）  ├── Redis 127.0.0.1:6379  db=4
                                                        ├── yt-dlp + ffmpeg（视频模块）
                                                        └── mysqldump（备份任务）
```

| 组件 | 建议版本 | 用途 | 必需 |
| --- | --- | --- | --- |
| Linux | CentOS 7+/Rocky 9/Ubuntu 20.04+ x86_64 | 运行环境 | 是 |
| MySQL | 5.7 或 8.0（dump 来源 5.7.26） | 业务库 `fssoa-net` | 是 |
| Redis | 5.0+ | 缓存、验证码、限流（配置为 **db 4**） | 是 |
| mysql 客户端 | 与 MySQL 同版本 | `mysqldump`，缺失时备份降级为纯 SQL 导出 | 建议 |
| Nginx 1.20+ 或 Apache 2.4+ | 反代、前端静态；`/ws` 才需要 WebSocket | 二选一 |
| systemd | 系统自带 | 守护进程、开机自启 | 是 |
| yt-dlp | 最新 | 视频解析/下载 | 视频模块必需 |
| ffmpeg | 5.x/6.x | `-x mp3` 转码、`bv*+ba` 合并 | 视频模块必需 |
| tzdata | 系统包 | DSN 中 `loc=Asia%2FShanghai` 需要 | 是 |
| Go | 1.27.1（`go.mod` 声明） | 仅服务器编译时需要 | 交叉编译则不需要 |
| Node.js + pnpm | 18+ / 9+ | 构建 `web/` 前端 | 仅前端需部署 |

> 后端无 CGO 依赖（MySQL 驱动、bcrypt 均为纯 Go），可 `CGO_ENABLED=0` 交叉编译出单一静态二进制。

---

## 2. 快速开始（推荐）

### 2.1 在开发机（Windows）交叉编译并打包

```powershell
cd c:\Users\Administrator\Desktop\fssadmin_nestjs\FastAdmin\FssAdmin_Python\go-project

$env:GOPROXY="https://goproxy.cn,direct"
$env:GOOS="linux"; $env:GOARCH="amd64"; $env:CGO_ENABLED="0"

go mod tidy
go test ./...
go build -trimpath -ldflags "-s -w" -o dist/fssadmin .

# 组装发布包：dist/{fssadmin,manifest,resource,static,deploy,database}
New-Item -ItemType Directory -Force dist | Out-Null
Copy-Item -Recurse -Force manifest,resource,deploy -Destination dist
New-Item -ItemType Directory -Force dist/static/upload,dist/static/videos,dist/static/bakup | Out-Null
New-Item -ItemType Directory -Force dist/database | Out-Null
Copy-Item -Force ..\database\fssoa.sql dist\database\

tar -czf dist/fssadmin-linux-amd64.tar.gz -C dist fssadmin manifest resource static deploy database
```

也可用 GoFrame CLI（`hack/config.yaml` 已声明 `system: windows,linux`、`packSrc: manifest/config,resource`）：

```bat
gf build
```

### 2.2 上传到服务器并一键部署

```bash
scp go-project/dist/fssadmin-linux-amd64.tar.gz root@SERVER:/tmp/
ssh root@SERVER
mkdir -p /tmp/release && tar -xzf /tmp/fssadmin-linux-amd64.tar.gz -C /tmp/release
chmod +x /tmp/release/deploy/deploy.sh

# 有域名（推荐，Nginx 会自动处理 default_server 冲突）
cd /tmp/release && sudo DOMAIN=admin.example.com ./deploy/deploy.sh all

# 只有 IP（会用 default_server 抢占 80 端口，并移除发行版默认站点）
cd /tmp/release && sudo ./deploy.sh all
```

执行顺序：`deps → db → config → app → service → nginx → check`。

部署完成后：

- 后端目录 `/opt/fssadmin`，二进制 `/opt/fssadmin/fssadmin`
- 配置 `/opt/fssadmin/manifest/config/config.yaml`（权限 600）
- 自动生成的密钥（DB / Redis / JWT）保存在 `/opt/fssadmin/.deploy.env`（600），**重跑脚本会复用，不要删**
- 服务名 `fssadmin`，Nginx 站点 `/etc/nginx/conf.d/fssadmin.conf`

### 2.3 分步执行 / 重跑单个环节

```bash
sudo ./deploy.sh deps      # 只装依赖
sudo ./deploy.sh db        # 只建库+导数据
sudo FORCE_CONFIG=1 ./deploy.sh config   # 覆盖生成配置（旧文件自动备份）
sudo ./deploy.sh app       # 只更新二进制与资源（升级用）
sudo ./deploy.sh service   # 只重装/重启 systemd
sudo ./deploy.sh nginx     # 只重装 Nginx 配置
sudo ./deploy.sh web       # 构建并部署前端
sudo ./deploy.sh check     # 健康检查
```

常用环境变量（全部可选）：

| 变量 | 默认 | 说明 |
| --- | --- | --- |
| `DOMAIN` | `_` | 站点域名，影响 CORS 与 `default_server` |
| `APP_DIR` | `/opt/fssadmin` | 部署根目录（必须与 systemd `WorkingDirectory` 一致） |
| `APP_USER` | `fssadmin` | 运行账号（自动创建，nologin） |
| `APP_PORT` | `8181` | 后端监听端口（仅本机） |
| `WEB_ROOT` | `/var/www/fssadmin` | 前端 dist 部署位置 |
| `DB_NAME` / `DB_USER` | `fssoa-net` / `fssadmin` | 库名带连字符，脚本已加反引号 |
| `DB_PASS` / `REDIS_PASS` / `SECRET_KEY` | 自动生成 | 显式传入则优先使用 |
| `MYSQL_ROOT_PASS` | 空 | Ubuntu/MariaDB root 走 socket 认证时留空并用 sudo |
| `SQL_FILE` | 自动查找 | `database/fssoa.sql` 绝对路径 |
| `BIN_SRC` | 自动查找 | linux 二进制路径 |
| `REL_SRC` | 自动查找 | 含 `manifest/config/config.yaml` 的发布目录 |
| `FORCE_DB=1` | 0 | 库中已有表时也强制重导（会 DROP 同名表） |
| `FORCE_CONFIG=1` | 0 | 覆盖已存在的 config.yaml |

---

## 3. 手工部署（不使用脚本的等价步骤）

### 3.1 系统基础

```bash
apt update && apt install -y curl wget unzip tar ca-certificates tzdata ffmpeg nginx mysql-server redis-server
timedatectl set-timezone Asia/Shanghai

useradd -r -s /sbin/nologin fssadmin
mkdir -p /opt/fssadmin/{manifest/config,resource/public,resource/plugins,static/upload,static/videos,static/bakup,logs/server}

cat >>/etc/security/limits.conf <<'EOF'
fssadmin soft nofile 65535
fssadmin hard nofile 65535
EOF
```

`tzdata` 必须存在：配置里 `loc=Asia%2FShanghai` 会调用 `time.LoadLocation`，缺时区数据会直接连库失败。

### 3.2 MySQL

```bash
mysql -uroot <<'SQL'
CREATE DATABASE IF NOT EXISTS `fssoa-net` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS 'fssadmin'@'127.0.0.1' IDENTIFIED BY '强密码';
GRANT ALL PRIVILEGES ON `fssoa-net`.* TO 'fssadmin'@'127.0.0.1';
FLUSH PRIVILEGES;
SQL

# dump 内没有 CREATE DATABASE，必须先建库；里面是 MyISAM/utf8 老语法，放宽 sql_mode 再导入
mysql --default-character-set=utf8mb4 -uroot \
  --init-command="SET SESSION sql_mode='NO_ENGINE_SUBSTITUTION'" \
  `fssoa-net` < database/fssoa.sql

mysql -uroot -e "SELECT COUNT(*) FROM \`fssoa-net\`.sa_system_user;"
```

若连接报认证错误，把账号改成 `mysql_native_password`：

```sql
ALTER USER 'fssadmin'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY '强密码';
```

### 3.3 Redis

在 `/etc/redis/redis.conf`（CentOS 为 `/etc/redis.conf`）末尾追加：

```conf
bind 127.0.0.1
protected-mode yes
requirepass 你的Redis密码
appendonly yes
maxmemory-policy allkeys-lru
```

```bash
systemctl enable --now redis-server   # CentOS: redis
```

配置里使用 `db: 4`，Redis 默认 16 个库可直接用（注：根目录 README 写的 `db=1` 已过时，以 `config.yaml` 为准）。

### 3.4 yt-dlp + ffmpeg（视频模块）

`github.com/lrstanley/go-ytdlp` **不是**把 yt-dlp 编进二进制，只是去调系统里的可执行文件。`EnsureBin()` 查找顺序：

1. 环境变量 `FSSADMIN_YTDLP_BIN`（`fssadmin.service` 已设为 `/usr/local/bin/yt-dlp`）
2. `PATH` 中的 `yt-dlp` / `yt-dlp.exe`
3. 都没有 → `ytdlp.Install()` 从 GitHub 拉官方二进制（超时 3 分钟）

生产环境**不要走第 3 步**：systemd 的 PATH 很窄，内网也常上不了 GitHub，第一次解析/下载会卡死再失败。请事先装好独立二进制，并让第 1 步命中。

`ffmpeg` 同样要装：默认画质 `bv*+ba/b` 合并、`-x --audio-format mp3` 抽音都依赖它。本仓库的 `EnsureBin()` **不会**调用 `InstallFFmpeg()`。

```bash
# Ubuntu / Debian（ffmpeg 走发行版）
apt update && apt install -y ffmpeg ca-certificates tzdata

# yt-dlp：官方 self-contained 二进制，不要只靠 pip
curl -fL -o /usr/local/bin/yt-dlp \
  https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux
chmod +x /usr/local/bin/yt-dlp

# 必须用服务账号验证（systemd 用户是 fssadmin，不是 root）
sudo -u fssadmin /usr/local/bin/yt-dlp --version
sudo -u fssadmin bash -lc 'command -v ffmpeg && ffmpeg -version | head -1'
```

内网 / 无法访问 GitHub 时，在能上网的机器下载 `yt-dlp_linux`，拷到服务器同一路径：

```bash
install -m 0755 yt-dlp_linux /usr/local/bin/yt-dlp
```

`deploy.sh deps` 会尝试完成上述安装；失败时只告警，不会中止整次部署，上线视频功能前务必再确认。

下载产物目录是工作目录下的 `static/videos/`，属主必须是 `fssadmin`：

```bash
mkdir -p /opt/fssadmin/static/videos
chown -R fssadmin:fssadmin /opt/fssadmin/static/videos
```

页面进度**不是 WebSocket**：`parseProgress` 把百分比写入任务表，前端每 2 秒请求 `GET /api/platform/video/progress?ids=...`。反代按普通 HTTP 即可，见 [3.8 Nginx](#38-nginx) / [3.9 Apache](#39-apachehttp-轮询)。控制台进度在 journal：`journalctl -u fssadmin -f`。

### 3.5 配置文件

参考 [附录 A](#附录-a生产环境-configyaml-参考)，写入 `/opt/fssadmin/manifest/config/config.yaml`，然后 `chmod 600`。

关键项：

| 项 | 生产值 | 原因 |
| --- | --- | --- |
| `server.address` | `127.0.0.1:8181` | 只让 Nginx 访问，不暴露公网 |
| `server.dumpRouterMap` | `false` | 减少启动日志 |
| `logger.level` | `info` | 关掉调试级日志 |
| `database.default.link` | 独立账号 | 不要用 root |
| `redis.default.pass` | 真实密码 | 与 redis.conf 一致 |
| `app.debug` | `false` | 同时关闭数据库维护接口 |
| `app.secretKey` | 随机 64 位 | JWT 签名密钥，泄露即可伪造令牌 |
| `app.corsEnable` | 同域反代时 `false` | 避免多余跨域头 |
| `app.schedulerEnable` | `true` | 内置每天 02:00 备份任务 |
| `app.ipLocationEnable` | 内网/无外网环境设 `false` | IP 归属地查询开关；关闭后登录日志与在线用户只显示「内网IP/未解析(已关闭归属地查询)」，不再请求外网 |
| `app.ipLocationCacheHours` | `168` | 归属地缓存时长（小时，默认 7 天） |
| `app.ipLocationTimeout` | `3` | 单次外网归属地查询硬超时（秒），避免拖慢登录 |

### 3.6 安装二进制与资源

```bash
install -m 0755 dist/fssadmin /opt/fssadmin/fssadmin
cp -a resource/. /opt/fssadmin/resource/
mkdir -p /opt/fssadmin/static/{upload,videos,bakup}
chown -R fssadmin:fssadmin /opt/fssadmin
```

四个目录约束（来自 `internal/bootstrap/bootstrap.go`）：

- `server.serverRoot: "resource/public"` 相对工作目录解析，缺失会 404；
- 只有 `static/` 存在时才注册 `/static/upload`、`/static/videos` 静态路由；
- `logs`、`logs/server` 必须可写；
- 插件模块会写 `resource/plugins/registry.json`，`resource/plugins` 必须可写。

### 3.7 systemd

```bash
install -m 0644 deploy/fssadmin.service /etc/systemd/system/fssadmin.service
systemctl daemon-reload
systemctl enable --now fssadmin
systemctl status fssadmin --no-pager
```

`WorkingDirectory` 必须是 `/opt/fssadmin`。单元内已显式设置 `PATH=/usr/local/bin:/usr/bin:/bin`，否则 `yt-dlp`、`mysqldump` 找不到。

### 3.8 Nginx

```bash
sed -e 's#__DOMAIN__#admin.example.com#g' \
    -e 's#__WEB_ROOT__#/var/www/fssadmin#g' \
    -e 's#__APP_PORT__#8181#g' \
    deploy/nginx-fssadmin.conf > /etc/nginx/conf.d/fssadmin.conf
nginx -t && systemctl reload nginx
```

`/api` 前缀由后端中间件 `RewriteAPIPrefix` 剥离，无需 rewrite 规则。模板里 `proxy_read_timeout 300s`、`proxy_buffering off` 是为视频解析和进度轮询准备的。`/ws/` 才保留 WebSocket 升级头，供 AI 聊天 `useAiChatWs` 使用，**与下载进度无关**。

### 3.9 Apache（HTTP 轮询）

`deploy.sh` 只渲染 Nginx。若站点走 Apache，用 `deploy/apache-fssadmin.conf`（占位符与 Nginx 模板相同）。

视频页进度链路：

1. `yt-dlp` 输出 `[download] 45.3% ...`
2. 后端写入任务表 `progress` / `speed`
3. 页面每 2 秒 `GET /api/platform/video/progress?ids=...`（普通 HTTP JSON）
4. 用返回的 `job_progress` 画进度条

因此 Apache **不必**为视频进度开 WebSocket；只要 `/api` 反代通、超时够、不要把短轮询缓冲住即可。仓库里真正的 WS 只有 `/ws/ai`。

启用模块：

```bash
# Debian / Ubuntu
a2enmod proxy proxy_http proxy_wstunnel headers rewrite
# proxy_wstunnel / rewrite 仅 AI 聊天需要；视频进度只用 proxy + proxy_http

sed -e 's#__DOMAIN__#admin.example.com#g' \
    -e 's#__WEB_ROOT__#/var/www/fssadmin#g' \
    -e 's#__APP_PORT__#8181#g' \
    deploy/apache-fssadmin.conf > /etc/apache2/sites-available/fssadmin.conf
a2ensite fssadmin
apache2ctl configtest && systemctl reload apache2
```

RHEL / Rocky 把文件放到 `/etc/httpd/conf.d/fssadmin.conf`，模块名为 `mod_proxy` / `mod_proxy_http` / `mod_proxy_wstunnel`。

要点：

| 项 | 说明 |
| --- | --- |
| `ProxyPass /api/` | 进度轮询走这里，**不要**配 `Upgrade` |
| `ProxyTimeout 300` | 视频解析、入队下载可能较慢 |
| `flushpackets=on` | 避免进度 JSON 被反向代理攒着 |
| `LimitRequestBody 67108864` | 与后端 `clientMaxBodySize: 64MB` 对齐 |
| `ProxyPass /ws/` + `upgrade=websocket` | **仅** AI 聊天；配错不影响下载进度 |
| Apache &lt; 2.4.47 | 没有 `upgrade=websocket`，用文档模板里的 `RewriteRule ... [P]` 那段 |

本地开发后端是 `:8787`，`deploy.sh` 生产默认 `:8181`，Apache 里改成实际 `APP_PORT`。

### 3.10 前端

```bash
cd web
corepack enable && pnpm install && pnpm build      # 产物 web/dist
rsync -a --delete web/dist/ /var/www/fssadmin/
chown -R www-data:www-data /var/www/fssadmin       # CentOS: nginx:nginx
```

`web/.env.production` 中 `VITE_API_URL=/api`，与 Nginx / Apache 反代路径一致，无需改动。

---

## 4. 验证

```bash
curl -s http://127.0.0.1:8181/health
curl -s http://127.0.0.1:8181/health/ready
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8181/core/captcha
curl -s http://127.0.0.1:8181/api.json | head -c 200

curl -s -X POST http://127.0.0.1:8181/core/login \
  -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"admin123"}'

curl -sI -H 'Host: admin.example.com' http://127.0.0.1/

# 视频模块：二进制必须对 fssadmin 用户可见
sudo -u fssadmin /usr/local/bin/yt-dlp --version
command -v ffmpeg
# 进度接口（未登录会 401，能通即可；登录后 ids= 为视频主键）
curl -s -o /dev/null -w '%{http_code}\n' 'http://127.0.0.1:8181/api/platform/video/progress?ids=1'

journalctl -u fssadmin -n 50 --no-pager     # 必须看到 mysql ready / redis ready
```

启动日志里若出现 `mysql not ready: ... (degraded)` 或 `redis not ready`，进程**不会退出**，属降级启动，极易被误判为"部署成功"，务必确认。

---

## 5. 运维

```bash
systemctl restart fssadmin          # 重启
journalctl -u fssadmin -f           # 实时日志
tail -f /opt/fssadmin/logs/server/access.$(date +%Y%m%d).log
tail -f /opt/fssadmin/logs/$(date +%Y-%m-%d).log
```

升级（只换二进制，配置不动）：

```bash
sudo BIN_SRC=/tmp/release/fssadmin ./deploy.sh app && systemctl restart fssadmin
```

备份：内置任务每天 02:00 写入 `/opt/fssadmin/static/bakup/`，保留 30 天。`mysqldump` 不在 `PATH` 时会退化为纯 SQL 导出（逻辑一致但更慢、无一致性保证）。

手工快照与回滚：

```bash
mysqldump -ufssadmin -p --single-transaction --routines --triggers `fssoa-net` | gzip > /root/fssoa-$(date +%F).sql.gz

# 回滚：重新导入权威 dump（README 明确不做自动迁移）
mysql -ufssadmin -p -e "DROP DATABASE \`fssoa-net\`; CREATE DATABASE \`fssoa-net\` DEFAULT CHARACTER SET utf8mb4;"
mysql -ufssadmin -p \`fssoa-net\` < database/fssoa.sql
```

变更配置后只需重启服务——GoFrame 读取顺序为「文件系统优先于内嵌资源」，外部 `manifest/config/config.yaml` 会覆盖 `gf build` 打包进二进制的配置。

---

## 6. 故障排查

| 现象 | 原因与处理 |
| --- | --- |
| 导入 SQL 报 `No database selected` | dump 无 `CREATE DATABASE`，先建库 `fssoa-net` |
| 导入报 sql_mode 相关错误 | 用 `--init-command="SET SESSION sql_mode='NO_ENGINE_SUBSTITUTION'"` |
| MySQL 连接被拒（认证插件） | 账号改 `mysql_native_password`，或 DSN 加 `allowNativePasswords=true` |
| 后端连库报时区/未知时区 | 安装 `tzdata`，或把 DSN 的 `loc=Asia%2FShanghai` 改为 `loc=Local` |
| 启动日志出现 `(degraded)` | 数据库或 Redis 连接串/密码错误，进程不退出，需修正后重启 |
| 页面 404 / 白屏 | 前端 dist 未部署到 `WEB_ROOT`，或 Nginx `root` 未改 |
| `/api` 502 | 后端未启动；`systemctl status fssadmin` 查看 |
| 视频下载/解析失败 | `ffmpeg` 缺失，或 `yt-dlp` 未命中 `FSSADMIN_YTDLP_BIN`；`sudo -u fssadmin yt-dlp -J <url>` 复现。不要指望 `go-ytdlp` 在生产自动下载 |
| 页面进度条不动 | 前端轮询 `/api/platform/video/progress`（每 2 秒），不是 `/ws`。检查 Apache/Nginx 的 `/api` 反代、超时与缓冲；`/ws` 配错只影响 AI 聊天 |
| 首次下载卡住约 3 分钟后失败 | 未预装 yt-dlp，进程在走 `ytdlp.Install()`；按 [3.4](#34-yt-dlp--ffmpeg视频模块) 装到 `/usr/local/bin/yt-dlp` 并重启 `fssadmin` |
| 备份任务失败或很慢 | `mysqldump` 不在 systemd `PATH`；确认单元内 `Environment=PATH=` |
| Nginx 80 端口被占用 | `DOMAIN` 未设置时脚本已配 `default_server` 并移除发行版默认站点；如有其它站点需手工调整 |
| 上传大文件 413 | `client_max_body_size` 与 `server.clientMaxBodySize` 需同时调大 |
| 数据库维护接口 404 | 该接口仅 `app.debug=true` 时可用，生产关闭属预期 |

---

## 附录 A：生产环境 config.yaml 参考

与 `deploy.sh config` 生成内容一致（密钥请替换为真实值）：

```yaml
server:
  address: "127.0.0.1:8181"
  openapiPath: "/api.json"
  swaggerPath: "/docs"
  serverRoot: "resource/public"
  dumpRouterMap: false
  logPath: "logs/server"
  logStdout: false
  errorStack: true
  errorLogEnabled: true
  errorLogPattern: "error.{Ymd}.log"
  accessLogEnabled: true
  accessLogPattern: "access.{Ymd}.log"
  maxHeaderBytes: "20KB"
  clientMaxBodySize: "64MB"
  graceful: true
  gracefulTimeout: 10

logger:
  level: "info"
  stdout: true
  path: "logs"
  file: "{Y-m-d}.log"
  stStatus: 0

database:
  default:
    type: "mysql"
    link: "mysql:fssadmin:密码@tcp(127.0.0.1:3306)/fssoa-net?charset=utf8mb4&parseTime=true&loc=Asia%2FShanghai"
    debug: false
    charset: "utf8mb4"
    maxIdle: 10
    maxOpen: 30
    maxLifetime: "30m"

redis:
  default:
    address: "127.0.0.1:6379"
    db: 4
    pass: "Redis密码"
    idleTimeout: "60s"
    maxActive: 50

cache:
  expire: 3600
  prefix: "cache"

app:
  name: "FssAdmin"
  version: "0.1.0"
  timezone: "Asia/Shanghai"
  debug: false
  demoEnable: false
  captchaEnable: true
  captchaExpire: 600
  secretKey: "用 openssl rand -hex 32 生成"
  jwtAlg: "HS256"
  accessTTL: 7200
  refreshTTL: 43200
  sessionType: "jwt"
  tokenSliding: true
  gzipEnable: true
  corsEnable: false
  corsMaxAge: 600
  corsOrigins: "https://admin.example.com"
  csrfEnable: true
  xssEnable: true
  uploadDir: "static/upload"
  videoDir: "static/videos"
  backupDir: "static/bakup"
  backupCron: "0 0 2 * * *"
  maxFileSize: 10485760
  schedulerEnable: true
  ipLocationEnable: true
  ipLocationCacheHours: 168
  ipLocationTimeout: 3
  rateLimitEnable: true
  rateLimitTimes: 1000
  rateLimitSeconds: 60
  rateLimitPrefix: "fssadmin:rl:"
  ipWhiteList: ""
  ipBlackList: ""
  tenantWhitelist: "/system/auth/,/health,/common/health,/core/captcha,/core/login,/core/tenants-by-username,/core/config/public/"
```

## 附录 B：服务器目录结构

```
/opt/fssadmin/
├── fssadmin                      # 二进制（0755）
├── .deploy.env                   # 自动生成的密钥（0600）
├── manifest/config/config.yaml   # 运行时配置（0600）
├── resource/
│   ├── public/                   # serverRoot
│   └── plugins/                  # 插件注册表（需可写）
├── static/
│   ├── upload/                   # app.uploadDir
│   ├── videos/                   # app.videoDir（yt-dlp 输出）
│   └── bakup/                    # app.backupDir（保留 30 天）
└── logs/
    ├── {Y-m-d}.log               # GoFrame glog
    └── server/access|error.*.log # WebServer 日志

/etc/systemd/system/fssadmin.service
/etc/nginx/conf.d/fssadmin.conf            # 或 Apache: /etc/apache2/sites-available/fssadmin.conf
/usr/local/bin/yt-dlp                      # FSSADMIN_YTDLP_BIN
/var/www/fssadmin/                         # 前端 dist
```
