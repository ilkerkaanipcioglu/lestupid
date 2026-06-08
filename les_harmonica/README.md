# Les Harmonica

Les Harmonica is a safe communication and trusted-proximity product.

It can run by itself as a standalone secure contact app, or it can be activated
inside the LesTupid ecosystem through Les Go, Les Certification, Les Match,
Les Care, Les Commerce, and optional Les Block proofs.

## Product Role

Les Harmonica helps people recognize and safely communicate with each other
without immediately exposing real identity.

Core loop:

1. Two people, groups, guardians, venues, schools, teams, or apps create a
   consented trust connection.
2. Each side receives a pairwise pseudonymous contact reference.
3. Nearby or app-mediated contact can show a limited trust signal.
4. Communication opens only through the allowed mode: message, proximity alert,
   safe check-in, group signal, emergency support, or verified handoff.

## Standalone Mode

In standalone mode, Les Harmonica owns its own:

- local account or device key;
- contact graph;
- contact invites;
- proximity pairing;
- encrypted messages;
- local trust notes;
- block/report list.

It does not need Les Go, Les Certification, Les Match, Les Block, or any other
LesTupid app to work.

## Ecosystem Mode

In ecosystem mode, Les Harmonica can consume optional adapters:

- `identity_adapter`: link to one LesTupid identity without exposing it publicly.
- `activation_adapter`: activate safe-contact channel from another app.
- `certification_adapter`: request pseudonymous trust credentials.
- `les_block_adapter`: optional hash-only proof and revocation pointers.
- `go_context_adapter`: open safe-contact cards from a place/mode feed.
- `match_adapter`: only after Les Match explicit opt-in.

The app must remain extractable. If these adapters disappear, core secure
contact and local encrypted messaging still work.

## Identity-Hidden Trust

Les Harmonica does not expose a universal user profile by default.

Each counterparty gets a pairwise pseudonymous reference. A person can show:

- trusted contact;
- guardian-approved contact;
- certified venue staff;
- verified peer courier;
- reliable buyer/seller;
- safe group member;
- emergency helper;
- school-approved club/group contact.

The other side should not automatically see real name, phone, full history,
exact place trail, dating history, health context, or commerce basket.

## Safety Rules

- No silent contact discovery.
- No public people browsing.
- No automatic identity reveal.
- No global social credit score.
- No raw relationship graph on chain.
- No raw message content on chain.
- No adult, dating, health, or minor context reuse across domains.
- Minors use guardian/school-approved contacts only.
- Les Match people discovery stays opt-in and separate.

## Web3 Rule

Blockchain is optional proof, not the communication database.

Allowed chain payloads:

- credential hash;
- pairwise contact proof hash;
- issuer id;
- expiry/revocation pointer;
- optional public badge metadata with user consent.

Forbidden chain payloads:

- real names, phone numbers, emails;
- raw contact graph;
- message content;
- exact location history;
- health, dating, adult or minor private data.

## Go Fit

Les Go can show Les Harmonica as a feed card:

- "Open anonymous safe contact";
- "Show trust without identity";
- "Guardian/school approved contact only";
- "Venue staff verified";
- "Emergency helper nearby";
- "Start contact after Les Match opt-in".

Go launches the contact flow; Les Harmonica owns the conversation and secure
contact state.

