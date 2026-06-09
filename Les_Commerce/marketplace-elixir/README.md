# Marketplace Elixir

Genel marketplace ve listing motoru icin ayrilmis alandir.

Bu katman hem klasik pazaryeri hem de ilan/listing akislari icindir:

- ev, oda, yurt, ofis ve mekan ilanlari
- araba satisi, kiralama ve paylasim ilanlari
- ikinci el urun, kiyafet, elektronik ve kampus satislari
- hizmet listing'leri: tamir, ders, danismanlik, usta, freelance is
- mikro is ve peer service listing'leri: sac/bakim, kampus ici tasima, paket
  teslimi, evrak goturme, hafif kurye, etkinlik destegi, ders anlatma ve odev
  kontrolu
- yerel teklif, talep, sponsor ve merchant opportunity akislari
- satici, alici, magaza ve servis profilleri
- katalog, varyant ve stok modeli gereken urunler
- dikey marketplace'ler: kitapci/sahaf/ikinci el kitap, akademik kitap,
  koleksiyon kitap, hobi veya bolge bazli pazarlar
- siparis, odeme, komisyon ve teklif akislari
- pazaryeri moderasyonu, raporlama ve guven sinyalleri
- agent-friendly servis ve event cikislari

## Tap-To-Filter Listing Discovery

Marketplace icinde gorunen her anlamli deger filtreye donusebilmelidir. Bu
ozellikle ilan pazarinda onemli:

- `Nike`, `Apple`, `Toyota` gibi marka;
- `Air Max`, `iPhone 13`, `Corolla` gibi model;
- `42`, `M`, `XL`, `5 mm` gibi numara/beden/olcu;
- `Kadikoy`, `Nairobi Uni`, `kampus ici` gibi yer;
- `kiralik`, `satilik`, `bakimli`, `ikinci el` gibi listing durumu;
- `paket tasima`, `sac yapma`, `ders anlatma` gibi servis turu.

Bu davranisin ortak kontrati `../tap-to-filter-commerce-spec.md` dosyasindadir.
UI ilk once gorunen degerleri chip/underline olarak sunar; kullanici tiklayinca
aktif filtre barina ekler. Daha derin filtre paneli gerekirse ayni facet
state'inden acilir.

## Dikey Marketplace Ornegi: Books/Sahaf

`../books-marketplace/` NadirKitap benzeri kitapci ve sahaf pazaridir. Yeni
ayri altyapi kurmaz; bu marketplace motorunun dikey kurgusudur.

Kitap/sahaf vertical'i su alanlari ortak facet/listing diline cevirir:

- kitap adi, yazar, yayinevi, ISBN;
- baski, yil, dil, kategori ve ders/akademik alan;
- kondisyon, imzali, ilk baski, koleksiyon etiketi;
- sahaf/kitapci, sehir, kampus, teslimat veya kargo secenegi.

Quick Commerce ile kendi shop'unu acan bir kitapci urunu kataloguna ekler.
Urunu kendi shop'unda tutabilir veya tek aksiyonla Books Marketplace'e
yayinlayabilir. Yayinlama kopya urun degildir; ayni katalog kaydinin pazar
listing kanalidir.

## Mikro Is Sinirlari

Marketplace ogrenci ve yerel kullanicilarin para kazanabilecegi kucuk isleri
destekler:

- ders anlatirim, kaynak bulurum, taslak kontrol ederim, formatlarim;
- sacini yaparim, makyaj/styling/bakim randevusu acarim;
- okula esya tasirim, paketini/evragini gotururum;
- etkinlikte yardim ederim, sira/pickup/teslimat isi alirim.

Akademik sinir: baskasinin yerine odev, sinav, proje veya teslim edilecek
calismayi yapmak desteklenmez. Bu alan "study help" olarak kalir: anlatma,
kontrol, kaynak, plan, format ve geri bildirim.

Teslimat siniri: yasa disi, riskli, kapali/icerigi belirsiz veya yasakli
paketler desteklenmez. Paket/evrak islerinde teslim kaniti, ucret, rota ve
sorumluluk kosullari acik olmalidir.

## LesTupid Konumu

- Les Go bu listing'leri check-in feed'inde local opportunity olarak gosterir.
- Les Go mikro isleri `service_gig` kartlari olarak gosterir; ilk ekranda
  dikkat dagitmayacak sayida kalir, fazlasi browse ile acilir.
- Les Match yalnizca opt-in olursa mentor, sponsor, proje, grup veya
  alici-satici firsatlarini onerir.
- Les Certification ilan, satici, mekan ve hizmet guven sinyallerini okur.
- Les Wait randevu, teslimat, pickup veya hizmet sirasi olan listing'lere
  baglanabilir.
- Les Poke kampus kesfi, local deal veya listing gorevleri uretebilir.

`commerce-engine/` alt klasoru onceki commerce engine calismalarindan ayrilan
yerel calisma alanidir.
