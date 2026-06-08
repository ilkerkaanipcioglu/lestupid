# lestupid identity and app activation spec

## Goal

One LesTupid account should work across the ecosystem. A user registers once,
then only activates the other apps they want to use.

This keeps onboarding light without silently enabling sensitive app features.
It also keeps each app separable: a product may run alone, or run as an
activated app inside the broader LesTupid ecosystem.

## Core Rule

Registration belongs to the LesTupid identity layer.

Individual apps do not create unrelated user accounts. They create an app
activation record for the existing ecosystem identity.

When an app runs outside the ecosystem, it may create local accounts. Those
local accounts must be linkable later to a LesTupid identity without forcing a
new profile or losing consent history.

```text
lestupid_identity
  -> les_wait activation
  -> Les_poke activation
  -> les_match activation
  -> Les_Commerce activation
  -> car channel activation
  -> travel channel activation
  -> place channel activation
  -> education channel activation
  -> product channel activation
  -> instagram channel activation
  -> tiktok channel activation
  -> hepsiburada channel activation
  -> university affiliation activation
  -> pseudonymous trust credentials
```

## Account States

| State | Meaning |
| --- | --- |
| `registered` | User has one ecosystem identity. |
| `verified` | Primary contact or wallet/passkey is verified. |
| `activated` | A specific app is enabled for this user. |
| `paused` | User or policy paused an app activation. |
| `revoked` | Activation was removed for safety, abuse, or user request. |

## Activation Contract

Each app activation must store:

- `identity_id`
- `product_id`
- `status`
- `activated_at`
- `permissions`
- `consent_version`
- `source_app`
- `last_seen_at`

Apps may add their own profile fields, but the identity id stays shared.

## Runtime Modes

Every app should support these modes:

| Mode | Meaning |
| --- | --- |
| `standalone_app` | App runs alone with local registration, local consent, and its own deployment. |
| `ecosystem_activated_app` | App is activated from a shared LesTupid identity and can use cross-app channels. |

The shared identity layer is an adapter, not a hard dependency for booting the
product. If the adapter is unavailable, the app should keep its standalone core
flows working and queue or disable cross-app features clearly.

## Interaction Channel Activation

App activation opens a product. Channel activation opens a life area, object, or
interest that can be used across products.

Examples:

| Channel | What activation means |
| --- | --- |
| `car` | User wants car-related information, offers, people, events, routes, products, and services. |
| `travel` | User wants trip, route, hotel, event, local people, guide, sponsor, and safety opportunities. |
| `place` | User wants check-in, local people, venue certification, queue, reward, and discovery interactions. |
| `education` | User wants learning, mentor, sponsor, internship, job, school, and travel support. |
| `event` | User wants concert, festival, meetup, game, conference, and group plan interactions. |
| `product` | User wants product knowledge, local offers, repair, resale, community, or merchant interactions. |
| `hobby` | User wants interest-based people, places, content, and events. |
| `health_fitness` | User wants safe, consent-based activity, place, coach, and service interactions. |
| `instagram` | User allows selected social/profile/content signals to create interactions. |
| `tiktok` | User allows selected short-video/content signals to create interactions. |
| `shopping_marketplace` | User allows selected shopping interest, wishlist, product, repair, resale, or offer signals. |
| `university_affiliation` | User allows school/community affiliation for mentor, sponsor, event, travel, project, and job interactions. |

Each channel activation should store:

- `identity_id`
- `channel_id`
- `status`
- `scope`
- `allowed_apps`
- `allowed_interactions`
- `consent_version`
- `privacy_level`
- `expires_at`

External or certified platform channels should also store:

- `provider`
- `provider_account_ref`
- `verification_status`
- `allowed_signal_types`
- `data_refresh_policy`

Channel activation can power all apps: information, offers, recommendations,
check-ins, loyalty, certification pressure, and matchmaking.

If `les_match` is active too, channel activity may also create match
opportunities. If `les_match` is not active, the same channel can still power
non-personal information and app interactions.

## Consent Boundaries

Activation is not just a login shortcut. It is explicit consent for that app's
domain.

- Les Match must ask for matchmaking consent before showing or using a match
  profile.
- Les Poke must ask for quest/location consent before city discovery.
- les_wait must ask for queue/service notification consent before wait flows.
- Les_Commerce must ask for commerce, merchant, checkout, or reward consent.

No app may infer sensitive attributes or activate another app silently.

## Match Opportunity Rule

Every LesTupid app may create match opportunities from active channels, but
only after the user has activated Les Match.

Examples:

- a shared car, product, food, game, book, or hobby;
- an Instagram, TikTok, marketplace, wishlist, or shopping signal;
- a concert, event, route, holiday, or travel plan;
- a university affiliation or student looking for education, travel, internship,
  job, or project sponsorship;
- a place check-in that can suggest compatible people and mark the venue as a
  lestupid place candidate.

An opportunity is only a signal. It becomes a visible match suggestion only when
both sides have matchmaking enabled and the reason can be explained.

## Token and Loyalty Fit

The La/Le/Lo/Lale journey should attach to the shared identity, not to separate
per-app accounts.

- `La`: first ecosystem registration or first app activation.
- `Le`: ongoing use in an activated app.
- `Lo`: verified trust, contribution, or repeat relationship.
- `Lale`: completed certified journey across one or more apps.

## Identity-Hidden Trust

The shared identity is the private root. Public trust should not require
revealing that root identity.

Les Certification may issue pseudonymous trust credentials from consented app,
place, queue, commerce, learning, delivery or contribution events. The user can
show a scoped trust badge such as "reliable buyer", "verified peer courier", or
"fair queue participant" without exposing their name, full history, exact place
trail, or universal ecosystem identity.

Rules:

- Trust credentials are domain-scoped, not one global social score.
- Each counterparty should see a pairwise pseudonymous reference by default.
- Blockchain proofs are optional, hash-only and revocable.
- Raw events stay in the app/core ledger and are not published.
- Dating, health, adult and minor-safe contexts need stricter domain separation.
- No app may silently use trust credentials for matchmaking or ranking.

## Required API Shape

Future app APIs should expose:

- `GET /api/identity/status`
- `POST /api/activations`
- `GET /api/activations`
- `PATCH /api/activations/:product_id`
- `DELETE /api/activations/:product_id`

Machine-readable app manifests should include `identity_activation`.
They should also include `runtime_modes` and `portability`.

## Certification Criteria

An app is not LesTupid-compatible unless:

- it accepts a shared LesTupid identity;
- it supports explicit app activation;
- it keeps app-specific consent separate from registration;
- it lets the user pause or revoke activation;
- it does not create duplicate unrelated accounts for the same person;
- it records activation state for audit and human review;
- it can run as a standalone app without unrelated LesTupid apps;
- it can be activated from another LesTupid app without duplicate signup;
- it exposes enough manifest metadata to separate or reconnect the app later.

See `les_certification/lestupid-app-portability-spec.md` for the separability
and adapter contract.
