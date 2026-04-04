# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Background metadata prefill service that fetches video metadata (duration, resolution) after library scan completes, improving detail page load time from 650-4122ms to 150-230ms.
- Skeleton loading state for detail page, replacing full-screen loading indicator with placeholder content for better perceived performance.
- Indexing progress indicator on home page header (debug builds only) to track metadata prefill progress.
- Profile logging infrastructure for performance analysis with `AppDebugLogger`.

### Changed
- Metadata prefill now uses batch database updates to prevent UI jank and item reordering during indexing.
- Metadata prefill delays 3 seconds after scan completion to let the poster wall stabilize first.
- Technical metadata updates no longer modify `updatedAt` field, preventing unwanted sort order changes.
- Debug logging is now completely disabled in release builds for zero performance overhead.

### Fixed
- Poster wall no longer flickers or reorders during metadata indexing.
- Detail pages now load consistently fast with pre-filled metadata.
- Media path card in detail page now uses consistent full width with other info cards.

## [0.1.0] - 2026-04-03

### Added
- Initial MVP release of OneShelf for Android, focused on offline local media library usage.
- Media source management via Android SAF, including add, remove, reauthorize, and rescan.
- Local media indexing with deterministic media IDs and missing-file detection.
- Local metadata ingestion from `.nfo`, `poster.jpg`, `fanart.jpg`, and video file attributes.
- Poster wall home, recent watching strip, filename search, and library sorting options.
- Detail page with artwork, metadata fallback, local rating, resume entry, and external player handoff.
- Built-in playback with auto-play, progress persistence, and gesture controls.
- Settings for source management, rescans, cache clearing, playback preferences, and recent-watching visibility.

### Changed
- Improved scan performance by reusing unchanged media folders during rescans.
- Added asynchronous loading for technical media metadata to improve perceived responsiveness.
- Configured release signing for production-style Android distribution.

### Fixed
- Stabilized poster loading in library views.
- Polished player gestures, detail actions, and route callback handling.
- Refined library and search presentation, including header and label consistency.

[Unreleased]: https://github.com/BenjaminNH/OneShelf/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/BenjaminNH/OneShelf/releases/tag/v0.1.0
