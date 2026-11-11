@echo off
rem Double-click to run the KARE Help Desk app in Chrome.
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File ".\run_chrome.ps1"
pause
