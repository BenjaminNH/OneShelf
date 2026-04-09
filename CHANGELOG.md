# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2026-04-09

### Added
- More resilient automatic poster generation for local videos, with extra frame extraction fallbacks and a system thumbnail fallback when direct frame capture fails.
- Native video diagnostics in the exported debug log to help troubleshoot device-specific metadata and thumbnail extraction issues.
- A self-hosted GitHub Actions release workflow for building signed Android APKs from a verified tag on a dedicated runner.
- Release helper scripts for runner setup, local toolchain bootstrap, release prerequisite checks, and APK signature verification.

### Changed
- Reduced poster cache contention during scans by limiting concurrent poster materialization work.
- Auto-poster and library watch flows now capture richer timing information to make scan-time performance easier to diagnose.
- Self-hosted release automation now injects signing files, preinstalls required Android components, and resets native build caches before release builds.

### Fixed
- The Settings page now hides the QA-only update feed URL in release builds.
- Self-hosted release checks now detect the workspace root correctly during prerequisite validation.
- Self-hosted tag builds now validate the requested tag more reliably before packaging release APKs.

## [0.3.0] - 2026-04-09

### Added
- Automatic poster generation for videos without bundled artwork by extracting a representative frame and caching it locally.
- In-app update support in Settings, including a local feed override for QA and release validation.
- Manual GitHub Actions release workflow that builds from a verified tag and can create a draft GitHub release automatically.

### Changed
- The `Keep resume history` setting now also controls playback progress bar visibility on poster tiles.
- Release automation now uses Flutter `3.41.4` and Node.js 24 compatible GitHub Actions versions.

### Fixed
- Removed debug snackbar notifications from the library home page for cleaner release builds.
- Shortened settings option copy to fit better on smaller screens.
- Stabilized settings-dependent widget tests to reduce false failures in CI.

## [0.2.0] - 2026-04-05

### Added
- Background metadata prefill service that fetches video metadata (duration, resolution) after library scan completes, improving detail page load time from 650-4122ms to 150-230ms.
- Backup and restore support for local ratings and playback progress.
- Skeleton loading state for detail page, replacing full-screen loading indicator with placeholder content for better perceived performance.
- Indexing progress indicator on home page header (debug builds only) to track metadata prefill progress.
- Profile logging infrastructure for performance analysis with `AppDebugLogger`.
- Adaptive Android launcher icon assets, plus app icon source files for future iOS handoff.

### Changed
- Metadata prefill now uses batch database updates to prevent UI jank and item reordering during indexing.
- Metadata prefill delays 3 seconds after scan completion to let the poster wall stabilize first.
- Technical metadata updates no longer modify `updatedAt` field, preventing unwanted sort order changes.
- Debug logging is now completely disabled in release builds for zero performance overhead.
- Refined the OneShelf launcher icon composition and added Android themed icon support.

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

[Unreleased]: https://github.com/BenjaminNH/OneShelf/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/BenjaminNH/OneShelf/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/BenjaminNH/OneShelf/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/BenjaminNH/OneShelf/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/BenjaminNH/OneShelf/releases/tag/v0.1.0
