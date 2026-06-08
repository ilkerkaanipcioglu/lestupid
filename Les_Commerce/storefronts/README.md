# LesCommerce Storefronts

Bu klasor Quick Commerce'in ortaklasacak vitrin ve tema sablonlari icin ayrilmis
havuzdur. Amac merchant'in Shopify benzeri akista magaza acarken sececegi
storefront varyantlarini burada toplamak ve yeniden kullanmaktir.

Mevcut aktif storefrontlar kendi urun klasorleri altindadir:

| Aktif storefront | Rol | Stack |
| --- | --- | --- |
| `../quick-commerce-elixir/storefront/` | Quick Commerce'in hizli, icerik ve katalog odakli commerce vitrini. | Astro |
| `../diy-marketplace-elixir/storefront/` | DIY video, malzeme, hazir urun ve usta pazaryeri deneyimi. Quick Commerce tema havuzuna bagli degil, kendi DIY deneyimidir. | Next.js |

Yeni ortak storefrontlar bu klasore `nextjs-*`, `astro-*` veya kullandigi
teknolojiye gore acik isimlerle eklenmelidir. Bu klasorun asil sahibi Quick
Commerce'tir; diger commerce uygulamalari buradaki temalari adapter ile
kullanabilir ama kendi urun deneyimlerini korur.
