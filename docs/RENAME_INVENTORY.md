# Rename Inventory

This inventory prepares the future snake_case rename. Do not rename directories
until the references below are updated in the same controlled change.

## Target Renames

| Current | Future |
| --- | --- |
| `Les_poke/` | `les_poke/` |
| `Les_Commerce/` | `les_commerce/` |
| `LesTupid_Lan/` | `lestupid_lan/` |

## Known Reference Groups

- Root docs and manifests: `README.md`, `lestupid.app.json`,
  `les_certification/certification-registry.json`.
- Les Match docs, manifest, tests and API constants reference `Les_poke` and
  `Les_Commerce`.
- Les Certification specs reference all three legacy directory names.
- Les Commerce and Les Poke manifests contain their own current `directory`
  values.
- LesTupid_Lan specs contain absolute links to the old external-style
  `LesTupid_Lan` path.

## Pre-Rename Checklist

- Update registry and every `lestupid.app.json` directory/manifest path.
- Update all docs and tests that assert source app names or paths.
- Decide whether public `source_app` labels such as `Les_poke` stay as product
  labels or change to `les_poke`; paths and product labels can differ.
- Run `rg -n "Les_poke|Les_Commerce|LesTupid_Lan"` and verify only historical
  notes remain.
- Run JSON parse, registry validation, Les Go typecheck/build, and relevant
  Phoenix tests.

## Current Decision

Rename is planned but not executed in the Go demo loop phase. This avoids
breaking path-sensitive Phoenix, npm and manifest references while the demo
loop is being hardened.
