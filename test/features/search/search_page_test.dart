import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_shelf/src/data/providers/data_providers.dart';
import 'package:one_shelf/src/domain/entities/media_entry.dart';
import 'package:one_shelf/src/domain/entities/media_item.dart';
import 'package:one_shelf/src/domain/entities/scan_report.dart';
import 'package:one_shelf/src/domain/repositories/library_repository.dart';
import 'package:one_shelf/src/features/search/search_page.dart';

void main() {
  testWidgets('search page keeps only a single file-name hint', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          libraryRepositoryProvider.overrideWithValue(_FakeLibraryRepository()),
        ],
        child: const MaterialApp(home: SearchPage()),
      ),
    );

    await tester.pump();

    expect(find.text('File name only'), findsOneWidget);
    expect(find.text('Case-insensitive'), findsNothing);
    expect(find.text('Offline index'), findsNothing);
  });
}

class _FakeLibraryRepository implements LibraryRepository {
  @override
  Future<void> rebuildLibrary() async {}

  @override
  Future<ScanReport> scanAllSources() async => const ScanReport(
    sourcesScanned: 0,
    itemsFound: 0,
    itemsUpdated: 0,
    itemsMissing: 0,
  );

  @override
  Future<ScanReport> scanSource(String sourceId) async => const ScanReport(
    sourcesScanned: 0,
    itemsFound: 0,
    itemsUpdated: 0,
    itemsMissing: 0,
  );

  @override
  Future<void> updatePlayback({
    required String mediaId,
    required int positionMs,
    int? durationMs,
    required bool isFinished,
  }) async {}

  @override
  Future<void> updateRating(String mediaId, double? rating) async {}

  @override
  Stream<MediaEntry?> watchEntry(String mediaId) => const Stream.empty();

  @override
  Stream<List<MediaEntry>> watchLibrary({
    MediaSort sort = MediaSort.recentlyAdded,
  }) => Stream.value(const <MediaEntry>[]);

  @override
  Stream<List<MediaEntry>> watchRecent() => Stream.value(const <MediaEntry>[]);

  @override
  Stream<List<MediaEntry>> watchSearch(String query) =>
      Stream.value(const <MediaEntry>[]);
}
