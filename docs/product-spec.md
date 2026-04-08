# Qollector Product Spec

## Product Summary
Qollector is an iPhone-first record collection app with a calm pastel visual style and a collectible feel. The first release is offline-first and designed around a personal library experience: users browse owned records, add entries manually, search locally, tag records, rate them, write notes, and personalize the record icon using preset visual patterns.

## Core Experience
- Launch into the library as the center page of a horizontal pager.
- Swipe left to search local records.
- Swipe right to add a new record.
- Continue swiping right to access settings.
- Tap any record in the library or search results to view its detail page.

## Functional Requirements
- Users can create a record with title, artist, optional release year, optional genre, notes, rating, tags, and a visual icon recipe.
- Records are stored locally and remain available offline.
- Users can edit or delete records from the detail view.
- Search covers title, artist, genre, notes, and tags.
- Rating defaults to 5 stars and can be switched in settings to a 1-10 scale.
- Users can choose an app font from a fixed set of 5 curated type styles.
- Users can choose the app background color theme from a fixed set of 5 pastel options.
- Tags are reusable and user-defined.
- Each record gets an automatically generated icon recipe based on a deterministic hash of record title + artist, ignoring case.
- Users can override the auto-generated icon recipe by selecting preset colors and patterns.

## Stretch / Deferred
- Remote catalog lookup through a public music database API.
- Import flows and sync.
- Accounts, cloud backup, and multi-device sync.
- Barcode scanning, cover art lookup, or marketplace integrations.
- Expand from vinyl-only into selectable collection modes such as books, vinyl, or other collectible categories.
- Allow mode-specific metadata and icon treatments while preserving one shared collection shell.

## Success Criteria For Foundation
- The app feels like a finished shell instead of a template.
- The visual language is centralized in reusable theme primitives.
- Core record CRUD, local search, tags, ratings, and icon generation all work with local persistence.
- Global visual preferences for font and background theme can be changed from settings and applied across the app.
- The architecture leaves room for a future online catalog provider without reworking the local model layer.
