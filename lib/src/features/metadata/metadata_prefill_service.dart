import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../../shared/debug/app_debug_logger.dart';
import '../../shared/media/local_video_metadata.dart';

typedef PrefillProgressCallback = void Function(int processed, int total);

class MetadataPrefillService {
  MetadataPrefillService({
    required AppDatabase database,
    required LocalVideoMetadataReader metadataReader,
    required AppDebugLogger logger,
    this.onProgress,
    this.delayBeforeStart = const Duration(seconds: 3),
  }) : _database = database,
       _metadataReader = metadataReader,
       _logger = logger;

  final AppDatabase _database;
  final LocalVideoMetadataReader _metadataReader;
  final AppDebugLogger _logger;
  final PrefillProgressCallback? onProgress;
  final Duration delayBeforeStart;

  Future<List<MediaItemsTableData>> getItemsNeedingMetadata() async {
    final allItems = await _database.select(_database.mediaItemsTable).get();
    return allItems.where((item) {
      final hasUri =
          item.primaryVideoUri != null && item.primaryVideoUri!.isNotEmpty;
      final needsMetadata =
          item.durationMs == null || item.width == null || item.height == null;
      return hasUri && needsMetadata;
    }).toList();
  }

  Future<int> prefillMissingMetadata() async {
    final items = await getItemsNeedingMetadata();
    if (items.isEmpty) {
      return 0;
    }

    onProgress?.call(0, items.length);

    final metadataResults = <_MetadataResult>[];
    var processedCount = 0;

    for (final item in items) {
      final uri = item.primaryVideoUri;
      if (uri == null || uri.isEmpty) {
        processedCount++;
        onProgress?.call(processedCount, items.length);
        continue;
      }

      try {
        final metadata = await _metadataReader.read(uri);
        if (metadata == null || !metadata.hasAnyValue) {
          processedCount++;
          onProgress?.call(processedCount, items.length);
          continue;
        }

        metadataResults.add(
          _MetadataResult(
            itemId: item.id,
            durationMs: metadata.durationMs ?? item.durationMs,
            width: metadata.width ?? item.width,
            height: metadata.height ?? item.height,
          ),
        );

        await _logger.log(
          scope: 'metadata_prefill',
          event: 'item_updated',
          fields: <String, Object?>{
            'mediaId': item.id,
            'durationMs': metadata.durationMs,
            'width': metadata.width,
            'height': metadata.height,
          },
        );
      } catch (error) {
        await _logger.log(
          scope: 'metadata_prefill',
          event: 'item_failed',
          fields: <String, Object?>{
            'mediaId': item.id,
            'error': error.toString(),
          },
        );
      }

      processedCount++;
      onProgress?.call(processedCount, items.length);
    }

    if (metadataResults.isEmpty) {
      await _logger.log(
        scope: 'metadata_prefill',
        event: 'prefill_completed',
        fields: <String, Object?>{
          'totalItems': items.length,
          'updatedCount': 0,
        },
      );
      return 0;
    }

    final updatedCount = await _applyMetadataBatch(metadataResults);

    await _logger.log(
      scope: 'metadata_prefill',
      event: 'prefill_completed',
      fields: <String, Object?>{
        'totalItems': items.length,
        'updatedCount': updatedCount,
      },
    );

    return updatedCount;
  }

  Future<int> _applyMetadataBatch(List<_MetadataResult> results) async {
    var updatedCount = 0;

    await _database.batch((batch) {
      for (final result in results) {
        batch.update(
          _database.mediaItemsTable,
          MediaItemsTableCompanion(
            durationMs: Value(result.durationMs),
            width: Value(result.width),
            height: Value(result.height),
          ),
          where: (tbl) => tbl.id.equals(result.itemId),
        );
        updatedCount++;
      }
    });

    return updatedCount;
  }
}

class _MetadataResult {
  _MetadataResult({
    required this.itemId,
    required this.durationMs,
    required this.width,
    required this.height,
  });

  final String itemId;
  final int? durationMs;
  final int? width;
  final int? height;
}
