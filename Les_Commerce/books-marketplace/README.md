# LesCommerce Books Marketplace

NadirKitap benzeri kitapci, sahaf, koleksiyoncu ve okul/akademi kitap pazari
icin ayrilmis dikey marketplace alanidir.

Bu yeni bir ayri altyapi degildir. `lescommerce-marketplace` listing motorunu,
Quick Commerce merchant katalog modelini ve ortak tap-to-filter kontratini
kullanir.

## Konum

- `lescommerce-books`: kitap ve sahaf marketplace vertical'i.
- `lescommerce-marketplace`: ortak listing/search/order altyapisi.
- `lescommerce-quick-commerce`: kitapci veya sahaf kendi shop'unu acar.
- `storefronts`: kitapci shop temalari ve vitrin sablonlari.

## Ilk Senaryo

1. Sahaf veya kitapci Quick Commerce ile shop acar.
2. Kitaplari kendi shop kataloguna ekler.
3. Urun ekrani "marketplace'e yayinla" aksiyonu sunar.
4. Satici isterse urunu `lescommerce-books` pazarina da ekler.
5. Marketplace arama/facet/filter ayni katalog kaydini okur.
6. Siparis, stok, fiyat, kargo ve komisyon kaydi ortak commerce eventlerine
   duser.

## Kitap Facetleri

Tap-to-filter icin ilk anlamli alanlar:

- kitap adi;
- yazar;
- yayinevi;
- ISBN;
- baski / yil;
- dil;
- kategori / ders / akademik alan;
- kondisyon;
- imzali / ilk baski / koleksiyon;
- sahaf / kitapci;
- sehir / kampus / teslimat yeri.

## LesTupid Baglantilari

- Les Go: kampus, kutuphane, kurs veya sahaf check-in'inde kitap firsati
  gosterir.
- Les Poke: kitap avlama, sahaf gezisi, okuma kulubu veya ders kitabi bulma
  quest'i uretebilir.
- Les Wait: kitap teslim/pickup sirasi veya sahaf randevusu acabilir.
- Les Match: opt-in olursa ayni kitabi arayan okur, kulup, mentor veya ikinci
  el alici-satici firsati onerir.
- Les Certification: satici, nadir kitap, imza, kondisyon ve sahte urun riskini
  guven sinyali olarak denetler.

## Ayrisma Kurali

Books marketplace kendi marka ve domain'iyle tek basina calisabilmelidir; ama
catalog, listing, order, filter, certification ve storefront davranislari ortak
Les Commerce altyapisindan gelmelidir.
