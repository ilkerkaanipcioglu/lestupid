# Dukkadee Quick Commerce Backend (LesCommerce Africa) Başlatıcı
# Port: 4005 | DB: dukkadee_africa.db

$env:PORT="4005"
$env:DATABASE_PATH="dukkadee_africa.db"

Write-Host "--------------------------------------------------------" -ForegroundColor Cyan
Write-Host "Quick Commerce (LesCommerce Africa) Backend Baslatiliyor..." -ForegroundColor Green
Write-Host "Port: 4005 | Veritabani: $env:DATABASE_PATH" -ForegroundColor Yellow
Write-Host "--------------------------------------------------------" -ForegroundColor Cyan

# Veritabanı dosyası yoksa otomatik oluşturup migrasyonları çalıştırmak için
if (-not (Test-Path $env:DATABASE_PATH)) {
    Write-Host "Veritabani bulunamadi, sifirdan olusturuluyor..." -ForegroundColor Magenta
    mix ecto.setup
}

mix phx.server
