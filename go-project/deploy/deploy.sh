#!/usr/bin/env bash
# =============================================================================
# FssAdmin (go-project) Linux 一键部署脚本
#
# 子命令：
#   deps     安装系统依赖（MySQL / Redis / Nginx / ffmpeg / yt-dlp / 时区）
#   db       建库、建账号、导入 database/fssoa.sql
#   config   生成 $APP_DIR/manifest/config/config.yaml（旧文件自动备份）
#   app      安装后端二进制 + resource/static 目录
#   service  安装并启动 systemd 服务
#   nginx    安装 Nginx 站点配置并 reload
#   web      构建/部署前端到 $WEB_ROOT
#   check    健康检查
#   all      deps -> db -> config -> app -> service -> nginx -> check
#
# 常用环境变量（全部可选，脚本会自动生成缺失的密码并落盘复用）：
#   DOMAIN=admin.example.com        # 不填则用 "_"（仅 IP 访问，会抢占 default_server）
#   WEB_ROOT=/var/www/fssadmin
#   APP_DIR=/opt/fssadmin  APP_USER=fssadmin  APP_PORT=8181
#   DB_NAME=fssoa-net DB_USER=fssadmin DB_PASS=xxx  MYSQL_ROOT_PASS=xxx
#   REDIS_PASS=xxx  REDIS_DB=4
#   SQL_FILE=/tmp/fssoa.sql         # 不填则按 ./dist、../database 顺序自动查找
#   BIN_SRC=/tmp/fssadmin           # 不填则按 ./dist、./bin、上级目录顺序自动查找
#   REL_SRC=/tmp/release            # 含 manifest/ resource/ static/ 的发布目录
#   FORCE_CONFIG=1 FORCE_DB=1       # 覆盖已存在的配置 / 强制重新导入数据
#
# 用法示例：
#   sudo DOMAIN=admin.example.com ./deploy.sh all
# =============================================================================

set -Eeuo pipefail

APP_DIR="${APP_DIR:-/opt/fssadmin}"
APP_USER="${APP_USER:-fssadmin}"
SERVICE_NAME="${SERVICE_NAME:-fssadmin}"
APP_PORT="${APP_PORT:-8181}"

DOMAIN="${DOMAIN:-_}"
WEB_ROOT="${WEB_ROOT:-/var/www/fssadmin}"

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-fssoa-net}"
DB_USER="${DB_USER:-fssadmin}"
DB_PASS="${DB_PASS:-}"

REDIS_HOST="${REDIS_HOST:-127.0.0.1}"
REDIS_PORT="${REDIS_PORT:-6379}"
REDIS_DB="${REDIS_DB:-4}"
REDIS_PASS="${REDIS_PASS:-}"

MYSQL_ROOT_USER="${MYSQL_ROOT_USER:-root}"
MYSQL_ROOT_PASS="${MYSQL_ROOT_PASS:-}"

SECRET_KEY="${SECRET_KEY:-}"
SQL_FILE="${SQL_FILE:-}"
BIN_SRC="${BIN_SRC:-}"
REL_SRC="${REL_SRC:-}"
FORCE_CONFIG="${FORCE_CONFIG:-0}"
FORCE_DB="${FORCE_DB:-0}"

YTDLP_BIN="${YTDLP_BIN:-/usr/local/bin/yt-dlp}"
NGINX_CONF="/etc/nginx/conf.d/fssadmin.conf"
UNIT_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_FILE="$APP_DIR/.deploy.env"

C_OK=$'\033[32m'; C_WARN=$'\033[33m'; C_ERR=$'\033[31m'; C_INFO=$'\033[36m'; C_OFF=$'\033[0m'
log()  { printf '%s[%s]%s %s\n' "$C_INFO" "$(date +%H:%M:%S)" "$C_OFF" "$*"; }
ok()   { printf '%s  ok %s %s\n' "$C_OK" "$C_OFF" "$*"; }
warn() { printf '%s  !! %s %s\n' "$C_WARN" "$C_OFF" "$*" >&2; }
die()  { printf '%s  xx %s %s\n' "$C_ERR" "$C_OFF" "$*" >&2; exit 1; }
trap 'die "脚本在第 ${LINENO} 行失败，请检查上方输出"' ERR

need_root() { [[ ${EUID} -eq 0 ]] || die "需要 root 权限，请使用 sudo 运行"; }

rand_hex() {
  local n="${1:-24}" s
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex "$n"
  else
    s=$(tr -dc 'a-f0-9' </dev/urandom 2>/dev/null | head -c $((n * 2)) || true)
    printf '%s\n' "$s"
  fi
  return 0
}

# 复用上次生成的密码，避免重跑导致配置与数据库不一致（显式传入的环境变量优先）
load_secrets() {
  [[ -f "$SECRETS_FILE" ]] || return 0
  local k v
  while IFS='=' read -r k v; do
    [[ -z "$k" || "$k" == \#* ]] && continue
    [[ -n "${!k:-}" ]] && continue
    printf -v "$k" '%s' "$v" || true
  done < "$SECRETS_FILE"
  return 0
}

save_secrets() {
  mkdir -p "$APP_DIR"
  local old_umask
  old_umask="$(umask)"
  umask 077
  cat >"$SECRETS_FILE" <<EOF
# 由 deploy.sh 生成，请勿提交到版本库。删除本文件后重跑会轮换密钥。
DB_PASS=$DB_PASS
REDIS_PASS=$REDIS_PASS
SECRET_KEY=$SECRET_KEY
EOF
  chmod 600 "$SECRETS_FILE"
  umask "$old_umask"
}

detect_os() {
  [[ -r /etc/os-release ]] || die "无法识别系统（缺少 /etc/os-release）"
  . /etc/os-release
  OS_ID="${ID:-unknown}"
  if command -v apt-get >/dev/null 2>&1; then PKG=apt
  elif command -v dnf >/dev/null 2>&1; then PKG=dnf
  elif command -v yum >/dev/null 2>&1; then PKG=yum
  else die "不支持的发行版：$OS_ID（需要 apt / dnf / yum）"; fi
  ok "系统 $PRETTY_NAME (${PKG})"
}

pkg_install() {
  case "$PKG" in
    apt) DEBIAN_FRONTEND=noninteractive apt-get install -y "$@" ;;
    *)   "$PKG" install -y "$@" ;;
  esac
}

svc_start() {
  local s
  for s in "$@"; do
    if systemctl list-unit-files --type=service 2>/dev/null | awk '{print $1}' | grep -qx "${s}.service"; then
      systemctl enable --now "$s" >/dev/null 2>&1 || warn "启动服务 ${s} 失败"
      return 0
    fi
  done
  warn "未找到服务：$*"
  return 1
}

svc_name() {
  local s
  for s in "$@"; do
    if systemctl list-unit-files --type=service 2>/dev/null | awk '{print $1}' | grep -qx "${s}.service"; then
      printf '%s' "$s"; return 0
    fi
  done
  return 1
}

mysql_root() {
  if [[ -n "$MYSQL_ROOT_PASS" ]]; then
    mysql -h"$DB_HOST" -P"$DB_PORT" -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASS" "$@"
  else
    mysql -h"$DB_HOST" -P"$DB_PORT" -u"$MYSQL_ROOT_USER" "$@"
  fi
}

mysql_app() {
  mysql --default-character-set=utf8mb4 -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASS" "$@"
}

find_sql_file() {
  local c
  for c in "$SQL_FILE" "$SCRIPT_DIR/../database/fssoa.sql" "$SCRIPT_DIR/database/fssoa.sql" "$APP_DIR/database/fssoa.sql"; do
    [[ -n "$c" && -f "$c" ]] && { printf '%s' "$c"; return 0; }
  done
  return 1
}

find_bin() {
  local c
  for c in "$BIN_SRC" "$SCRIPT_DIR/dist/fssadmin" "$SCRIPT_DIR/../dist/fssadmin" "$SCRIPT_DIR/../bin/fssadmin" "$SCRIPT_DIR/../fssadmin" "$APP_DIR/fssadmin"; do
    [[ -n "$c" && -f "$c" ]] && { printf '%s' "$c"; return 0; }
  done
  return 1
}

find_rel_src() {
  local c
  for c in "$REL_SRC" "$SCRIPT_DIR/dist" "$SCRIPT_DIR/.."; do
    [[ -n "$c" && -f "$c/manifest/config/config.yaml" ]] && { printf '%s' "$c"; return 0; }
  done
  return 1
}

# ---------------------------------------------------------------------------
# deps
# ---------------------------------------------------------------------------
do_deps() {
  need_root
  detect_os
  log "安装基础工具"
  case "$PKG" in
    apt) apt-get update -qq || warn "apt-get update 失败，继续使用现有索引"
         pkg_install curl wget unzip tar ca-certificates tzdata gnupg
         ;;
    *)   pkg_install curl wget unzip tar ca-certificates tzdata
         ;;
  esac

  if ! command -v mysqld >/dev/null 2>&1 && ! command -v mariadbd >/dev/null 2>&1; then
    log "安装 MySQL"
    case "$PKG" in
      apt) pkg_install mysql-server || warn "mysql-server 安装失败，请手工安装 MySQL 5.7/8.0" ;;
      *)   pkg_install mysql-server || pkg_install mariadb-server || warn "MySQL 安装失败，请手工处理" ;;
    esac
  else
    ok "MySQL 已安装"
  fi
  svc_start mysqld mysql mariadb || true

  if ! command -v redis-server >/dev/null 2>&1; then
    log "安装 Redis"
    pkg_install redis-server || pkg_install redis || warn "Redis 安装失败，请手工安装"
  else
    ok "Redis 已安装"
  fi
  svc_start redis-server redis || true

  if ! command -v nginx >/dev/null 2>&1; then
    log "安装 Nginx"
    pkg_install nginx || warn "Nginx 安装失败，请手工安装"
  else
    ok "Nginx 已安装"
  fi
  svc_start nginx || true

  if ! command -v ffmpeg >/dev/null 2>&1; then
    log "安装 ffmpeg（视频模块合并/转码依赖）"
    if ! pkg_install ffmpeg; then
      warn "ffmpeg 安装失败。非视频业务可忽略；视频模块上线前必须手工装好。"
    fi
  else
    ok "ffmpeg 已安装"
  fi

  if ! command -v yt-dlp >/dev/null 2>&1 && [[ ! -x "$YTDLP_BIN" ]]; then
    log "安装 yt-dlp（self-contained 二进制，免 Python）"
    if curl -fL --retry 3 --connect-timeout 20 \
        -o "$YTDLP_BIN" \
        https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux; then
      chmod +x "$YTDLP_BIN"
      ok "yt-dlp -> $YTDLP_BIN ($("$YTDLP_BIN" --version 2>/dev/null || echo '?') )"
    else
      warn "yt-dlp 下载失败（内网环境常见）。请离线拷贝到 $YTDLP_BIN 并 chmod +x。"
    fi
  else
    ok "yt-dlp 已安装"
  fi

  log "配置 Redis（bind/requirepass/appendonly）"
  do_redis_conf
}

do_redis_conf() {
  local conf=""
  local c
  for c in /etc/redis/redis.conf /etc/redis.conf; do
    [[ -f "$c" ]] && { conf="$c"; break; }
  done
  [[ -n "$conf" ]] || { warn "未找到 redis.conf，跳过 Redis 配置"; return 0; }

  sed -i "/^# >>> fssadmin BEGIN/,/^# <<< fssadmin END/d" "$conf"
  cat >>"$conf" <<EOF

# >>> fssadmin BEGIN
bind 127.0.0.1
protected-mode yes
requirepass $REDIS_PASS
appendonly yes
maxmemory-policy allkeys-lru
# <<< fssadmin END
EOF
  local s
  if s=$(svc_name redis-server redis); then
    systemctl restart "$s" && ok "Redis 已重启（$s）"
  fi
  return 0
}

# ---------------------------------------------------------------------------
# db
# ---------------------------------------------------------------------------
do_db() {
  need_root
  mysql_root -e "SELECT 1" >/dev/null 2>&1 || die "无法以 ${MYSQL_ROOT_USER} 连接 MySQL。Ubuntu/MariaDB 的 root 走 socket 认证时请用 sudo 执行；否则设置 MYSQL_ROOT_PASS=..."

  log "创建数据库与账号"
  mysql_root -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" \
    || die "建库失败（库名含连字符，脚本已加反引号）"
  mysql_root -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'127.0.0.1' IDENTIFIED BY '${DB_PASS}';"
  mysql_root -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
  mysql_root -e "ALTER USER '${DB_USER}'@'127.0.0.1' IDENTIFIED BY '${DB_PASS}';" || true
  mysql_root -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'127.0.0.1';"
  mysql_root -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost';"
  mysql_root -e "FLUSH PRIVILEGES;"
  ok "数据库 ${DB_NAME} / 账号 ${DB_USER} 就绪"

  local sql
  if ! sql=$(find_sql_file); then
    warn "未找到 fssoa.sql，跳过数据导入（可用 SQL_FILE=/path/fssoa.sql 指定）"
    return 0
  fi

  local tables
  tables=$(mysql_app -N -B -e "SHOW TABLES;" "$DB_NAME" 2>/dev/null | wc -l | tr -d ' ') || true
  tables="${tables:-0}"
  if [[ "$tables" -gt 0 && "$FORCE_DB" != "1" ]]; then
    warn "库中已有 ${tables} 张表，跳过导入（FORCE_DB=1 可强制重导，注意会 DROP 同名表）"
    return 0
  fi

  log "导入 $sql（dump 内为 MyISAM/utf8，仅放宽 sql_mode，不做隐式转换）"
  mysql_app --init-command="SET SESSION sql_mode='NO_ENGINE_SUBSTITUTION'" "$DB_NAME" <"$sql" \
    || die "导入失败，请检查 dump 与 MySQL 版本兼容性"
  tables=$(mysql_app -N -B -e "SHOW TABLES;" "$DB_NAME" | wc -l | tr -d ' ')
  ok "导入完成，共 ${tables} 张表"
}

# ---------------------------------------------------------------------------
# config
# ---------------------------------------------------------------------------
do_config() {
  need_root
  local cfg="$APP_DIR/manifest/config/config.yaml"
  mkdir -p "$(dirname "$cfg")"

  if [[ -f "$cfg" && "$FORCE_CONFIG" != "1" ]]; then
    warn "配置已存在，跳过生成：$cfg（FORCE_CONFIG=1 覆盖，旧文件会备份）"
    return 0
  fi
  if [[ -f "$cfg" ]]; then
    cp -a "$cfg" "${cfg}.bak.$(date +%Y%m%d%H%M%S)"
    ok "已备份旧配置"
  fi

  local cors_enable cors_origins
  if [[ "$DOMAIN" == "_" ]]; then
    cors_enable="true"
    cors_origins="http://localhost,http://127.0.0.1"
  else
    cors_enable="false"
    cors_origins="https://${DOMAIN},http://${DOMAIN}"
  fi

  cat >"$cfg" <<EOF
# 由 deploy/deploy.sh 生成于 $(date '+%Y-%m-%d %H:%M:%S')，生产环境请勿提交到版本库。
server:
  address: "127.0.0.1:${APP_PORT}"
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
  # 日志滚动：单文件超过 10MB 自动分割，最多保留 30 个备份、30 天
  rotateSize: "10MB"
  rotateBackupLimit: 30
  rotateBackupExpire: "720h"
  rotateCheckInterval: "1h"

database:
  default:
    type: "mysql"
    link: "mysql:${DB_USER}:${DB_PASS}@tcp(${DB_HOST}:${DB_PORT})/${DB_NAME}?charset=utf8mb4&parseTime=true&loc=Asia%2FShanghai"
    debug: false
    charset: "utf8mb4"
    maxIdle: 10
    maxOpen: 30
    maxLifetime: "30m"

redis:
  default:
    address: "${REDIS_HOST}:${REDIS_PORT}"
    db: ${REDIS_DB}
    pass: "${REDIS_PASS}"
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
  secretKey: "${SECRET_KEY}"
  jwtAlg: "HS256"
  accessTTL: 7200
  refreshTTL: 43200
  sessionType: "jwt"
  tokenSliding: true
  gzipEnable: true
  corsEnable: ${cors_enable}
  corsMaxAge: 600
  corsOrigins: "${cors_origins}"
  csrfEnable: true
  xssEnable: true
  uploadDir: "static/upload"
  videoDir: "static/videos"
  backupDir: "static/bakup"
  backupCron: "0 0 2 * * *"
  maxFileSize: 10485760
  schedulerEnable: true
  shellTaskEnable: true
  # IP 归属地：关闭后不再请求外网，仅标注「内网IP/未解析(已关闭归属地查询)」
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
EOF

  chown -R "$APP_USER:$APP_USER" "$APP_DIR/manifest" 2>/dev/null || true
  chmod 600 "$cfg"
  save_secrets
  ok "配置已生成：$cfg"
}

# ---------------------------------------------------------------------------
# app
# ---------------------------------------------------------------------------
do_app() {
  need_root
  id -u "$APP_USER" >/dev/null 2>&1 || { useradd -r -s /sbin/nologin "$APP_USER" && ok "已创建系统用户 $APP_USER"; }

  log "创建目录结构"
  mkdir -p "$APP_DIR"/{manifest/config,resource/public,resource/plugins,static/upload,static/videos,static/bakup,logs/server}

  local rel
  if rel=$(find_rel_src); then
    log "同步资源目录（源：$rel）"
    if [[ -d "$rel/resource" ]]; then
      cp -a "$rel/resource/." "$APP_DIR/resource/"
    fi
    # 排除开发机上遗留的数据库备份快照
    if [[ -d "$rel/static" ]]; then
      ( cd "$rel/static" && tar --exclude='*.sql.gz' -cf - . ) | ( cd "$APP_DIR/static" && tar xf - )
    fi
    if [[ -f "$rel/manifest/config/config.yaml" && ! -f "$APP_DIR/manifest/config/config.yaml" ]]; then
      cp -a "$rel/manifest/config/config.yaml" "$APP_DIR/manifest/config/config.yaml"
    fi
    ok "资源同步完成"
  else
    warn "未找到含 manifest/config/config.yaml 的发布目录，跳过资源同步（可用 REL_SRC=/tmp/release 指定）"
  fi

  local bin
  if bin=$(find_bin); then
    install -m 0755 "$bin" "$APP_DIR/fssadmin"
    ok "二进制已安装：$APP_DIR/fssadmin（来源 $bin）"
  elif [[ -x "$APP_DIR/fssadmin" ]]; then
    ok "沿用已有二进制 $APP_DIR/fssadmin"
  else
    die "未找到 linux 二进制。请先交叉编译：GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -trimpath -ldflags \"-s -w\" -o dist/fssadmin ."
  fi

  chown -R "$APP_USER:$APP_USER" "$APP_DIR"
  chmod 755 "$APP_DIR" "$APP_DIR/logs" "$APP_DIR/static" 2>/dev/null || true
  ok "目录权限已设置"
}

# ---------------------------------------------------------------------------
# service
# ---------------------------------------------------------------------------
do_service() {
  need_root
  local src="$SCRIPT_DIR/fssadmin.service"
  [[ -f "$src" || -f "$UNIT_FILE" ]] || die "缺少 fssadmin.service"

  if [[ -f "$src" ]]; then
    install -m 0644 "$src" "$UNIT_FILE"
    [[ "$APP_DIR" != "/opt/fssadmin" ]] && sed -i "s#/opt/fssadmin#${APP_DIR}#g" "$UNIT_FILE"
    [[ "$APP_USER" != "fssadmin" ]] && sed -i "s#User=fssadmin#User=${APP_USER}#; s#Group=fssadmin#Group=${APP_USER}#" "$UNIT_FILE"
    [[ "$YTDLP_BIN" != "/usr/local/bin/yt-dlp" ]] && sed -i "s#/usr/local/bin/yt-dlp#${YTDLP_BIN}#g" "$UNIT_FILE"
  fi

  systemctl daemon-reload
  systemctl enable "$SERVICE_NAME" >/dev/null 2>&1 || true
  systemctl restart "$SERVICE_NAME"
  sleep 2
  systemctl is-active --quiet "$SERVICE_NAME" || {
    journalctl -u "$SERVICE_NAME" -n 40 --no-pager || true
    die "服务启动失败，日志见上"
  }
  ok "服务 ${SERVICE_NAME} 已启动"
}

# ---------------------------------------------------------------------------
# nginx
# ---------------------------------------------------------------------------
do_nginx() {
  need_root
  command -v nginx >/dev/null 2>&1 || die "未安装 Nginx"

  local src="$SCRIPT_DIR/nginx-fssadmin.conf"
  [[ -f "$src" ]] || die "缺少 nginx-fssadmin.conf"

  install -m 0644 "$src" "$NGINX_CONF"
  sed -i "s#__DOMAIN__#${DOMAIN}#g; s#__WEB_ROOT__#${WEB_ROOT}#g; s#__APP_PORT__#${APP_PORT}#g" "$NGINX_CONF"

  mkdir -p "$WEB_ROOT"
  if [[ ! -f "$WEB_ROOT/index.html" ]]; then
    printf 'FssAdmin frontend placeholder\n' >"$WEB_ROOT/index.html"
    warn "已写入占位 index.html，请部署真实前端（deploy.sh web 或手工上传 dist）"
  fi

  if [[ "$DOMAIN" == "_" ]]; then
    sed -i "s#^    listen 80;#    listen 80 default_server;#; s#^    listen \[::\]:80;#    listen [::]:80 default_server;#" "$NGINX_CONF"
    # 避免与发行版默认站点抢占 80
    rm -f /etc/nginx/sites-enabled/default /etc/nginx/conf.d/default.conf 2>/dev/null || true
    warn "DOMAIN 未设置，已配置为 default_server 并移除发行版默认站点"
  fi

  nginx -t || die "nginx 配置校验失败"
  systemctl enable nginx >/dev/null 2>&1 || true
  systemctl reload nginx 2>/dev/null || systemctl restart nginx
  ok "Nginx 已 reload：$NGINX_CONF"
}

# ---------------------------------------------------------------------------
# web
# ---------------------------------------------------------------------------
do_web() {
  local web_src="$SCRIPT_DIR/../web"
  [[ -d "$web_src" ]] || web_src="$SCRIPT_DIR/web"
  local dist="$web_src/dist"
  local pm="npm"
  command -v pnpm >/dev/null 2>&1 && pm="pnpm"

  if [[ -d "$web_src" ]] && command -v node >/dev/null 2>&1; then
    dist="$web_src/dist"
    log "构建前端 $web_src（包管理器：$pm）"
    ( cd "$web_src" && "$pm" install && "$pm" run build ) || die "前端构建失败"
  else
    warn "未找到 web/ 或 node 环境，改为直接部署已存在的 dist"
  fi

  [[ -d "$dist" ]] || die "缺少前端产物 dist，可用 WEB_DIST=/path/dist 手工指定后重试"
  mkdir -p "$WEB_ROOT"
  rm -rf "${WEB_ROOT:?}"/*
  cp -a "$dist/." "$WEB_ROOT/"
  chown -R www-data:www-data "$WEB_ROOT" 2>/dev/null || chown -R nginx:nginx "$WEB_ROOT" 2>/dev/null || true
  ok "前端已部署到 $WEB_ROOT"
}

# ---------------------------------------------------------------------------
# check
# ---------------------------------------------------------------------------
do_check() {
  local base="http://127.0.0.1:${APP_PORT}"
  log "健康检查 $base"
  printf '  /health       -> '; curl -fsS --max-time 5 "$base/health" || warn "失败"
  printf '\n  /health/ready -> '; curl -fsS --max-time 5 "$base/health/ready" || warn "失败"
  printf '\n  /core/captcha -> '; curl -fsS -o /dev/null -w 'HTTP %{http_code}\n' --max-time 5 "$base/core/captcha" || warn "失败"
  printf '  /api.json     -> '; curl -fsS -o /dev/null -w 'HTTP %{http_code}\n' --max-time 5 "$base/api.json" || warn "失败"

  if [[ "$DOMAIN" != "_" ]]; then
    printf '  http://%s/ -> ' "$DOMAIN"
    curl -fsS -o /dev/null -w 'HTTP %{http_code}\n' --max-time 8 -H "Host: $DOMAIN" http://127.0.0.1/ || warn "Nginx 转发异常"
  fi

  log "启动日志（关注 mysql ready / redis ready，出现 degraded 即为连接异常）"
  journalctl -u "$SERVICE_NAME" -n 25 --no-pager || true
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------
usage() {
  sed -n '3,28p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

main() {
  local cmd="${1:-all}"
  load_secrets
  [[ -n "$DB_PASS" ]]     || DB_PASS="$(rand_hex 16)"
  [[ -n "$REDIS_PASS" ]]  || REDIS_PASS="$(rand_hex 16)"
  [[ -n "$SECRET_KEY" ]]  || SECRET_KEY="$(rand_hex 32)"

  case "$cmd" in
    deps)    do_deps ;;
    db)      do_db ;;
    config)  do_config ;;
    app)     do_app ;;
    service) do_service ;;
    nginx)   do_nginx ;;
    web)     do_web ;;
    check)   do_check ;;
    all)
      do_deps
      do_db
      do_config
      do_app
      do_service
      do_nginx
      do_check
      log "部署完成。数据库密码等密钥保存在 $SECRETS_FILE（600）"
      ;;
    -h|--help|help) usage ;;
    *) die "未知子命令：$cmd（可用：deps db config app service nginx web check all）" ;;
  esac
}

main "$@"
