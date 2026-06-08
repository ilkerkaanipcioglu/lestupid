# Veritabanı Sıfırlama ve Phoenix Sunucusu Başlatma Scripti
# Dukkadee/Africa Ecommerce Projesi için

# Çevre değişkenlerini yükle
if (Test-Path .env) {
    Get-Content .env | ForEach-Object {
        if ($_ -match "^\s*([^#][^=]+)=(.*)$") {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            Set-Item -Path "env:$key" -Value $value
        }
    }
    Write-Host "ENV değişkenleri yüklendi." -ForegroundColor Green
} else {
    Write-Host ".env dosyası bulunamadı!" -ForegroundColor Red
    exit 1
}

# Çalışan Erlang/Elixir süreçlerini sonlandır
Write-Host "Çalışan Erlang süreçleri sonlandırılıyor..." -ForegroundColor Yellow
Get-Process erl -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process epmd -ErrorAction SilentlyContinue | Stop-Process -Force
Write-Host "Tüm Erlang süreçleri sonlandırıldı." -ForegroundColor Green

# PostgreSQL yolunu ayarla
$env:Path += ";C:\Program Files\PostgreSQL\15\bin"
$env:PGPASSWORD = $env:POSTGRES_PASSWORD

# Veritabanını sıfırla
Write-Host "Veritabanı sıfırlanıyor..." -ForegroundColor Yellow
mix run reset_db.exs
Write-Host "Veritabanı sıfırlandı." -ForegroundColor Green

# Göçleri çalıştır
Write-Host "Göçler çalıştırılıyor..." -ForegroundColor Yellow
mix ecto.migrate
Write-Host "Göçler tamamlandı." -ForegroundColor Green

# Bağımlılıkları güncelle
Write-Host "Bağımlılıklar güncelleniyor..." -ForegroundColor Yellow
mix deps.get
Write-Host "Bağımlılıklar güncellendi." -ForegroundColor Green

# Varlıkları derle
Write-Host "Varlıklar derleniyor..." -ForegroundColor Yellow
cd assets
npm install
cd ..
Write-Host "Varlıklar derlendi." -ForegroundColor Green

# Phoenix sunucusunu başlat
Write-Host "Phoenix sunucusu başlatılıyor..." -ForegroundColor Yellow
Write-Host "Sunucu adresi: http://localhost:$env:PORT" -ForegroundColor Cyan
mix phx.server 