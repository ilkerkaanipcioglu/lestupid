# lestupid waiting app spec

> Working name: Les Wait.

Les Wait is one of the first first-party apps to receive the lestupid
certification route.

It must remain simple, fast, and flexible: mobile web/PWA first, API only when
persistence is needed, and native/mobile/desktop shells only when they solve a
real deployment problem.

## 1. Product Idea

The app turns waiting into a visible, fair, and community-aware journey.

The original trigger is simple: in a hospital corridor, people wait for their names to be called, cannot leave for fresh air, and staff must manage a daily crowd with goodwill but poor flow. The product should respect that reality. It must not begin with "download our app." It begins with the smallest working queue signal.

It can be used for:

- cafes
- barbers
- clinics
- hospitals
- public offices
- notaries and banks
- restaurants and kitchens
- valet and parking
- taxi stands
- logistics gates
- retail consultant queues
- workshops
- SAP consulting intake
- ticket/event lines
- street sellers and local services
- lescommerce service appointments

The app should not manipulate people with fake scarcity, pressure, countdown tricks, or status games. It should show where someone is in the flow and what they can do next.

The lowest-tech version must still work:

- paper
- a phone call
- SMS
- WhatsApp
- a printed QR
- a screen
- a staff tablet
- even physical tokens if needed

The certification is earned by making the wait fair, breathable, and visible.

## 2. Core Flow

1. A place, seller, or service creates a waiting flow.
2. A member joins via web, QR, table/counter code, SMS, WhatsApp, Telegram,
   USSD, phone number, proximity discovery, staff tablet, or manual/offline
   entry.
3. The app records a neutral event.
4. The member can receive La, Le, Lo, or Lale based on natural participation.
5. The place can become a lestupid candidate or certified place.

Hospital corridor example:

1. Patient checks in at desk, QR, SMS, phone, proximity discovery, or staff
   tablet.
2. Patient receives a simple queue state.
3. Patient can wait outside the cramped corridor.
4. System notifies: "3 people before you. Please come closer."
5. Staff calls fewer names into empty air and the corridor stays humane.

## 3. Token Journey

- `La`: first join into a place or queue.
- `Le`: natural participation while waiting, returning, buying, learning, or contributing.
- `Lo`: recognition after repeated trust or meaningful depth.
- `Lale`: completed waiting/service/learning journey or certified relationship.

## 4. Channels

The app must be channel-independent.

Supported target channels:

- Web and QR
- table, counter, door, desk, or sign code
- SMS
- WhatsApp
- Telegram
- USSD
- phone number entry
- proximity/local place discovery
- staff tablet
- AgentAndBot API
- lescommerce checkout/appointment events
- manual/offline field entry

The channel adapter may be digital or analog. If a clinic only has a staff phone and paper, the staff can still record the event later as `manual`.

## 4.1 Venue Owner And Staff Entry

Les Wait is two-sided. Users can request or join a queue only when a real queue
surface exists; venue owners and staff must be able to create, verify and manage
that surface.

Venue owner actions:

- claim or create a place;
- verify place ownership or admin permission through Les Certification when
  risk requires it;
- create a waiting flow;
- choose join methods: QR, table/counter code, phone, staff tablet, proximity,
  web link, manual/offline;
- print QR or table signs;
- open staff tablet mode;
- set service windows, capacity and delay messages;
- call next, delay, pause, close, override, complete, no-show or cancel;
- export queue history;
- request certification as a fair waiting place.

User entry methods:

- `qr_scan`;
- `table_code_scan`;
- `short_link`;
- `phone_number`;
- `sms_or_chat`;
- `proximity_discovery`;
- `staff_tablet`;
- `manual_offline`.

Inactive venue rule:

- If a place has no active owner/staff flow, Les Go can show "request Les Wait
  for this venue".
- The app must not show a fake live queue.
- Community requests can become a merchant/certification lead.
- Activation requires owner/staff onboarding or an authorized integration.

## 5. Event Model

All channels produce the same core event:

```json
{
  "schema_version": "lestupid.event.v1",
  "channel": "web",
  "event_type": "queue_joined",
  "actor": {
    "type": "member",
    "member_id": "mem_123"
  },
  "entity": {
    "type": "place",
    "entity_id": "place_123"
  },
  "evidence": {
    "source": "qr_scan",
    "entry_surface_id": "surface_barber_door_qr_001",
    "venue_owner_flow_id": "flow_barber_123",
    "note": "joined barber queue"
  }
}
```

## 5.1 Service Flow Expansion

Les Wait can grow from queue-only events into a broader service-flow contract
without becoming a monolithic backend. This is the useful part of the E-SWSP
proposal: queue, booking, pickup, return, service status, notification state
and embeddable widgets can share one normalized event language.

Candidate cross-app service events:

- `service_flow_created`
- `entry_surface_created`
- `channel_session_started`
- `queue_joined`
- `booking_requested`
- `booking_confirmed`
- `service_eta_updated`
- `notification_sent`
- `pickup_ready`
- `order_handoff_requested`
- `staff_override_recorded`
- `service_completed`
- `no_show_recorded`
- `flow_closed`

Ownership rule:

- Les Wait owns service flow runtime, staff actions and ETA.
- Les Commerce owns catalog, checkout, order and payment logic.
- Les Go only previews and launches contextual cards.
- Les Certification owns fairness, owner/staff and widget certification rules.
- e-any.online/Windmill/Activepieces can run operational automation, but must
  not become the source of truth for live queue or private service state.

## 6. Payment Model

Payments are optional and provider-neutral.

Supported target providers:

- cash reported
- M-Pesa / mobile money
- card or bank transfer
- Celo stablecoin payment
- thirdweb-assisted wallet payment
- lescommerce checkout

Payment verification can strengthen evidence, but it must not be required for participation.

## 7. AI Role

AI may:

- summarize queue feedback
- detect fake check-ins
- suggest service improvements
- identify certification readiness
- explain delays in plain language

AI may not:

- silently issue final certificates
- create artificial urgency
- hide the queue state from users
- nudge people into unnecessary spending


## 8. Optional Web3, Certificate, Point, And Spend Layer

Les Wait may create value events, but the queue must work without a wallet.

The source of truth is the Les Wait database or future LesTupid core ledger. Web3 is optional proof and portability.

Possible value events:

- `La`: first fair queue join at a place or service.
- `Le`: natural participation, return, pickup, appointment, or completed wait.
- `Lo`: repeated trust, staff-recognized contribution, or reliable place usage.
- `Lale`: completed service journey or certified place relationship.
- `point_earned`: queue-safe participation or certified place action.
- `point_spent`: transparent reward, discount, service credit, or merchant offer.
- `certificate_proof_requested`: user or venue requests a public proof.
- `certificate_proof_revoked`: certification or proof is revoked.

Rules:

- wallet is never required to join a queue;
- points cannot change queue order unless the policy clearly allows and labels it;
- paid priority is not allowed by default;
- private queue, health, location, or match data must not be public on-chain;
- Web3 payloads should be hashes or minimal proofs;
- minting or public proof requires explicit user or venue consent.

Adapter:

- `les_block_adapter`: optional proof, point, spend, redeem, and certificate receipt adapter.

Les Block should remain an adapter until cross-app value, certificate proofs, or merchant settlement becomes large enough to justify a separate service.
## 9. AgentAndBot Role

AgentAndBot should expose the waiting app as an agent-callable public service.

Suggested skills:

- `create_lestupid_waiting_flow`
- `join_lestupid_waiting_flow`
- `record_lestupid_waiting_event`
- `lookup_lestupid_waiting_status`
- `summarize_lestupid_waiting_feedback`

## 10. lescommerce Role

lescommerce should use the waiting app for:

- service appointments
- workshop seats
- creator sessions
- pickup queues
- seller onboarding
- merchant certification review slots

## 11. Certification Criteria

The waiting app becomes lestupid certified when:

- queue order is clear
- hidden priority tricks are absent
- people do not need to stay trapped in a cramped waiting area just to hear their name
- every channel maps to the same event model
- users can join without a wallet
- Web3 proof is optional
- AI recommendations are labeled
- human override is auditable
- integrations are agent-readable

## 12. Source Notes

Imported concept notes from `les_wait/source-note-validebag-hospital.txt` and
`les_wait/source-note-waiting-scenarios.txt`, plus the broader omnichannel concept note:

- `source-note-validebag-hospital.txt`: Validebag Hospital corridor observation and the "solve it with whatever exists" principle.
- `source-note-waiting-scenarios.txt`: valet, blocked parking, food court, table order, group order, tattoo removal, barber, and taxi stand scenarios.
- `Beklemesiz_ Akilli Bekleme ve Sira Yonetimi Platformu Konsepti.md`: mobile, omnichannel, QR/barcode, LPR, AI wait prediction, business panel, API integrations, and multi-sector scenarios.
