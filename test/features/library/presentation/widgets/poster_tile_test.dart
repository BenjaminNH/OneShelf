import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_shelf/src/domain/entities/app_settings.dart';
import 'package:one_shelf/src/domain/entities/media_entry.dart';
import 'package:one_shelf/src/domain/entities/media_item.dart';
import 'package:one_shelf/src/features/library/presentation/widgets/poster_tile.dart';
import 'package:one_shelf/src/features/settings/application/settings_providers.dart';

void main() {
  testWidgets('poster tile shows parsed title as the only label', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWith(
            (ref) => Stream.value(const AppSettings()),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PosterTile(
              entry: _entry(title: 'Movie Title', fileName: 'Movie Name.mp4'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Movie Title'), findsOneWidget);
    expect(find.text('Movie Name.mp4'), findsNothing);
  });

  testWidgets('poster tile falls back to the file stem without extension', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWith(
            (ref) => Stream.value(const AppSettings()),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PosterTile(
              entry: _entry(title: '', fileName: 'ABP-123.mp4'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('ABP-123'), findsOneWidget);
    expect(find.text('ABP-123.mp4'), findsNothing);
  });
}

MediaEntry _entry({required String title, required String fileName}) {
  final now = DateTime(2026, 4, 2);
  return MediaEntry(
    item: MediaItem(
      id: 'media-1',
      sourceId: 'source-1',
      title: title,
      displayLabel: title,
      fileName: fileName,
      firstSeenAt: now,
      lastSeenAt: now,
      createdAt: now,
      updatedAt: now,
    ),
    userState: null,
  );
}
