# Dukkadee DIY Marketplace Backend (DIYABI.COM) Başlatıcı
# Port: 4003 | DB: dukkadee_dev.db

$env:PORT="4003"
$env:DATABASE_PATH="dukkadee_dev.db"

Write-Host "--------------------------------------------------------" -ForegroundColor Cyan
Write-Host "DIY Marketplace (DIYABI.COM) Backend Baslatiliyor..." -ForegroundColor Green
Write-Host "Port: 4003 | Veritabani: $env:DATABASE_PATH" -ForegroundColor Yellow
Write-Host "--------------------------------------------------------" -ForegroundColor Cyan

mix phx.server
