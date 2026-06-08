# Urun Plani: City Quest + Sokak Hafizasi

## Ozet

Urun, mobil odakli bir gercek dunya kesif oyunu olacak: kullanici Kadikoy ve Nairobi haritasinda gorev noktalarini gorur, mekana gidip gorev cozer, mekanin hikaye/hafiza katmanini acar, puan ve rozet kazanir.

Ilk fazda ana cekirdek **Quest + Hafiza** olacak. Esnaf odulleri hafif destek olarak eklenecek, canli etkinlikler daha sonraki fazlara birakilacak.

## Teknik Kararlar

- Mobil uygulama: Expo React Native.
- Mobile web/PWA: hafif quest discovery ve aktivasyon icin desteklenmeli.
- Backend: Elixir/Phoenix JSON API.
- Veritabani hedefi: PostgreSQL + PostGIS.
- Repo yapisi: `apps/mobile` + `api`.
- Rust: simdilik yok; ileride geospatial hesaplama, anti-cheat veya rota optimizasyonu icin opsiyon.

## MVP

- Sehir secimi: Kadikoy / Nairobi.
- Harita/gorev pinleri.
- Gorev detay ekrani.
- Puan ve rozet gosteren profil ekrani.
- LesTupid aktivasyon/kanal consent yuzeyi.
- Opsiyonel Les Match firsat sinyalleri: check-in, quest interest, event plan,
  travel plan.
- Opsiyonel Les AI/AgentAndBot destegi: quest fikri, field note, yer kaniti
  ozeti.
- Ilk icerik mock/seed veriyle baslayacak.

## Fazlar

1. Harita + gorevler + puan/rozet.
2. Esnaf odulleri ve sponsor gorevleri.
3. Kullanici uretimli icerik, Les AI destekli taslaklar ve moderasyon.
4. Urban Live tarzinda anlik etkinlik pinleri.
5. Opsiyonel Les Block proof/value katmani: quest proof, badge proof, point
   snapshot.
6. Gerekirse Rust destekli geospatial veya anti-cheat servisleri.
