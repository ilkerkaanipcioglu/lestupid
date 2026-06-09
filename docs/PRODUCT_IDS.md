# LESTUPID Product IDs

This file is the canonical product id registry for manifests, event envelopes,
activation records, API metadata and integration contracts.

Folder names may keep their current casing or historical names. Display names
may be human-friendly. Product ids must stay lowercase and hyphen-separated.

## Canonical Product IDs

<!-- canonical-product-ids:start -->
| Canonical ID | Display Name | Current Directory / Scope | Notes |
| --- | --- | --- | --- |
| `lestupid-roof` | LesTupid | `.` | Ecosystem roof and discovery layer. |
| `les-core` | Les Core | planned | Lightweight identity, activation and event contract API. |
| `les-certification` | Les Certification | `les_certification` | Registry, certification and proof policy. |
| `les-go` | LesTupid Go | `les_go` | PWA shell and cross-app opportunity surface. |
| `les-wait` | Les Wait | `les_wait` | Waiting, queue and service-state app. |
| `les-poke` | Les Poke | `Les_poke` | Place check-in, quest and city memory app. |
| `les-match` | Les Match | `les_match` | Consent-first matchmaking app. |
| `les-care` | Les Care | `les_care` | Safe health information and care routing. |
| `les-harmonica` | Les Harmonica | `les_harmonica` | Secure contact and trusted proximity app. |
| `les-contacts` | Les Contacts | `les_contacts` | Private contact, place and relationship graph. |
| `les-travel` | Les Travel | `les_travel` | Travel readiness, planning and private trip memory. |
| `les-commerce` | Les Commerce | `Les_Commerce` | Commerce family / umbrella product area. |
| `lescommerce-core` | Les Commerce Core | `Les_Commerce` | Current core commerce backend compatibility id. |
| `lescommerce-quick-commerce` | Les Commerce Quick Commerce | `Les_Commerce/quick-commerce-elixir` | Quick store builder. |
| `lescommerce-diydiy` | diydiy | `Les_Commerce/diy-marketplace-elixir` | DIY video marketplace. |
| `lescommerce-marketplace` | Les Commerce Marketplace | `Les_Commerce/marketplace-elixir` | Marketplace/listing engine. |
| `lescommerce-books` | Les Commerce Books | `Les_Commerce/books-marketplace` | Book and sahaf marketplace. |
| `lescommerce-storefronts` | Les Commerce Storefronts | `Les_Commerce/storefronts` | Storefront theme pool. |
| `les-itemotel` | Les Item Otel | `Les_Commerce/les_itemotel` | Item custody, storage, care, rental and resale. |
| `les-affiliate` | Les Affiliate Oyun | `les_affiliate_oyun` | Affiliate game canonical id. |
| `les-ai` | Les AI | `les_ai` | AI compatibility adapter layer. |
| `agentandbot-governance-core` | AgentAndBot Governance Core | `les_ai/agentandbot/governance_core` | Independent AgentAndBot service mirrored into LesTupid. |
| `ai-senaryo` | ai_senaryo | `les_ai/ai_beraberproje` | Collective scenario/video workspace. |
| `e-any` | e-any.online | `e-any.online` | Tools and workflow hub canonical id. |
| `e-any-com` | e-any.com | external expected | External e-government portal candidate. |
| `eny-com-tr` | eny.com.tr | external expected | External TR e-government portal candidate. |
| `e-any-info` | e-any.info | external expected | External social/news feed candidate. |
| `ipcioglu-com` | ipcioglu.com | external expected | External holding site candidate. |
| `ilkerkaan-ipcioglu-com` | ilkerkaan.ipcioglu.com | external expected | External personal page candidate. |
| `lestupid-lan` | LesTupid Lan | `LesTupid_Lan` | Language renderer and tooling. |
<!-- canonical-product-ids:end -->

## Legacy Aliases

These ids may still appear in older docs or comments, but must not be used in
new manifests, registry product ids, event envelopes or activation records.

| Legacy ID | Canonical ID | Notes |
| --- | --- | --- |
| `lestupid-waiting-app` | `les-wait` | Former Les Wait product id. |
| `les-affiliate-oyun` | `les-affiliate` | Former affiliate game product id. |
| `e-any-online-tools` | `e-any` | Former e-any.online tools product id. |

## Rules

- Product ids are lowercase and hyphen-separated.
- Folder names do not have to match product ids.
- Display names can contain spaces, casing and product wording.
- Event envelopes must use canonical ids in `source_app`.
- Activation records must use canonical ids in `product_id` and
  `activation_product_id`.
- Registry entries and app manifests must use canonical ids.
