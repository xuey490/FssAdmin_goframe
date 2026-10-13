# 一键停止。ponytail: Windows 无 SIGTERM，直接 Stop-Process；Linux 用 stop.sh。
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

$pidFile = Join-Path $Root 'bin\fssadmin.pid'

function Stop-Pid {
    param([int]$Id)
    $p = Get-Process -Id $Id -ErrorAction SilentlyContinue
    if (-not $p) { return }
    Write-Host "stopping pid=$Id ($($p.ProcessName))"
    Stop-Process -Id $Id -Force -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 300
}

$stopped = $false
if (Test-Path $pidFile) {
    $raw = (Get-Content $pidFile | Select-Object -First 1)
    if ($raw -match '^\d+$') {
        Stop-Pid -Id ([int]$raw)
        $stopped = $true
    }
    Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
}

Get-Process -Name 'fssadmin' -ErrorAction SilentlyContinue | ForEach-Object {
    Stop-Pid -Id $_.Id
    $stopped = $true
}

if ($stopped) {
    Write-Host 'stopped'
} else {
    Write-Host 'not running'
}
