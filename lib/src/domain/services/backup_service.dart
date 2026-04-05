import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/database/app_database.dart';

class MediaItemFingerprint {
  const MediaItemFingerprint({
    required this.mediaId,
    required this.fileName,
    required this.fileSizeBytes,
    required this.durationMs,
    required this.width,
    required this.height,
  });

  final String mediaId;
  final String fileName;
  final int? fileSizeBytes;
  final int? durationMs;
  final int? width;
  final int? height;

  String get fileNameWithoutExt {
    final dot = fileName.lastIndexOf('.');
    return dot > 0 ? fileName.substring(0, dot) : fileName;
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaId': mediaId,
      'fileName': fileName,
      'fileSizeBytes': fileSizeBytes,
      'durationMs': durationMs,
      'width': width,
      'height': height,
    };
  }

  factory MediaItemFingerprint.fromJson(Map<String, dynamic> json) {
    return MediaItemFingerprint(
      mediaId: json['mediaId'] as String,
      fileName: json['fileName'] as String,
      fileSizeBytes: json['fileSizeBytes'] as int?,
      durationMs: json['durationMs'] as int?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }
}

class BackupUserState {
  const BackupUserState({
    required this.mediaId,
    this.ratingValue,
    this.lastPositionMs,
    this.durationMsSnapshot,
    this.lastPlayedAt,
    this.playCount = 0,
    this.isFinished = false,
    required this.updatedAt,
  });

  final String mediaId;
  final double? ratingValue;
  final int? lastPositionMs;
  final int? durationMsSnapshot;
  final DateTime? lastPlayedAt;
  final int playCount;
  final bool isFinished;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'mediaId': mediaId,
      'ratingValue': ratingValue,
      'lastPositionMs': lastPositionMs,
      'durationMsSnapshot': durationMsSnapshot,
      'lastPlayedAt': lastPlayedAt?.toIso8601String(),
      'playCount': playCount,
      'isFinished': isFinished,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory BackupUserState.fromJson(Map<String, dynamic> json) {
    return BackupUserState(
      mediaId: json['mediaId'] as String,
      ratingValue: json['ratingValue'] as double?,
      lastPositionMs: json['lastPositionMs'] as int?,
      durationMsSnapshot: json['durationMsSnapshot'] as int?,
      lastPlayedAt: json['lastPlayedAt'] != null
          ? DateTime.parse(json['lastPlayedAt'] as String)
          : null,
      playCount: json['playCount'] as int,
      isFinished: json['isFinished'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class BackupData {
  const BackupData({
    required this.version,
    required this.exportedAt,
    required this.userStates,
    required this.mediaFingerprints,
  });

  final int version;
  final DateTime exportedAt;
  final List<BackupUserState> userStates;
  final List<MediaItemFingerprint> mediaFingerprints;

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'exportedAt': exportedAt.toIso8601String(),
      'userStates': userStates.map((s) => s.toJson()).toList(),
      'mediaFingerprints': mediaFingerprints.map((f) => f.toJson()).toList(),
    };
  }

  factory BackupData.fromJson(Map<String, dynamic> json) {
    return BackupData(
      version: json['version'] as int,
      exportedAt: DateTime.parse(json['exportedAt'] as String),
      userStates: (json['userStates'] as List)
          .map((s) => BackupUserState.fromJson(s as Map<String, dynamic>))
          .toList(),
      mediaFingerprints:
          (json['mediaFingerprints'] as List?)
              ?.map(
                (f) => MediaItemFingerprint.fromJson(f as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class BackupResult {
  const BackupResult({
    required this.success,
    this.filePath,
    this.error,
    this.recordCount = 0,
  });

  final bool success;
  final String? filePath;
  final String? error;
  final int recordCount;
}

class RestoreResult {
  const RestoreResult({
    required this.success,
    this.exactMatchCount = 0,
    this.fuzzyMatchCount = 0,
    this.skippedCount = 0,
    this.error,
  });

  final bool success;
  final int exactMatchCount;
  final int fuzzyMatchCount;
  final int skippedCount;
  final String? error;

  int get totalImported => exactMatchCount + fuzzyMatchCount;
}

abstract interface class BackupService {
  Future<BackupResult> exportBackup();
  Future<RestoreResult> importBackup(String filePath);
  Future<String?> pickBackupFile();
}

class BackupServiceImpl implements BackupService {
  BackupServiceImpl({required AppDatabase database}) : _database = database;

  final AppDatabase _database;
  static const int _backupVersion = 2;

  @override
  Future<BackupResult> exportBackup() async {
    try {
      final userStates = await _database
          .select(_database.mediaUserStatesTable)
          .get();

      final mediaIds = userStates.map((s) => s.mediaId).toSet();
      final mediaItems = await (_database.select(
        _database.mediaItemsTable,
      )..where((tbl) => tbl.id.isIn(mediaIds.toList()))).get();

      final fingerprints = mediaItems
          .map(
            (item) => MediaItemFingerprint(
              mediaId: item.id,
              fileName: item.fileName,
              fileSizeBytes: item.fileSizeBytes,
              durationMs: item.durationMs,
              width: item.width,
              height: item.height,
            ),
          )
          .toList();

      final backupStates = userStates
          .map(
            (s) => BackupUserState(
              mediaId: s.mediaId,
              ratingValue: s.ratingValue,
              lastPositionMs: s.lastPositionMs,
              durationMsSnapshot: s.durationMsSnapshot,
              lastPlayedAt: s.lastPlayedAt,
              playCount: s.playCount,
              isFinished: s.isFinished,
              updatedAt: s.updatedAt,
            ),
          )
          .toList();

      final backup = BackupData(
        version: _backupVersion,
        exportedAt: DateTime.now(),
        userStates: backupStates,
        mediaFingerprints: fingerprints,
      );

      final json = const JsonEncoder.withIndent('  ').convert(backup.toJson());
      final fileName =
          'oneshelf_backup_${DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first}.json';

      final downloadDir = await _getDownloadDirectory();
      final oneshelfDir = Directory('${downloadDir.path}/OneShelf');
      if (!await oneshelfDir.exists()) {
        await oneshelfDir.create(recursive: true);
      }

      final file = File('${oneshelfDir.path}/$fileName');
      await file.writeAsString(json);

      return BackupResult(
        success: true,
        filePath: file.path,
        recordCount: userStates.length,
      );
    } catch (e) {
      return BackupResult(success: false, error: e.toString());
    }
  }

  @override
  Future<RestoreResult> importBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return const RestoreResult(success: false, error: 'File not found');
      }

      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final backup = BackupData.fromJson(json);

      if (backup.version > _backupVersion) {
        return const RestoreResult(
          success: false,
          error: 'Backup version is newer than supported',
        );
      }

      final currentMediaItems = await _database
          .select(_database.mediaItemsTable)
          .get();

      final currentById = <String, MediaItemsTableData>{};
      final currentByFingerprint = <String, List<MediaItemsTableData>>{};

      for (final item in currentMediaItems) {
        currentById[item.id] = item;
        final key = _buildFingerprintKey(
          fileSizeBytes: item.fileSizeBytes,
          fileName: item.fileName,
          durationMs: item.durationMs,
        );
        currentByFingerprint.putIfAbsent(key, () => []).add(item);
      }

      final fingerprintById = <String, MediaItemFingerprint>{};
      for (final fp in backup.mediaFingerprints) {
        fingerprintById[fp.mediaId] = fp;
      }

      var exactMatchCount = 0;
      var fuzzyMatchCount = 0;
      var skippedCount = 0;

      await _database.batch((batch) {
        for (final state in backup.userStates) {
          String? targetMediaId;

          if (currentById.containsKey(state.mediaId)) {
            targetMediaId = state.mediaId;
            exactMatchCount++;
          } else {
            final fingerprint = fingerprintById[state.mediaId];
            if (fingerprint != null) {
              targetMediaId = _findFuzzyMatch(
                fingerprint: fingerprint,
                currentByFingerprint: currentByFingerprint,
                currentById: currentById,
              );
              if (targetMediaId != null) {
                fuzzyMatchCount++;
              }
            }
          }

          if (targetMediaId != null) {
            batch.insert(
              _database.mediaUserStatesTable,
              MediaUserStatesTableCompanion(
                mediaId: Value(targetMediaId),
                ratingValue: Value(state.ratingValue),
                lastPositionMs: Value(state.lastPositionMs),
                durationMsSnapshot: Value(state.durationMsSnapshot),
                lastPlayedAt: Value(state.lastPlayedAt),
                playCount: Value(state.playCount),
                isFinished: Value(state.isFinished),
                updatedAt: Value(state.updatedAt),
              ),
              mode: InsertMode.insertOrReplace,
            );
          } else {
            skippedCount++;
          }
        }
      });

      return RestoreResult(
        success: true,
        exactMatchCount: exactMatchCount,
        fuzzyMatchCount: fuzzyMatchCount,
        skippedCount: skippedCount,
      );
    } catch (e) {
      return RestoreResult(success: false, error: e.toString());
    }
  }

  String _buildFingerprintKey({
    required int? fileSizeBytes,
    required String fileName,
    required int? durationMs,
  }) {
    final dot = fileName.lastIndexOf('.');
    final nameWithoutExt = dot > 0 ? fileName.substring(0, dot) : fileName;
    final size = fileSizeBytes ?? 0;
    return '${size}_$nameWithoutExt';
  }

  String? _findFuzzyMatch({
    required MediaItemFingerprint fingerprint,
    required Map<String, List<MediaItemsTableData>> currentByFingerprint,
    required Map<String, MediaItemsTableData> currentById,
  }) {
    final key = _buildFingerprintKey(
      fileSizeBytes: fingerprint.fileSizeBytes,
      fileName: fingerprint.fileName,
      durationMs: fingerprint.durationMs,
    );

    final candidates = currentByFingerprint[key];
    if (candidates == null || candidates.isEmpty) {
      return null;
    }

    if (candidates.length == 1) {
      return candidates.first.id;
    }

    String? bestMatch;
    var bestScore = -1;

    for (final candidate in candidates) {
      var score = 0;

      if (candidate.durationMs != null && fingerprint.durationMs != null) {
        final diff = (candidate.durationMs! - fingerprint.durationMs!).abs();
        if (diff < 1000) {
          score += 10;
        } else if (diff < 5000) {
          score += 5;
        }
      }

      if (candidate.width == fingerprint.width &&
          candidate.height == fingerprint.height) {
        score += 5;
      }

      if (score > bestScore) {
        bestScore = score;
        bestMatch = candidate.id;
      }
    }

    return bestMatch ?? candidates.first.id;
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    }
    return await getApplicationDocumentsDirectory();
  }

  @override
  Future<String?> pickBackupFile() async {
    throw UnimplementedError('Use file_picker package in UI layer');
  }
}
