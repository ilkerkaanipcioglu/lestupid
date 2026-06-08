# Les Poke

Mobile-first real-world quest and city-memory prototype for Kadikoy and Nairobi.

## Structure

- `apps/mobile`: Expo React Native mobile app skeleton.
- `api`: Phoenix JSON API skeleton.
- `docs`: Product plan and roadmap.
- `lestupid.app.json`: LesTupid ecosystem manifest for discovery, certification and cross-app integration.

## LesTupid Compatibility

Les Poke is registered as `les-poke` in `../les_certification/certification-registry.json`.
The API exposes the same discovery metadata through:

- `GET /api/health`
- `GET /agent-manifest.json`
- `GET /.well-known/ai-agent.json`
- `GET /.well-known/lestupid-app.json`

The manifest declares integration points for LesCommerce rewards/campaigns,
les_wait queue-safe micro quests, and les_certification review.
It also declares optional Les Match, Les AI, AgentAndBot/KADRO and Les Block
proof/value adapters.

## Creator Membership And Drops

Les Poke can host creator memberships, fan clubs and paid local drops as
quest/content access. Examples: concert recap quests, cafe routes, campus study
trails, creator challenges and member-only city stories.

Creator promotion tasks can be surfaced first by Les Go from a live place/mode
context, then turned into Les Poke quests: walk video, live stream, photo set,
reels/story, product demo, cafe route, campus tour or event recap. Paid briefs
and affiliate terms stay in Les Commerce; Les Poke owns only the quest/challenge
shape, proof boundary and location privacy.

In the mobile demo, creator promotion quests appear as labeled challenge cards:
cafe reels/story work, campus live walks, and DIY product demos. These cards
can point back to Les Commerce for brief, payout, affiliate or checkout terms
without turning Les Poke into the commerce owner.

The Nairobi graduate launch circle is the first university viral loop. Les Go
surfaces the campus context; Les Poke turns it into a quest/challenge where a
student can collect CV, mentor, safe gig, creator and travel-readiness signals.
People discovery still belongs to Les Match opt-in, and sexual-service
marketplace behavior remains forbidden.

Rules are defined in `docs/CREATOR_MEMBERSHIP_AND_DROPS.md`. Public questing
must keep working without paid membership. Paid content is labeled, adult
content is 18+/legal-review only, and money/gifts/travel/access must not be
framed as payment for sexual services.

## Affiliate Game Fit

Les Affiliate Oyun can consume Les Poke quest signals as `quest_card`,
`campus_drop`, `event_drop`, `city_discovery_deck` or `creator_challenge_card`.

Les Poke remains the owner of real-world quest safety, check-in proof,
location privacy and creator drop policy. The game can render the quest as a
card or deck challenge, but it must not expose private location trails or turn
public questing into forced purchases.

## Runtime Modes

Les Poke must remain usable as:

- `standalone_app`: a city quest and memory app with local app registration and
  its own API/mobile runtime.
- `ecosystem_activated_app`: an app activated from a shared LesTupid identity,
  with optional Les Match, Les Commerce, Les Wait and certification adapters.

If ecosystem adapters are disabled, core city/quest flows should keep working;
match opportunities, shared loyalty and cross-app certification signals become
optional features.

## Platform Strategy

- Expo/native mobile remains the main city-play surface.
- Mobile web/PWA should work for lightweight quest discovery and activation.
- Desktop is mainly for admin/content/review surfaces.

## Optional Value Layer

Les Poke can emit quest completion, badge, point, La/Le/Lo/Lale, and place
candidate events. Wallets are optional.

`les_block_adapter` may create proofs later, but local/API records remain the
source of truth. Private location trails must not be published on-chain.

## Agent And AI Fit

Les AI and AgentAndBot/KADRO agents may help create quest ideas, draft field
notes, summarize place evidence, or suggest agent-led city tasks. If those
agents appear in Les Match, they must be clearly labeled as AI agents.

## First Run

Mobile:

```powershell
cd apps/mobile
npm install
npm run start
```

API:

```powershell
cd api
mix deps.get
mix test
mix phx.server
```

The current API is scaffolded for Phoenix/PostgreSQL/PostGIS, but dependencies are intentionally not vendored.
