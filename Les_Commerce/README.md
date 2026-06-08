# LesCommerce

LesCommerce, LesTupid ekosistemindeki ticaret katmanidir. Tek bir dev
uygulama degil; birbirine baglanabilen ticaret motorlari ve bir storefront
havuzundan olusur.

## Alt Alanlar

| Klasor | Rol | Stack |
| --- | --- | --- |
| `diy-marketplace-elixir/` | DIY marketplace. Videodan DIY urunleri, malzeme bundle'lari, usta/mentor randevulari ve hazir el isi urunleri uretir. Ornek: orgu videosu -> ip/sis malzemeleri -> orgu ustasi -> hazir kazak. | Elixir/Phoenix, Next.js |
| `les_itemotel/` | Esya oteli. Ayakkabi, kayak takimi, gelinlik, sezonluk kiyafet, araba lastigi gibi fiziksel esyalarin saklama, bakim, kiralama, satis ve geri cagirma akisini yonetir. | Manifest/spec |
| `marketplace-elixir/` | Genel marketplace ve listing motoru. Ev, araba, hizmet, ikinci el urun, yerel teklif, freelance is, mekan veya kisi bazli ilanlar burada konumlanir. | Elixir/Phoenix |
| `quick-commerce-elixir/` | Shopify benzeri hizli e-ticaret sitesi acma motoru. Merchant magaza acar, tema/storefront secer, katalog ve checkout yayinlar. | Elixir/Phoenix, Astro |
| `storefronts/` | Quick Commerce icin ortak tema ve storefront havuzu. Aktif vitrinler simdilik kendi urun klasorlerinde durur; ortaklasan sablonlar buraya gelir. | Planlanan |

## Iliski Modeli

- DIY bir video sayfasini ticarete cevirir: egitim videosu, malzeme bundle,
  usta/mentor, hazir urun.
- Marketplace ilan ve pazar mantigini tasir: ev, araba, hizmet, ikinci el,
  yerel listing, kampus ilanlari ve teklif akislari.
- Item Otel esya custody mantigini tasir: kullanicinin esyasi depoda durur,
  bakimi yapilir, sahibi isterse kiralanir veya satilir, satilmadiysa geri
  cagirilir.
- Quick Commerce magazayi tasir: marka/merchant vitrini, katalog, checkout,
  kampanya, siparis.
- Storefronts Quick Commerce'in tema ve vitrin sablonlarini ortaklastirir.
- Tap-to-filter butun ticaret yuzeylerinin ortak kesif davranisidir: kullanici
  baslikta, aciklamada, varyantta, listing metninde veya kayitta gordugu marka,
  model, numara, beden, yer, malzeme, usta, kategori gibi degerlere tiklayarak
  filtre acabilir.

Bu motorlar ayrik calisabilmeli ama birbirine firsat uretmelidir. Ornegin:

- Bir DIY orgu drop'u Quick Commerce magazasina urun olarak eklenebilir.
- Bir DIY ustasi Marketplace'te hizmet listing'i olarak gorunebilir.
- Item Otel'deki kayak takimi Marketplace'te kiralik listing olabilir.
- Item Otel'deki araba lastigi icin Les Wait bakim/degisim randevusu acabilir.
- Marketplace'teki bir araba kiralama ilani Les Go check-in feed'inde local
  opportunity olabilir.
- Quick Commerce magazasinin vitrin temasi `storefronts/` havuzundan secilebilir.
- Les Affiliate Oyun, Les Commerce urunlerini ve listing'lerini `product_card`
  veya `creator_card` olarak kullanabilir. Affiliate link, fiyat, checkout,
  refund, merchant terms ve komisyon ledger'i Les Commerce'te kalir; oyun
  sadece kart/deck deneyimini ve odul preview'ini yonetir.
- Influencer/creator promotion Go'da baglam olarak dogar: creator kafede,
  kampuste, beach'te, etkinlikte veya magazada yurur, video/live/foto/story
  uretir ve para kazanir. Les Commerce bu isin ticari kaydini tutar: brief,
  fiyat, teslim beklentisi, affiliate link, komisyon, fatura, iptal ve merchant
  terms. Les Poke bunu quest/challenge yapabilir; Les Match creator/merchant/
  sponsor eslesmesini yalnizca opt-in acar; Les Certification sponsorlu icerik
  disclosure ve sahte engagement riskini denetler.
- Les Certification satici, mekan, urun, video ve ilan guven sinyallerini
  ortak okur.
- Les Match yalnizca opt-in ise mentor, sponsor, workshop veya alici-satici
  firsati onerir; listing ve insan eslesmesi ayri etiketlenir.

## Tap-To-Filter

Commerce ekranlari form doldurtarak baslamamali. Kullanici gordugu seye dokunur
ve pazar o deger etrafinda daralir. Ornekler:

- ayakkabi basliginda `42` geciyorsa `size=42` filtresi;
- aciklamada `Nike Air Max` geciyorsa `brand=Nike`, `model=Air Max`;
- DIY sayfasinda `5 mm orgu sisi` geciyorsa `material/tool=5 mm needle`;
- Item Otel kaydinda `kislik lastik` geciyorsa `category=tire`,
  `season=winter`;
- listing satirinda `Kadikoy` geciyorsa `place=Kadikoy`.

Ortak kontrat: `tap-to-filter-commerce-spec.md`.

## Guncel Yapi

```text
Les_Commerce/
  diy-marketplace-elixir/
    backend/
    storefront/
  les_itemotel/
  marketplace-elixir/
    commerce-engine/
  quick-commerce-elixir/
    backend/
    storefront/
  storefronts/
```

## Notlar

- Eski `LesCommerce/backend` yolu `quick-commerce-elixir/backend` altina tasindi.
- Eski `LesCommerce/storefront` yolu `quick-commerce-elixir/storefront` altina tasindi.
- Eski `LesCommerce_diyapp/backend` yolu `diy-marketplace-elixir/backend` altina tasindi.
- Eski `LesCommerce_diyapp/storefront` yolu `diy-marketplace-elixir/storefront` altina tasindi.
