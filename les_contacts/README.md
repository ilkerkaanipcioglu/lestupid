# Les Contacts

Les Contacts is the personal contact and place graph for LesTupid.

It lets a user import people, places, products, services and personal assets
from phone contacts, Google contacts, Instagram, LinkedIn, Airbnb/travel
platforms, shopping sites, marketplaces, maps, calendars, schools, workplaces,
orders, receipts and manual notes. Imported records stay private by default.
They can later become personal memories, family contacts, business leads,
customers, sellers, drivers, mentors, sponsors, creators, service providers,
safe contacts, travel companions, venues, memory places, products used, products
bought, assets owned or places to visit.

## Product Role

Les Contacts is not matchmaking by itself and not a public people directory.

It owns:

- imported contact records;
- imported or saved place records;
- product, service and asset relationship records;
- personal, work, family, school, social, travel and commerce context spaces;
- private relationship timeline events;
- product usage, purchase, rental, custody and service events;
- person/place CRM history;
- follow-up tasks and reminders;
- source attribution;
- deduplication and merge suggestions;
- private notes and tags;
- role candidates;
- consent state;
- export/delete controls.

Other apps consume it through optional adapters.

## Current Runtime Slice

The first runtime MVP now exists as a small Elixir package in this directory.
It currently focuses on one thing only:

- turn check-in context into a private draft relationship timeline event;
- keep visibility private by default;
- mark clinic/adult/private-context drafts as sensitive;
- require user review before any cross-app promotion.

This is intentionally smaller than full import/CRM/contact sync behavior.

## Context Spaces

Les Contacts is one private graph with multiple context spaces. The same person,
place or product can exist in more than one context, but permissions and notes
stay scoped.

Context spaces:

- `personal`: memories, visits, private notes, saved places and personal
  follow-ups.
- `work`: leads, customers, sellers, partners, job/stage/internship contacts,
  meetings and business follow-ups.
- `family`: relatives, family places, family assets, shared memories and
  guardian-safe contacts.
- `school`: classmates, teachers, clubs, courses, campus places and student
  opportunities.
- `social`: friends, creators, communities, events, groups and safe contact
  handoffs.
- `travel`: stays, rentals, hosts, guests, routes, trips, saved destinations and
  travel memories.
- `commerce`: orders, wishlists, receipts, warranties, refunds, merchants,
  products, services and Item Otel assets.

Cross-context use is never automatic. A family contact does not become a sales
lead, a work contact does not become a match candidate, and a travel stay does
not become public memory unless the user explicitly moves or shares it.

## Import And Connector Sources

Les Contacts may import from any source the user explicitly connects and that
the source platform legally allows:

- phone contacts and call/contact metadata allowed by the device;
- Google Contacts, Calendar and Maps exports or APIs;
- Instagram, TikTok, LinkedIn and other social/profile signals through official
  APIs, user export files or manual links;
- Airbnb/travel platform bookings, saved places, hosts/guests and trip notes
  through official APIs, email/receipt imports, user exports or manual entry;
- shopping sites, marketplaces and quick commerce receipts, carts, orders,
  wishlists, warranties and returns;
- email receipt imports, only after mailbox-scoped consent;
- browser/bookmark/manual saves;
- LesTupid app events from Go, Commerce, Item Otel, Wait, Poke, Match,
  Harmonica and Care.

Every imported field keeps source attribution. Unsupported scraping, hidden
enrichment, password collection and platform-rule bypassing are outside the
product model.

## Person Records

A person can be imported from:

- phone contacts;
- Google contacts;
- Instagram;
- LinkedIn;
- TikTok or creator profile links;
- WhatsApp/Telegram contacts, when allowed;
- Airbnb/travel host or guest interactions;
- marketplace buyer/seller interactions;
- school/work/community affiliation;
- manual entry.

Possible future roles:

- lead;
- customer;
- seller;
- family;
- friend;
- coworker;
- classmate;
- host/guest;
- driver/courier;
- mentor;
- sponsor;
- creator;
- service provider;
- teammate;
- safe contact;
- match candidate, only if Les Match is active.

Sensitive or adult-context labels must not be inferred automatically. Sexual
service marketplace behavior is not supported by LesTupid products.

## Relationship Timeline / Personal CRM

Les Contacts can keep a private timeline for every person, place, product,
service and asset. This is the personal CRM layer of LesTupid: where the user
went, who they met, which service they received, what they bought, what they
used, what they rented, what they stored, what follow-up is needed, and what
kind of relationship that person, place or thing may become over time.

Possible event types:

- place visit;
- clinic, dental or wellness service;
- meal, coffee, shopping or marketplace transaction;
- product view, product use, purchase, rental, resale, repair or return;
- Item Otel custody, care, rental, resale or recall;
- delivery, pickup or peer courier task;
- school, work, club, event or travel memory;
- meeting, date or private encounter;
- customer, lead, seller or service-provider interaction;
- support issue, complaint, refund or follow-up task.

Events are private by default. Sensitive health, intimate, adult, minor,
financial or legal context is never shared across apps by default and must not
be used for matchmaking, commerce, AI training or public scoring without a clear
review and consent step.

Automatic capture is allowed only as a private draft event. A Les Go check-in,
Les Wait queue, Les Commerce order, Les Care visit, Les Harmonica contact or
Les Match handoff can suggest a timeline entry, but the user decides whether it
becomes a CRM note, memory, lead, trust evidence, quest signal or opportunity.

## Product, Service And Asset Records

A product, service or personal asset can be imported from:

- Les Commerce orders, listings, carts, receipts and refunds;
- DIY video commerce materials, workshops and ready products;
- Item Otel custody, care, rental, resale and recall records;
- marketplace listings for phones, cars, clothing, homes, services or local
  offers;
- quick commerce storefronts;
- manual notes, photos, warranty cards or serial numbers.

Possible future roles:

- product bought;
- product used;
- product liked or saved;
- product returned or refunded;
- rented item;
- owned asset;
- stored asset;
- repair/care item;
- resale candidate;
- rental candidate;
- warranty or service follow-up;
- merchant/customer relationship signal.

Les Contacts does not own checkout, price, refund, inventory or merchant terms.
Those stay in Les Commerce. Contacts owns the private relationship memory: "I
bought this", "I used this", "I rented this", "this item is stored", "this needs
care", "I may sell this later", or "follow up with this seller".

## Place Records

A place can be imported or saved from:

- map/search result;
- check-in;
- calendar/travel plan;
- Airbnb/travel stay;
- restaurant, clinic, venue, workplace or school booking;
- Les Go place home;
- Les Poke city memory;
- Les Commerce merchant/listing;
- manual note.

Possible future roles:

- cafe to visit;
- merchant lead;
- venue to certify;
- place to buy/rent/sell;
- vacation place;
- stay or accommodation;
- school/work place;
- family place;
- memory place;
- event place;
- delivery/pickup point;
- safe meeting point.

## Standalone Mode

Les Contacts can run alone with:

- local contact import;
- local place save;
- local context spaces;
- local product/service/asset memory;
- private tags;
- dedupe/merge;
- CSV/JSON export;
- delete/revoke controls.

## Ecosystem Mode

Optional adapters:

- `go_context_adapter`: show contacts/places in Les Go context.
- `source_import_adapter`: import records from connected sources with source
  attribution and per-source revoke/delete controls.
- `relationship_event_adapter`: create private draft events from check-ins,
  orders, appointments, safe contacts, service visits and follow-ups.
- `match_adapter`: create match opportunities only after Les Match opt-in.
- `commerce_adapter`: turn contacts/places into leads, customers, sellers,
  merchants or service providers, and write private product/order relationship
  events after explicit commerce activation.
- `poke_adapter`: turn places into quests, memories and city trails.
- `harmonica_adapter`: turn approved contacts into safe contacts.
- `certification_adapter`: certify venues, merchants or trust credentials.

## Privacy Rules

- Import never means public exposure.
- Contacts are private by default.
- Context spaces are private and scoped by default.
- Relationship events are private by default.
- Product, service and asset relationship records are private by default.
- Places can be private, saved, shared, certified or public.
- Source must be visible: phone, Google, Instagram, LinkedIn, map, manual, etc.
- Connected external sources must use official APIs, user exports, email/receipt
  imports or manual entry; hidden scraping and password collection are not
  allowed.
- Sensitive event categories require explicit user review before any cross-app
  adapter can consume them.
- A contact cannot become a visible match candidate unless Les Match is active.
- A contact cannot be messaged through Harmonica unless safe-contact consent
  exists.
- A commerce role needs clear business context and opt-in communication.
- Commerce orders, receipts, product usage and asset custody records stay under
  Commerce/Item Otel as source systems; Contacts stores only private CRM memory
  and scoped references.
- Imported address books must not be uploaded to train AI models.
