# Les Match

Les Match is the LesTupid matchmaking app for consent-first people, place,
merchant, event, quest, and service matching.

The product goal is simple: match useful intent without manipulative ranking,
fake scarcity, hidden boosts, or engagement traps.

## Current State

- `api/`: Elixir/Phoenix JSON API skeleton.
- Registry id: `les-match`.
- Manifest: `lestupid.app.json`.
- Certification route: consent-first matchmaking, transparent scoring,
  explainable recommendations, and no pay-to-rank dark patterns.

## Matchmaking Scope

Les Match can support these first match types and opportunity signals:

| Match type | Example |
| --- | --- |
| Person to person | Skill, interest, collaboration, or local social matching. |
| Person to place | Nearby venue, queue-safe route, or city discovery match. |
| Person to merchant | Honest offer, local seller, product, or service match. |
| Quest to participant | Les Poke city quest suggestions based on intent and proximity. |
| Wait state to action | Les Wait micro walks, errands, or breathable waiting suggestions. |
| Shared interest | A user shares a car, camera, game, book, or food; opted-in people with the same taste can meet. |
| Event or travel | People going to the same concert, festival, city, route, or holiday can meet before or during the trip. |
| Meal or experience plan | Adults or appropriate social groups can opt into lunch, dinner, coffee, travel, or shared-experience plans with clear expectations. |
| Sponsor or mentor | University students can meet education, travel, internship, job, or project sponsors. |
| Check-in opportunity | People checking in at a place can meet compatible people and also create pressure for the venue to become lestupid. |
| Person to agent | A user can discover a clearly labeled AgentAndBot/KADRO AI agent for a task, mentor, workflow, or service need. |
| Agent to task | A KADRO agent can be suggested for a user, merchant, student, creator, or venue task when its capability fits. |
| Creator membership | Creators and fans can discover opt-in paid memberships, fan clubs, exclusive access, collabs, and supporter communities. |
| Game opponent or team | Les Affiliate Oyun players can find opt-in duel opponents, teams, mentors, sponsors, creator/fan groups or brand campaign partners. |

## Match Opportunity Layer

Every LesTupid app can emit a `match_opportunity` when a user has activated
Les Match and the relevant interaction channel.

Examples:

- A user shares a car they love. Les Match can suggest opted-in people who also
  like that car or car culture.
- A user plans a concert or holiday. Les Match can suggest people going there,
  nearby, or wanting to join.
- A university student asks for education, travel, internship, or job support.
  Les Match can suggest sponsors, mentors, companies, alumni, or local patrons.
- A user checks in at a cafe, campus, hospital, event, or shop. Les Match can
  suggest compatible opted-in people nearby.
- Check-ins also become evidence that a venue should become a lestupid place if
  enough users want honest pricing, clean service, and fair local value there.
- A creator publishes a paid membership or exclusive fan club. Les Match can
  suggest it only as a labeled commercial opportunity and only when the user has
  opted into the relevant creator/community channel.
- A merchant, venue, brand or sponsor opens a creator promotion brief through
  Les Commerce. Les Go may show the nearby/live opportunity, but Les Match only
  suggests a creator, merchant, sponsor or collaborator when both sides opted
  into creator/commercial matching and the paid reason is visible.
- A Les Affiliate Oyun player wants a duel, team deck, sponsor, mentor,
  creator/fan campaign or brand challenge. Les Match may preview candidates
  only when matchmaking is active and the commercial/game reason is explained.

An opportunity only becomes a match suggestion when both sides have matching
enabled and the suggestion can be explained.

## AgentAndBot / KADRO Agent Matching

AgentAndBot and KADRO agents can participate in Les Match, but only as clearly
labeled AI agents or agent personas.

Rules:

- an AI agent must never be shown as an unlabeled human match;
- agent identity, capability, owner/operator when available, and source must be
  visible;
- users must be able to accept, reject, mute, or report agent suggestions;
- Les Match may suggest agents for tasks, mentoring, workflow help, merchant
  operations, student support, creator work, or venue/service operations;
- AgentAndBot remains published independently on `agentandbot.com`; Les Match
  consumes it through optional Les AI/AgentAndBot adapters.

## Interaction Channels

Users can activate life-area channels independently from apps. These channels
can power all LesTupid apps, certified apps, and certified places.

| Channel | Possible interactions |
| --- | --- |
| `car` | car people, car events, routes, services, parts, offers, repair, content |
| `travel` | trips, people going there, guides, hotels, routes, sponsors, safety |
| `place` | check-ins, compatible people, venue pressure, rewards, queue-safe actions |
| `education` | mentors, sponsors, internships, jobs, schools, travel support |
| `event` | concerts, festivals, meetups, group plans |
| `product` | knowledge, offers, repair, resale, merchant and community interactions |
| `hobby` | people, places, products, content and events around an interest |
| `instagram` | profile/content/social signals the user explicitly allows |
| `tiktok` | short-video/content/community signals the user explicitly allows |
| `shopping_marketplace` | wishlist, product interest, repair, resale, price and offer signals |
| `university_affiliation` | campus, alumni, sponsor, mentor, travel, project, internship and job interactions |

Example: activating the `car` channel can produce car information and offers
across Les_Commerce, car-related local discovery in Les_poke, and car-culture
match opportunities in Les Match.

Example: activating an `instagram` or `tiktok` channel can turn selected public
or user-approved posts into interest signals. Activating a `shopping_marketplace`
channel such as Hepsiburada can turn wishlists or product interests into offers,
repair/resale options, and compatible communities. Activating a
`university_affiliation` channel can connect students with sponsors, mentors,
events, travel support, internships, jobs, and projects.

## Trust Rules

- A LesTupid user registers once at the ecosystem identity layer.
- Les Match is activated separately for that existing identity.
- Matching must be opt-in.
- Other apps may emit opportunities, but they may not expose a person unless
  that person has activated matchmaking.
- Channel activation can power non-personal information and offers without
  matchmaking; people discovery still requires Les Match activation.
- External platform channels must use only user-approved signals and must not
  import private messages by default.
- Users must know why a match was suggested.
- Paid placement must be labeled and separated from organic matching.
- Game duel invites cannot punish rejection and cannot hide commercial
  campaign placement.
- Sensitive attributes must not be inferred silently.
- Rejection, mute, block, and report flows are first-class safety controls.
- Matching history should be auditable for certification review.
- Creator membership matching must follow `CREATOR_MEMBERSHIP_POLICY.md`.
- Money, gifts, access, subscriptions or travel must not be framed as payment
  for sexual services.
- Meal, dating, travel, creator or experience matching must stay consent-first
  and expectation-clear; it is not a sexual service marketplace.

## Ecosystem Fit

Les Match should stay compatible with:

- `les_certification/lestupid-identity-activation-spec.md` for one account,
  many app activations.
- `les_certification/lestupid-app-portability-spec.md` for standalone and
  ecosystem-activated runtime modes.
- `les_certification/certification-registry.json` for product status.
- `Les_Commerce/` for optional merchant, reward, or offer matching.
- `Les_poke/` for city or quest-based matching flows.
- `les_affiliate_oyun/` for opt-in game opponent, team, sponsor, creator/fan
  and brand campaign matching.
- `les_wait/` for queue-safe matching and routing flows.
- `les_ai/` and `agentandbot.com` for optional KADRO agent/persona/task
  matching.
- `CREATOR_MEMBERSHIP_POLICY.md` for creator/fan paid access, adult-mode and
  commercial matching boundaries.

## Runtime Modes

Les Match must remain usable as:

- `standalone_app`: a consent-first matchmaking app with local profiles,
  consent, safety controls, and match decisions.
- `ecosystem_activated_app`: the matchmaking layer activated from another
  LesTupid app or the LesTupid core identity screen.

Other apps may feed `match_opportunity` signals only through optional adapters.
If those adapters are removed, Les Match still works with local profiles and
local opportunities.

## Planned API Shape

- `GET /api/identity/status`
- `POST /api/activations`
- `GET /api/health`
- `GET /agent-manifest.json`
- `GET /.well-known/lestupid-app.json`
- `POST /api/matches/preview`
- `POST /api/opportunities`
- `POST /api/matches/accept`
- `POST /api/matches/reject`
- `POST /api/safety/report`

## First Run

```powershell
cd api
mix test
mix phx.server
```
