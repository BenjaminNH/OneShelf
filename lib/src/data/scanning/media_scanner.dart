import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:docman/docman.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/media_source.dart' as domain;
import '../../shared/debug/app_debug_logger.dart';
import '../database/app_database.dart';
import '../database/database_mappers.dart';
import '../document_tree/document_tree_access.dart';
import '../services/auto_poster_service.dart';
import 'nfo_parser.dart';
import 'scan_rules.dart';

class ScanSourceResult {
  const ScanSourceResult({
    required this.itemsFound,
    required this.itemsUpdated,
    required this.itemsMissing,
    this.errorMessage,
  });

  final int itemsFound;
  final int itemsUpdated;
  final int itemsMissing;
  final String? errorMessage;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}

class MediaScanner {
  MediaScanner({
    required AppDatabase database,
    required DocumentTreeAccess documentTreeAccess,
    required NfoParser nfoParser,
    required AppDebugLogger debugLogger,
    AutoPosterService? autoPosterService,
  }) : _database = database,
       _documentTreeAccess = documentTreeAccess,
       _nfoParser = nfoParser,
       _debugLogger = debugLogger,
       _autoPosterService = autoPosterService;

  final AppDatabase _database;
  final DocumentTreeAccess _documentTreeAccess;
  final NfoParser _nfoParser;
  final AppDebugLogger _debugLogger;
  final AutoPosterService? _autoPosterService;

  Future<ScanSourceResult> scanSource(MediaSourcesTableData source) async {
    final now = DateTime.now();
    final scanSessionId = '${source.id}-${now.microsecondsSinceEpoch}';
    final scanStopwatch = Stopwatch()..start();
    var nfoCount = 0;
    var videoFolderCount = 0;
    var reusedFolderCount = 0;
    await _debugLogger.log(
      scope: 'scan',
      event: 'source_started',
      fields: <String, Object?>{
        'sourceId': source.id,
        'displayName': source.displayName,
      },
    );

    await _database
        .into(_database.scanSessionsTable)
        .insert(
          ScanSessionsTableCompanion.insert(
            id: scanSessionId,
            sourceId: source.id,
            scanType: 'manual',
            status: 'running',
            startedAt: now,
          ),
        );

    await (_database.update(
      _database.mediaSourcesTable,
    )..where((tbl) => tbl.id.equals(source.id))).write(
      MediaSourcesTableCompanion(
        permissionStatus: Value(
          permissionStatusToDb(domain.MediaSourcePermissionStatus.granted),
        ),
        lastScanStatus: Value(
          scanStatusToDb(domain.MediaSourceScanStatus.scanning),
        ),
        lastScanStartedAt: Value(now),
        updatedAt: Value(now),
        lastError: const Value(null),
      ),
    );

    try {
      final root = await _documentTreeAccess.resolve(source.rootUri);
      if (root == null || !root.exists || !root.isDirectory) {
        await _debugLogger.log(
          scope: 'scan',
          event: 'source_unavailable',
          fields: <String, Object?>{
            'sourceId': source.id,
            'elapsedMs': scanStopwatch.elapsedMilliseconds,
          },
        );
        return _failScan(
          sourceId: source.id,
          scanSessionId: scanSessionId,
          now: now,
          message: 'Media source is not accessible',
        );
      }

      final existingRows = await (_database.select(
        _database.mediaItemsTable,
      )..where((tbl) => tbl.sourceId.equals(source.id))).get();
      final existingById = {for (final row in existingRows) row.id: row};

      final collectStopwatch = Stopwatch()..start();
      final scanTree = await _scanDirectory(
        directory: root,
        relativeDirPath: '',
        sourceId: source.id,
        now: now,
        existingById: existingById,
      );
      await _debugLogger.log(
        scope: 'scan',
        event: 'collect_files_done',
        fields: <String, Object?>{
          'sourceId': source.id,
          'fileCount': scanTree.filesVisited,
          'directoryCount': scanTree.directoriesVisited,
          'foldersReused': scanTree.reusedFolders,
          'elapsedMs': collectStopwatch.elapsedMilliseconds,
        },
      );
      final scannedMediaIds = scanTree.activeIds;
      final scannedItems = scanTree.items;
      final foundCount = scanTree.foundCount;
      final updatedCount = scanTree.updatedCount;
      nfoCount = scanTree.nfoReadCount;
      videoFolderCount = scanTree.mediaFoldersFound;
      reusedFolderCount = scanTree.reusedFolders;

      late final int missingCount;
      final writeStopwatch = Stopwatch()..start();
      await _database.transaction(() async {
        for (final item in scannedItems) {
          await _database
              .into(_database.mediaItemsTable)
              .insertOnConflictUpdate(item.companion);
        }
        missingCount = await _markMissing(
          sourceId: source.id,
          now: now,
          activeIds: scannedMediaIds,
        );
      });
      await _debugLogger.log(
        scope: 'scan',
        event: 'database_write_done',
        fields: <String, Object?>{
          'sourceId': source.id,
          'itemsWritten': scannedItems.length,
          'itemsMissing': missingCount,
          'elapsedMs': writeStopwatch.elapsedMilliseconds,
        },
      );

      final mediaCount = await _countActiveMedia(source.id);

      await (_database.update(
        _database.mediaSourcesTable,
      )..where((tbl) => tbl.id.equals(source.id))).write(
        MediaSourcesTableCompanion(
          permissionStatus: Value(
            permissionStatusToDb(domain.MediaSourcePermissionStatus.granted),
          ),
          lastScanStatus: Value(
            scanStatusToDb(domain.MediaSourceScanStatus.completed),
          ),
          mediaCount: Value(mediaCount),
          lastScanFinishedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          lastError: const Value(null),
        ),
      );

      await (_database.update(
        _database.scanSessionsTable,
      )..where((tbl) => tbl.id.equals(scanSessionId))).write(
        ScanSessionsTableCompanion(
          status: const Value('completed'),
          finishedAt: Value(DateTime.now()),
          itemsFound: Value(foundCount),
          itemsUpdated: Value(updatedCount),
          itemsMissing: Value(missingCount),
        ),
      );

      await _debugLogger.log(
        scope: 'scan',
        event: 'source_finished',
        fields: <String, Object?>{
          'sourceId': source.id,
          'elapsedMs': scanStopwatch.elapsedMilliseconds,
          'sessionId': scanSessionId,
          'nfoCount': nfoCount,
          'videoFolderCount': videoFolderCount,
          'reusedFolderCount': reusedFolderCount,
          'itemsFound': foundCount,
          'itemsUpdated': updatedCount,
          'itemsMissing': missingCount,
        },
      );

      _generateAutoPostersAsync(scannedItems);

      return ScanSourceResult(
        itemsFound: foundCount,
        itemsUpdated: updatedCount,
        itemsMissing: missingCount,
      );
    } catch (error) {
      await _debugLogger.log(
        scope: 'scan',
        event: 'source_failed',
        fields: <String, Object?>{
          'sourceId': source.id,
          'elapsedMs': scanStopwatch.elapsedMilliseconds,
          'error': error.toString(),
        },
      );
      return _failScan(
        sourceId: source.id,
        scanSessionId: scanSessionId,
        now: now,
        message: error.toString(),
      );
    }
  }

  Future<ScanSourceResult> _failScan({
    required String sourceId,
    required String scanSessionId,
    required DateTime now,
    required String message,
  }) async {
    await (_database.update(
      _database.mediaSourcesTable,
    )..where((tbl) => tbl.id.equals(sourceId))).write(
      MediaSourcesTableCompanion(
        permissionStatus: Value(
          permissionStatusToDb(domain.MediaSourcePermissionStatus.lost),
        ),
        lastScanStatus: Value(
          scanStatusToDb(domain.MediaSourceScanStatus.failed),
        ),
        lastScanFinishedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        lastError: Value(message),
      ),
    );

    await (_database.update(
      _database.scanSessionsTable,
    )..where((tbl) => tbl.id.equals(scanSessionId))).write(
      ScanSessionsTableCompanion(
        status: const Value('failed'),
        finishedAt: Value(DateTime.now()),
        errorMessage: Value(message),
      ),
    );

    return ScanSourceResult(
      itemsFound: 0,
      itemsUpdated: 0,
      itemsMissing: 0,
      errorMessage: message,
    );
  }

  Future<_DirectoryScanResult> _scanDirectory({
    required DocumentFile directory,
    required String relativeDirPath,
    required String sourceId,
    required DateTime now,
    required Map<String, MediaItemsTableData> existingById,
  }) async {
    final normalizedDirPath = normalizePath(relativeDirPath);
    final children = await _documentTreeAccess.listChildren(directory);
    final files = <_FoundFile>[];
    final subdirectories = <(DocumentFile directory, String relativePath)>[];

    for (final child in children) {
      final childRelativePath = normalizePath(
        normalizedDirPath.isEmpty
            ? child.name
            : '$normalizedDirPath/${child.name}',
      );
      if (child.isDirectory) {
        subdirectories.add((child, childRelativePath));
        continue;
      }
      if (!child.isFile) {
        continue;
      }
      files.add(
        _FoundFile(
          document: child,
          name: child.name,
          uri: child.uri,
          relativePath: childRelativePath,
          parentRelativePath: normalizedDirPath,
          size: child.size,
          lastModified: child.lastModified,
        ),
      );
    }

    final items = <_ScannedMediaRecord>[];
    final activeIds = <String>{};
    var foundCount = 0;
    var updatedCount = 0;
    var nfoReadCount = 0;
    var mediaFoldersFound = 0;
    var reusedFolders = 0;

    final candidateVideos = files
        .where((file) {
          if (!isVideoFileName(file.name)) {
            return false;
          }
          return !isExtraVideo(
            relativePath: file.relativePath,
            fileName: file.name,
          );
        })
        .toList(growable: false);

    if (candidateVideos.isNotEmpty) {
      mediaFoldersFound = 1;
      final primary = _selectPrimaryVideo(candidateVideos);
      final posterFile = _findByName(files, 'poster.jpg');
      final fanartFile = _findByName(files, 'fanart.jpg');
      final nfoFile = _findNfo(files);
      final mediaId = buildMediaId(
        sourceId: sourceId,
        folderRelativePath: normalizedDirPath.isEmpty
            ? null
            : normalizedDirPath,
        primaryVideoRelativePath: primary.relativePath,
      );
      final existing = existingById[mediaId];
      final folderFingerprint = _buildFolderFingerprint(
        files: files,
        subdirectories: subdirectories,
      );

      activeIds.add(mediaId);
      foundCount = 1;
      if (existing != null) {
        updatedCount = 1;
      }

      if (_canReuseExisting(existing, folderFingerprint)) {
        reusedFolders = 1;
        items.add(
          _ScannedMediaRecord(
            id: mediaId,
            companion: _reuseExistingCompanion(
              existing: existing!,
              now: now,
              folderFingerprint: folderFingerprint,
            ),
          ),
        );
      } else {
        ParsedNfo parsedNfo = const ParsedNfo();
        if (nfoFile != null) {
          nfoReadCount = 1;
          final nfoText = await _documentTreeAccess.readText(nfoFile.document);
          if (nfoText != null) {
            parsedNfo = _nfoParser.parse(nfoText);
          }
        }

        final displayLabel = _buildDisplayLabel(
          folderPath: normalizedDirPath,
          fileName: primary.name,
          nfoTitle: parsedNfo.title,
        );

        items.add(
          _ScannedMediaRecord(
            id: mediaId,
            companion: MediaItemsTableCompanion(
              id: Value(mediaId),
              sourceId: Value(sourceId),
              title: Value(parsedNfo.title),
              displayLabel: Value(displayLabel),
              actorNamesJson: Value(encodeActorNames(parsedNfo.actors)),
              code: Value(parsedNfo.code),
              plot: Value(parsedNfo.plot),
              posterRelativePath: Value(posterFile?.relativePath),
              posterUri: Value(posterFile?.uri),
              posterLastModified: Value(
                posterFile == null || posterFile.lastModified == 0
                    ? null
                    : posterFile.lastModified,
              ),
              hasAutoPoster: const Value(false),
              autoPosterTimeMs: Value(existing?.autoPosterTimeMs),
              fanartRelativePath: Value(fanartFile?.relativePath),
              fanartUri: Value(fanartFile?.uri),
              fanartLastModified: Value(
                fanartFile == null || fanartFile.lastModified == 0
                    ? null
                    : fanartFile.lastModified,
              ),
              folderRelativePath: Value(
                normalizedDirPath.isEmpty ? null : normalizedDirPath,
              ),
              primaryVideoRelativePath: Value(primary.relativePath),
              primaryVideoUri: Value(primary.uri),
              primaryVideoLastModified: Value(
                primary.lastModified == 0 ? null : primary.lastModified,
              ),
              nfoRelativePath: Value(nfoFile?.relativePath),
              nfoUri: Value(nfoFile?.uri),
              fileName: Value(primary.name),
              fileSizeBytes: Value(primary.size),
              folderFingerprint: Value(folderFingerprint),
              durationMs: Value(existing?.durationMs),
              width: Value(existing?.width),
              height: Value(existing?.height),
              isPlayable: const Value(true),
              isMissing: const Value(false),
              firstSeenAt: Value(existing?.firstSeenAt ?? now),
              lastSeenAt: Value(now),
              createdAt: Value(existing?.createdAt ?? now),
              updatedAt: Value(now),
            ),
          ),
        );
      }
    }

    const batchSize = 6;
    var filesVisited = files.length;
    var directoriesVisited = 1;
    for (var index = 0; index < subdirectories.length; index += batchSize) {
      final batch = subdirectories.skip(index).take(batchSize).toList();
      final nestedResults = await Future.wait(
        batch.map(
          (entry) => _scanDirectory(
            directory: entry.$1,
            relativeDirPath: entry.$2,
            sourceId: sourceId,
            now: now,
            existingById: existingById,
          ),
        ),
      );
      for (final nested in nestedResults) {
        filesVisited += nested.filesVisited;
        directoriesVisited += nested.directoriesVisited;
        foundCount += nested.foundCount;
        updatedCount += nested.updatedCount;
        nfoReadCount += nested.nfoReadCount;
        mediaFoldersFound += nested.mediaFoldersFound;
        reusedFolders += nested.reusedFolders;
        activeIds.addAll(nested.activeIds);
        items.addAll(nested.items);
      }
    }

    return _DirectoryScanResult(
      items: items,
      activeIds: activeIds,
      foundCount: foundCount,
      updatedCount: updatedCount,
      nfoReadCount: nfoReadCount,
      mediaFoldersFound: mediaFoldersFound,
      reusedFolders: reusedFolders,
      filesVisited: filesVisited,
      directoriesVisited: directoriesVisited,
    );
  }

  bool _canReuseExisting(
    MediaItemsTableData? existing,
    String folderFingerprint,
  ) {
    if (existing == null) {
      return false;
    }
    final fingerprint = existing.folderFingerprint?.trim();
    return fingerprint != null &&
        fingerprint.isNotEmpty &&
        fingerprint == folderFingerprint;
  }

  MediaItemsTableCompanion _reuseExistingCompanion({
    required MediaItemsTableData existing,
    required DateTime now,
    required String folderFingerprint,
  }) {
    return MediaItemsTableCompanion(
      id: Value(existing.id),
      sourceId: Value(existing.sourceId),
      title: Value(existing.title),
      displayLabel: Value(existing.displayLabel),
      actorNamesJson: Value(existing.actorNamesJson),
      code: Value(existing.code),
      plot: Value(existing.plot),
      posterRelativePath: Value(existing.posterRelativePath),
      posterUri: Value(existing.posterUri),
      posterLastModified: Value(existing.posterLastModified),
      hasAutoPoster: Value(existing.hasAutoPoster),
      autoPosterTimeMs: Value(existing.autoPosterTimeMs),
      fanartRelativePath: Value(existing.fanartRelativePath),
      fanartUri: Value(existing.fanartUri),
      fanartLastModified: Value(existing.fanartLastModified),
      folderRelativePath: Value(existing.folderRelativePath),
      primaryVideoRelativePath: Value(existing.primaryVideoRelativePath),
      primaryVideoUri: Value(existing.primaryVideoUri),
      primaryVideoLastModified: Value(existing.primaryVideoLastModified),
      nfoRelativePath: Value(existing.nfoRelativePath),
      nfoUri: Value(existing.nfoUri),
      fileName: Value(existing.fileName),
      fileSizeBytes: Value(existing.fileSizeBytes),
      folderFingerprint: Value(folderFingerprint),
      durationMs: Value(existing.durationMs),
      width: Value(existing.width),
      height: Value(existing.height),
      isPlayable: Value(existing.isPlayable),
      isMissing: const Value(false),
      firstSeenAt: Value(existing.firstSeenAt),
      lastSeenAt: Value(now),
      createdAt: Value(existing.createdAt),
      updatedAt: Value(now),
    );
  }

  String _buildFolderFingerprint({
    required List<_FoundFile> files,
    required List<(DocumentFile directory, String relativePath)> subdirectories,
  }) {
    final entries = <String>[
      for (final file in [...files]..sort((a, b) => a.name.compareTo(b.name)))
        'f:${file.name.toLowerCase()}:${file.size}:${file.lastModified}',
      for (final directoryEntry in [
        ...subdirectories,
      ]..sort((a, b) => a.$2.compareTo(b.$2)))
        'd:${directoryEntry.$1.name.toLowerCase()}:${directoryEntry.$1.size}:${directoryEntry.$1.lastModified}',
    ];
    return sha1.convert(utf8.encode(entries.join('|'))).toString();
  }

  _FoundFile _selectPrimaryVideo(List<_FoundFile> candidates) {
    final sorted = List<_FoundFile>.from(candidates)
      ..sort((a, b) {
        final sizeCompare = b.size.compareTo(a.size);
        if (sizeCompare != 0) {
          return sizeCompare;
        }
        final modifiedCompare = b.lastModified.compareTo(a.lastModified);
        if (modifiedCompare != 0) {
          return modifiedCompare;
        }
        return a.name.compareTo(b.name);
      });
    return sorted.first;
  }

  _FoundFile? _findByName(List<_FoundFile> files, String targetName) {
    final normalizedTarget = targetName.toLowerCase();
    for (final file in files) {
      if (file.name.toLowerCase() == normalizedTarget) {
        return file;
      }
    }
    return null;
  }

  _FoundFile? _findNfo(List<_FoundFile> files) {
    for (final file in files) {
      if (file.name.toLowerCase().endsWith('.nfo')) {
        return file;
      }
    }
    return null;
  }

  String _buildDisplayLabel({
    required String folderPath,
    required String fileName,
    required String? nfoTitle,
  }) {
    final parsedTitle = nfoTitle?.trim();
    if (parsedTitle != null && parsedTitle.isNotEmpty) {
      return parsedTitle;
    }
    final normalizedFolder = normalizePath(folderPath);
    if (normalizedFolder.isNotEmpty) {
      final segments = normalizedFolder.split('/');
      return segments.last;
    }
    return fileNameWithoutExtension(fileName);
  }

  Future<int> _markMissing({
    required String sourceId,
    required DateTime now,
    required Set<String> activeIds,
  }) async {
    final query = _database.update(_database.mediaItemsTable)
      ..where((tbl) {
        final sourceMatch = tbl.sourceId.equals(sourceId);
        if (activeIds.isEmpty) {
          return sourceMatch;
        }
        return sourceMatch & tbl.id.isNotIn(activeIds.toList());
      });

    return query.write(
      MediaItemsTableCompanion(
        isMissing: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }

  Future<int> _countActiveMedia(String sourceId) async {
    final countExpression = _database.mediaItemsTable.id.count();
    final query = _database.selectOnly(_database.mediaItemsTable)
      ..addColumns([countExpression])
      ..where(
        _database.mediaItemsTable.sourceId.equals(sourceId) &
            _database.mediaItemsTable.isMissing.equals(false),
      );

    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }

  void _generateAutoPostersAsync(List<_ScannedMediaRecord> items) {
    final autoPosterService = _autoPosterService;
    if (autoPosterService == null) {
      return;
    }

    final candidates = <_ScannedMediaRecord>[];
    for (final item in items) {
      final posterUri = item.companion.posterUri.value;
      final hasPoster = posterUri != null && posterUri.trim().isNotEmpty;

      if (!hasPoster) {
        final primaryVideoUri = item.companion.primaryVideoUri.value;
        if (primaryVideoUri != null && primaryVideoUri.trim().isNotEmpty) {
          candidates.add(item);
        }
      }
    }

    if (candidates.isEmpty) {
      unawaited(
        _debugLogger.log(
          scope: 'auto_poster',
          event: 'queue_skipped',
          fields: const <String, Object?>{'reason': 'no_candidates'},
        ),
      );
      return;
    }

    unawaited(
      _debugLogger.log(
        scope: 'auto_poster',
        event: 'queue_scheduled',
        fields: <String, Object?>{
          'candidateCount': candidates.length,
          'maxConcurrent': 3,
        },
      ),
    );

    _runAutoPosterGenerationWithLimit(
      candidates: candidates,
      autoPosterService: autoPosterService,
      maxConcurrent: 3,
    );
  }

  Future<void> _runAutoPosterGenerationWithLimit({
    required List<_ScannedMediaRecord> candidates,
    required AutoPosterService autoPosterService,
    required int maxConcurrent,
  }) async {
    final stopwatch = Stopwatch()..start();
    final semaphore = _Semaphore(maxConcurrent);
    var generatedCount = 0;
    var failedCount = 0;

    await Future.wait(
      candidates.map((item) async {
        await semaphore.acquire();
        final itemStopwatch = Stopwatch()..start();
        try {
          final generated = await autoPosterService.generateAutoPosterIfNeeded(
            mediaId: item.id,
            posterUri: item.companion.posterUri.value,
            primaryVideoUri: item.companion.primaryVideoUri.value,
            hasAutoPoster: false,
            durationMs: item.companion.durationMs.value,
          );
          if (generated) {
            generatedCount++;
          } else {
            failedCount++;
          }
          await _debugLogger.log(
            scope: 'auto_poster',
            event: 'queue_item_finished',
            fields: <String, Object?>{
              'mediaId': item.id,
              'generated': generated,
              'elapsedMs': itemStopwatch.elapsedMilliseconds,
            },
          );
        } finally {
          semaphore.release();
        }
      }),
    );

    await _debugLogger.log(
      scope: 'auto_poster',
      event: 'queue_completed',
      fields: <String, Object?>{
        'candidateCount': candidates.length,
        'generatedCount': generatedCount,
        'failedCount': failedCount,
        'maxConcurrent': maxConcurrent,
        'elapsedMs': stopwatch.elapsedMilliseconds,
      },
    );
  }
}

class _Semaphore {
  _Semaphore(this._maxCount);

  final int _maxCount;
  int _currentCount = 0;
  final _waitQueue = <Completer<void>>[];

  Future<void> acquire() async {
    if (_currentCount < _maxCount) {
      _currentCount++;
      return;
    }
    final completer = Completer<void>();
    _waitQueue.add(completer);
    await completer.future;
  }

  void release() {
    if (_waitQueue.isNotEmpty) {
      final completer = _waitQueue.removeAt(0);
      completer.complete();
    } else {
      _currentCount--;
    }
  }
}

class _FoundFile {
  const _FoundFile({
    required this.document,
    required this.name,
    required this.uri,
    required this.relativePath,
    required this.parentRelativePath,
    required this.size,
    required this.lastModified,
  });

  final DocumentFile document;
  final String name;
  final String uri;
  final String relativePath;
  final String parentRelativePath;
  final int size;
  final int lastModified;
}

class _ScannedMediaRecord {
  const _ScannedMediaRecord({required this.id, required this.companion});

  final String id;
  final MediaItemsTableCompanion companion;
}

class _DirectoryScanResult {
  const _DirectoryScanResult({
    required this.items,
    required this.activeIds,
    required this.foundCount,
    required this.updatedCount,
    required this.nfoReadCount,
    required this.mediaFoldersFound,
    required this.reusedFolders,
    required this.filesVisited,
    required this.directoriesVisited,
  });

  final List<_ScannedMediaRecord> items;
  final Set<String> activeIds;
  final int foundCount;
  final int updatedCount;
  final int nfoReadCount;
  final int mediaFoldersFound;
  final int reusedFolders;
  final int filesVisited;
  final int directoriesVisited;
}
