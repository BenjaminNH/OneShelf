import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/data_providers.dart';
import '../../../domain/services/backup_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupServiceImpl(database: ref.watch(appDatabaseProvider));
});

final backupActionsProvider = Provider<BackupActions>((ref) {
  return BackupActions(ref);
});

class BackupActions {
  const BackupActions(this._ref);

  final Ref _ref;

  BackupService get _service => _ref.read(backupServiceProvider);

  Future<BackupResult> export() => _service.exportBackup();

  Future<RestoreResult> import(String filePath) =>
      _service.importBackup(filePath);

  Future<String?> pickBackupFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: false,
    );
    return result?.files.single.path;
  }
}
