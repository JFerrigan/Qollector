# Qollector Architecture

## App Shape
- SwiftUI app using SwiftData for local persistence.
- Root `NavigationStack` wraps a paged `TabView` used purely as a swipe shell.
- Record detail and edit flows are presented from the shared root so all pages can open them consistently.

## Domain Objects
- `RecordItem`: local record entity, including display metadata, rating, notes, tags, and icon recipe fields.
- `Tag`: reusable tag entity keyed by normalized name.
- `AppSettings`: singleton-style local settings entity holding rating mode, font preset, background preset, and seed flags.
- `RecordIconRecipe`: codable value type stored on the record entity as token/raw-value fields.

## Future Domain Expansion
- Keep the current implementation vinyl-specific, but avoid hard-coding UI assumptions that would block a future collectible mode switch.
- Future versions may introduce a higher-level collection type such as `vinyl`, `books`, or other collectible categories.
- Shared behaviors should remain reusable across modes: library browsing, search, tags, notes, ratings, and themed icon generation.
- Mode-specific metadata should be layered on top later rather than forcing v1 to generalize prematurely.

## Theme Preferences
- Add a font preset enum with 5 supported app-wide options.
- Add a background preset enum with 5 pastel options.
- Theme resolution should read from `AppSettings` so visual preferences propagate through shared theme helpers instead of ad hoc view state.

## Services
- `AppBootstrap`: ensures settings exist and optionally seeds a starter library.
- `RecordEditor`: maps form drafts to stored entities and reuses existing tags.
- `RecordIconRecipeFactory`: deterministically creates an icon recipe from title + artist.
- `ThemeResolver`: maps stored font/background presets to concrete SwiftUI theme values.
- `CatalogProvider`: protocol placeholder for future remote lookup integration.

## Future Online Boundary
- Remote search should depend on `CatalogProvider`, not directly on views.
- The initial implementation ships with a no-op provider and local search only.
- No custom backend is required for the foundation phase.
