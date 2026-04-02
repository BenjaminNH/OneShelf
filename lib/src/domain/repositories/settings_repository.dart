import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  Stream<AppSettings> watchSettings();

  Future<AppSettings> load();

  Future<void> save(AppSettings settings);

  Future<void> clearImageCache();
}
