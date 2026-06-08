# Les Wait

Les Wait is the LesTupid waiting, queue, appointment, check-in, and service-state
app.

It starts from a very human problem: people should not be trapped in a cramped
waiting area just to hear their name. The app should make the wait visible,
fair, and breathable with the smallest tool that works.

## Runtime Modes

- `standalone_app`: Les Wait runs as its own queue/appointment app for a place,
  clinic, shop, event, workshop, or service provider.
- `ecosystem_activated_app`: a user activates Les Wait from a shared LesTupid
  identity and can connect queue state to Les Match, Les Poke, Les Commerce, or
  Les Certification through optional adapters.

## Platform Strategy

Keep it simple and fast:

- mobile web/PWA first;
- static prototype until API persistence is needed;
- Phoenix JSON API when queue flows need storage and notification state;
- Expo/native app only if install, push, or offline field use becomes necessary;
- desktop/kiosk via responsive web first.

## Source Of Truth

- `lestupid.app.json`: app manifest.
- `lestupid-waiting-app-spec.md`: product and certification spec.
- `waiting.html`: current static prototype.
- `source-note-validebag-hospital.txt`: original hospital corridor observation.
- `source-note-waiting-scenarios.txt`: original multi-scenario notes cleaned
  into stable ASCII.
- `Beklemesiz_ Akıllı Bekleme ve Sıra Yönetimi Platformu Konsepti.md`: broader
  omnichannel product concept.
- `openspec/project.md`: implementation context for future structured changes.

## Core Rule

All channels must normalize into the same queue event model. QR, web, SMS,
WhatsApp, USSD, staff tablet, phone call, or paper should produce comparable
events.

No channel is mandatory. No wallet is mandatory. AI and Web3 are optional.

## Service Flow Direction

The E-SWSP Ar-Ge outline is useful as a broader direction for Les Wait. We
should take the multi-channel, embeddable service-management structure from it,
but keep LesTupid modular:

- Les Wait owns queue, booking, service-state, ETA and staff actions;
- Les Commerce owns catalog, order and checkout;
- Les Go shows contextual cards and launches the right app;
- Les Certification reviews owner, staff, fairness, widget and proof rules;
- e-any.online can expose widget/tool metadata and Windmill/Activepieces
  operational flows, but does not own live queue state.

See `docs/E_SWSP_LESTUPID_EVALUATION.md` for the detailed evaluation and
roadmap.

## Two-Sided Entry Model

Les Wait has two entry sides:

- `user_entry`: the person joins, views, updates or exits a queue.
- `venue_owner_entry`: the place owner, staff member, event operator or service
  provider creates and controls the waiting flow.

User join methods:

- scan a printed QR;
- scan/read a table, counter, door or service-desk code;
- enter a phone number and receive SMS/WhatsApp/Telegram status;
- open a short web link;
- approach a place and see the venue appear through coarse proximity or local
  discovery;
- staff enters the person from a tablet or phone;
- staff records a manual/offline entry and syncs later.

Venue owner flow:

1. Owner claims or creates the place.
2. Les Certification checks ownership/admin permission where needed.
3. Owner creates one or more waiting flows: canteen pickup, clinic desk, barber
   chair, table service, student affairs, event entry, workshop seat, Item Otel
   pickup/return.
4. Owner chooses allowed join methods: QR, table code, phone, staff tablet,
   proximity discovery, manual entry.
5. Owner prints or displays entry surfaces.
6. Staff can call, delay, pause, close, override, complete or mark no-show.
7. Users see only the queue state they need, not internal staff data.

If a venue is not active, users can request Les Wait for that place. Repeated
requests become a certification/merchant lead, but the queue cannot pretend to
be active until the venue owner or authorized staff enables it.

## Optional Value Layer

Les Wait can emit La/Le/Lo/Lale, point, spend, redeem, and certificate proof
events. The queue still works without a wallet.

`les_block_adapter` is optional and only handles proof/portability:

- certificate proof;
- point proof;
- spend or redeem receipt;
- revocation proof.

Private waiting, health, location, or match data must not be published on-chain.
