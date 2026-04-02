import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_shelf/src/domain/entities/media_entry.dart';
import 'package:one_shelf/src/domain/entities/media_item.dart';
import 'package:one_shelf/src/features/library/presentation/widgets/poster_tile.dart';

void main() {
  testWidgets('poster tile hides duplicate filename subtitle', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PosterTile(
            entry: _entry(title: 'Movie Name', fileName: 'Movie Name.mp4'),
          ),
        ),
      ),
    );

    expect(find.text('Movie Name'), findsOneWidget);
    expect(find.text('Movie Name.mp4'), findsNothing);
  });

  testWidgets('poster tile keeps subtitle when media code exists', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PosterTile(
            entry: _entry(
              title: 'Movie Name',
              fileName: 'ABP-123.mp4',
              code: 'ABP-123',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Movie Name'), findsOneWidget);
    expect(find.text('ABP-123'), findsOneWidget);
  });
}

MediaEntry _entry({
  required String title,
  required String fileName,
  String? code,
}) {
  final now = DateTime(2026, 4, 2);
  return MediaEntry(
    item: MediaItem(
      id: 'media-1',
      sourceId: 'source-1',
      title: title,
      displayLabel: title,
      fileName: fileName,
      code: code,
      firstSeenAt: now,
      lastSeenAt: now,
      createdAt: now,
      updatedAt: now,
    ),
    userState: null,
  );
}
