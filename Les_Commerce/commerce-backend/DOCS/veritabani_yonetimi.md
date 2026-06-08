# Veritabanı Yönetim Araçları

Bu dokümantasyon, Dukkadee/Africa Ecommerce projesi için oluşturulan veritabanı yönetim araçlarını detaylı bir şekilde açıklar.

## Genel Bakış

Projemizde PostgreSQL veritabanı kullanılmaktadır. Geliştirme sürecinde veritabanı yönetimini kolaylaştırmak için çeşitli araçlar oluşturulmuştur:

1. `.env` dosyası - Çevre değişkenlerini saklamak için
2. PowerShell scriptleri - Veritabanı ve sunucu yönetimi için
3. Elixir scriptleri - Veritabanı sıfırlama ve göçleri işaretleme için
4. Docker desteği - Konteynerize geliştirme ortamı için

## Çevre Değişkenleri

Projede `.env` dosyası kullanılarak hassas bilgiler (şifreler, API anahtarları vb.) güvenli bir şekilde saklanmaktadır. Bu dosya `.gitignore` listesinde yer aldığından versiyon kontrolü tarafından izlenmez.

Örnek `.env` dosyası:

```
POSTGRES_USER=postgres
POSTGRES_PASSWORD=20911980
POSTGRES_HOST=localhost
POSTGRES_DB=dukkadee_dev
POSTGRES_TEST_DB=dukkadee_test
PORT=4003
SECRET_KEY_BASE=BurasıÇokGizliDoldurun
```

## Veritabanı Yönetim Araçları

### 1. PowerShell Araçları

#### db_tools.ps1

Bu script, veritabanı yönetimi için çeşitli fonksiyonlar sunar.

Kullanım:

```powershell
.\db_tools.ps1 [action] [env]
```

Parametreler:
- `action`: Gerçekleştirilecek işlem (status, terminate, drop, create, reset, mark, query)
- `env`: Çalışma ortamı (dev, test)

Örnekler:

```powershell
# Veritabanı durumunu kontrol et
.\db_tools.ps1 status

# Veritabanı bağlantılarını sonlandır
.\db_tools.ps1 terminate

# Veritabanını sil
.\db_tools.ps1 drop

# Veritabanını oluştur
.\db_tools.ps1 create

# Veritabanını sıfırla (sil ve yeniden oluştur)
.\db_tools.ps1 reset

# Test veritabanı durumunu kontrol et
.\db_tools.ps1 status test
```

#### start_server.ps1

Phoenix sunucusunu başlatan script.

Kullanım:

```powershell
.\start_server.ps1
```

Bu script şunları yapar:
1. Çevre değişkenlerini yükler
2. Çalışan Erlang/Elixir süreçlerini sonlandırır
3. Veritabanı bağlantısını kontrol eder
4. Bağımlılıkları günceller
5. Varlıkları derler
6. Phoenix sunucusunu başlatır

#### reset_and_start.ps1

Veritabanını sıfırlayıp Phoenix sunucusunu başlatan script.

Kullanım:

```powershell
.\reset_and_start.ps1
```

Bu script şunları yapar:
1. Çevre değişkenlerini yükler
2. Çalışan Erlang/Elixir süreçlerini sonlandırır
3. Veritabanını sıfırlar
4. Göçleri çalıştırır
5. Bağımlılıkları günceller
6. Varlıkları derler
7. Phoenix sunucusunu başlatır

### 2. Elixir Araçları

#### reset_db.exs

Veritabanını sıfırlamak için Elixir script.

Kullanım:

```bash
mix run reset_db.exs
```

Bu script şunları yapar:
1. Çevre değişkenlerini yükler
2. Aktif veritabanı bağlantılarını sonlandırır
3. Veritabanını siler
4. Veritabanını yeniden oluşturur

#### mark_migrations.exs

Göçleri işaretlemek için Elixir script. Bu script, göçlerin zaten çalıştırıldığını işaretleyerek, göç hatalarını çözmek için kullanılabilir.

Kullanım:

```bash
mix run mark_migrations.exs
```

Bu script şunları yapar:
1. Çevre değişkenlerini yükler
2. schema_migrations tablosunu kontrol eder ve gerekirse oluşturur
3. Ana göç dosyasını işaretler
4. Mağaza göçlerini (varsa) işaretler

## Docker Desteği

Projede Docker kullanarak konteynerize bir geliştirme ortamı oluşturulabilir.

### docker-compose.yml

Docker Compose yapılandırması, PostgreSQL veritabanı ve Phoenix uygulaması için konteynerler oluşturur.

Kullanım:

```bash
# Konteyner başlatma
docker-compose up

# Arkaplanda başlatma
docker-compose up -d

# Konteyner durdurma
docker-compose down
```

## Önerilen Yöntemler

### İlk Kurulum

Yeni bir sisteme kurulum yaparken şu adımları izleyin:

1. `.env` dosyasını oluşturun
2. Veritabanını oluşturun:
   ```
   .\db_tools.ps1 create
   ```
3. Göçleri çalıştırın:
   ```
   mix ecto.migrate
   ```
4. Sunucuyu başlatın:
   ```
   .\start_server.ps1
   ```

### Veritabanı Sorunlarını Çözme

Göç hataları veya diğer veritabanı sorunlarıyla karşılaşırsanız:

1. Veritabanını sıfırlayın:
   ```
   .\db_tools.ps1 reset
   ```
   veya
   ```
   mix run reset_db.exs
   ```

2. Göçleri işaretleyin (gerekirse):
   ```
   mix run mark_migrations.exs
   ```

3. Göçleri çalıştırın:
   ```
   mix ecto.migrate
   ```

### Hızlı Geliştirme İş Akışı

Günlük geliştirme için:

1. Sunucuyu başlatın:
   ```
   .\start_server.ps1
   ```

2. Veritabanı/sunucu sorunlarını çözmek için:
   ```
   .\reset_and_start.ps1
   ```

## Hata Ayıklama İpuçları

1. Veritabanı durumunu kontrol edin:
   ```
   .\db_tools.ps1 status
   ```

2. PostgreSQL'e doğrudan bağlanarak sorgu çalıştırın:
   ```
   .\db_tools.ps1 query
   ```

3. Aktif bağlantıları sonlandırın (veritabanı kilitlendiğinde):
   ```
   .\db_tools.ps1 terminate
   ```

4. Çalışan Erlang süreçlerini sonlandırın (sunucu takılırsa):
   ```
   Get-Process erl -ErrorAction SilentlyContinue | Stop-Process -Force
   ``` 