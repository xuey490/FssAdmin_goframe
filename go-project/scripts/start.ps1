# 一键启动（后台）。工作目录必须是 go-project 根，配置按相对路径解析。
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

$bin = Join-Path $Root 'bin\fssadmin.exe'
$pidFile = Join-Path $Root 'bin\fssadmin.pid'
$logDir = Join-Path $Root 'logs'
$outLog = Join-Path $logDir 'console.out.log'
$errLog = Join-Path $logDir 'console.err.log'

function Get-ListenAddr {
    $cfg = Join-Path $Root 'manifest\config\config.yaml'
    if (Test-Path $cfg) {
        $m = Select-String -Path $cfg -Pattern '^\s*address:\s*"?([^"\s]+)"?' | Select-Object -First 1
        if ($m) { return $m.Matches[0].Groups[1].Value }
    }
    return '127.0.0.1:8787'
}

function Test-Running {
    if (-not (Test-Path $pidFile)) { return $false }
    $id = [int](Get-Content $pidFile | Select-Object -First 1)
    $p = Get-Process -Id $id -ErrorAction SilentlyContinue
    return [bool]$p
}

if (Test-Running) {
    $id = Get-Content $pidFile | Select-Object -First 1
    Write-Host "already running pid=$id  http://$(Get-ListenAddr)"
    exit 0
}

if (-not (Test-Path $bin)) {
    Write-Host 'binary missing, building windows...'
    & (Join-Path $PSScriptRoot 'build.ps1') -Target windows
}

New-Item -ItemType Directory -Force -Path (Split-Path $bin), $logDir | Out-Null

$p = Start-Process -FilePath $bin -WorkingDirectory $Root -PassThru -WindowStyle Hidden `
    -RedirectStandardOutput $outLog -RedirectStandardError $errLog
$p.Id | Set-Content -Encoding ascii $pidFile
Start-Sleep -Seconds 1
if (-not (Get-Process -Id $p.Id -ErrorAction SilentlyContinue)) {
    Write-Host "start failed, see $errLog"
    if (Test-Path $errLog) { Get-Content $errLog -Tail 40 }
    Remove-Item $pidFile -ErrorAction SilentlyContinue
    exit 1
}

$addr = Get-ListenAddr
Write-Host "started pid=$($p.Id)"
Write-Host "  http://$addr"
Write-Host "  OpenAPI  http://$addr/api.json"
Write-Host "  Swagger  http://$addr/docs"
Write-Host "  logs     $outLog"
