# Les Match Product Plan

## Summary

Les Match is a matchmaking layer for the LesTupid ecosystem. It routes intent
between people, places, merchants, quests, wait states, and services without
turning matching into a manipulative engagement game.

It must also remain separable: Les Match can run as its own matchmaking app,
while the ecosystem version simply adds shared identity activation and optional
signals from other LesTupid apps.

From the matchmaking window, every other LesTupid app can create a match
opportunity when the user has activated Les Match. Sharing a car, planning a
concert, checking in at a place, joining a university community, or looking for
a sponsor can all become explainable match opportunities.

AgentAndBot/KADRO agents can also become explainable match candidates for tasks,
mentorship, workflow help, merchant support, creator work, or student support.
They must be clearly labeled as AI agents and must not be presented as human
matches.

The larger ecosystem model is channel activation: users can activate car,
travel, place, education, event, product, hobby, or similar interaction channels.
Those channels power information, offers, recommendations, check-ins,
certification pressure, and matchmaking when Les Match is also active.

Channels can also be external message, social, commerce, or affiliation channels:
Instagram, TikTok, Hepsiburada-like marketplaces, universities, schools,
communities, alumni groups, and certified places.

## MVP

- Elixir/Phoenix JSON API under `api/`.
- Standalone runtime plus ecosystem-activated runtime.
- Shared LesTupid identity activation: users register once, then explicitly
  activate Les Match.
- Match profile with explicit intent, location preference, availability, and
  safety controls.
- Match preview endpoint that explains why each candidate appears.
- Match opportunity ingestion from other apps.
- Accept, reject, mute, block, and report flows.
- Merchant and service matching hooks for `Les_Commerce/`.
- Quest and local-event matching hooks for `Les_poke/`.
- Queue-safe micro action matching hooks for `les_wait/`.
- Shared-interest hooks for posts, products, vehicles, hobbies, and content.
- Interaction channel activation hooks for car, travel, place, education,
  event, product, hobby, and future channels.
- External channel hooks for Instagram, TikTok, shopping marketplaces, and
  university or community affiliation.
- Event and travel hooks for concerts, festivals, holidays, routes, and trips.
- University sponsor hooks for education, travel, internship, job, and project support.
- Place check-in hooks that can both create people matches and signal that a
  venue should become a lestupid place.
- AgentAndBot/KADRO agent hooks for clearly labeled person-to-agent,
  agent-to-person, and agent-to-task suggestions.

## Certification Criteria

- One ecosystem identity, app-specific activation.
- Standalone operation without requiring Les Poke, Les Wait, Les Commerce, or a
  central LesTupid shell.
- Consent-first matching.
- Explainable scoring and recommendation reasons.
- Labeled paid placement.
- No hidden boosts, fake scarcity, or addictive ranking loops.
- No silent sensitive attribute inference.
- Auditable match history for human review.

## First Data Model

| Entity | Purpose |
| --- | --- |
| `match_profile` | User or entity matching preferences and boundaries. |
| `match_intent` | What the user wants now: meet, buy, learn, walk, wait, collaborate. |
| `match_candidate` | A candidate person, place, merchant, quest, or service. |
| `agent_candidate` | A clearly labeled AgentAndBot/KADRO AI agent, persona, mentor, or worker candidate. |
| `match_opportunity` | A signal from another app: share, check-in, event, travel, sponsor need, or intent. |
| `interaction_channel` | A user-activated life area, platform, marketplace, affiliation, or object. |
| `channel_signal` | User-approved signal from a channel: post, wishlist, check-in, membership, plan, product, or event. |
| `match_explanation` | Plain-language reason and score components. |
| `match_decision` | Accept, reject, mute, block, or report action. |
| `safety_report` | Human-reviewable safety issue. |

## Ecosystem Events

Les Match should emit future `harezm.event.v1` events for:

- `les_match.previewed`
- `les_match.opportunity_created`
- `les_match.accepted`
- `les_match.rejected`
- `les_match.blocked`
- `les_match.reported`
- `les_match.reviewed`
- `les_match.agent_suggested`
