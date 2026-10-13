#!/usr/bin/env bash
# FssAdmin GoFrame: Linux 本机 / 交叉编译
#   bash scripts/build.sh              # 本机 linux/amd64 -> bin/fssadmin
#   bash scripts/build.sh windows      # 交叉 windows/amd64 -> bin/fssadmin.exe
#   bash scripts/build.sh all
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

TARGET="${1:-linux}"
SKIP_TIDY="${SKIP_TIDY:-0}"

command -v go >/dev/null 2>&1 || { echo "未找到 go，请先安装 Go 1.27.1+ 并加入 PATH" >&2; exit 1; }

export GOPROXY="${GOPROXY:-https://goproxy.cn,direct}"
mkdir -p "$ROOT/bin"

if [[ "$SKIP_TIDY" != "1" ]]; then
  echo ">> go mod tidy"
  go mod tidy
fi

build_one() {
  local goos="$1" goarch="$2" out="$3"
  echo ">> GOOS=$goos GOARCH=$goarch CGO_ENABLED=0 -> $out"
  CGO_ENABLED=0 GOOS="$goos" GOARCH="$goarch" go build -trimpath -ldflags '-s -w' -o "$out" .
  echo "   ok $out"
}

case "$TARGET" in
  linux)
    build_one linux amd64 "$ROOT/bin/fssadmin"
    ;;
  windows)
    build_one windows amd64 "$ROOT/bin/fssadmin.exe"
    ;;
  all)
    build_one linux amd64 "$ROOT/bin/fssadmin"
    build_one windows amd64 "$ROOT/bin/fssadmin.exe"
    ;;
  *)
    echo "用法: $0 [linux|windows|all]" >&2
    exit 1
    ;;
esac

echo "build done"
