# Tap-To-Filter Commerce Spec

## Goal

Every commerce surface should let the user turn visible product/listing text
into a filter with one tap or click.

If a value appears anywhere meaningful, it can become a filter:

- title;
- description;
- product card;
- material list;
- master/service card;
- listing detail;
- tag/chip;
- place line;
- variant row;
- receipt/order memory;
- Item Otel custody record.

Example: if `42` appears as a shoe size in a title, variant, description or
asset record, tapping it applies `size=42`. If `Nike`, `Air Max`, `Kadikoy`,
`rental`, `wool`, `4.5 mm needle`, `winter tire` or `wedding dress` appears,
tapping it should open or apply the matching facet.

## Product Rule

Search is text. Tap-to-filter is structure.

The UI should not make the user open a heavy filter form first. The visible
commerce page should reveal small clickable facet signals, and the filter panel
should explain what was applied.

## Shared Facet Signal

```json
{
  "schema_version": "lescommerce.facet_signal.v1",
  "facet_id": "shoe-size-42",
  "key": "size",
  "value": "42",
  "label": "42",
  "source": "title",
  "scope": "current_surface",
  "confidence": "explicit",
  "product_ids": ["prod_123"]
}
```

## Core Facet Keys

- `brand`
- `model`
- `category`
- `size`
- `color`
- `material`
- `condition`
- `price_range`
- `place`
- `seller`
- `service_type`
- `listing_type`
- `availability`
- `delivery_method`
- `care_type`
- `rental_period`
- `certification`
- `creator`
- `video`
- `master`

Apps can add domain keys, but they should map them to this shared language
when possible.

## Surface Behavior

### Product And Listing Text

- Detect explicit known values first: catalog attributes, variants, tags,
  seller metadata and place metadata.
- Detect safe text hints second: title and description tokens such as brand,
  model, size, color, location, material and listing type.
- Show the value as a small clickable chip or underline, not as a disruptive
  modal.
- On click, apply the filter in the current surface and show an active filter
  bar.
- Re-clicking the same value removes it.

### Filter Panel

The panel opens when a facet signal is clicked or when the user taps filter.

It should show:

- active filters;
- related values from the current result set;
- clear all;
- broaden search;
- save search/alert later.

### Scope

- `current_surface`: filter only the current page/list/section.
- `merchant_store`: filter the current merchant/storefront.
- `marketplace`: filter a marketplace search.
- `nearby`: filter local check-in results.
- `ecosystem`: only for explicit global search, never the default.

## App Placement

| App | Behavior |
| --- | --- |
| DIY Marketplace | Video page values become filters: material, tool size, master, ready product, creator, skill level. |
| Marketplace | Listing text values become filters: brand, model, place, size, condition, price, service type. |
| Quick Commerce | Storefront catalog values become filters: brand, category, variant, stock, delivery, campaign. |
| Item Otel | Asset records become filters: item type, size, season, care type, rental/sale status, location. |
| Les Go | Opportunity cards can launch a commerce search with pre-applied filters. |
| Les Contacts | Private product memories can suggest filters, but do not auto-publish private history. |

## Safety And Trust Rules

- Do not infer sensitive traits as commerce filters.
- Do not expose private user ownership, purchase or location history as public
  filter values.
- Do not create adult/illegal service filters.
- Paid placement and sponsored filters must be labeled.
- A filter derived from AI extraction should be labeled `ai_suggested` until
  confirmed.
- Merchant-provided structured attributes outrank free text extraction.

## URL Contract

Use stable query params where possible:

```text
?f.brand=Nike&f.model=Air%20Max&f.size=42&scope=marketplace
```

For local state-only pages, keep the same internal shape so it can later become
a URL or API query.

## API Contract

Future search APIs should accept:

```json
{
  "query": "running shoes",
  "scope": "marketplace",
  "facets": {
    "brand": ["Nike"],
    "model": ["Air Max"],
    "size": ["42"],
    "place": ["Kadikoy"]
  }
}
```

and return:

```json
{
  "items": [],
  "active_facets": {
    "brand": ["Nike"],
    "size": ["42"]
  },
  "suggested_facets": [
    {
      "key": "condition",
      "value": "used",
      "count": 12
    }
  ]
}
```

## UI Principle

Commerce should feel tactile and direct. If the user sees a meaningful value,
they can touch it and the market reshapes around it.

