import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/database/app_database.dart';
import '../../shared/debug/app_debug_logger.dart';
import '../../shared/media/video_frame_extractor.dart';

class AutoPosterService {
  const AutoPosterService({
    required AppDatabase database,
    required VideoFrameExtractor frameExtractor,
    required AppDebugLogger debugLogger,
  }) : _database = database,
       _frameExtractor = frameExtractor,
       _debugLogger = debugLogger;

  final AppDatabase _database;
  final VideoFrameExtractor _frameExtractor;
  final AppDebugLogger _debugLogger;

  Future<bool> generateAutoPosterIfNeeded({
    required String mediaId,
    required String? posterUri,
    required String? primaryVideoUri,
    required bool hasAutoPoster,
    int? durationMs,
  }) async {
    if (posterUri != null && posterUri.trim().isNotEmpty) {
      return false;
    }

    if (primaryVideoUri == null || primaryVideoUri.trim().isEmpty) {
      return false;
    }

    final stopwatch = Stopwatch()..start();

    try {
      final frameBytes = await _frameExtractor.extractFrame(
        primaryVideoUri,
        positionMs: _calculateExtractPosition(durationMs),
      );

      if (frameBytes == null || frameBytes.isEmpty) {
        await _debugLogger.log(
          scope: 'auto_poster',
          event: 'extract_failed',
          fields: <String, Object?>{
            'mediaId': mediaId,
            'elapsedMs': stopwatch.elapsedMilliseconds,
          },
        );
        return false;
      }

      final cacheFile = await _saveAutoPosterCache(mediaId, frameBytes);
      if (cacheFile == null) {
        return false;
      }

      await (_database.update(
        _database.mediaItemsTable,
      )..where((tbl) => tbl.id.equals(mediaId))).write(
        MediaItemsTableCompanion(
          hasAutoPoster: const Value(true),
          autoPosterTimeMs: Value(durationMs != null ? durationMs ~/ 10 : null),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await _debugLogger.log(
        scope: 'auto_poster',
        event: 'generated',
        fields: <String, Object?>{
          'mediaId': mediaId,
          'elapsedMs': stopwatch.elapsedMilliseconds,
          'bytes': frameBytes.length,
        },
      );
      return true;
    } catch (error) {
      await _debugLogger.log(
        scope: 'auto_poster',
        event: 'exception',
        fields: <String, Object?>{
          'mediaId': mediaId,
          'elapsedMs': stopwatch.elapsedMilliseconds,
          'error': error.toString(),
        },
      );
      return false;
    }
  }

  int? _calculateExtractPosition(int? durationMs) {
    if (durationMs == null || durationMs <= 0) {
      return null;
    }
    return (durationMs * 0.1).toInt();
  }

  Future<File?> _saveAutoPosterCache(String mediaId, List<int> bytes) async {
    try {
      final cacheDir = await getApplicationCacheDirectory();
      final autoPosterDir = Directory(
        '${cacheDir.path}${Platform.pathSeparator}oneshelf${Platform.pathSeparator}auto_posters',
      );

      if (!autoPosterDir.existsSync()) {
        autoPosterDir.createSync(recursive: true);
      }

      final cacheFile = File(
        '${autoPosterDir.path}${Platform.pathSeparator}$mediaId.jpg',
      );

      await cacheFile.writeAsBytes(bytes, flush: true);
      return cacheFile;
    } catch (error) {
      await _debugLogger.log(
        scope: 'auto_poster',
        event: 'cache_save_failed',
        fields: <String, Object?>{
          'mediaId': mediaId,
          'error': error.toString(),
        },
      );
      return null;
    }
  }

  Future<void> clearAutoPoster(String mediaId) async {
    try {
      final cacheDir = await getApplicationCacheDirectory();
      final cacheFile = File(
        '${cacheDir.path}${Platform.pathSeparator}oneshelf${Platform.pathSeparator}auto_posters${Platform.pathSeparator}$mediaId.jpg',
      );

      if (cacheFile.existsSync()) {
        await cacheFile.delete();
      }
    } catch (_) {}
  }

  Future<File?> getAutoPosterFile(String mediaId) async {
    try {
      final cacheDir = await getApplicationCacheDirectory();
      final cacheFile = File(
        '${cacheDir.path}${Platform.pathSeparator}oneshelf${Platform.pathSeparator}auto_posters${Platform.pathSeparator}$mediaId.jpg',
      );

      if (cacheFile.existsSync() && cacheFile.lengthSync() > 0) {
        return cacheFile;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
