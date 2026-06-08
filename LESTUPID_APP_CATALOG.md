# LesTupid App Catalog

This file is the single human-readable and AI-readable catalog for products
inside `B:\DEV\HAREZM_EKOSISTEMI\LesTupid`. It summarizes what each app,
sub-app, service, or feature area does, how it relates to other apps, its
current technology, and its GitHub location.

Source of truth:

- Registry: `les_certification/certification-registry.json`
- Manifests: `*/lestupid.app.json`
- Repository: `https://github.com/ilkerkaanipcioglu/lestupid`

Important scope note: the certification registry may mention future or external
properties such as `eny`, `ipcioglu`, or `harezm`. They are not listed in this
catalog unless their files are actually under this LesTupid workspace.
`e-any.online` is listed because its files now exist in this workspace.

## Architecture Rule

Every app should be able to run in two modes:

- `standalone_app`: the product works alone with its own deploy, local account
  or local data model, and core business flow.
- `ecosystem_activated_app`: the product is activated from a shared LesTupid
  identity and can use optional adapters from other LesTupid apps.

Cross-app features must stay adapter-based. No product should become impossible
to separate just because it works well with the ecosystem.

A folder is not always one app. Some folders are product families or workspaces
with multiple sub-apps, services, storefronts, bots, adapters, or feature
modules. Repo boundaries are also flexible: a sub-app can later be split into
its own repository, or separate repos can be merged into the monorepo if that
keeps the system simpler.

## Apps

| App / Area | Product ID | Folder Role / Sub-Apps | What It Does | Related Apps | Technology | Repo Strategy / GitHub |
| --- | --- | --- | --- | --- | --- | --- |
| lestupid roof | `lestupid-roof` | Root ecosystem folder. | Ecosystem roof for honest value, certification, identity activation, portability, and app discovery. | Les Certification, Les Go, Les Match, Les Poke, Les Wait, Les Commerce, Les Care | Root manifests, Markdown docs, registry coordination | Monorepo root now; can keep umbrella docs here. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main` |
| Les Certification | `les-certification` | Policy/registry app folder. Contains registry JSON, identity specs, portability specs, trust credential specs, Les Block adapter spec, validator. | Registry, certification policy, identity activation, portability, loyalty, pseudonymous trust credentials, and proof rules. | All LesTupid apps, Les Block adapter, Les Go, Les Commerce, Les Match, Les Poke | JSON registry, Markdown specs, Node validator; Phoenix/PostgreSQL planned | Monorepo now; can split into `les-certification-api` later. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/les_certification` |
| LesTupid Go | `les-go` | App folder. PWA shell with typed adapters, mock data, visual flow gallery, Item Otel panel and opportunity feed. | Mobile web/PWA shell for place/mode check-ins, app activation, channel consent, visual cross-app storyboard, opportunity feed, contextual creator/influencer promotion opportunities, and the Nairobi student launch board. | Les Wait, Les Poke, Les Match, Les Contacts, Les Harmonica, Les Affiliate Oyun, Les Commerce, Les AI, Les Travel, Les Certification, Les Block | Vite, React, TypeScript, PWA; mock/http adapters | Monorepo now; natural standalone repo candidate after demo stabilizes. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/les_go` |
| Les Wait | `lestupid-waiting-app` | Product/spec folder. May later contain API, mobile/web surfaces, bot channels and venue dashboards. | Breathable waiting, queue, appointment, and service-state app for canteens, clinics, student affairs, venues, and services; supports QR/table/sign/phone/proximity/staff tablet user entry plus venue owner/staff queue creation. | Les Go, Les Poke, Les Match, Les Commerce, Les Certification, Les Block | Spec/prototype; future API channels SMS/WhatsApp/USSD/Web and venue dashboard | Can stay monorepo while spec-first; split when queue API/venue dashboard becomes active. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/les_wait` |
| Les Poke | `les-poke` | Product family folder. Contains Expo mobile app, Phoenix API, docs, manifest and quest/drop policy. | Mobile-first real-world quest, city memory, check-in, creator drop, creator promotion quest, graduate launch circle, live content challenge, and safe public-space discovery layer. | Les Go, Les Match, Les Commerce, Les Wait, Les AI, Les Certification, Les Block, Les Affiliate Oyun | Expo React Native mobile; Phoenix JSON API; manifests/specs | Good split candidate because mobile/API can live independently. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/Les_poke` |
| Les Match | `les-match` | Product/API folder. Match API, product plan, consent/safety policy and manifest. | Consent-first matchmaking for people, places, merchants, quests, wait states, agents, creators, teams, sponsors, and services. | Les Go, Les Commerce, Les Poke, Les Wait, Les AI, AgentAndBot, Les Harmonica, Les Affiliate Oyun | Elixir/Phoenix JSON API skeleton; Ecto planned; manifest/specs | Likely standalone service repo later; keep adapter contracts in monorepo. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/les_match` |
| Les Care | `les-care` | Product/spec folder. Future safe health info app, certified contributor content, clinic/pharmacy routing. | Safe health information, first-aid guidance, clinic/pharmacy routing, certified content, and optional knowledge rewards. | Les Go, Les AI, Les Wait, Les Commerce, Les Certification, Les Block | Manifest/spec docs; safe health info layer planned | Split only after legal/safety reviewed API begins. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/les_care` |
| Les Harmonica | `les-harmonica` | Product/spec folder. Secure contact, proximity, pairwise pseudonym, encrypted communication. | Safe communication and trusted proximity for identity-hidden contact, pairwise pseudonymous trust, encrypted messaging, and consented handoff. | Les Go, Les Certification, Les Match, Les Block | Manifest/spec docs; secure contact/proximity app planned | Strong standalone app candidate due crypto/contact state. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/les_harmonica` |
| Les Contacts | `les-contacts` | Product/spec folder. Multi-context private CRM: contact graph, place graph, product/service/asset graph and relationship timeline. | Imports people/places/products/assets from phone, Google, LinkedIn, social, travel, shopping, commerce and manual sources; separates personal/work/family/school/social/travel/commerce contexts; tracks private events, purchases, usage, custody, follow-ups, memories, leads and role candidates. | Les Go, Les Match, Les Commerce, Les Item Otel, Les Travel, Les Harmonica, Les Poke, Les Care, Les Certification, Les AI | Manifest/spec docs; local-first/Phoenix/PWA service planned | Strong standalone app candidate because it owns private relationship graph data. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/les_contacts` |
| Les Travel | `les-travel` | Product/spec folder. Travel readiness, official visa/source routing, stay safety and trip memory. | Plans trips with official visa/source checks, document readiness, accommodation safety, budget guardrails, route/return plans, scam/risk briefing, emergency contacts, private travel memory, and Nairobi student Turkiye-readiness cards. | Les Go, Les Contacts, Les Commerce, Les Match, Les Harmonica, Les Care, Les Certification, Les AI | Manifest/spec docs; future PWA/API travel readiness service | Standalone travel safety/planning app candidate; can also stay as Go travel mode adapter. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/les_travel` |
| e-any.online | `e-any-online-tools` | Product/app folder. Astro tools hub with public, customer and internal tools plus workflow orchestration metadata. | Hosts tools such as CV generator, background remover, SVG vectorizer and registry surfaces; positions Windmill for internal/long-running jobs and Activepieces for OAuth/SaaS/customer connector flows. | AgentAndBot, Les AI, Les Go, Les Certification, Les Commerce, Les Contacts | Astro, TypeScript, Astro API routes; Windmill/Activepieces adapters; CV runtime/service links | Has its own nested git history now; can be kept as standalone repo and mirrored into LesTupid catalog. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/e-any.online` |
| Les Commerce | `lescommerce-core` | Umbrella folder, not one app. Contains DIY marketplace, Item Otel, marketplace engine, quick commerce, commerce backend, storefront pool. | Commerce family for DIY marketplace, item hotel, general marketplace/listings, quick commerce, storefront themes, tap-to-filter discovery, creator promotion briefs, affiliate campaigns and merchant terms. | Les Go, Les Match, Les Poke, Les Wait, Les Certification, Les Affiliate Oyun, Les Item Otel | Commerce umbrella docs; Phoenix/Elixir sub-apps; storefronts; shared facet signal contract | Keep umbrella in monorepo; mature sub-apps can split. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/Les_Commerce` |
| Les Commerce Quick Commerce | `lescommerce-quick-commerce` | Sub-app under Les Commerce. Backend + storefront. | Shopify-style quick commerce engine for merchant storefronts, catalogs, checkout flows, and theme-based stores. | Les Commerce, Marketplace, DIY, Storefronts, Les Certification | Elixir/Phoenix backend; Astro storefront; quick store engine | Can split as merchant SaaS repo later. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/Les_Commerce/quick-commerce-elixir` |
| diydiy | `lescommerce-diydiy` | Sub-app under Les Commerce. Backend + storefront for DIY/video commerce. | DIY video marketplace for craft drops, material bundles, workshops, appointments, masters, and ready-made products. | Les Commerce, Les Go, Les Poke, Les AI, Les Match, Les Certification, Les Block | Elixir/Phoenix backend; Next.js storefront; DIY marketplace | Can split as creator/DIY marketplace repo. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/Les_Commerce/diy-marketplace-elixir` |
| Les Item Otel | `les-itemotel` | Sub-app under Les Commerce. Item custody/care/rental/resale/recall and peer courier. | Item custody, seasonal storage, care, rental, resale, recall, and peer courier flows for physical belongings. | Les Commerce, Marketplace, Quick Commerce, Les Go, Les Match, Les Wait, Les AI, Les Certification, Les Block | Manifest/spec docs; custody/care/rental/resale service planned | Likely standalone operational repo if warehouse/courier backend grows. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/Les_Commerce/les_itemotel` |
| Les Affiliate Oyun | `les-affiliate-oyun` | Product/spec folder. Social commerce card game; may later include game API, Pixi UI, bots. | Social-commerce card game for product cards, quest drops, creator drops, opt-in duels, transparent affiliate rewards, and certified game economy. | Les Commerce, Les Poke, Les Match, Les Certification, Les Block, Les Go | Manifest/spec docs; planned Elixir/Ash backend and React/Pixi UI | Game can become separate repo; adapter specs stay here. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/les_affiliate_oyun` |
| Les AI | `les-ai` | AI workspace/umbrella folder. Contains KADRO data/platform, AgentAndBot compatibility, ai_senaryo/ai_beraberproje, CV generator and protocols. | LesTupid adapter layer for AI products mostly published through AgentAndBot, including KADRO and ai_senaryo compatibility. | AgentAndBot, KADRO, ai_senaryo, Les Go, Les Match, Les Poke, Les Wait, Les Commerce, Les Certification | Markdown/JSON specs; KADRO data; AgentAndBot adapters | Some parts belong to external AgentAndBot repos; keep LesTupid adapters here. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/les_ai` |
| AgentAndBot Governance Core | `agentandbot-governance-core` | Sub-app under Les AI, but published conceptually outside LesTupid under AgentAndBot. | Independent AgentAndBot runtime for agents, tools, tasks, feeds, personas, marketplace, and automation; LesTupid-compatible by adapters. | Les AI, Les Match, Les Go, Les Certification, ai_senaryo | Elixir/Phoenix governance core; external AgentAndBot platform | External repo candidate/possible source of truth; keep compatibility manifest here if mirrored. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/les_ai/agentandbot/governance_core` |
| ai_senaryo / ai_beraberproje | `ai-senaryo` | Sub-app/workspace under Les AI. Collective story, scenario, prompt, video and project collaboration. | Collective AI scenario, story, prompt, and video generation workspace aligned with LesTupid products. | Les AI, AgentAndBot, Les Go, Les Wait, Les Poke, Les Match, Les Certification | Markdown specs; AI scenario/video workspace; manifest | Can merge with AgentAndBot creative workspace or split as creator product. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/les_ai/ai_beraberproje` |
| LesTupid Lan | `lestupid-lan` | Tooling/spec folder. Language, renderer, HTML renderer, skills and experiments. | LesTupid language, renderer, spec, skill, and tooling experiments. | Les Certification, Les Go renderer experiments | Language spec/tooling; HTML renderer; TypeScript-oriented renderer path | Tooling can stay monorepo until it has independent users. `https://github.com/ilkerkaanipcioglu/lestupid/tree/main/LesTupid_Lan` |

## Runtime And Surface Matrix

This section answers a different question than the product table: is each thing
an app, a web page, a backend service, a bot, a spec folder, or a product
family? It also separates backend and frontend technology instead of hiding
everything under one "tech" label.

| App / Area | Current Shape | User Surface | Backend | Frontend | Main Language / Stack | Status |
| --- | --- | --- | --- | --- | --- | --- |
| lestupid roof | Ecosystem umbrella, not a user app. | Docs, manifests, registry links. | None. | None. | Markdown, JSON. | Active coordination layer. |
| Les Certification | Policy/registry app and future service. | Docs/admin/review surface planned. | Planned Phoenix/PostgreSQL; current validator is Node. | Future web admin possible. | JSON, Markdown, Node.js; Elixir/Phoenix planned. | Spec/registry active. |
| LesTupid Go | Real PWA app. | Mobile web/PWA first; desktop web works; native later; visual flow gallery included. | None in v1; future HTTP/Phoenix adapters. | Vite React TypeScript. | TypeScript, React, Vite. | Working demo app. |
| Les Wait | App concept/spec plus prototype. | Web/mobile/SMS/WhatsApp/USSD channels planned. | Planned API, likely Elixir/Phoenix. | Prototype HTML; future web/mobile surfaces. | Markdown/spec, HTML prototype; Elixir planned. | Spec/prototype. |
| Les Poke | Mobile app plus API product. | Expo mobile app; mobile web later; admin/content surfaces possible; creator promotion quests appear as labeled challenge cards. | Phoenix JSON API skeleton. | Expo React Native. | Elixir/Phoenix, React Native/TypeScript. | Scaffold/spec. |
| Les Match | Backend API app plus future client/admin surfaces. | Match UI can be standalone or launched from Go. | Elixir/Phoenix API skeleton; Ecto planned. | Not primary yet; Go previews opportunities. | Elixir/Phoenix. | API scaffold/spec. |
| Les Care | Product/spec folder, future app. | Web/mobile safe info and clinic/pharmacy routing planned. | Planned service, likely Phoenix or lightweight API. | Future PWA/mobile. | Markdown/JSON now. | Spec stage. |
| Les Harmonica | Product/spec folder, future secure contact app. | Mobile app likely primary; PWA/admin possible. | Secure contact/proximity backend planned; crypto/contact state may be local-first. | Future mobile/PWA. | Markdown/JSON now; mobile/crypto stack TBD. | Spec stage. |
| Les Contacts | Product/spec folder, future multi-context personal/business/family CRM app. | Mobile/PWA contact-place-product graph, context spaces, private timeline and follow-up surface planned. | Planned local-first or Phoenix service. | Future PWA/mobile. | Markdown/JSON now. | Spec stage. |
| Les Travel | Product/spec folder, future travel readiness app. | Mobile/PWA travel planner, visa/source cards, safe stay and emergency contact surface planned. | Planned lightweight API or local-first adapter. | Future PWA/mobile; Go visual flow now. | Markdown/JSON now. | Spec stage. |
| e-any.online | Real Astro tools site and workflow hub. | Public tools, customer tools, internal registry, embeddable widgets. | Astro API routes plus external runtimes; Windmill/Activepieces execute selected flows. | Astro pages, widgets and static assets. | Astro, TypeScript, Node, Windmill/Activepieces integrations. | Working tools site/spec stage for orchestration. |
| Les Commerce | Product family, not one app. | Storefronts, merchant admin, marketplace pages, checkout. | Multiple Phoenix/Elixir commerce backends. | Astro, Next.js, storefront themes. | Elixir/Phoenix, Astro, Next.js. | Umbrella with sub-apps. |
| Quick Commerce | Commerce sub-app. | Merchant storefront and admin/checkout. | Elixir/Phoenix backend. | Astro storefront. | Elixir, Astro/TypeScript. | Sub-app scaffold/spec. |
| diydiy | Commerce sub-app. | DIY video marketplace/storefront. | Elixir/Phoenix backend. | Next.js storefront. | Elixir, Next.js/TypeScript. | Sub-app scaffold/spec. |
| Marketplace | Commerce sub-app/engine. | Listings and marketplace surfaces. | Elixir/Phoenix planned/scaffold. | Future web UI. | Elixir/Phoenix. | Sub-app area. |
| Storefronts | Frontend/theme pool. | Storefront themes and templates. | None by itself. | Shared storefront templates. | Astro/Next.js-oriented. | Shared frontend area. |
| Les Item Otel | Commerce sub-app/spec, future operational app. | Web/mobile panel for storage, care, rental, resale, recall. | Planned service; likely Phoenix. | Go has demo panel; future standalone UI. | Markdown/JSON now; Elixir likely. | Spec + Go demo panel. |
| Les Affiliate Oyun | Game product/spec, future game app. | Web/mobile game, bots, social sharing. | Planned Elixir/Ash backend. | Planned React + Pixi.js; mobile via Capacitor possible. | Elixir/Ash planned, React/Pixi planned. | Spec stage. |
| Les AI | AI workspace/adapter family, not one app. | Agent directories, docs, possible admin/workbench surfaces. | AgentAndBot/Phoenix pieces; KADRO data. | Various docs/HTML/platform UIs. | JSON, Markdown, Elixir/Phoenix, Python in sub-services. | Umbrella/workspace. |
| KADRO / ai_kadro | AI agent roster/data and platform area. | Roster/CV/profile/admin surfaces. | Phoenix platform exists under `kadro_platform`. | Phoenix HEEx/assets, static profiles. | Elixir/Phoenix, JSON, image assets. | Active sub-area. |
| AgentAndBot Governance Core | Independent AI agent platform service. | Web/admin/API for agents, tasks, marketplace, feeds. | Elixir/Phoenix. | Phoenix LiveView/HEEx/assets. | Elixir/Phoenix. | Active external-compatible sub-app. |
| AgentAndBot CV Generator | AI service sub-area. | API/service for CV generation. | Python service. | None or service API. | Python. | Sub-service. |
| ai_senaryo / ai_beraberproje | AI creative workspace/spec. | Scenario/story/video collaboration workspace planned. | TBD; may live with AgentAndBot. | Future creative board. | Markdown/JSON now. | Spec/workspace. |
| LesTupid Lan | Tooling/spec workspace. | HTML renderer/tools; developer-facing. | Tool scripts/services possible. | HTML renderer. | TypeScript/HTML-oriented tooling, specs. | Tooling stage. |

## AI Index

Use this section when another AI agent needs a compact machine-oriented view.

```json
{
  "repo": "https://github.com/ilkerkaanipcioglu/lestupid",
  "registry": "les_certification/certification-registry.json",
  "core_rules": {
    "identity": "one_lestupid_identity_many_app_activations",
    "runtime_modes": ["standalone_app", "ecosystem_activated_app"],
    "integration_style": "optional_adapters",
    "folder_rule": "a_folder_can_contain_many_apps_services_features_or_adapters",
    "repo_strategy": "monorepo_now_split_or_merge_when_product_boundaries_require_it",
    "catalog_scope": "only_files_under_B_DEV_HAREZM_EKOSISTEMI_LesTupid",
    "web3": "proof_and_portability_only",
    "ai": "recommendation_and_evidence_summary_only",
    "matchmaking": "explicit_opt_in",
    "trust_credentials": "domain_scoped_pairwise_pseudonymous_hash_only_revocable",
    "contextual_ui": "fast_things_feel_fast_static_things_stand_still_flowing_things_flow_each_app_and_place_shows_its_own_character"
  },
  "app_groups": {
    "shell_and_activation": ["les-go"],
    "policy_and_proof": ["les-certification", "les_block_adapter"],
    "commerce": [
      "lescommerce-core",
      "lescommerce-quick-commerce",
      "lescommerce-diydiy",
      "les-itemotel",
      "les-affiliate-oyun"
    ],
    "social_and_discovery": ["les-poke", "les-match", "les-harmonica"],
    "relationship_graph": ["les-contacts"],
    "travel_and_safety": ["les-travel"],
    "tools_and_flows": ["e-any-online-tools"],
    "service_flow": ["lestupid-waiting-app", "les-care"],
    "ai": ["les-ai", "agentandbot-governance-core", "ai-senaryo"],
    "tooling": ["lestupid-lan"]
  },
  "folder_families": {
    "Les_Commerce": [
      "lescommerce-core",
      "lescommerce-quick-commerce",
      "lescommerce-diydiy",
      "les-itemotel",
      "marketplace-elixir",
      "commerce-backend",
      "storefronts"
    ],
    "les_ai": [
      "les-ai",
      "ai_kadro",
      "agentandbot",
      "agentandbot-governance-core",
      "ai-senaryo",
      "cv_generator",
      "protocol_specs"
    ],
    "LesTupid_Lan": [
      "lestupid-lan",
      "html-renderer",
      "language_specs"
    ]
  }
}
```

## Relationship Notes

- Les Go is the first user-facing ecosystem shell. It previews opportunities
  but does not own other products' core data.
- Les Certification is the policy, registry, trust credential, and proof
  coordination layer. It does not replace product databases.
- Les Block is an adapter concept, not yet a required standalone app. It should
  store hash/proof/revocation state only, never private raw data.
- Les Match is the only people matchmaking owner. Other apps may emit
  opportunities, but person discovery stays opt-in.
- Les Commerce owns checkout, pricing, refund, merchant terms, listings, and
  affiliate ledgers.
- Les Poke owns real-world quests, drops, city memory, public-space proof, and
  creator challenge flows; paid creator promotion briefs, payouts and affiliate
  terms stay in Les Commerce.
- Les Harmonica owns safe communication, encrypted contact, trusted proximity,
  and pairwise pseudonymous handoff.
- Les Contacts owns imported people, saved places, private product/service/asset
  relationship memory, context spaces, private timeline events, follow-up notes,
  and role candidates. Personal, work, family, school, social, travel and
  commerce contexts stay separated. Commerce and Item Otel remain source-of-
  truth for checkout, receipts, custody and orders; Contacts keeps the user's
  private CRM memory.
- Les Travel owns trip intent, travel readiness, official visa/source routing,
  accommodation safety, risk briefing, emergency contact packs and private trip
  memory. It must never invent visa rules when official sources are needed.
- e-any.online owns internal/customer/public tool surfaces and safe workflow
  catalog metadata. Windmill runs internal and long-running jobs; Activepieces
  runs OAuth/SaaS/customer connector flows. Tokens and customer credentials must
  stay in vault/env/provider storage, never in repo or agent-visible manifests.
- Les Affiliate Oyun owns cards, decks, game state, rarity, duels, and seasons;
  commerce, quest, and match functions remain adapters.
- Les AI aligns KADRO, AgentAndBot, and ai_senaryo with LesTupid, but AI agents
  must always be labeled as AI and never shown as unlabeled humans.
- UI follows contextual character: live things are alive, stable places are
  grounded, calm contexts breathe, crowded contexts are dense but attention-
  limited, and risky contexts are visibly risky.
