# Les Travel

Les Travel is the LesTupid travel readiness, stay safety and trip memory app.

It helps a user plan a trip without turning travel into blind excitement. Visa,
documents, money, accommodation, school/work purpose, safe routes, emergency
contacts, scams, health, trusted places and return plans are shown together.

## Product Role

Les Travel is not a visa agency and not a travel marketplace by itself.

It owns:

- trip intent records;
- country/city readiness checklist;
- official visa/source link routing;
- stay safety checklist;
- accommodation risk labels;
- route and return planning;
- emergency contact pack;
- scam/risk briefing;
- travel budget guardrails;
- private trip memory;
- consented travel opportunity cards.

## Core Scenarios

### Nairobi University Student To Turkiye

Profile:

- Kenyan citizen;
- geography student at University of Nairobi;
- already uses LesTupid;
- wants to travel to Turkiye for study, conference, internship, exchange,
  tourism or sponsor/mentor opportunity.

Flow:

1. User creates a trip intent: `Kenya -> Turkiye`.
2. Les Travel asks trip purpose: tourism, study visit, conference, exchange,
   internship, work, family or medical.
3. Visa readiness card links only to official Turkish Ministry/e-Visa/mission
   sources. It does not invent requirements.
4. Les AI/KADRO creates a document checklist draft: passport, acceptance/invite,
   accommodation proof, funding proof, insurance, return ticket and school
   letter where relevant.
5. Les Certification labels official source confidence and warns about fake
   visa/payment sites.
6. Les Commerce/Marketplace can show stay options, but risk labels and report
   controls are mandatory.
7. Les Harmonica prepares safe contacts: campus contact, host, friend, embassy
   contact, trusted venue or LesTupid certified place.
8. Les Contacts stores the trip as private travel context and memory.
9. Les Go shows city/place mode after arrival: airport, dorm, cafe, campus,
   transport, clinic, event, safe return.

### Phuket Holiday / High-Risk Tourist Trap Avoidance

Flow:

1. User creates a holiday intent.
2. Les Travel checks budget, return ticket, accommodation, insurance and local
   risk briefing.
3. Risk cards flag common tourist traps: fake bookings, unsafe transport,
   overcharging, aggressive nightlife upsells, document/passport custody,
   unverified medical/tour operators and unsafe private meetups.
4. Les Match remains opt-in and never turns travel, gifts or money into sexual
   service expectations.
5. Les Harmonica gives trusted contact and panic/handoff options.
6. Les Contacts logs safe places, people met, bookings and trip memories
   privately.

## Standalone Mode

Les Travel can run alone with:

- trip checklist;
- official source links;
- accommodation notes;
- budget planner;
- safety briefing;
- emergency contacts;
- private trip journal;
- export/delete controls.

## Ecosystem Mode

Optional adapters:

- `go_context_adapter`: show trip cards in Les Go and after-arrival place mode.
- `contacts_adapter`: save trip people, places, bookings and memories privately.
- `commerce_adapter`: show accommodation, ticket, gear, insurance or service
  offers with clear terms.
- `certification_adapter`: label official sources, certified venues, safe
  operators and scam warnings.
- `harmonica_adapter`: secure trusted contact and emergency handoff.
- `match_adapter`: opt-in travel companion, school/sponsor/mentor or event
  matching.
- `care_adapter`: travel health info, clinic routing and emergency-first
  guidance.
- `ai_adapter`: document checklist, itinerary draft, risk summary and language
  help.

## Safety Rules

- Visa and entry rules must be checked through official sources at runtime.
- The product must show "verify official source" whenever visa/entry rules are
  displayed.
- No fake urgency, fake scarcity or hidden commission.
- No unsupported private scraping of travel accounts.
- No hidden person tracking.
- No automatic matchmaking.
- No sexual service marketplace behavior.
- No request to surrender passport/documents to unverified operators.
- Risky locations and offers must look risky, not cute.

## Initial Official Source Candidates

- Turkiye Ministry of Foreign Affairs visa information:
  `https://www.mfa.gov.tr/visa-information-for-foreigners.en.mfa`
- Turkiye official e-Visa portal:
  `https://www.evisa.gov.tr/`
- Turkish Embassy in Nairobi contact page:
  `https://nairobi-emb.mfa.gov.tr/Mission/Contact`

These are source candidates, not cached legal advice. The running product must
show a last-checked date and should re-check before the user acts.
