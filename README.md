# OneShelf

OneShelf is an Android-first, offline local media library built with Flutter. It is designed for people who already organize their videos on phone storage or SD cards and want a fast poster wall, local metadata reading, and reliable playback without depending on cloud services.

## What it does

- Adds local storage and SD card folders as media sources through Android SAF
- Scans local folders and builds a local media index with deterministic media IDs
- Reads local `.nfo`, `poster.jpg`, `fanart.jpg`, and video file metadata
- Shows a phone-friendly poster wall with a compact recent watching row
- Supports basic filename search and library sorting
- Opens a detail page with artwork, metadata, resume entry points, and local rating
- Plays videos with the built-in player or hands them off to an external player
- Stores playback progress, recent activity, and local ratings in an offline database
- Reuses unchanged media folders during rescans to avoid reparsing everything

## Product scope

OneShelf is intentionally focused:

- Android first
- offline first
- local metadata only
- privacy friendly
- phone browsing first, landscape playback first

It does **not** aim to be a full media-center replacement, scraper, or server-backed library.

## Current MVP feature set

### Library and scanning

- Add, remove, rescan, and reauthorize media sources
- Full scan and manual rescan flows
- Incremental rescan reuse for unchanged media folders
- Missing file detection after rescans
- Poster and fanart loading with local cache files

### Metadata and browsing

- `.nfo` parsing for title, plot, code, and actors
- Poster wall home screen
- Compact recent watching strip
- Basic filename search
- Sort by recently added, title, or last played

### Detail page

- Poster and fanart presentation
- Local metadata fallback when files are incomplete
- Local 0-10 rating
- Resume playback entry
- External player handoff

### Player

- Built-in playback with `video_player`
- Auto-play when the player opens
- Resume from saved position
- Double-tap left/right seek
- Double-tap center play/pause
- Long-press right side speed boost
- Horizontal swipe for variable seek
- Playback progress persistence

### Settings

- Media source management entry
- Rescan all and full rebuild actions
- Cache clearing
- Playback preference controls
- Gesture timing and speed defaults
- Recent watching toggle

## Tech stack

- **Framework:** Flutter
- **State management:** Riverpod
- **Database:** Drift / SQLite
- **Android storage access:** `docman` over SAF
- **Player:** `video_player`
- **Metadata parsing:** XML-based local NFO parser

## Project structure

```text
lib/src/
  app/          App shell, routing, theme, route pages
  core/         Route names and shared navigation constants
  data/         Drift database, repositories, scanning, SAF access
  domain/       Entities and repository contracts
  features/     Library, detail, player, search, settings, sources
  shared/       Debug logging, media resolving, shared widgets
test/           Widget and media resolver tests
docs/           PRD, MVP, data model, navigation, design references
```

## Getting started

### Requirements

- Flutter SDK compatible with Dart `^3.11.1`
- Android device or emulator
- Android 11+ is the primary target

### Run locally

```bash
flutter pub get
flutter run
```

### Run checks

```bash
flutter analyze
flutter test
```

### Regenerate Drift files

Run this after changing the database schema:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Notes for development

- The library is rebuilt from local files only. There is no online scraping.
- Release builds hide the profile logging tools used during device debugging.
- The current incremental scan reduces reparsing work, but directory enumeration is still limited by Android SAF and SD card I/O.

## Documentation

Key design and product docs live in `docs/`:

- `docs/PRD.md`
- `docs/MVP.md`
- `docs/DATA_MODEL.md`
- `docs/TECH_DECISIONS.md`
- `docs/NAVIGATION.md`
- `docs/ui_codex.pen`

## Status

This repository currently contains the MVP baseline merged into `main`, including:

- stable source scanning
- improved poster loading and caching
- async technical metadata loading
- compact recent watching UI
- swipe-enhanced player controls
