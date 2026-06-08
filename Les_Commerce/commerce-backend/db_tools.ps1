# PostgreSQL Veritabanı Yönetim Aracı
# Deecommerce/Dukkadee Projesi için

param (
    [string]$action = "status",
    [string]$env = "dev"
)

# .env dosyasından değişkenleri yükle
function Load-EnvVars {
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
}

# PostgreSQL araçlarını PATH'e ekle
function Setup-PostgresPath {
    $env:Path += ";C:\Program Files\PostgreSQL\15\bin"
    # Şifre için env değişkenlerini kullan
    $env:PGPASSWORD = $env:POSTGRES_PASSWORD
}

# Veritabanı durumunu kontrol et
function Check-Database {
    $dbName = if ($env -eq "test") { $env:POSTGRES_TEST_DB } else { $env:POSTGRES_DB }
    
    Write-Host "Veritabanı durumu kontrol ediliyor: $dbName" -ForegroundColor Cyan
    
    # PostgreSQL'e bağlanabilme durumunu kontrol et
    try {
        $result = psql -U $env:POSTGRES_USER -h $env:POSTGRES_HOST -c "\l" -t | Select-String $dbName
        
        if ($result) {
            Write-Host "Veritabanı '$dbName' mevcut." -ForegroundColor Green
            
            # Şema göçleri tablosunu kontrol et
            $migrationsResult = psql -U $env:POSTGRES_USER -h $env:POSTGRES_HOST -d $dbName -c "SELECT COUNT(*) FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';" -t
            
            if ($migrationsResult -gt 0) {
                Write-Host "Veritabanında $migrationsResult tablo mevcut." -ForegroundColor Green
                
                # Şema göç durumunu kontrol et
                if (psql -U $env:POSTGRES_USER -h $env:POSTGRES_HOST -d $dbName -c "\dt schema_migrations" -t) {
                    $migrations = psql -U $env:POSTGRES_USER -h $env:POSTGRES_HOST -d $dbName -c "SELECT version FROM schema_migrations ORDER BY version;" -t
                    Write-Host "Uygulanan göçler:" -ForegroundColor Yellow
                    $migrations | ForEach-Object { Write-Host "- $_" -ForegroundColor Yellow }
                } else {
                    Write-Host "schema_migrations tablosu henüz oluşturulmamış." -ForegroundColor Yellow
                }
            } else {
                Write-Host "Veritabanı boş, henüz tablo oluşturulmamış." -ForegroundColor Yellow
            }
        } else {
            Write-Host "Veritabanı '$dbName' mevcut değil." -ForegroundColor Red
        }
    } catch {
        Write-Host "PostgreSQL'e bağlanırken hata oluştu: $_" -ForegroundColor Red
    }
}

# Tüm veritabanı bağlantılarını sonlandır
function Terminate-Connections {
    $dbName = if ($env -eq "test") { $env:POSTGRES_TEST_DB } else { $env:POSTGRES_DB }
    
    Write-Host "Veritabanına aktif bağlantılar sonlandırılıyor: $dbName" -ForegroundColor Cyan
    
    $query = "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$dbName' AND pid <> pg_backend_pid();"
    
    try {
        $result = psql -U $env:POSTGRES_USER -h $env:POSTGRES_HOST -c "$query" -t
        Write-Host "Tüm bağlantılar sonlandırıldı." -ForegroundColor Green
    } catch {
        Write-Host "Bağlantıları sonlandırırken hata oluştu: $_" -ForegroundColor Red
    }
}

# Veritabanını sil
function Drop-Database {
    $dbName = if ($env -eq "test") { $env:POSTGRES_TEST_DB } else { $env:POSTGRES_DB }
    
    Write-Host "Veritabanı siliniyor: $dbName" -ForegroundColor Cyan
    
    # Önce bağlantıları sonlandır
    Terminate-Connections
    
    # Veritabanını sil
    try {
        $result = psql -U $env:POSTGRES_USER -h $env:POSTGRES_HOST -c "DROP DATABASE IF EXISTS $dbName;" -t
        Write-Host "Veritabanı '$dbName' silindi." -ForegroundColor Green
    } catch {
        Write-Host "Veritabanını silerken hata oluştu: $_" -ForegroundColor Red
    }
}

# Veritabanı oluştur
function Create-Database {
    $dbName = if ($env -eq "test") { $env:POSTGRES_TEST_DB } else { $env:POSTGRES_DB }
    
    Write-Host "Veritabanı oluşturuluyor: $dbName" -ForegroundColor Cyan
    
    try {
        $result = psql -U $env:POSTGRES_USER -h $env:POSTGRES_HOST -c "CREATE DATABASE $dbName;" -t
        Write-Host "Veritabanı '$dbName' oluşturuldu." -ForegroundColor Green
    } catch {
        Write-Host "Veritabanını oluştururken hata oluştu: $_" -ForegroundColor Red
    }
}

# Veritabanını sıfırla (sil ve yeniden oluştur)
function Reset-Database {
    Write-Host "Veritabanı sıfırlanıyor..." -ForegroundColor Cyan
    Drop-Database
    Create-Database
    Write-Host "Veritabanı sıfırlama işlemi tamamlandı." -ForegroundColor Green
}

# Veritabanında SQL sorgusu çalıştır
function Execute-Query {
    param (
        [string]$query
    )
    
    $dbName = if ($env -eq "test") { $env:POSTGRES_TEST_DB } else { $env:POSTGRES_DB }
    
    Write-Host "SQL sorgusu çalıştırılıyor..." -ForegroundColor Cyan
    Write-Host $query -ForegroundColor Gray
    
    try {
        $result = psql -U $env:POSTGRES_USER -h $env:POSTGRES_HOST -d $dbName -c "$query" -t
        Write-Host "Sorgu başarıyla çalıştırıldı." -ForegroundColor Green
        return $result
    } catch {
        Write-Host "Sorgu çalıştırılırken hata oluştu: $_" -ForegroundColor Red
        return $null
    }
}

# Göçleri işaretle
function Mark-Migrations {
    param (
        [string]$version = "20250501000000"
    )
    
    $dbName = if ($env -eq "test") { $env:POSTGRES_TEST_DB } else { $env:POSTGRES_DB }
    
    Write-Host "Göç işaretleniyor: $version" -ForegroundColor Cyan
    
    $query = "INSERT INTO schema_migrations (version, inserted_at) VALUES ('$version', now());"
    
    # Önce schema_migrations tablosunun varlığını kontrol et
    $tableExists = Execute-Query "SELECT to_regclass('schema_migrations');"
    
    if ($tableExists -match "schema_migrations") {
        Execute-Query $query
        Write-Host "Göç $version başarıyla işaretlendi." -ForegroundColor Green
    } else {
        Write-Host "schema_migrations tablosu mevcut değil. Önce göçleri çalıştırın." -ForegroundColor Red
    }
}

# Ana işlevler

# Çevre değişkenlerini yükle
Load-EnvVars

# PostgreSQL yolunu ayarla
Setup-PostgresPath

# Seçilen işleme göre fonksiyonu çalıştır
switch ($action) {
    "status" {
        Check-Database
    }
    "terminate" {
        Terminate-Connections
    }
    "drop" {
        Drop-Database
    }
    "create" {
        Create-Database
    }
    "reset" {
        Reset-Database
    }
    "mark" {
        Mark-Migrations
    }
    "query" {
        $query = Read-Host "SQL sorgusunu girin"
        Execute-Query $query
    }
    default {
        Write-Host "Geçersiz işlem: $action" -ForegroundColor Red
        Write-Host "Geçerli işlemler: status, terminate, drop, create, reset, mark, query" -ForegroundColor Yellow
    }
}

# İşlem tamamlandı
Write-Host "`nİşlem tamamlandı." -ForegroundColor Green
