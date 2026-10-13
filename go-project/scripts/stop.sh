#!/usr/bin/env bash
# 一键停止：先 SIGTERM，8s 后 SIGKILL。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PIDFILE="$ROOT/bin/fssadmin.pid"

stop_pid() {
  local pid="$1"
  if ! kill -0 "$pid" 2>/dev/null; then
    return 0
  fi
  echo "stopping pid=$pid"
  kill -TERM "$pid" 2>/dev/null || true
  local i=0
  while kill -0 "$pid" 2>/dev/null && [[ $i -lt 16 ]]; do
    sleep 0.5
    i=$((i + 1))
  done
  if kill -0 "$pid" 2>/dev/null; then
    echo "SIGKILL pid=$pid"
    kill -KILL "$pid" 2>/dev/null || true
  fi
}

stopped=0
if [[ -f "$PIDFILE" ]]; then
  old="$(cat "$PIDFILE" 2>/dev/null || true)"
  if [[ "$old" =~ ^[0-9]+$ ]]; then
    stop_pid "$old"
    stopped=1
  fi
  rm -f "$PIDFILE"
fi

# fallback: 同目录二进制名
if pgrep -f "$ROOT/bin/fssadmin" >/dev/null 2>&1; then
  pgrep -f "$ROOT/bin/fssadmin" | while read -r p; do
    [[ "$p" == "$$" ]] && continue
    stop_pid "$p"
    stopped=1
  done
fi

if [[ "$stopped" -eq 1 ]]; then
  echo "stopped"
else
  echo "not running"
fi
