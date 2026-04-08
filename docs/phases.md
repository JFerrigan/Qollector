# VinylCollector Implementation Phases

## Phase 1: Foundation Shell
- Establish docs, theme tokens, root pager, settings model, and sample data bootstrap.
- Replace the template screen with the real app shell and polished page surfaces.
- Define the 5 background presets and 5 font presets in the theme layer.

## Phase 2: Local Collection Flow
- Add manual record creation, library browsing, detail view, edit/delete, and local persistence.
- Implement rating control, tags, notes, and deterministic icon generation.

## Phase 3: Search And Organization
- Add local search, tag rendering, and stronger empty states.
- Refine card layouts and collection browsing affordances.

## Phase 4: Polish
- Tighten motion, accessibility labels, tests, and edge cases.
- Add richer icon customization and better first-run copy if needed.
- Add settings-driven font and background switching with whole-app application.

## Phase 5: Online Catalog
- Implement a real `CatalogProvider` backed by a public music database API.
- Add remote search or metadata lookup without changing the existing local model flow.
