# KARE Help Desk - builds the website folder with the KARE logo and name.
# Used by make_web.bat (double-click that file).

Set-Location $PSScriptRoot

if (-not (Test-Path "pubspec.yaml")) {
  Write-Host "ERROR: put make_web.bat and make_web.ps1 inside the KARE_HelpDesk_FINAL folder (next to pubspec.yaml)." -ForegroundColor Red
  exit 1
}
if (-not (Test-Path "assets\images\kare_logo.png")) {
  Write-Host "ERROR: assets\images\kare_logo.png not found." -ForegroundColor Red
  exit 1
}

Write-Host "1/5 Saving your main.dart..."
Copy-Item "lib\main.dart" "$env:TEMP\kare_main.dart" -Force

if (-not (Test-Path "web\index.html")) {
  Write-Host "2/5 Creating the web folder (first time only)..."
  flutter create --platforms web --project-name kare_helpdesk .
  Copy-Item "$env:TEMP\kare_main.dart" "lib\main.dart" -Force
  Remove-Item "test\widget_test.dart" -ErrorAction SilentlyContinue
} else {
  Write-Host "2/5 Web folder already exists."
}

Write-Host "3/5 Putting the KARE logo on the website..."
foreach ($f in @("web\favicon.png", "web\icons\Icon-192.png", "web\icons\Icon-512.png",
                 "web\icons\Icon-maskable-192.png", "web\icons\Icon-maskable-512.png")) {
  Copy-Item "assets\images\kare_logo.png" $f -Force
}

Write-Host "4/5 Setting the name KARE Help Desk..."
$idx = Get-Content "web\index.html" -Raw
$idx = $idx -replace '<title>[^<]*</title>', '<title>KARE Help Desk</title>'
$idx = $idx -replace 'content="kare_helpdesk"', 'content="KARE Help Desk"'
Set-Content -Path "web\index.html" -Value $idx -Encoding UTF8

$man = Get-Content "web\manifest.json" -Raw
$man = $man -replace '"name": "[^"]*"', '"name": "KARE Help Desk"'
$man = $man -replace '"short_name": "[^"]*"', '"short_name": "KARE Help Desk"'
Set-Content -Path "web\manifest.json" -Value $man -Encoding UTF8

Write-Host "5/5 Building the website (2 to 3 minutes)..."
flutter pub get
flutter build web --release

Write-Host ""
Write-Host "DONE. Your website folder is: build\web" -ForegroundColor Green
Write-Host "Drag the 'web' folder to https://app.netlify.com/drop"
Start-Process explorer.exe "$PWD\build"
