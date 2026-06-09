# LESTUPID Ekosistemi — Agent Geliştirme Komut Dosyası

## ANTIGRAVITY AGENT ÖNERİLERİ & PERFORMANS NOTLARI (HAZİRAN 2026)

Sevgili geliştirici agent, LESTUPID ekosistemini kodlarken hem insan hem de agent kullanıcı deneyimini artırmak ve **sistem performansını korumak/yavaşlatmamak** adına aşağıdaki kurallara ve önerilere dikkat etmeni önemle rica ederim:

### 1. Performans & Hafiflik Kriterleri (Sistemi Yavaşlatmama Kuralları)
- **Veritabanı İndeksleri:** Event tabanlı yapılarda (`check_in`, `opportunity_event` vb.) `product_id`, `event_type`, `occurred_at` alanlarına mutlaka veritabanı indeksleri (`index: true` veya migration düzeyinde index) ekle. Bu, event log'lar büyüdükçe sorguların yavaşlamasını engeller.
- **Asenkron Event Dağıtımı:** Event broadcast veya notification gibi işlemleri Phoenix controller/LiveView ana akışında senkron olarak yürütme. Mümkünse `Task.start/1` veya `Oban` kuyrukları ile asenkron arka plan görevleri olarak tasarla.
- **Frontend / React Performansı:** PWA (`les_go`) üzerinde veri setlerini ve listeleri render ederken gereksiz re-render'lardan kaçın. React state güncellemelerinde `useMemo` ve `useCallback` hook'larını yerinde kullan, mock verileri olabildiğince hafif tut.
- **Dosya Depolama ve Ağ İstekleri:** Ağ isteklerinin sayısını minimumda tutmak için cache (Redis veya ETS) yapılarını aktif kullan.

### 2. Kod Yapısı & Okunabilirlik (Geliştiriciler & Agentlar İçin)
- **Ayrık Uygulama (Separable) Modeli:** Phoenix uygulamalarının birbirinin iş mantığına doğrudan bağımlı olmasını önle. Diğer modüllerle haberleşirken sadece hafif HTTP client katmanları veya kontrat adapter'ları kullan.
- **Gizlilik Limitlerine Uyum:** Event envelope'larında `private` seviyesindeki verilerin (`payload`) kesinlikle ortak stream'e yazılmadığından emin ol.
- **Küçük ve Atomik Değişiklikler:** Değişiklikleri büyük bloklar halinde tek seferde yapmaktan kaçın; her bir değişiklik öncesinde `# DEĞİŞİKLİK: ...` gerekçesini içeren tek cümlelik yorum satırını eklemeyi unutma.

---

## Görev Tanımı

Sen bir yazılım geliştirme agentısın. **LESTUPID** dijital ekosistemini geliştirmekle görevlisin. Repo'ya tam erişimin var.

### Çalışma Protokolü — MUTLAKA UYGULA

**Her bileşen için şu sırayı izle:**

1. **Önce repo'yu tara.** İlgili bileşenin mevcut kodunu bul ve oku. Dosya yapısını, modül isimlerini, mevcut logic'i tam olarak anla.
2. **Bu belgedeki öneriyle karşılaştır.** Aşağıdaki mimari ve uygulama tanımlarını referans al.
3. **Karar ver:**
   - Mevcut kod bu belgedeki yaklaşımdan **daha iyiyse veya eşdeğerdeyse** → **dokunma**, devam et.
   - Bu belgedeki yaklaşım **daha iyiyse** → değişikliği uygula.
4. **Her değişiklik öncesi tek cümleyle gerekçe yaz.** Format: `# DEĞİŞİKLİK: [ne değişiyor] — [neden daha iyi]`
5. **Asla sıfırdan silip yeniden yazma.** Çalışan kodu koru, üzerine inşa et.

**"Daha iyi" kriterleri:**
- Daha az kod, aynı işlevsellik
- Daha iyi test edilebilirlik
- Ekosistem entegrasyonuna (standart event envelope, adapter sınırı) daha uygun
- Elixir/OTP idiomlarına daha yakın
- Performans veya hata toleransı açısından üstün

---

## Ekosistem Genel Bakış

**LESTUPID**, birden fazla mobil uygulama, web uygulaması ve web sitesinden oluşan, birbirine entegre çalışan bir dijital ekosistemdir. İsim, "aptal değil, akıllıca" anlamını taşır — ekosistemin sertifika sistemi bu değeri yansıtır.

**Temel prensipler:**
- Her uygulama **bağımsız çalışır** — standalone APK/IPA/web sitesi olarak deploy edilebilir, ayrıca ekosisteme bağlı modda da çalışabilir
- Uygulamalar birbirinin iş mantığını doğrudan içe aktarmaz; iletişim **standart event envelope** ve **adapter sınırı** üzerinden olur
- Kullanıcı bir uygulamaya girdiğinde diğerleri önerilir; zamanla ekosisteme dahil olur
- Mümkün olduğunda kullanıcı uygulamalar arası geçiş yapmadan aynı uygulama içinden genişletme ile diğer özelliklere ulaşır
- Her uygulamanın iki çalışma modu vardır: `standalone_app` ve `ecosystem_activated_app`
- Backend Elixir/Phoenix tabanlıdır; önyüz teknolojisi uygulamaya göre değişir

---

## Teknik Mimari

### Genel Model: Separable Apps + Hafif Contract Katmanı

Repo, her ürünün bağımsız çalışabildiği **ayrılabilir uygulama modeli** üzerine kuruludur. Bu model korunur — erken aşamada zorunlu umbrella migrasyonu yapılmaz. Uygulamalar arasındaki bağ şu üç katmanla sağlanır:

```
[Uygulama A]  ←→  les_core contract API  ←→  [Uygulama B]
                   (kimlik, aktivasyon,
                    event envelope)
```

**Her Phoenix uygulaması şu standart dosyaları içerir:**

```
lib/<app>/ecosystem.ex          # ürün kimliği, manifest, entegrasyon listesi
lib/<app>/events.ex             # yayınlanan ve dinlenen event tipleri
<app>_web/controllers/
  agent_manifest_controller.ex  # GET /.well-known/lestupid-app.json
  health_controller.ex          # GET /api/health
test/<app>_web/controllers/*_test.exs
```

**Her uygulama şu endpoint'leri açar:**
- `GET /api/health`
- `GET /.well-known/lestupid-app.json`
- `GET /agent-manifest.json` (agent-compatible uygulamalar için)

### Canonical Product ID Kuralı

Tüm manifests, event'ler ve API'lerde **küçük harf, tire ile ayrılmış** canonical ID kullanılır. Display name ayrı tutulur.

| Canonical ID | Display Name |
|---|---|
| `les-core` | Les Core |
| `les-poke` | Les Poke |
| `les-wait` | Les Wait |
| `les-match` | Les Match |
| `les-contacts` | Les Contacts |
| `les-certification` | Les Certification |
| `les-travel` | Les Travel |
| `les-harmonica` | Les Harmonica |
| `les-care` | Les Care |
| `les-commerce` | Les Commerce |
| `lescommerce-core` | Les Commerce Core |
| `les-ai` | Les AI |
| `les-affiliate` | Les Affiliate Oyun |
| `e-any` | e-any.online |
| `les-go` | Les Go |

Naming drift olan dosyalarda (`Les_poke`, `les-wait`, `lestupid-waiting-app` vb.) canonical ID'ye geçiş yapılır. Dosya/klasör isimlerinde mevcut konvansiyona dokunulmaz; sadece manifest, event ve API içerikleri canonical ID kullanır.

### Standart Event Envelope

Tüm uygulamalar arası event'ler bu formatta yayınlanır. Hiçbir uygulama bu formatın dışına çıkmaz:

```json
{
  "schema_version": "lestupid.event.v1",
  "event_id": "evt_<ulid>",
  "event_type": "<event_type_aşağıdaki_listeden>",
  "source_app": "<canonical-product-id>",
  "identity_id": "id_<ulid>",
  "occurred_at": "2026-06-09T12:00:00Z",
  "privacy_level": "coarse_location | private | public",
  "payload": {}
}
```

**Tanımlı event tipleri:**

| event_type | Yayınlayan | Dinleyenler |
|---|---|---|
| `user_registered` | les-core | les-affiliate, les-contacts |
| `app_activated` | les-core | tüm uygulamalar |
| `channel_activated` | les-core | les-match, les-harmonica, les-care |
| `place_checkin_recorded` | les-poke | les-contacts, les-certification, les-affiliate, les-wait |
| `match_opportunity_created` | les-match | les-contacts, les-travel, les-harmonica |
| `match_decision_recorded` | les-match | les-contacts |
| `purchase_completed` | les-commerce | les-contacts, les-affiliate, les-certification |
| `itemotel_item_listed` | les-commerce | les-certification |
| `queue_ticket_created` | les-wait | les-poke |
| `certification_signal_recorded` | les-certification | les-poke |
| `travel_created` | les-travel | les-poke, les-match |
| `agent_hired` | les-ai | les-ai (ai_beraberproje dinler) |

**Gizlilik kuralı:** `private` seviyesindeki event payload'ları (konum izi, sağlık verisi, adres defteri, ham makbuz) shared event stream'e yazılmaz. Bunlar yalnızca ilgili uygulamanın kendi veritabanında şifreli saklanır.

### Manifest Tutarlılık Testleri

Her uygulama için şu testler yazılır:

- `lestupid-app.json` içindeki `product_id` → registry canonical ID ile eşleşmeli
- `Ecosystem.product_id()` → manifest `product_id` ile eşleşmeli
- `runtime_modes` → `standalone_app` içermeli
- `activation` ve `portability` alanları mevcut olmalı

### Önyüz Stratejisi

| Katman | Teknoloji | Kullanım Alanı |
|--------|-----------|----------------|
| Web UI (dinamik) | Phoenix LiveView | les-wait, les-poke, les-match, les-contacts, les-harmonica, les-care, les-affiliate, e-any.online |
| Web UI (SEO / storefront) | Next.js (ayrı repo) | les-commerce storefronts, agentandbot.com, les-certification landing |
| Mobil | React Native + Expo | Tüm mobil uygulamalar — super app veya standalone APK/IPA |
| PWA | Vite/React (les-go) | Demo shell, offline kullanım, cross-app fırsat akışı |

**Mobil Super App yaklaşımı:** Expo Router ile her uygulama ayrı paket olarak geliştirilir. Ana "LESTUPID" uygulaması lazy-load ile içerir. Her paket ayrıca standalone APK/IPA olarak export edilebilir.

### les_core — Hafif Contract API (Ağır Platform Değil)

`les_core` şu aşamada tam OAuth/OIDC platformu olmaz. Minimum contract surface:

**Endpoint'ler:**
- `GET /api/identity/status`
- `GET /api/activations`
- `POST /api/activations/apps/:product_id`
- `POST /api/activations/channels/:channel_id`
- `POST /api/check-ins`
- `POST /api/opportunity-events`

**Kayıtlar:**
- `identity`
- `app_activation`
- `channel_activation`
- `check_in`
- `opportunity_event`

OAuth/OIDC, refresh token, external provider, billing, bildirim altyapısı ve tam kullanıcı yönetimi **sonraki aşamalara** bırakılır.

### les_go — PWA Demo Shell

Mevcut Vite/React/TypeScript yapısı korunur. Büyük dosyalar (`main.tsx`, `data.ts`, `adapters.ts`) davranış değiştirilmeden feature modüllerine bölünür:

```
les_go/src/
  features/
    feed/
    places/
    commerceFacets/
    skillAdapters/
    appModes/
  adapters/
    opportunity/
    lesCore/
  mock/
    fixtures/
  shared/
    types/
    ui/
```

İlk canlı entegrasyon: les-core aktivasyon/check-in state. Fırsat kartları backend contract'lar stable olana kadar mock-backed kalır.

### Les_Commerce — Wrapper Önce, Rewrite Yok

`commerce-backend` gerçek Phoenix kodu ve testler içeriyor. Dukkadee naming ve router tekrarları var ama **sıfırdan yazılmaz**. Sıra:

1. LesTupid-uyumlu wrapper contract ekle (`/.well-known/lestupid-app.json`, facet API, event publisher)
2. Manifest canonical ID'ye hizala (`lescommerce-core`)
3. Router tekrarlarını temizle
4. Naming'i kademeli güncelle

---

## Uygulamalar — Detaylı Tanımlar

### les-core *(Faz 1 — hafif contract API olarak başlar)*

Ekosistem kimlik ve aktivasyon contract'ı. Bu aşamada ağır bir identity platform değil; diğer uygulamaların bağlanabileceği minimum API yüzeyi.

- Kimlik durumu ve aktivasyon yönetimi
- App ve channel aktivasyonu
- Check-in ve opportunity event kaydı
- Scoped consent (les-match, les-harmonica, les-care için ayrı onay akışı)
- Event envelope tanımları (tüm ekosistem bu tanımları kullanır)

---

### les-contacts *(Faz 1 — diğer uygulamaların CRM'i)*

Kullanıcının tüm ekosistemden zaman içinde biriktirdiği kişileri ve yerleri CRM tarzında tutar.

**İlk runtime dilimi (dış import yok — check-in'den başla):**
- Contact ve place record struct/schema
- les-poke check-in'inden private draft timeline event
- Açık visibility ve sensitivity alanları
- Ham adres defteri yüklemesi yok, varsayılanda AI eğitimi yok

**Sonraki aşamada:** Google Contacts, SIM kart import.

**Önyüz:** Phoenix LiveView + mobil React Native

---

### les-certification *(Faz 1 — hafif tut)*

Tüm LESTUPID uygulamalarına, web sitelerine ve fiziksel mekânlara "LESTUPID sertifikası" verir.

**Mevcut durum:** JSON registry ve policy doc'lar var, validator çalışıyor — bu korunur.

**Sonraki adımlar:**
- CI'da `validate-registry.mjs` çalıştırma
- Canonical product ID doğrulaması
- Opsiyonel event/schema doğrulama
- Gerçek reviewlar başladığında auditable registry geçmişi

**Henüz yapılmaz:** Ağır admin paneli.

**Önyüz:** Next.js landing (ileride) + mevcut JSON registry

---

### les-poke *(Faz 2)*

Kullanıcıların fiziksel ve sanal yerlere check-in yapabildiği keşif uygulaması.

**Mevcut durum:** Phoenix JSON API skeleton, testler geçiyor — Ecosystem modülü mevcut.

**Sonraki adımlar (büyük harita sisteminden önce):**
- `POST /api/check-ins` endpoint'i
- `place_checkin_recorded` event yayony (standart envelope ile)
- Quest tamamlanma event'i
- Konum: coarse/private/public ayrımı

**Önyüz:** React Native (mobil öncelikli) + PWA

---

### les-wait *(Faz 2)*

Online veya fiziksel mekânlarda bekleme/sıra yönetimi.

**Özellikler:**
- Bekleme bileti alma (QR kod)
- Anlık sıra takibi
- Sırası gelince push bildirim
- İşletme paneli: sıra yönetimi, tahmini süre
- les-poke entegrasyonu: check-in yapılan yerin kuyruğuna otomatik katılma
- Sanal kuyruk (online hizmetler)

**Önyüz:** Phoenix LiveView (gerçek zamanlı için ideal)

---

### les-match *(Faz 3)*

Kişiler arası eşleştirme uygulaması.

**Mevcut durum:** Phoenix JSON API skeleton, testler geçiyor — Ecosystem modülü mevcut, safety/consent metadata görünür.

**Sonraki adımlar:**
- Persisted match opportunities ve user decisions (Ecto)
- Event input validation
- les-core aktivasyon kontrolü adapter'ı
- Manifest tutarlılık testleri (registry canonical ID ile)

**Entegrasyon sınırı:** les-match, les-contacts/les-care/les-travel/sosyal veriye **yalnızca açık aktivasyon ve onay sonrası** erişebilir.

**Önyüz:** React Native + Phoenix LiveView

---

### les-travel *(Faz 3)*

Bireysel veya grup seyahatlerini yönetme uygulaması.

- Seyahat planı oluşturma (rotalar, tarihler, konaklama)
- les-match'ten gelen seyahat arkadaşlarıyla ortak plan
- Seyahat günlüğü
- les-poke entegrasyonu: seyahatte check-in'ler otomatik güncellenir
- les-certification'lı yerler seyahat planında öne çıkar
- Harcama takibi (grup bölüşümü)

**Önyüz:** React Native + Phoenix LiveView

---

### les-harmonica *(Faz 3)*

Ses tabanlı güvenli kişi bulma uygulaması.

- Sesli profil oluşturma (görsel kimlik paylaşmadan)
- Ses analizi ile kişilik eşleşmesi
- Güvenli, anonim sesli chat
- les-match ile entegrasyon: ses profili eşleşme algoritmasını besler
- **Ses verisi:** yerel şifreleme + sunucuda anonimleştirilmiş saklama
- Aktivasyon gerektirir — les-core channel aktivasyonu zorunlu

**Önyüz:** React Native (ses özellikleri için native)

---

### les-care *(Faz 5)*

Sağlık ve diğer konularda kişiye bilgi sağlayan uygulama.

- Sağlık bilgisi ve semptom değerlendirme (AI destekli)
- İlaç hatırlatıcısı
- Doktor/uzman yönlendirme
- Kişisel sağlık geçmişi (yerel şifreli saklama, GDPR/KVKK uyumlu)
- **Not:** Tıbbi teşhis yapmaz; bilgi ve yönlendirme sağlar
- Aktivasyon gerektirir — les-core'da ayrı sensitive feature consent

**Önyüz:** React Native + Phoenix LiveView

---

### les-commerce *(Faz 4)*

E-ticaret ekosistemi. Mevcut `commerce-backend` (Dukkadee) kodu korunur; wrapper contract eklenir.

**İlk wrapper adımları:**
- `/.well-known/lestupid-app.json` endpoint'i
- `lescommerce-core` canonical ID ile manifest hizalaması
- Ürün/listing facet API
- `purchase_completed` event (standart envelope)
- `itemotel_item_listed` event
- Router tekrar temizliği (kademeli)

#### quick-commerce
Kullanıcıların hızlıca e-ticaret sitesi açabildiği platform.
- Mağaza oluşturma wizard'ı, ürün yönetimi, stok takibi
- Ödeme entegrasyonu (Stripe)
- Otomatik storefront atama

#### Marketplace
- Ürün listeleme ve arama
- Ev, araba gibi büyük varlıklar için listing
- Satıcı değerlendirme sistemi

#### Storefronts
- Next.js tabanik statik + SSR storefrontlar
- Tema marketplace, özel domain desteği

#### Book Marketplace
- ISBN tabanlı kitap katalog
- İkinci el kitap satışı, sahaf profilleri

#### les_itemotel
Mevsimsel eşyaların bırakılıp saklandığı, kiralanıp satılabildiği platform.
- Eşya kayıt/fotoğrafa, depolama takibi
- Oteldeyken bakım/onarım servisi
- Kiralama veya satış
- İstendiğinde kargo ile iade

#### DIY Market
- YouTube video yükleme/embed
- Video içeriğindeki malzemelerin listelenmesi (AI destekli)
- Usta/zanaatkâr profilleri
- "Bana yaptır" akışı: malzemeleri ustaya kargolatarak ürün sipariş etme

---

### les-ai *(Faz 5)*

#### agentandbot.com
- Ajan tanıtım sayfaları, skill kütüphanesi, topluluk
- **Önyüz:** Next.js (SEO öncelikli, bağımsız domain)

#### ai_beraberproje
- Kolektif yaratıcı proje platformu (senaryo, film, müzik)
- Emek katkısı + kaynak katkısı + gelir paylaşımı modeli
- les-ai/ai_kadro entegrasyonu: AI ajanları projeye katılabilir

#### ai_kadro
- Agent kariyer platformu: CV, çalışma örnekleri, stack
- GitHub entegrasyonu: ajan bilgileri taşınabilir
- Hosting bağımsız profil
- Hızlı kurulum rehberi: Hermes, AutoGen, Agent-Zero, OpenCraw
- GitHub token'ları kullanıcı başına izole vault'ta saklanır

---

### e-any.online *(Faz 5)*

Tüm iç araçların ve kullanıcıya sunulan yardımcı araçların merkezi.

- Takım mesajlaşması, proje yönetimi
- Windmill / ActivePieces self-hosted entegrasyonu
- Kullanıcı araçları: arka plan kaldırma, dosya dönüştürme, AI metin araçları

**Önyüz:** Phoenix LiveView + entegre araç frame'leri

---

### les-affiliate *(Faz 2)*

Affiliate pazarlama sistemini oyunlaştıran uygulama.

- Referans linki → puan sistemi
- Seviye: Bronze → Silver → Gold → Platinum
- Görev kartları, lider tablosu
- Puan → nakit / indirim / les-commerce kredisi
- les-poke check-in referansı, les-commerce ürün referansı

**Önyüz:** React Native + Phoenix LiveView

---

## Geliştirme Öncelik Sırası

**Her faza başlamadan önce:** O fazdaki tüm bileşenlerin mevcut durumunu repo'da tara. Dosyaları, modülleri, geçen testleri belgele. Bu belgeyle karşılaştır, eksik veya iyileştirilebilir olanları uygula.

### Faz 1 — Contract Altyapısı

1. **Canonical ID listesi** — `docs/PRODUCT_IDS.md` oluştur, registry doğrulaması ekle
2. **les-core** — hafif contract API (kimlik, aktivasyon, check-in, opportunity event)
3. **les-certification** — CI doğrulaması, canonical ID testi

### Faz 2 — Demo Shell + İlk Canlı Bağlantı

4. **les-go** — feature modüllerine bölme (davranış değişmez), les-core'a bağlama
5. **les-poke** — check-in event endpoint'i ekle
6. **les-contacts** — private draft timeline (check-in'den, dış import yok)
7. **les-affiliate** — büyüme motoru
8. **les-wait** — kuyruk yönetimi

### Faz 3 — Sosyal ve Eşleştirme

9. **les-match** — persisted opportunities, les-core aktivasyon kontrolü
10. **les-harmonica** — ses profili, channel aktivasyon zorunlu
11. **les-travel** — seyahat planlama

### Faz 4 — Ticaret

12. **les-commerce** — wrapper contract (mevcut kodu koru)
13. **quick-commerce**, **Marketplace**, **Storefronts**, **Book**, **İtemotel**, **DIY** — sırayla

### Faz 5 — AI ve Araçlar

14. **les-ai / agentandbot** — Next.js site
15. **les-ai / ai_kadro** — agent profil + GitHub entegrasyonu
16. **les-ai / ai_beraberproje** — kolektif proje sistemi
17. **e-any.online** — araç merkezi
18. **les-care** — sağlık bilgi sistemi (sensitive consent zorunlu)

---

## Mobil Super App — Uygulama Öneri Akışı

Öneri mantığı `les-core` içindeki `RecommendationEngine` modülü tarafından yönetilir; yalnızca public aktivasyon/check-in state'e dayanır.

| Kullanıcı aksiyonu | Önerilen uygulama |
|---|---|
| les-poke'da 3+ check-in | les-wait, les-certification |
| les-match'te eşleşme | les-travel, les-harmonica |
| les-commerce'te alışveriş | les-affiliate, les-itemotel |
| les-travel'da seyahat planı | les-match, les-poke |
| les-harmonica'da ses profili | les-match |
| e-any.online'da araç kullanımı | les-ai/agentandbot |

---

## Teknik Gereksinimler

- **Elixir:** 1.16+ (OTP 26+)
- **Phoenix:** 1.7+ (LiveView 0.20+)
- **Veritabanı:** PostgreSQL 15+
- **Job queue:** Oban
- **Dosya depolama:** S3 compatible (AWS S3 / Cloudflare R2)
- **Mobil:** React Native 0.73+ / Expo SDK 50+
- **Next.js:** 14+ (App Router)
- **Arama:** Meilisearch
- **Cache:** Redis (oturumlar, rate limiting)
- **Monitoring:** Telemetry + Grafana / Honeybadger

---

## Güvenlik Gereksinimleri

- Tüm API endpoint'leri kimlik doğrulama gerektirir
- Rate limiting: les-core middleware'i
- les-harmonica: ses verileri yerel şifreleme + sunucuda anonimleştirilmiş saklama
- les-care: sağlık verileri şifreli, GDPR/KVKK uyumlu, ayrı sensitive consent
- les-itemotel: eşya değerleme ve sigorta için audit log
- les-ai/ai_kadro: GitHub token'ları kullanıcı başına izole vault'ta saklanır
- Private event payload'ları (konum izi, sağlık verisi, adres defteri) shared stream'e yazılmaz

---

## Yapılmaması Gerekenler — KESINLIKLE UYGULA

Aşağıdaki adımlar şu aşamada atılmaz. Prompt içinde başka bir bölüm bile bu kısıtlarla çelişiyor gibi görünse, bu liste önceliklidir.

- **Umbrella migrasyonu yapma** — mevcut separable-app modeli korunur
- **Tam OAuth/OIDC platform kurma** — hafif les-core contract API yeterli
- **Commerce'i sıfırdan yeniden yazma** — mevcut Dukkadee kodu korunur, wrapper eklenir
- **Spec-only uygulamaları aynı anda başlatma** — les-wait, les-care, les-harmonica, les-travel, les-affiliate sadece kendi faz sırası geldiğinde başlar
- **les-go'yu diğer ürünlerin iş mantığı deposu yapma**
- **les-match'in les-contacts, les-care, les-travel veya sosyal veriye açık aktivasyon ve onay olmadan erişmesine izin verme**
- **Private check-in izi, sağlık verisi, adres defteri veya ham makbuz bilgisini shared event'lere yazma**

---

*Bu belge LESTUPID ekosistemine ait tüm bileşenleri, teknik kararları ve geliştirme sırasını tanımlamaktadır. Herhangi bir bileşeni geliştirirken önce ilgili bölümü oku, canonical ID listesini kontrol et, event envelope formatına uy.*

---

## Karşılaştırma Raporu Şablonu

Her bileşeni inceledikten sonra aşağıdaki formatta bir özet çıkar. Değişiklik yapmadan önce bu raporu yaz ve onay bekle.

```
## Karşılaştırma Raporu — [Bileşen Adı]

### Mevcut Durum
- Dosyalar: [bulunan dosyalar]
- Mevcut yaklaşım: [kısa özet]
- Test durumu: [var/yok, geçiyor/geçmiyor]

### Bu Belgedeki Öneri
- Önerilen yaklaşım: [kısa özet]

### Karar
- [ ] Mevcut kod daha iyi — dokunmuyorum
- [ ] Öneri daha iyi — değiştiriyorum
- [ ] Mevcut kod yok — yazıyorum

### Değişiklik Gerekçesi (eğer değiştirilecekse)
[Tek paragraf gerekçe]
```
