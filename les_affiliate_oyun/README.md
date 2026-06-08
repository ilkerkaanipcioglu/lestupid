# Les Affiliate Oyun

Les Affiliate Oyun is a social-commerce card game layer for LesTupid.

It turns products, creator drops, local listings, quests, skills and certified
merchant offers into collectible game cards. It can run as a standalone card
game, or work inside the ecosystem with Les Commerce, Les Poke, Les Match,
Les Certification, Les Go and optional Les Block proof.

## Positioning

The original idea is `Omni-Deck Arena`: users create decks from products,
social assets and game cards, then play, trade, complete quests and earn
transparent affiliate rewards.

LesTupid positioning:

- Les Commerce owns commerce, affiliate links, checkout, refunds, merchant
  terms and commission ledger.
- Les Poke owns quests, drops, discovery loops, proof-of-participation and
  location-safe game tasks.
- Les Match owns opt-in opponent/team/sponsor/creator/community matching.
- Les Certification owns rules, disclosure labels, anti-manipulation review and
  trust/proof policy.
- Les Affiliate Oyun owns card/deck rules, game state, rarity, crafting,
  duels, seasons and game UI.

## Standalone Mode

In standalone mode, the game can run with:

- local player account;
- local deck and card inventory;
- mock product cards;
- non-cash points;
- local quests;
- friendly duels;
- local leaderboard.

No LesTupid app is required for the core card game.

## Ecosystem Mode

In ecosystem mode, optional adapters can enrich the game:

- `lescommerce_adapter`: product cards, affiliate attribution, checkout link,
  merchant reward, commission receipt.
- `les_poke_adapter`: quest cards, check-in drops, city/campus challenges,
  proof-of-participation.
- `les_match_adapter`: opt-in duel opponent, team, mentor, sponsor, creator or
  brand match.
- `certification_adapter`: paid placement labels, odds/rules disclosure,
  merchant/product certification and anti-manipulation review.
- `les_block_adapter`: optional card proof, reward receipt or season result
  hash. It is not required to play.

## Game Card Types

| Card type | Owner app | Meaning |
| --- | --- | --- |
| `collectible_card` | Les Affiliate Oyun | Lore, art, game power, rarity. |
| `product_card` | Les Commerce | Product, listing, DIY kit, Item Otel rental, merchant offer. |
| `creator_card` | Les Poke / Les Commerce | Creator drop, fan club item, video-to-product drop. |
| `quest_card` | Les Poke | Check-in, campus task, city discovery, event participation. |
| `match_card` | Les Match | Opt-in opponent/team/sponsor/mentor candidate. |
| `trust_card` | Les Certification | Certified merchant, product, player or proof badge. |

## Safe Economy Rules

The game must not trick users into purchases or punish refusal.

Allowed:

- clear affiliate links;
- explicit paid placement labels;
- opt-in purchases;
- transparent commission split;
- reversible or supportable order flows through Les Commerce;
- non-cash game points for normal play;
- optional proof receipts.

Not allowed:

- hidden ads;
- dark-pattern urgency;
- pay-to-win matchmaking;
- forced wallet login;
- auto-purchase;
- "reject a duel and lose value";
- "someone buys one item and steals your whole deck" as a real-value loss;
- gambling-like odds without review and legal approval.

The original "affiliate buyout" can exist only as a clearly simulated game
event or opt-in wagerless tournament mechanic. Real product purchase must not
delete or confiscate a user's paid assets.

## Les Go Fit

Go can show lightweight cards such as:

- "Campus affiliate card drop";
- "Turn this listing into a product card";
- "Quest deck challenge nearby";
- "Creator drop from this event";
- "Find an opt-in duel/team through Les Match";
- "Certified merchant/product card".

Go launches the opportunity. Les Affiliate Oyun owns deck/game state.

