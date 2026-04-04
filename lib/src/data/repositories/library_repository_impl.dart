import 'dart:async';

import 'package:drift/drift.dart';

import '../../domain/entities/media_entry.dart';
import '../../domain/entities/media_item.dart';
import '../../domain/entities/scan_report.dart';
import '../../domain/repositories/library_repository.dart';
import '../database/app_database.dart';
import '../database/database_mappers.dart';
import '../scanning/media_scanner.dart';
import '../../shared/debug/app_debug_logger.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  LibraryRepositoryImpl({
    required AppDatabase database,
    required MediaScanner mediaScanner,
    AppDebugLogger? debugLogger,
  }) : _database = database,
       _mediaScanner = mediaScanner,
       _debugLogger = debugLogger;

  final AppDatabase _database;
  final MediaScanner _mediaScanner;
  final AppDebugLogger? _debugLogger;

  @override
  Stream<List<MediaEntry>> watchLibrary({
    MediaSort sort = MediaSort.recentlyAdded,
  }) {
    final query = _libraryJoin(sort: sort);
    return query.watch().map(_mapJoinRows);
  }

  @override
  Stream<List<MediaEntry>> watchRecent() {
    final query = _libraryJoin(
      sort: MediaSort.lastPlayed,
      limit: 12,
      onlyRecent: true,
    );
    return query.watch().map(_mapJoinRows);
  }

  @override
  Stream<List<MediaEntry>> watchSearch(String queryText) {
    final trimmed = queryText.trim();
    if (trimmed.isEmpty) {
      return watchLibrary();
    }

    final escaped = '%${trimmed.toLowerCase()}%';
    final query = _libraryJoin(
      sort: MediaSort.recentlyAdded,
      titleQueryLike: escaped,
    );
    return query.watch().map(_mapJoinRows);
  }

  @override
  Stream<MediaEntry?> watchEntry(String mediaId) {
    final stopwatch = Stopwatch()..start();
    final query =
        _database.select(_database.mediaItemsTable).join([
            leftOuterJoin(
              _database.mediaUserStatesTable,
              _database.mediaUserStatesTable.mediaId.equalsExp(
                _database.mediaItemsTable.id,
              ),
            ),
          ])
          ..where(_database.mediaItemsTable.id.equals(mediaId))
          ..limit(1);

    return query.watchSingleOrNull().map((row) {
      final elapsedMs = stopwatch.elapsedMilliseconds;
      stopwatch.reset();
      stopwatch.start();
      unawaited(
        _debugLogger?.log(
          scope: 'detail',
          event: 'db_query_entry',
          fields: <String, Object?>{
            'mediaId': mediaId,
            'found': row != null,
            'elapsedMs': elapsedMs,
          },
        ),
      );
      if (row == null) {
        return null;
      }
      final item = row.readTable(_database.mediaItemsTable);
      final userState = row.readTableOrNull(_database.mediaUserStatesTable);
      return toMediaEntry(item, userState);
    });
  }

  @override
  Future<void> updateRating(String mediaId, double? rating) async {
    final now = DateTime.now();
    final existing = await (_database.select(
      _database.mediaUserStatesTable,
    )..where((tbl) => tbl.mediaId.equals(mediaId))).getSingleOrNull();

    await _database
        .into(_database.mediaUserStatesTable)
        .insertOnConflictUpdate(
          MediaUserStatesTableCompanion(
            mediaId: Value(mediaId),
            ratingValue: Value(rating),
            lastPositionMs: Value(existing?.lastPositionMs),
            durationMsSnapshot: Value(existing?.durationMsSnapshot),
            lastPlayedAt: Value(existing?.lastPlayedAt),
            playCount: Value(existing?.playCount ?? 0),
            isFinished: Value(existing?.isFinished ?? false),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Future<void> updatePlayback({
    required String mediaId,
    required int positionMs,
    int? durationMs,
    required bool isFinished,
  }) async {
    final now = DateTime.now();
    final existing = await (_database.select(
      _database.mediaUserStatesTable,
    )..where((tbl) => tbl.mediaId.equals(mediaId))).getSingleOrNull();

    await _database
        .into(_database.mediaUserStatesTable)
        .insertOnConflictUpdate(
          MediaUserStatesTableCompanion(
            mediaId: Value(mediaId),
            ratingValue: Value(existing?.ratingValue),
            lastPositionMs: Value(positionMs),
            durationMsSnapshot: Value(
              durationMs ?? existing?.durationMsSnapshot,
            ),
            lastPlayedAt: Value(now),
            playCount: Value((existing?.playCount ?? 0) + 1),
            isFinished: Value(isFinished),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Future<void> updateTechnicalMetadata({
    required String mediaId,
    int? durationMs,
    int? width,
    int? height,
  }) async {
    final existing = await (_database.select(
      _database.mediaItemsTable,
    )..where((tbl) => tbl.id.equals(mediaId))).getSingleOrNull();

    await (_database.update(
      _database.mediaItemsTable,
    )..where((tbl) => tbl.id.equals(mediaId))).write(
      MediaItemsTableCompanion(
        durationMs: Value(durationMs ?? existing?.durationMs),
        width: Value(width ?? existing?.width),
        height: Value(height ?? existing?.height),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<ScanReport> scanAllSources() async {
    final sources = await (_database.select(
      _database.mediaSourcesTable,
    )..where((tbl) => tbl.isEnabled.equals(true))).get();

    var scannedSources = 0;
    var totalFound = 0;
    var totalUpdated = 0;
    var totalMissing = 0;
    String? firstError;

    for (final source in sources) {
      final result = await _mediaScanner.scanSource(source);
      scannedSources += 1;
      totalFound += result.itemsFound;
      totalUpdated += result.itemsUpdated;
      totalMissing += result.itemsMissing;
      firstError ??= result.errorMessage;
    }

    return ScanReport(
      sourcesScanned: scannedSources,
      itemsFound: totalFound,
      itemsUpdated: totalUpdated,
      itemsMissing: totalMissing,
      errorMessage: firstError,
    );
  }

  @override
  Future<ScanReport> scanSource(String sourceId) async {
    final source = await (_database.select(
      _database.mediaSourcesTable,
    )..where((tbl) => tbl.id.equals(sourceId))).getSingleOrNull();
    if (source == null) {
      return const ScanReport(
        sourcesScanned: 0,
        itemsFound: 0,
        itemsUpdated: 0,
        itemsMissing: 0,
        errorMessage: 'Media source not found',
      );
    }

    final result = await _mediaScanner.scanSource(source);
    return ScanReport(
      sourcesScanned: 1,
      itemsFound: result.itemsFound,
      itemsUpdated: result.itemsUpdated,
      itemsMissing: result.itemsMissing,
      errorMessage: result.errorMessage,
    );
  }

  @override
  Future<void> rebuildLibrary() async {
    await _database.transaction(() async {
      await _database.delete(_database.mediaItemsTable).go();
    });
    await scanAllSources();
  }

  JoinedSelectStatement<HasResultSet, dynamic> _libraryJoin({
    required MediaSort sort,
    int? limit,
    bool onlyRecent = false,
    String? titleQueryLike,
  }) {
    final query =
        _database.select(_database.mediaItemsTable).join([
          leftOuterJoin(
            _database.mediaUserStatesTable,
            _database.mediaUserStatesTable.mediaId.equalsExp(
              _database.mediaItemsTable.id,
            ),
          ),
        ])..where(
          _database.mediaItemsTable.isMissing.equals(false) &
              _database.mediaItemsTable.isPlayable.equals(true),
        );

    if (titleQueryLike != null) {
      query.where(
        _database.mediaItemsTable.fileName.lower().like(titleQueryLike),
      );
    }

    if (onlyRecent) {
      query.where(_database.mediaUserStatesTable.lastPlayedAt.isNotNull());
    }

    switch (sort) {
      case MediaSort.recentlyAdded:
        query.orderBy([
          OrderingTerm.desc(_database.mediaItemsTable.firstSeenAt),
          OrderingTerm.desc(_database.mediaItemsTable.updatedAt),
        ]);
      case MediaSort.title:
        query.orderBy([
          OrderingTerm.asc(_database.mediaItemsTable.displayLabel),
          OrderingTerm.asc(_database.mediaItemsTable.fileName),
        ]);
      case MediaSort.lastPlayed:
        query.orderBy([
          OrderingTerm.desc(_database.mediaUserStatesTable.lastPlayedAt),
          OrderingTerm.desc(_database.mediaItemsTable.updatedAt),
        ]);
    }

    if (limit != null) {
      query.limit(limit);
    }
    return query;
  }

  List<MediaEntry> _mapJoinRows(List<TypedResult> rows) {
    return rows
        .map((row) {
          final item = row.readTable(_database.mediaItemsTable);
          final userState = row.readTableOrNull(_database.mediaUserStatesTable);
          return toMediaEntry(item, userState);
        })
        .toList(growable: false);
  }
}
