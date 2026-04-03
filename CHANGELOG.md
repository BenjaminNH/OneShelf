# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
