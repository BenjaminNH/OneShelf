import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/data_providers.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/repositories/settings_repository.dart';

final appSettingsProvider = StreamProvider<AppSettings>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return repository.watchSettings();
});

final settingsActionsProvider = Provider<SettingsActions>((ref) {
  return SettingsActions(ref);
});

class SettingsActions {
  const SettingsActions(this._ref);

  final Ref _ref;

  SettingsRepository get _repository => _ref.read(settingsRepositoryProvider);

  Future<AppSettings> load() => _repository.load();

  Future<void> save(AppSettings settings) => _repository.save(settings);

  Future<void> update({
    bool? preferExternalPlayer,
    int? seekBackwardSeconds,
    int? seekForwardSeconds,
    double? holdSpeed,
    bool? rememberPlaybackSpeed,
    bool? keepResumeHistory,
  }) async {
    final current = await _repository.load();
    final next = current.copyWith(
      preferExternalPlayer: preferExternalPlayer,
      seekBackwardSeconds: seekBackwardSeconds,
      seekForwardSeconds: seekForwardSeconds,
      holdSpeed: holdSpeed,
      rememberPlaybackSpeed: rememberPlaybackSpeed,
      keepResumeHistory: keepResumeHistory,
    );
    await _repository.save(next);
  }

  Future<void> clearImageCache() => _repository.clearImageCache();
}
