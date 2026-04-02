import 'package:docman/docman.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/media_source.dart' as domain;
import '../database/app_database.dart';
import '../database/database_mappers.dart';
import '../document_tree/document_tree_access.dart';
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
  }) : _database = database,
       _documentTreeAccess = documentTreeAccess,
       _nfoParser = nfoParser;

  final AppDatabase _database;
  final DocumentTreeAccess _documentTreeAccess;
  final NfoParser _nfoParser;

  Future<ScanSourceResult> scanSource(MediaSourcesTableData source) async {
    final now = DateTime.now();
    final scanSessionId = '${source.id}-${now.microsecondsSinceEpoch}';

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
        return _failScan(
          sourceId: source.id,
          scanSessionId: scanSessionId,
          now: now,
          message: 'Media source is not accessible',
        );
      }

      final files = await _collectFiles(root);
      final filesByDir = <String, List<_FoundFile>>{};
      for (final file in files) {
        filesByDir.putIfAbsent(file.parentRelativePath, () => <_FoundFile>[]);
        filesByDir[file.parentRelativePath]!.add(file);
      }

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

      final videosByFolder = <String, List<_FoundFile>>{};
      for (final video in candidateVideos) {
        videosByFolder.putIfAbsent(
          video.parentRelativePath,
          () => <_FoundFile>[],
        );
        videosByFolder[video.parentRelativePath]!.add(video);
      }

      final scannedMediaIds = <String>{};
      final existingRows = await (_database.select(
        _database.mediaItemsTable,
      )..where((tbl) => tbl.sourceId.equals(source.id))).get();
      final existingById = {for (final row in existingRows) row.id: row};

      var foundCount = 0;
      var updatedCount = 0;

      for (final entry in videosByFolder.entries) {
        final folderPath = entry.key;
        final folderVideos = entry.value;
        final primary = _selectPrimaryVideo(folderVideos);
        final siblingFiles = filesByDir[folderPath] ?? const <_FoundFile>[];
        final posterFile = _findByName(siblingFiles, 'poster.jpg');
        final fanartFile = _findByName(siblingFiles, 'fanart.jpg');
        final nfoFile = _findNfo(siblingFiles);

        ParsedNfo parsedNfo = const ParsedNfo();
        if (nfoFile != null) {
          final nfoText = await _documentTreeAccess.readText(nfoFile.document);
          if (nfoText != null) {
            parsedNfo = _nfoParser.parse(nfoText);
          }
        }

        final mediaId = buildMediaId(
          sourceId: source.id,
          folderRelativePath: folderPath.isEmpty ? null : folderPath,
          primaryVideoRelativePath: primary.relativePath,
        );
        scannedMediaIds.add(mediaId);

        final existing = existingById[mediaId];
        foundCount += 1;
        if (existing != null) {
          updatedCount += 1;
        }

        final displayLabel = _buildDisplayLabel(
          folderPath: folderPath,
          fileName: primary.name,
          nfoTitle: parsedNfo.title,
        );

        await _database
            .into(_database.mediaItemsTable)
            .insertOnConflictUpdate(
              MediaItemsTableCompanion(
                id: Value(mediaId),
                sourceId: Value(source.id),
                title: Value(parsedNfo.title),
                displayLabel: Value(displayLabel),
                actorNamesJson: Value(encodeActorNames(parsedNfo.actors)),
                code: Value(parsedNfo.code),
                plot: Value(parsedNfo.plot),
                posterRelativePath: Value(posterFile?.relativePath),
                fanartRelativePath: Value(fanartFile?.relativePath),
                folderRelativePath: Value(
                  folderPath.isEmpty ? null : folderPath,
                ),
                primaryVideoRelativePath: Value(primary.relativePath),
                nfoRelativePath: Value(nfoFile?.relativePath),
                fileName: Value(primary.name),
                fileSizeBytes: Value(primary.size),
                durationMs: const Value(null),
                width: const Value(null),
                height: const Value(null),
                isPlayable: const Value(true),
                isMissing: const Value(false),
                firstSeenAt: Value(existing?.firstSeenAt ?? now),
                lastSeenAt: Value(now),
                createdAt: Value(existing?.createdAt ?? now),
                updatedAt: Value(now),
              ),
            );
      }

      final missingCount = await _markMissing(
        sourceId: source.id,
        now: now,
        activeIds: scannedMediaIds,
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

      return ScanSourceResult(
        itemsFound: foundCount,
        itemsUpdated: updatedCount,
        itemsMissing: missingCount,
      );
    } catch (error) {
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

  Future<List<_FoundFile>> _collectFiles(DocumentFile root) async {
    final found = <_FoundFile>[];

    Future<void> walk(DocumentFile directory, String relativeDirPath) async {
      final children = await _documentTreeAccess.listChildren(directory);
      for (final child in children) {
        final childRelativePath = normalizePath(
          relativeDirPath.isEmpty
              ? child.name
              : '$relativeDirPath/${child.name}',
        );
        if (child.isDirectory) {
          await walk(child, childRelativePath);
          continue;
        }
        if (child.isFile) {
          found.add(
            _FoundFile(
              document: child,
              name: child.name,
              uri: child.uri,
              relativePath: childRelativePath,
              parentRelativePath: normalizePath(relativeDirPath),
              size: child.size,
              lastModified: child.lastModified,
            ),
          );
        }
      }
    }

    await walk(root, '');
    return found;
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
