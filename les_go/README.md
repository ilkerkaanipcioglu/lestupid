# LesTupid Go

LesTupid Go is a lightweight PWA shell for contextual life flow: choose or
check in to a place, pick the mode you are in, then see useful cross-app
opportunities.

It is intentionally not a giant backend. Each product keeps its own runtime and
business logic. Go only activates, previews, and launches opportunities through
typed adapters.

## First Loop

1. User opens a campus, canteen, cafe, workplace, football club, gym, beach,
   village, barber, club, concert, school, course center, library, clinic or
   event as a stable place home.
2. User picks the current mode: study, eat, work, train, social, date, relax,
   shop, care, travel, service or safe.
3. User checks in with public, coarse, or private-note privacy.
4. Go shows opportunity cards from Les Wait, Les Poke, Les Match, Les Commerce,
   Les Contacts, Les AI/AgentAndBot, Les Certification, and Les Block.

## Product Logic

- Static things feel like doors, homes, or pages: university, school, canteen,
  course center, shop, club, venue, profile, and certified place.
- Moving things feel like a feed: check-ins, quests, queue actions, offers,
  local listings, match prompts, AI agent help, proof events, reports, and
  transactions.
- Fast things feel fast; flowing things flow; static things stand still.
  Beautiful/good things are allowed to feel attractive and generous. Risky,
  bad, unsafe or legally sensitive things must look clearly risky instead of
  being disguised as cute opportunity cards.
- Crowded places should feel dense and active, but still attention-limited.
  Calm places should feel breathable, quiet and lower pressure.
- The user should not feel like they are filling forms. Filters can narrow the
  flow, but discovery is primarily feed-first and tap-first.
- Time should be visible in the interface. Live/short events are compact and
  slightly alive; today/ongoing/stable things get calmer and more space. Static
  places should not feel like feed posts.
- The feed follows two signals: `where am I?` and `what mode am I in?` A beach
  in relax mode, a beach in date mode, a gym in train mode and school in eat
  mode should feel different without becoming separate apps.
- The left rail shows nearby places first, not the whole world. The main feed
  shows only a small number of nearby topics and opportunity cards by default;
  extra topics, places and cards are opened through browse actions.
- Nearby topics are not exposed people profiles. They are consent-safe context
  signals such as food plans, study groups, gear rental, queue windows, creator
  drops or safe-mode alerts. Person discovery still belongs to Les Match opt-in.
- A place home should expose basic utility actions before deeper discovery:
  view menu, join or track a queue, open a third-party ticket/reservation link,
  and open route/return options. Go labels external checkout/map links and does
  not store payment, ticket or private route data in v1.
- Go can also show `next stop` signals: where people usually go after this
  place. These are aggregate, consent-safe trends, not person tracking. Example:
  after canteen -> cafe/library/class, after concert -> food/safe ride, after
  gym -> shower/smoothie/home.
- Each source app keeps its own mood: Les Wait is practical/time-aware, Les Poke
  is quest-like, Les Match is warm but consent-first, Les Commerce is terms-
  visible, Les Contacts is private/memory-like, Les Harmonica is secure, Les AI
  is clearly labeled and Les Certification is sober/evidence-led.
- The `Visual Flows` screen is the shared demo gallery for humans and AI
  agents. It shows every major app as a visual storyboard before the user opens
  the standalone demo screen.
- Les Commerce opportunity cards support tap-to-filter facets. If a card shows
  a visible commerce value such as brand, model, size, place, item type,
  listing type, service type or care type, the user can tap it and the feed
  narrows in the current context. Changing place or mode clears these facets so
  old commerce filters do not silently leak into a new context.

## School Feed Sources

- Les Wait turns canteens, clinics, student affairs, and library reservations
  into queue actions: come later, preorder, join queue, reserve/return when a
  quiet study room opens, or request Les Wait for an unsupported place.
- Joining a queue can happen by scanning a QR, reading a table/counter/sign
  code, entering a phone number, staff tablet entry, short link, or seeing the
  place appear through coarse proximity. A live official queue still requires
  venue owner/staff onboarding; otherwise Go only shows a "request Les Wait for
  this venue" prompt.
- Place utility cards show menus for canteens, cafes, beach venues, villages,
  gyms, football clubs and event venues. Concert, theater-like event and club
  cards can open third-party ticket/reservation links.
- Route cards answer "how do I get there and how do I get back?" through
  external map or mobility links, with late-night return safety labels for
  concerts, clubs and events.
- Next-stop cards show anonymous flow after a place: common next venues, safe
  return routes, after-event food, study continuation, sport recovery or item
  return/pickup opportunities.
- Les Travel adds travel readiness cards: official visa/source check,
  accommodation safety, budget guardrail, route/return plan, emergency contact,
  scam/risk briefing and private trip memory. A Nairobi student planning a
  Turkiye visit or a user planning a Phuket holiday should see practical,
  source-labeled safety steps before offers or social discovery.
- Les Contacts can turn a check-in into a private draft timeline event: place
  visit, service visit, meal, purchase, meeting, delivery, memory or follow-up.
  Go can suggest the entry, but Contacts owns the person/place graph and keeps
  sensitive events private unless the user promotes them to another app.
- Les Poke turns school life into quests: visit a club stand, complete a 45 min
  library focus quest, rate the canteen menu, check in to Maker Night, or
  discover three campus points.
- Les Match stays opt-in. It can preview same-event, same-course, project
  partner, mentor, and sponsor opportunities only as activation prompts until
  the matchmaking channel is active. High-school places use minor-safe mode:
  no person matching, only school-approved club/group/counselor opportunities.
- Adult social contexts such as clubs and concerts may support 18+ opt-in
  dating, travel companion and shared-experience prompts. The product language
  must stay expectation/consent/safety-first. It must not frame money, gifts,
  travel or access as payment for sexual services.
- Adult-only venues are isolated behind legal/safety mode: 18+ only, no
  matchmaking, no service booking, no gamified quest, no private trail and no
  optional proof event in v1.
- Place marketplace can show local peer listings and plans after check-in:
  phone resale, car rental, clothing/outfit sales, lunch/dinner plans, creator
  drops and service offers. Listings need clear price/terms, report controls
  and certification review when risk is high. Sexual service listings are not
  allowed.
- Commerce/listing/gig cards expose `commerceFacets` for feed-first filtering:
  Apple/iPhone, car/rent/daily, food/student menu, outfit/skirt, Item Otel
  care/rent/sell, peer courier, tutoring, hair and local place facets. This is
  a UI behavior first; future Marketplace/Quick Commerce APIs can use the same
  facet contract.
- Micro-gig cards let nearby people earn money with small services: tutoring,
  homework review, styling/hair, carrying items, package/document delivery or
  event help. Academic work must stay help/review/tutoring; doing someone's
  submitted homework, exam or project for them is not allowed.
- Les Item Otel can surface storage, care, rental and recall cards when the
  context fits: gym gear, football equipment, beach items, seasonal clothing,
  tires, wedding dresses or other stored belongings.
- Living CV turns school activity into a controlled opportunity profile:
  check-ins, quests, focus blocks, micro-gigs, Item Otel delivery proof,
  certificates, projects and KADRO drafts can grow the student's CV. The
  student can then prepare job, internship, education, scholarship and mentor
  applications from the feed. Go never auto-applies and never shares CV signals
  without an explicit review/consent step.
- The Nairobi student launch loop is the first university viral demo: a
  University of Nairobi student or new graduate can open one campus feed and
  see living CV growth, GIS/research/tourism internship drafts, safe campus
  income gigs, creator campus tour tasks, mentor/sponsor opt-in prompts,
  Turkiye travel readiness, trusted contact and pseudonymous trust preview.
  Adult dating remains separate, 18+, legal/consent-first and opt-in; money,
  gifts, access or travel must not be framed as sexual-service exchange.
- Career opportunity cards stay separate from matchmaking. Applications,
  education paths and CV growth can appear in Go; mentor/sponsor people
  discovery still belongs to Les Match opt-in.
- Les Certification can show identity-hidden trust credentials in the flow:
  reliable buyer, fair queue participant, verified peer courier, item custody
  reliability, learning contribution or place evidence. These are domain-scoped
  badges, not a global social score. Les Block can later provide hash-only,
  revocable proof when the user explicitly consents.
- Les Harmonica can open safe communication cards: anonymous secure contact,
  trusted proximity, venue staff contact, guardian/school-approved contact,
  peer-service handoff or Les Match handoff. Go launches the card; Harmonica
  owns encrypted contact state and can still run as a standalone app.
- Les Affiliate Oyun can show card-drop opportunities: product cards from
  Les Commerce, quest cards from Les Poke, creator drops, certified merchant
  cards and opt-in duel/team prompts through Les Match. Go only launches the
  opportunity; the game owns card/deck state.
- Creator/influencer promotion starts in Go because it is contextual: the user
  is at a cafe, campus, beach, event, village, gym, shop or venue and can see
  live/photo/video/walk content gigs in the feed. Les Commerce owns the paid
  brief, checkout, affiliate/commission and merchant terms. Les Poke can turn
  it into a quest/challenge. Les Match can connect creators with merchants,
  sponsors or collaborators when both sides opt in. Les Certification checks
  sponsored-content disclosure, visit proof, fake engagement risk and creator
  trust signals.

## Run

```powershell
npm install
Copy-Item .env.example .env
npm run typecheck
npm run dev
```

## Runtime Config

- `VITE_OPPORTUNITY_ADAPTER=mock` keeps the deterministic demo feed.
- `VITE_OPPORTUNITY_ADAPTER=http` selects the future HTTP adapter boundary,
  currently falling back to mock until Phoenix APIs are connected.
- API base URLs live in `.env.example` and should be copied to `.env` locally.

## AI Crew

Go shows three AI lanes without merging their ownership:

- `les_ai/kadro`: labeled AI workers and personas.
- `agentandbot.com`: external task/runtime workspace.
- `les_ai/ai_beraberproje`: collective scenario and creator board (`ai_senaryo` product).
- `les_harmonica`: safe communication, trusted proximity and identity-hidden
  contact handoff.
- `les_affiliate_oyun`: social-commerce card game, affiliate product cards,
  quest drops and opt-in game matching.

## Rules

- Les Match stays explicit opt-in.
- KADRO agent cards are always labeled as AI agents.
- Les Block proof is optional.
- No private location trail is stored or published in v1.
- No backend persistence in v1.
