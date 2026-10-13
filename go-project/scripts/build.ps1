# FssAdmin GoFrame: Windows 本机 / 交叉编译
#   .\scripts\build.ps1                 # 本机 windows/amd64 -> bin\fssadmin.exe
#   .\scripts\build.ps1 -Target linux   # 交叉 linux/amd64  -> bin\fssadmin-linux-amd64
#   .\scripts\build.ps1 -Target all
param(
    [ValidateSet('windows', 'linux', 'all')]
    [string]$Target = 'windows',
    [switch]$SkipTidy
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

if (-not (Get-Command go -ErrorAction SilentlyContinue)) {
    throw '未找到 go，请先安装 Go 1.27.1+ 并加入 PATH'
}

if (-not $env:GOPROXY) {
    $env:GOPROXY = 'https://goproxy.cn,direct'
}

$binDir = Join-Path $Root 'bin'
New-Item -ItemType Directory -Force -Path $binDir | Out-Null

if (-not $SkipTidy) {
    Write-Host '>> go mod tidy'
    go mod tidy
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

function Invoke-Build {
    param([string]$Goos, [string]$Goarch, [string]$Out)
    $env:CGO_ENABLED = '0'
    $env:GOOS = $Goos
    $env:GOARCH = $Goarch
    Write-Host ">> GOOS=$Goos GOARCH=$Goarch CGO_ENABLED=0 -> $Out"
    go build -trimpath -ldflags '-s -w' -o $Out .
    $code = $LASTEXITCODE
    Remove-Item Env:GOOS -ErrorAction SilentlyContinue
    Remove-Item Env:GOARCH -ErrorAction SilentlyContinue
    Remove-Item Env:CGO_ENABLED -ErrorAction SilentlyContinue
    if ($code -ne 0) { throw "go build failed ($Goos/$Goarch)" }
    Write-Host "   ok $(Resolve-Path $Out)"
}

$targets = @($Target)
if ($Target -eq 'all') { $targets = @('windows', 'linux') }

foreach ($t in $targets) {
    if ($t -eq 'windows') {
        Invoke-Build windows amd64 (Join-Path $binDir 'fssadmin.exe')
    } else {
        Invoke-Build linux amd64 (Join-Path $binDir 'fssadmin-linux-amd64')
    }
}

Write-Host 'build done'
