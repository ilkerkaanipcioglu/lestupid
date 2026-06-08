# Les Travel Readiness Spec

## Goal

Help a user travel without losing money, documents, safety or dignity. The app
combines official-source routing, trip readiness, stay safety, scam awareness,
safe contacts and private travel memory.

## Core Record

```json
{
  "schema_version": "lestupid.trip_intent.v1",
  "trip_id": "trip_kenya_turkiye_001",
  "owner_identity_id": "student-demo-001",
  "origin_country": "Kenya",
  "destination_country": "Turkiye",
  "destination_city": "Istanbul",
  "purpose": "study_visit",
  "traveler_context": ["student", "university", "geography"],
  "readiness": {
    "passport": "check_required",
    "visa": "official_source_required",
    "accommodation": "unverified",
    "funding": "draft",
    "insurance": "missing",
    "return_plan": "draft",
    "emergency_contacts": "draft"
  },
  "risk_labels": ["fake_visa_site_risk", "unverified_accommodation"],
  "visibility": "private"
}
```

## Readiness Cards

- official visa/source check;
- document checklist;
- school/work purpose proof;
- invitation/acceptance letter;
- accommodation proof;
- budget and funding proof;
- insurance and care info;
- route and return plan;
- emergency contacts;
- local scam briefing;
- certified place/operator signal;
- private travel memory.

## Official Source Rule

Visa and entry requirements are unstable. Les Travel must not hardcode final
answers as product truth. It can cache explanations, but every visa card must
link to official sources and show a last-checked date.

Allowed official-source classes:

- destination foreign ministry;
- official e-visa portal;
- destination embassy/consulate;
- migration/immigration authority;
- university/institution official page for student invitations.

Initial official source candidates:

- `https://www.mfa.gov.tr/visa-information-for-foreigners.en.mfa`;
- `https://www.evisa.gov.tr/`;
- `https://nairobi-emb.mfa.gov.tr/Mission/Contact`.

## Kenya To Turkiye Student Flow

1. Create trip intent.
2. Select purpose: study visit, conference, exchange, internship, tourism or
   sponsor/mentor opportunity.
3. Check official visa source.
4. Build document checklist.
5. Verify accommodation and route.
6. Create emergency contact pack.
7. Add school contact, host, mentor or sponsor only with consent.
8. Store trip as private Les Contacts travel context.
9. After arrival, Les Go switches to airport/campus/city place mode.

## Phuket / Tourist Trap Avoidance Flow

1. Create holiday intent.
2. Check budget, return plan, stay and insurance.
3. Flag unsafe operators, fake bookings, passport/document custody, transport
   scams, aggressive upsells, unsafe private meetups and unverified medical/tour
   offers.
4. Offer certified alternatives where available.
5. Keep social/dating/travel companion discovery opt-in through Les Match.
6. Keep emergency contact through Les Harmonica.

## Adapter Boundaries

- Les Go: visual travel flow, arrival mode and nearby safe-place prompts.
- Les Contacts: private travel people, places, bookings and memories.
- Les Commerce: ticket, stay, gear, insurance or operator offers with clear
  terms.
- Les Certification: official source confidence, certified place/operator and
  scam labels.
- Les Harmonica: trusted contact, secure host/venue handoff and emergency
  contact.
- Les Match: opt-in travel companion, student mentor/sponsor or event group.
- Les Care: travel health info, clinic routing and emergency-first cards.
- Les AI: checklist, language help, itinerary and risk summary, always sourced.

## Non-Goals

- No visa decision ownership.
- No immigration/legal advice as final authority.
- No fake official links.
- No hidden commission.
- No automatic person tracking.
- No automatic matchmaking.
- No sexual service marketplace behavior.
- No unsupported scraping of travel accounts.
