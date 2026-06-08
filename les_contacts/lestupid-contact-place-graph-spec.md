# Les Contacts Contact And Place Graph Spec

## Goal

Create a private graph of people, places, products, services and personal assets
across personal, work, family, school, social, travel and commerce contexts.
The graph can later become useful across LesTupid without exposing raw address
books, private place lists, receipts, custody records or sensitive relationship
events.

## Core Records

```json
{
  "schema_version": "lestupid.contact_record.v1",
  "record_id": "contact_123",
  "owner_identity_id": "id_123",
  "source": "google_contacts",
  "display_name": "Ada Example",
  "normalized_refs": {
    "email_hash": "hash",
    "phone_hash": "hash",
    "social_ref": "instagram:private_ref"
  },
  "visibility": "private",
  "context_spaces": ["personal", "work"],
  "role_candidates": ["lead", "customer", "mentor"],
  "consent_state": {
    "match_visible": false,
    "commerce_contact_allowed": false,
    "harmonica_contact_allowed": false
  }
}
```

```json
{
  "schema_version": "lestupid.place_record.v1",
  "record_id": "place_123",
  "owner_identity_id": "id_123",
  "source": "manual",
  "name": "North Campus Cafe",
  "place_refs": {
    "maps_ref": "optional_provider_ref",
    "geohash": "coarse_hash"
  },
  "visibility": "private",
  "context_spaces": ["school", "commerce"],
  "role_candidates": ["cafe_to_visit", "merchant_lead", "memory_place"],
  "consent_state": {
    "go_visible": true,
    "certification_candidate": false,
    "commerce_lead_allowed": false
  }
}
```

```json
{
  "schema_version": "lestupid.product_relationship_record.v1",
  "record_id": "product_rel_123",
  "owner_identity_id": "id_123",
  "source": "lescommerce_order",
  "display_name": "Campus Coffee Monthly Pass",
  "relationship_type": "product_bought",
  "product_refs": {
    "commerce_product_id": "prod_123",
    "sku": "coffee-pass-monthly",
    "external_ref": null
  },
  "merchant_refs": ["contact_merchant_123"],
  "place_refs": ["place_123"],
  "asset_refs": [],
  "visibility": "private",
  "context_spaces": ["commerce", "school"],
  "role_candidates": ["repeat_purchase", "merchant_relationship"],
  "consent_state": {
    "commerce_use_allowed": true,
    "go_context_allowed": true,
    "match_use_allowed": false,
    "ai_summary_allowed": false
  }
}
```

```json
{
  "schema_version": "lestupid.asset_relationship_record.v1",
  "record_id": "asset_rel_123",
  "owner_identity_id": "id_123",
  "source": "les_itemotel",
  "display_name": "Winter Tires",
  "relationship_type": "stored_asset",
  "asset_refs": {
    "itemotel_item_id": "item_123",
    "serial_or_tag_hash": "hash"
  },
  "place_refs": ["itemotel_warehouse_123"],
  "visibility": "private",
  "context_spaces": ["personal", "commerce"],
  "role_candidates": ["care_due", "rental_candidate", "recall_needed"],
  "consent_state": {
    "commerce_use_allowed": true,
    "go_context_allowed": true,
    "certification_evidence_allowed": false,
    "ai_summary_allowed": false
  }
}
```

```json
{
  "schema_version": "lestupid.relationship_event.v1",
  "event_id": "event_123",
  "owner_identity_id": "id_123",
  "source": "les_go_checkin",
  "event_type": "place_visit",
  "occurred_at": "2026-06-03T15:20:00+03:00",
  "person_refs": ["contact_123"],
  "place_refs": ["place_123"],
  "product_refs": [],
  "asset_refs": [],
  "linked_app_refs": {
    "les_go_checkin_id": "checkin_123",
    "commerce_order_id": null,
    "commerce_product_id": null,
    "itemotel_record_id": null,
    "wait_ticket_id": null,
    "harmonica_thread_id": null,
    "match_handoff_id": null
  },
  "sensitivity": "normal",
  "visibility": "private",
  "context_spaces": ["school", "personal"],
  "summary": "Visited North Campus Cafe after class.",
  "role_candidates": ["memory", "merchant_lead"],
  "follow_up": {
    "status": "none",
    "due_at": null,
    "note": null
  },
  "consent_state": {
    "go_context_allowed": true,
    "match_use_allowed": false,
    "commerce_use_allowed": false,
    "certification_evidence_allowed": false,
    "ai_summary_allowed": false
  }
}
```

## Context Spaces

Allowed context spaces:

- `personal`;
- `work`;
- `family`;
- `school`;
- `social`;
- `travel`;
- `commerce`.

Records can belong to multiple contexts. Each context keeps separate notes,
permissions and adapter visibility. Cross-context promotion must be explicit:
for example, a family contact is not automatically a commerce lead, and a work
contact is not automatically a match candidate.

## Import Sources

- phone contacts;
- Google contacts;
- Instagram selected signals;
- TikTok selected signals;
- LinkedIn selected signals;
- WhatsApp/Telegram selected contacts, when allowed;
- Airbnb/travel bookings, saved stays, host/guest references and trip notes;
- marketplace interactions;
- shopping-site orders, wishlists, carts, receipts, warranties and returns;
- email receipt imports with mailbox-scoped consent;
- browser/bookmark/manual saves;
- commerce orders, receipts, carts, listings and refunds;
- Item Otel custody, care, rental, resale and recall records;
- product usage, repair, warranty and service notes;
- calendar/travel plans;
- maps/search;
- manual records.

## Connector Rules

Connectors must use one of these routes:

- official API/OAuth permission;
- user-provided export file;
- email/receipt parser with scoped mailbox consent;
- manual URL/profile/place/product save;
- LesTupid first-party app event.

Connectors must not collect user passwords for third-party services, bypass
platform rules, scrape private pages without permission, or merge records
without visible source attribution and undo controls.

## Role Candidate Rules

Roles are suggestions, not facts.

Allowed role candidates include:

- `lead`;
- `customer`;
- `seller`;
- `merchant`;
- `family`;
- `friend`;
- `coworker`;
- `classmate`;
- `host`;
- `guest`;
- `driver`;
- `courier`;
- `mentor`;
- `sponsor`;
- `creator`;
- `service_provider`;
- `safe_contact`;
- `match_candidate`;
- `cafe_to_visit`;
- `vacation_place`;
- `memory_place`;
- `certified_place_candidate`;
- `stay_or_accommodation`;
- `product_bought`;
- `product_used`;
- `product_saved`;
- `service_received`;
- `rented_item`;
- `owned_asset`;
- `stored_asset`;
- `care_due`;
- `resale_candidate`;
- `rental_candidate`;
- `warranty_follow_up`;

Sensitive, sexual, medical, minor-related, political or financial labels must
not be inferred automatically. Sexual service marketplace behavior is outside
LesTupid scope.

## Relationship Event Rules

Relationship events are the activity log for personal CRM. They can be attached
to people, places, apps, orders, appointments, check-ins, messages or manual
notes. They can also attach to products, services, personal assets, receipts,
rentals, storage/custody records, care records and warranty notes.

Allowed event types include:

- `place_visit`;
- `service_visit`;
- `clinic_or_dental_visit`;
- `wellness_visit`;
- `meal_or_coffee`;
- `marketplace_transaction`;
- `product_view`;
- `product_use`;
- `product_purchase`;
- `product_return_or_refund`;
- `item_rental`;
- `item_resale`;
- `item_custody`;
- `item_care`;
- `item_recall`;
- `warranty_or_repair`;
- `delivery_or_pickup`;
- `school_work_or_club_activity`;
- `event_or_travel_memory`;
- `meeting_or_date`;
- `private_encounter`;
- `lead_interaction`;
- `customer_interaction`;
- `seller_interaction`;
- `support_or_complaint`;
- `follow_up_task`.

Sensitive classes include:

- `health`;
- `intimate_or_adult`;
- `minor_related`;
- `financial`;
- `legal`;
- `safety`.

Sensitive events must default to `visibility: private`, `sensitivity:
restricted`, and all cross-app consent flags set to false. They may be kept as
personal memory or CRM history, but they must not feed people discovery,
commerce offers, public scoring, AI training, or certification evidence unless
the user explicitly promotes that event into a scoped, reviewed adapter flow.

## Commerce And Item Relationship Rules

Les Commerce remains source-of-truth for checkout, cart, price, payment, refund,
merchant terms, inventory and order status. Les Item Otel remains source-of-
truth for custody, condition, care, rental, resale and recall state.

Les Contacts may store private relationship records such as:

- bought from this merchant;
- used this product at this place;
- rented this item;
- stored this asset;
- care or repair due;
- refund or support follow-up;
- may sell, rent or buy again later.

These records are CRM memory and scoped references, not financial ledgers. They
must not expose receipts, serial numbers, addresses or private ownership details
to other apps unless the user explicitly promotes the record.

## Adapter Boundaries

- Les Match: can consume only `match_candidate` after Les Match activation.
- Les Commerce: can consume lead/customer/seller/merchant/service/product roles
  only with business context and contact permission. It can send order,
  product, rental, custody and refund events back as private CRM drafts.
- External connectors: can create private records only through official APIs,
  user exports, scoped email/receipt imports or manual saves. They cannot become
  hidden enrichment providers.
- Les Poke: can consume places as quests, city memory or trails without
  exposing private lists.
- Les Harmonica: can consume safe contact candidates only after contact consent.
- Les Go: can show private saved places, product/asset reminders, activation
  prompts and private draft timeline events from check-ins.
- Les Certification: can review places/merchants/trust evidence.
- Les AI: may summarize/dedupe/suggest only after review, but must not train on
  imported contacts or relationship events.
- Les Care: can create private visit/follow-up events, but diagnosis,
  prescription and emergency guidance stay under Les Care policy.

## Non-Goals

- No public people search from imported contacts.
- No raw address book sharing across apps.
- No automatic matchmaking.
- No automatic outreach.
- No hidden CRM enrichment.
- No third-party password collection.
- No unsupported private scraping.
- No cross-context use without explicit promotion.
- No hidden receipt, product ownership or asset custody sharing.
- No AI training on imported contacts or relationship events.
