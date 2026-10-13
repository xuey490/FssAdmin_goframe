@echo off
REM 在 Windows 上交叉编译 Linux amd64
cd /d "%~dp0.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1" -Target linux %*
if errorlevel 1 exit /b 1
