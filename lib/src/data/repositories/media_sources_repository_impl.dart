import 'package:drift/drift.dart';
import 'package:docman/docman.dart';

import '../../domain/entities/media_source.dart' as domain;
import '../../domain/entities/scan_report.dart';
import '../../domain/repositories/media_sources_repository.dart';
import '../database/app_database.dart';
import '../database/database_mappers.dart';
import '../document_tree/document_tree_access.dart';
import '../scanning/media_scanner.dart';
import '../scanning/scan_rules.dart';

class MediaSourcesRepositoryImpl implements MediaSourcesRepository {
  MediaSourcesRepositoryImpl({
    required AppDatabase database,
    required DocumentTreeAccess documentTreeAccess,
    required MediaScanner mediaScanner,
  }) : _database = database,
       _documentTreeAccess = documentTreeAccess,
       _mediaScanner = mediaScanner;

  final AppDatabase _database;
  final DocumentTreeAccess _documentTreeAccess;
  final MediaScanner _mediaScanner;

  @override
  Stream<List<domain.MediaSource>> watchSources() {
    final query = _database.select(_database.mediaSourcesTable)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);
    return query.watch().map(
      (rows) => rows.map((row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<domain.MediaSource?> addSource() async {
    final picked = await _documentTreeAccess.pickDirectory();
    if (picked == null) {
      return null;
    }

    final now = DateTime.now();
    final existing = await (_database.select(
      _database.mediaSourcesTable,
    )..where((tbl) => tbl.rootUri.equals(picked.uri))).getSingleOrNull();

    if (existing != null) {
      await (_database.update(
        _database.mediaSourcesTable,
      )..where((tbl) => tbl.id.equals(existing.id))).write(
        MediaSourcesTableCompanion(
          displayName: Value(_displayNameForRoot(picked)),
          permissionStatus: Value(
            permissionStatusToDb(domain.MediaSourcePermissionStatus.granted),
          ),
          updatedAt: Value(now),
        ),
      );

      final refreshed = await (_database.select(
        _database.mediaSourcesTable,
      )..where((tbl) => tbl.id.equals(existing.id))).getSingle();
      return refreshed.toDomain();
    }

    final sourceId = 'src_${buildSourceRelativeKey(picked.uri)}';
    await _database
        .into(_database.mediaSourcesTable)
        .insert(
          MediaSourcesTableCompanion.insert(
            id: sourceId,
            displayName: _displayNameForRoot(picked),
            rootUri: picked.uri,
            rootRelativeKey: buildSourceRelativeKey(picked.uri),
            sourceType: sourceTypeToDb(sourceTypeFromUri(picked.uri)),
            permissionStatus: permissionStatusToDb(
              domain.MediaSourcePermissionStatus.granted,
            ),
            lastScanStatus: scanStatusToDb(domain.MediaSourceScanStatus.idle),
            createdAt: now,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrReplace,
        );

    final inserted = await (_database.select(
      _database.mediaSourcesTable,
    )..where((tbl) => tbl.id.equals(sourceId))).getSingle();
    return inserted.toDomain();
  }

  @override
  Future<void> removeSource(String sourceId) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.scanSessionsTable,
      )..where((tbl) => tbl.sourceId.equals(sourceId))).go();

      await (_database.delete(
        _database.mediaItemsTable,
      )..where((tbl) => tbl.sourceId.equals(sourceId))).go();

      await (_database.delete(
        _database.mediaSourcesTable,
      )..where((tbl) => tbl.id.equals(sourceId))).go();

      await _database.customStatement(
        'DELETE FROM media_user_states_table WHERE media_id NOT IN (SELECT id FROM media_items_table)',
      );
    });
  }

  @override
  Future<void> reauthorizeSource(String sourceId) async {
    final source = await (_database.select(
      _database.mediaSourcesTable,
    )..where((tbl) => tbl.id.equals(sourceId))).getSingleOrNull();
    if (source == null) {
      return;
    }

    final picked = await _documentTreeAccess.pickDirectory(
      initDir: source.rootUri,
    );
    if (picked == null) {
      return;
    }

    await (_database.update(
      _database.mediaSourcesTable,
    )..where((tbl) => tbl.id.equals(sourceId))).write(
      MediaSourcesTableCompanion(
        rootUri: Value(picked.uri),
        rootRelativeKey: Value(buildSourceRelativeKey(picked.uri)),
        sourceType: Value(sourceTypeToDb(sourceTypeFromUri(picked.uri))),
        permissionStatus: Value(
          permissionStatusToDb(domain.MediaSourcePermissionStatus.granted),
        ),
        displayName: Value(_displayNameForRoot(picked)),
        updatedAt: Value(DateTime.now()),
        lastError: const Value(null),
      ),
    );
  }

  @override
  Future<ScanReport> rescanSource(String sourceId) async {
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

  String _displayNameForRoot(DocumentFile root) {
    final name = root.name.trim();
    if (name.isNotEmpty && name != 'unknown') {
      return name;
    }
    return 'Media Source';
  }
}
