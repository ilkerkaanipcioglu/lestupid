# Les Item Otel

Les Item Otel, Les Commerce altinda calisan esya saklama, bakim, kiralama,
satis ve geri cagirma uygulamasidir.

Kisa fikir: kullanici ayakkabisini, kayak takimini, gelinligini, kislik/yazlik
kiyafetlerini, araba lastigini veya sezonluk esyasini Item Otel'e gonderir.
Esya kataloglanir, guvenli kosullarda saklanir, gerekirse bakimi yapilir.
Kullanici isterse esyasini kiralayabilir, satabilir veya satilmadiysa ihtiyaci
oldugunda geri cagirabilir.

Ana vaat: kullanmadigin esya evinde yer kaplamaz. Otelde durur; otelde bakim
yapilir; istersen kiralanir, hatta satilabilir.

## Core Flow

```text
item intake -> catalog and condition check -> storage and care
  -> optional rent listing
  -> optional sale listing
  -> recall and return
```

## Tap-To-Filter Item Records

Item Otel kayitlari da commerce facet dilini kullanir. Kullanici esya kartinda
gordugu degere tiklayarak filtre acabilmelidir:

- ayakkabi numarasi, beden, olcu;
- kategori: ayakkabi, kayak takimi, gelinlik, lastik, sezonluk kiyafet;
- sezon: kislik, yazlik, okul donemi, tatil;
- care type: temizlik, tamir, lastik kontrolu, cilalama, koruma;
- durum: depoda, kiralik, satilik, bakimda, recall requested;
- yer: depo, kampus, yurt, drop-off noktasi;
- teslimat: peer courier, staff delivery, kargo.

Ortak kontrat `../tap-to-filter-commerce-spec.md` dosyasindadir. Ozel ve
sahiplik bilgileri public filtreye donusmez; sadece kullanicinin kendi
ekraninda veya izinli marketplace listing'inde kullanilir.

1. Esya kabul: kullanici esyasini kurye, kargo veya drop-off noktasi ile
   gonderir.
2. Kataloglama: esya fotograf, kategori, barkod/QR, kondisyon ve sahiplik
   kaydiyla sisteme girer.
3. Saklama: esya uygun depo, raf, nem/sicaklik veya sigorta kosullariyla
   saklanir.
4. Bakim: kuru temizleme, tamir, kayak cilalama, lastik kontrolu, ayakkabi
   bakimi veya gelinlik koruma gibi hizmetler kayda islenir.
5. Kiralama: sahibi izin verirse esya musait zamanlarda kiralik listing'e
   doner ve pasif gelir uretir.
6. Satis: sahibi izin verirse esya satilik listing'e doner; satis olursa recall
   kapanir ve sahiplik transferi kayda girer.
7. Geri cagirma: esya satilmadiysa kullanici tek aksiyonla geri ister.

## Peer Courier

Item Otel profesyonel kurye ile calisabilir ama kampus/yurt gibi yerlerde
ogrenci peer courier modeli de acilir. Ayni yurtta kalan veya ayni rotadan
gecen ogrenci esyayi Item Otel'e goturur, otelden geri getirir veya bakim
noktasina birakir; teslim kaniti tamamlaninca para kazanir.

Ornekler:

- yurttaki ogrenci ayakkabiyi Item Otel'e goturur;
- araba lastigi degisim noktasina giderken baska birinin lastigini de tasir;
- kayak takimi, forma, kucuk spor ekipmani veya paket otelden alinir;
- gelinlik ve hassas esyalar yalnizca sertifikali/guvenli tasiyici akisiyle
  acilir.

Peer courier profesyonel lojistigin yerine gecmek zorunda degildir; hizli,
yerel ve dusuk riskli esya akislari icin opsiyonel kazanma kanalidir.

## Les Commerce Konumu

- Marketplace: item otel esyalari kiralik/satilik listing olarak pazara
  acilabilir.
- Quick Commerce: item otel operatoru veya partner depo kendi magazasini
  acabilir.
- DIY Marketplace: tamir, yenileme, bakim videosu ve usta hizmetleri item care
  akisi icin kaynak olabilir.
- Storefronts: item otel operatorleri icin ileride depo/servis temalari
  uretilebilir.

## Ekosistem Entegrasyonlari

- Les Go: check-in feed'inde "kayak tatiline gidiyorsun, kayak takimi kirala",
  "yaz geldi, kisliklari depoya gonder", "lastik degisim zamani" gibi kartlar
  uretir.
- Les Match: yalnizca opt-in ise esya ihtiyaci ile esya arzini eslestirir.
  Insan eslesmesi degil, item opportunity olarak etiketlenir.
- Les Wait: depo teslim alma, bakim randevusu, kurye pickup ve geri teslim
  siralarini yonetir.
- Les Commerce Marketplace: peer courier ve item tasima islerini mikro gig
  olarak yayinlar.
- Les Certification: sahiplik, kondisyon, bakim gecmisi, hijyen, sigorta ve
  teslim kanitlarini sertifikasyon sinyali olarak tutar.
- Les AI: fotograflardan kategori/kondisyon tahmini, bakim onerisi, fiyat ve
  kiralama uygunlugu onerisi verir.
- Les Block: opsiyonel proof, teslim alma/teslim etme kaniti, bakim proof'u ve
  loyalty point event'i uretir.

## Minimum Veri Modeli

### `StoredItem`

- `id`
- `owner_identity_id`
- `name`
- `category`: `apparel`, `sports`, `automotive`, `wedding`, `footwear`,
  `seasonal`, `other`
- `status`: `intake_pending`, `in_storage`, `in_care`, `listed_for_rent`,
  `listed_for_sale`, `rented_out`, `recall_requested`, `returned`, `sold`
- `condition_rating`
- `storage_location_code`
- `images`

### `ItemCareLog`

- `id`
- `item_id`
- `care_type`: `cleaning`, `repair`, `tire_check`, `waxing`, `preservation`,
  `inspection`
- `performed_at`
- `provider_id`
- `certificate_id`

### `ItemListing`

- `id`
- `item_id`
- `listing_type`: `rent`, `sale`, `both`
- `price_sale`
- `price_rent_daily`
- `deposit_amount`
- `availability_window`
- `is_active`

### `ItemRecall`

- `id`
- `item_id`
- `requested_at`
- `delivery_address`
- `status`: `requested`, `preparing`, `shipped`, `delivered`, `cancelled`

### `ItemCourierJob`

- `id`
- `item_id`
- `courier_identity_id`
- `job_type`: `hotel_dropoff`, `hotel_pickup`, `care_dropoff`, `care_pickup`
- `pickup_place_id`
- `dropoff_place_id`
- `fee_amount`
- `proof_required`: `qr_scan`, `photo`, `staff_confirmed`, `recipient_confirmed`
- `status`: `open`, `assigned`, `picked_up`, `delivered`, `cancelled`, `disputed`

## Safety and Trust

- Sahiplik ve teslim kaniti olmadan esya satisa/kiraya acilmaz.
- Kullanicinin acik izni olmadan esya marketplace'e dusmez.
- Gelinlik, ayakkabi, spor ekipmani, cocuk/okul esyasi ve hijyen riski tasiyan
  kategoriler icin temizlik ve kondisyon etiketi zorunludur.
- Satilan esya geri cagiralamaz; recall sadece satilmamis ve uygun statudeki
  esyalar icindir.
- Kiralama hasar, depozito, sigorta ve teslim sartlari acik gosterilir.
- Peer courier islerinde teslim kaniti, rota, ucret, paket/esya siniri ve
  uyusmazlik proseduru zorunludur.
- Hassas, pahali, agir veya hijyen riski olan esyalar icin sigorta, staff
  onayi veya sertifikali tasiyici gerekebilir.
