import '../entities/media_entry.dart';
import '../entities/media_item.dart';
import '../entities/scan_report.dart';

abstract interface class LibraryRepository {
  Stream<List<MediaEntry>> watchLibrary({
    MediaSort sort = MediaSort.recentlyAdded,
  });

  Stream<List<MediaEntry>> watchRecent();

  Stream<List<MediaEntry>> watchSearch(String query);

  Stream<MediaEntry?> watchEntry(String mediaId);

  Future<void> updateRating(String mediaId, double? rating);

  Future<void> updatePlayback({
    required String mediaId,
    required int positionMs,
    int? durationMs,
    required bool isFinished,
  });

  Future<void> updateTechnicalMetadata({
    required String mediaId,
    int? durationMs,
    int? width,
    int? height,
  });

  Future<ScanReport> scanAllSources();

  Future<ScanReport> scanSource(String sourceId);

  Future<void> rebuildLibrary();
}
