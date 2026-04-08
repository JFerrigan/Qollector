# VinylCollector Architecture

## App Shape
- SwiftUI app using SwiftData for local persistence.
- Root `NavigationStack` wraps a paged `TabView` used purely as a swipe shell.
- Record detail and edit flows are presented from the shared root so all pages can open them consistently.

## Domain Objects
- `RecordItem`: local record entity, including display metadata, rating, notes, tags, and icon recipe fields.
- `Tag`: reusable tag entity keyed by normalized name.
- `AppSettings`: singleton-style local settings entity holding rating mode and seed flags.
- `RecordIconRecipe`: codable value type stored on the record entity as token/raw-value fields.

## Services
- `AppBootstrap`: ensures settings exist and optionally seeds a starter library.
- `RecordEditor`: maps form drafts to stored entities and reuses existing tags.
- `RecordIconRecipeFactory`: deterministically creates an icon recipe from title + artist.
- `CatalogProvider`: protocol placeholder for future remote lookup integration.

## Future Online Boundary
- Remote search should depend on `CatalogProvider`, not directly on views.
- The initial implementation ships with a no-op provider and local search only.
- No custom backend is required for the foundation phase.

