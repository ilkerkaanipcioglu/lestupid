# LesTupid

LesTupid, Harezm ekosisteminin sadakat, sertifikasyon ve bekleme/queue
katmanlarini tasiyan cati alandir.

Temel kimlik kurali: kullanici LesTupid ekosistemine bir kez kaydolur; diger
uygulamalarda yeni hesap acmaz, sadece ilgili uygulamayi aktive eder.

Temel mimari kurali: her uygulama tek basina calisabilir kalir. LesTupid cati
uygulamasi digerlerini aktive etmeyi kolaylastirir, ama hicbir urun kendi temel
islevi icin baska bir LesTupid uygulamasina gomulu olmak zorunda degildir.

Uygulama gelistirme kurali: sistem hizli, sade ve flexible kalmalidir. Ortak
katmanlar sadece kimlik, aktivasyon, kanal izni, manifest discovery ve temel UI
parcalarini paylasir; urunlerin kendi akisini agir bir merkezi platforma
baglamaz.

UI ruh kurali: akan sey akar, duran sey durur, hizli sey hizli hissedilir,
sakin sey nefes alir, kalabalik yer yogun gorunur, riskli/kotu sey acikca
riskli gorunur. Her uygulama ve her yer kendi karakterini gostermelidir.

## Guncel Yapi

```text
LesTupid/
  e-any.online/
  Les_Commerce/
  LesTupid_Lan/
  les_ai/
  les_affiliate_oyun/
  les_care/
  les_contacts/
  les_go/
  les_harmonica/
  les_match/
  les_travel/
  Les_poke/
  les_certification/
  les_wait/
```

| Klasor | Rol |
| --- | --- |
| `e-any.online/` | Internal/customer tool hub: CV generator, background remover, SVG vectorizer, embeddable tools, Windmill/Activepieces flow orchestration. |
| `Les_Commerce/` | LesTupid uyumlu ticaret, pazar yeri ve yerel magaza uygulamalari. |
| `LesTupid_Lan/` | LesTupid dil, renderer ve spec denemeleri. |
| `les_care/` | Guvenli saglik bilgisi, ilk yardim, klinik/eczane yonlendirme ve sertifikali bilgi katkisi katmani. |
| `les_contacts/` | Kisisel CRM: kisiler, yerler, iliski timeline'i, takip notlari ve gizli kisi/yer hafizasi. |
| `les_go/` | LesTupid Go PWA shell: ogrenci check-in, aktivasyon ve cross-app firsat feed'i. |
| `les_harmonica/` | Guvenli iletisim, trusted proximity, anonim/pairwise contact ve sertifikali guvenli handoff uygulamasi. |
| `les_match/` | Consent-first matchmaking: insan, mekan, esnaf, quest, bekleme ve servis eslestirme uygulamasi. |
| `les_travel/` | Seyahat hazirlik, resmi vize kaynak kontrolu, konaklama guvenligi, rota/donus plani ve ozel seyahat hafizasi. |
| `Les_poke/` | Sehir hafizasi, gercek dunya questleri ve loyalty puan kaynagi. |
| `les_certification/` | Lestupid felsefesi, sertifikasyon kriterleri, ortak kimlik/aktivasyon, loyalty network ve urun sertifika registry dosyalari. |
| `les_wait/` | Beklemesiz / akilli sira ve bekleme uygulamasi, openspec belgeleri ve prototip dosyalari. |
| `les_ai/` | LesTupid AI uyumluluk katmani: KADRO agent kadrosu, agentandbot.com platform baglantisi ve kolektif ai_senaryo alani. |
| `les_affiliate_oyun/` | Sosyal ticaret kart oyunu: affiliate urun kartlari, quest drop'lari, opt-in duello/takim eslesmeleri ve sertifikali oyun ekonomisi. |

## Ayrilabilir Uygulama Modeli

Her urun iki mod desteklemelidir:

- `standalone_app`: kendi deploy'u, verisi, kullanici/profil kaydi ve admin
  yuzeyiyle bagimsiz uygulama.
- `ecosystem_activated_app`: tek LesTupid kimligi uzerinden aktive edilen,
  diger uygulamalarla kanal ve firsat paylasabilen uygulama.

Ortak kimlik, aktivasyon, kanal ve sertifikasyon katmanlari adapter olarak
tasarlanir. Bir uygulamayi ekosistemden ayirmak gerektiginde core akisi
calismaya devam etmeli; sadece cross-app ozellikler kapanmali veya yerel
fallback'a donmelidir.

Platform hedefi:

- Once API-first app.
- Sonra responsive mobile web/PWA.
- Gerekirse ayni UI'dan Expo mobile app.
- Desktop icin once web/PWA, ihtiyac olursa Tauri shell.
- Electron gibi agir secenekler sadece gercek desktop ihtiyaci dogarsa.

Detay sozlesmeleri:

- `LESTUPID_APP_CATALOG.md`
- `ROADMAP.md`
- `docs/AGENTIC_AUTH_STRATEGY.md`
- `docs/VISUAL_DEMO_FLOWS.md`
- `docs/RENAME_INVENTORY.md`
- `les_certification/lestupid-identity-activation-spec.md`
- `les_certification/light-core-activation-api.md`
- `les_certification/lestupid-app-portability-spec.md`
- `les_go/contextual-ui-principles.md`
