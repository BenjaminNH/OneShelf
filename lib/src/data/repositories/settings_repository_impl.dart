import 'package:docman/docman.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../database/app_database.dart';
import '../database/database_mappers.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._database);

  final AppDatabase _database;

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
}
