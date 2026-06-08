# E-SWSP And LesTupid Evaluation

Source: pasted Ar-Ge outline for a multi-channel smart service management
platform.

## Short Verdict

The document is useful, especially for Les Wait. The strongest idea is not a
new giant platform, but a shared service-flow layer:

- queue;
- booking;
- service status;
- pickup/return;
- commerce handoff;
- notification state;
- embeddable widgets;
- WhatsApp, Telegram, SMS, email, QR, web and staff channels.

This fits LesTupid if every app stays portable and the shared layer is an
adapter/event contract, not a hard dependency.

## What We Should Take

### 1. Elixir/Phoenix For Real-Time Service Flows

Les Wait should use Phoenix when it leaves static/PWA prototype mode. Waiting,
queue state, live staff dashboard, estimated time, notifications and channel
sessions are a good fit for Elixir/OTP.

Recommended ownership:

- Les Wait owns queue and service-state runtime.
- Les Commerce owns catalog, checkout, order and merchant commerce runtime.
- Les Go shows contextual cards and launches the right app.
- Les Certification validates place, staff, fairness and evidence rules.
- e-any.online, Windmill and Activepieces can orchestrate tools and operational
  workflows, but should not own core queue state.

### 2. One Service Event Model Across Channels

The document's channel-independent idea should become a concrete LesTupid
contract. QR, web, WhatsApp, Telegram, SMS, email, USSD, staff tablet and manual
entry must normalize into comparable events.

Candidate event types:

- `service_flow_created`;
- `entry_surface_created`;
- `channel_session_started`;
- `queue_joined`;
- `booking_requested`;
- `booking_confirmed`;
- `service_eta_updated`;
- `notification_sent`;
- `pickup_ready`;
- `order_handoff_requested`;
- `staff_override_recorded`;
- `service_completed`;
- `no_show_recorded`;
- `flow_closed`.

### 3. Embeddable Widget Pack

The embeddable widget idea is very valuable. We should think of a LesTupid
widget pack, not only one app screen.

Candidate widgets:

- `les-wait-queue-widget`: join queue, see ETA, receive status.
- `les-booking-widget`: availability, reservation, appointment confirmation.
- `les-commerce-mini-widget`: lightweight product/service listing and checkout
  handoff.
- `les-service-status-widget`: pickup, order, repair, item hotel, clinic or
  office status.
- `les-place-request-widget`: "request Les Wait / certify this place".

These can be hosted by each product or exposed through e-any.online as public
tool/widget surfaces. The source-of-truth still stays with the owning app.

### 4. Multi-Country Low-Bandwidth Thinking

Turkey, Kenya and Mozambique are useful pilot lenses. They force the platform
to work with:

- unreliable internet;
- WhatsApp/SMS-first users;
- low-end phones;
- language differences;
- cash/mobile money/card payment diversity;
- offline or staff-assisted queue entry.

This improves the whole ecosystem, including Les Travel, Les Commerce, Les
Wait and Les Certification.

### 5. Dynamic ETA And Service Pressure

The document's wait-time prediction idea is worth keeping, but it should start
simple.

V1:

- staff-set ETA;
- historical average duration;
- capacity and no-show adjustment;
- "come closer" threshold;
- service paused/delayed state.

Later:

- adaptive ETA model;
- anomaly detection;
- fake check-in detection;
- fairness reports for certification.

### 6. Channel-State Engine

Stateful channel management should become a reusable adapter pattern.

Example: a person joins from QR, receives SMS, later checks status on web, and
staff completes service from tablet. All of that should point to the same
`service_session_id`.

## What We Should Not Take Directly

- Do not turn LesTupid into one monolithic E-SWSP backend.
- Do not make native iOS/Android a phase-one requirement.
- Do not force AI, wallet, blockchain or payment into the queue.
- Do not put Les Commerce checkout logic inside Les Wait.
- Do not expose private health, location, match or contact data through generic
  widgets.
- Do not let WhatsApp/Telegram/SMS become the only supported flow.

## Ecosystem Placement

| Capability | Owner | Role |
| --- | --- | --- |
| Queue and service state | Les Wait | Live flow, ETA, staff actions, fairness |
| Place/mode discovery | Les Go | Contextual cards and activation shell |
| Catalog, order, checkout | Les Commerce | Merchant and marketplace commerce |
| Booking and appointments | Les Wait first, Commerce optional | Service slots, pickup, repair, consultation |
| Public/customer widgets | Owning app + e-any.online catalog | Embeddable surfaces |
| Workflow automation | e-any.online + Windmill/Activepieces | Internal ops, customer connectors, approvals |
| Trust and certification | Les Certification | Owner, staff, fairness, audit and proof |
| Secure messaging | Les Harmonica | Anonymous or trusted contact handoff |
| Notifications | Les Wait channel adapters | SMS, WhatsApp, Telegram, email, web push |

## Suggested Technical Contracts

### `ServiceFlow`

```json
{
  "id": "flow_canteen_pickup_001",
  "owner_app": "les_wait",
  "place_id": "place_uni_canteen",
  "flow_type": "queue",
  "status": "active",
  "entry_methods": ["qr", "short_link", "staff_tablet", "phone_number"],
  "capacity": 42,
  "visibility": "public_place"
}
```

### `ServiceEvent`

```json
{
  "schema_version": "lestupid.service_event.v1",
  "event_type": "queue_joined",
  "service_flow_id": "flow_canteen_pickup_001",
  "actor_ref": {
    "type": "pseudonymous_user",
    "id": "mem_123"
  },
  "channel": "qr",
  "source_app": "les_wait",
  "evidence": {
    "entry_surface_id": "surface_canteen_qr_001"
  },
  "occurred_at": "2026-06-05T09:00:00Z"
}
```

### `EmbeddableWidget`

```json
{
  "widget_id": "les-wait-queue-widget",
  "owner_app": "les_wait",
  "embed_modes": ["script", "iframe", "link"],
  "allowed_flows": ["queue", "booking", "service_status"],
  "requires_origin_allowlist": true,
  "certification_required_for_public_badge": true
}
```

## Roadmap Proposal

### Phase 0: Spec Alignment

- Add `service_flow` and `service_event` language to Les Wait.
- Keep current event model, but rename broader cross-app events as service
  events.
- Add embeddable widget certification criteria.

### Phase 1: Les Wait Phoenix Core

- Minimal Phoenix API for service flows.
- Tables: places, service_flows, entry_surfaces, service_sessions,
  service_events, channel_sessions, staff_actions.
- Live staff dashboard can come after API proof.

### Phase 2: Widget Pack

- Queue widget.
- Booking widget.
- Service status widget.
- Place request widget.
- e-any.online registry page can list widgets and safe embed metadata.

### Phase 3: Omnichannel Adapters

- Web/QR first.
- SMS/email next.
- WhatsApp/Telegram after provider and cost decisions.
- USSD only if Kenya/Mozambique pilot needs it.

### Phase 4: Commerce And Booking Handoff

- Les Commerce uses Les Wait for pickup queue, service appointment and merchant
  onboarding slots.
- Les Item Otel uses service status for item intake, care, rental, sale,
  pickup and return.
- Les Go shows these as contextual opportunity cards.

### Phase 5: Pilot And Ar-Ge Evidence

- Turkey pilot: canteen, clinic, barber, student affairs.
- Kenya pilot: campus queue, mobile-money-friendly booking, SMS/WhatsApp status.
- Mozambique pilot: low-bandwidth and Portuguese localization evidence.
- Measure wait reduction, no-show rate, channel reliability and staff override
  audit quality.

## Funding / Ar-Ge Framing

The pasted document is useful as an Ar-Ge proposal frame. We can reuse the
structure for grant or investor material:

- problem;
- technical novelty;
- Elixir/OTP concurrency and fault tolerance;
- embeddable multi-channel service management;
- international low-bandwidth pilots;
- performance and pilot reports.

Product-wise, the first build should stay smaller:

1. Les Go shows the place and service opportunity.
2. Les Wait runs queue/booking/status.
3. Les Commerce handles product/order/checkout.
4. e-any.online exposes tools/widgets/flow metadata.
5. Les Certification guards trust, fairness and proof.

