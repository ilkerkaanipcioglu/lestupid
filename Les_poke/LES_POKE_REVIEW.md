# Les Poke Review

Review date: 2026-06-02

## Verdict

Les Poke is a strong city-memory and real-world quest app candidate. It should
remain mobile-first, but not mobile-only.

The current Expo app and Phoenix JSON API are a good lightweight base.

## What Is Good

- Product idea is concrete: city quests, memory layers, points, badges, and
  local discovery.
- The API is already separated from the mobile client.
- Les Match, Les Wait, Les Commerce, Les Certification, Les AI, AgentAndBot, and
  Les Block can all integrate through optional adapters.
- The app can run standalone as a quest app without the rest of LesTupid.

## Current Boundaries

Les Poke owns:

- cities;
- places;
- quests;
- quest completions;
- field notes;
- public-space discovery metadata;
- quest points and badges.

Les Poke must not own:

- final matchmaking decisions;
- commerce checkout;
- queue state;
- final certification decisions;
- Web3 source of truth;
- AgentAndBot agent runtime.

Those connect through adapters.

## Platform Strategy

- Expo/native app is useful for location and installed city play.
- Mobile web/PWA should also be supported for lightweight city discovery.
- Desktop is not a first-class play surface, but web admin/content tools can be
  desktop-friendly.

## Optional Value Layer

Les Poke can emit quest, badge, point, La/Le/Lo/Lale, and place-candidate value
events. Wallets are optional.

`les_block_adapter` may later create proofs for:

- quest completion;
- badge ownership;
- point snapshots;
- place candidate evidence;
- certified city-memory contribution.

Private location trails must not be published on-chain.

## Agent And AI Fit

Les AI and AgentAndBot/KADRO agents may help generate quest ideas, draft field
notes, summarize place evidence, or suggest agent-led city tasks.

Any agent appearing in Les Match from a Les Poke signal must be clearly labeled
as an AI agent.

## Next Recommended Step

Keep the current Expo/Phoenix split. Next useful implementation step is a small
activation and channel consent surface in the mobile app:

- activate Les Poke;
- activate city/location quest consent;
- activate optional Les Match opportunities;
- activate optional proof/value events.
