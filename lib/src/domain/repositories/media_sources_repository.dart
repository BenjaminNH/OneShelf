import '../entities/media_source.dart';
import '../entities/scan_report.dart';

abstract interface class MediaSourcesRepository {
  Stream<List<MediaSource>> watchSources();

  Future<MediaSource?> addSource();

  Future<void> removeSource(String sourceId);

  Future<void> reauthorizeSource(String sourceId);

  Future<ScanReport> rescanSource(String sourceId);
}
