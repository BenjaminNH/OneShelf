OneShelf app icon asset pack

Generated from `tooling/generate_app_icons.py`.

Files
- `oneshelf-app-icon-draft.svg`: editable vector master for future icon refinements.
- `ios/oneshelf-ios-appicon-1024.png`: primary iOS app icon source.
- `ios/oneshelf-ios-tinted-template-1024.png`: monochrome template for iOS tinted mode.
- `android/oneshelf-play-store-512.png`: Google Play listing icon.
- `android/oneshelf-android-adaptive-preview-1024.png`: full-color preview for adaptive icon composition.
- `android/oneshelf-android-foreground-432.png`: Android adaptive icon foreground layer.
- `android/oneshelf-android-monochrome-432.png`: Android themed icon monochrome layer.

Manual handoff notes
- In Figma, import `oneshelf-app-icon-draft.svg` as the editable master, or use the `1024` PNGs when you only need raster export handoff.
- For Android adaptive icons, use `#131922` as the background color and place the `432` foreground or monochrome layer centered on a `432x432` artboard.
- The current project is Android-only. If an iOS target is added later, start from the `ios/` assets here.

Regenerate
- Export-only asset pack: `python tooling/generate_app_icons.py`
- Also write Android launcher resources into the Flutter project: `python tooling/generate_app_icons.py --write-android`
