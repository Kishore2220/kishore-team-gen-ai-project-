@echo off
rem KARE Help Desk - double-click to build the website (with the KARE logo).
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0make_web.ps1"
pause
