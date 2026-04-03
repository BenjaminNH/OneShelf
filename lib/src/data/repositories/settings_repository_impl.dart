import 'package:docman/docman.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../database/app_database.dart';
import '../database/database_mappers.dart';
import '../../shared/debug/app_debug_logger.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._database, this._debugLogger);

  final AppDatabase _database;
  final AppDebugLogger _debugLogger;

  @override
  Stream<AppSettings> watchSettings() {
    final query = _database.select(_database.appSettingsTable)
      ..where((tbl) => tbl.id.equals(1));
    return query.watchSingleOrNull().map((row) {
      return row?.toDomain() ?? const AppSettings();
    });
  }

  @override
  Future<AppSettings> load() async {
    final query = _database.select(_database.appSettingsTable)
      ..where((tbl) => tbl.id.equals(1));
    final row = await query.getSingleOrNull();
    return row?.toDomain() ?? const AppSettings();
  }

  @override
  Future<void> save(AppSettings settings) async {
    final now = DateTime.now();
    await _database
        .into(_database.appSettingsTable)
        .insertOnConflictUpdate(
          AppSettingsTableCompanion(
            id: const Value(1),
            preferExternalPlayer: Value(settings.preferExternalPlayer),
            seekBackwardSeconds: Value(settings.seekBackwardSeconds),
            seekForwardSeconds: Value(settings.seekForwardSeconds),
            holdSpeed: Value(settings.holdSpeed),
            rememberPlaybackSpeed: Value(settings.rememberPlaybackSpeed),
            keepResumeHistory: Value(settings.keepResumeHistory),
            showRecentActivity: Value(settings.showRecentActivity),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Future<void> clearImageCache() async {
    await DocMan.dir.clearCache();
  }

  @override
  Future<String?> debugLogPath() async {
    final file = await _debugLogger.getLogFile();
    return file?.path;
  }

  @override
  Future<bool> shareDebugLog() async {
    final file = await _debugLogger.getLogFile();
    if (file == null || !file.existsSync()) {
      await _debugLogger.log(scope: 'session', event: 'share_log_unavailable');
      return false;
    }
    final document = await DocumentFile.fromUri(file.path);
    if (document == null || !document.exists || !document.isFile) {
      await _debugLogger.log(
        scope: 'session',
        event: 'share_log_unavailable',
        fields: <String, Object?>{'path': file.path},
      );
      return false;
    }
    final shared = await document.share(title: 'Share OneShelf profile log');
    await _debugLogger.log(
      scope: 'session',
      event: 'share_log',
      fields: <String, Object?>{'path': file.path, 'shared': shared},
    );
    return shared;
  }

  @override
  Future<void> clearDebugLog() {
    return _debugLogger.clear();
  }
}
