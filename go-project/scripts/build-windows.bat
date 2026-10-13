@echo off
cd /d "%~dp0.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1" -Target windows %*
if errorlevel 1 exit /b 1
