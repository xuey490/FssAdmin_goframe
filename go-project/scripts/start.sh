#!/usr/bin/env bash
# 一键启动（后台）。工作目录必须是 go-project 根。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

BIN="$ROOT/bin/fssadmin"
PIDFILE="$ROOT/bin/fssadmin.pid"
LOGDIR="$ROOT/logs"
OUTLOG="$LOGDIR/console.out.log"

listen_addr() {
  local cfg="$ROOT/manifest/config/config.yaml"
  if [[ -f "$cfg" ]]; then
    awk -F'"' '/^[[:space:]]*address:/{print $2; exit}' "$cfg"
  fi
}

if [[ -f "$PIDFILE" ]]; then
  old="$(cat "$PIDFILE" 2>/dev/null || true)"
  if [[ "$old" =~ ^[0-9]+$ ]] && kill -0 "$old" 2>/dev/null; then
    addr="$(listen_addr)"; addr="${addr:-127.0.0.1:8787}"
    echo "already running pid=$old  http://$addr"
    exit 0
  fi
  rm -f "$PIDFILE"
fi

if [[ ! -x "$BIN" ]]; then
  echo "binary missing, building linux..."
  bash "$ROOT/scripts/build.sh" linux
fi
chmod +x "$BIN"
mkdir -p "$ROOT/bin" "$LOGDIR"

nohup "$BIN" >>"$OUTLOG" 2>&1 &
echo $! >"$PIDFILE"
sleep 1
pid="$(cat "$PIDFILE")"
if ! kill -0 "$pid" 2>/dev/null; then
  echo "start failed, see $OUTLOG" >&2
  tail -n 40 "$OUTLOG" >&2 || true
  rm -f "$PIDFILE"
  exit 1
fi

addr="$(listen_addr)"; addr="${addr:-127.0.0.1:8787}"
echo "started pid=$pid"
echo "  http://$addr"
echo "  OpenAPI  http://$addr/api.json"
echo "  Swagger  http://$addr/docs"
echo "  logs     $OUTLOG"
