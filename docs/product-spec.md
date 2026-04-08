# VinylCollector Product Spec

## Product Summary
VinylCollector is an iPhone-first record collection app with a calm pastel visual style and a collectible feel. The first release is offline-first and designed around a personal library experience: users browse owned records, add entries manually, search locally, tag records, rate them, write notes, and personalize the record icon using preset visual patterns.

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
- Tags are reusable and user-defined.
- Each record gets an automatically generated icon recipe based on a deterministic hash of record title + artist, ignoring case.
- Users can override the auto-generated icon recipe by selecting preset colors and patterns.

## Stretch / Deferred
- Remote catalog lookup through a public music database API.
- Import flows and sync.
- Accounts, cloud backup, and multi-device sync.
- Barcode scanning, cover art lookup, or marketplace integrations.

## Success Criteria For Foundation
- The app feels like a finished shell instead of a template.
- The visual language is centralized in reusable theme primitives.
- Core record CRUD, local search, tags, ratings, and icon generation all work with local persistence.
- The architecture leaves room for a future online catalog provider without reworking the local model layer.

