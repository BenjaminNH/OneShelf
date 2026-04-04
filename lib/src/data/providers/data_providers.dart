import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/library_repository.dart';
import '../../domain/repositories/media_sources_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../database/app_database.dart';
import '../document_tree/docman_document_tree_access.dart';
import '../document_tree/document_tree_access.dart';
import '../repositories/library_repository_impl.dart';
import '../repositories/media_sources_repository_impl.dart';
import '../repositories/settings_repository_impl.dart';
import '../scanning/media_scanner.dart';
import '../scanning/nfo_parser.dart';
import '../../shared/debug/app_debug_logger.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final documentTreeAccessProvider = Provider<DocumentTreeAccess>((ref) {
  return DocmanDocumentTreeAccess();
});

final nfoParserProvider = Provider<NfoParser>((ref) {
  return NfoParser();
});

final mediaScannerProvider = Provider<MediaScanner>((ref) {
  return MediaScanner(
    database: ref.watch(appDatabaseProvider),
    documentTreeAccess: ref.watch(documentTreeAccessProvider),
    nfoParser: ref.watch(nfoParserProvider),
    debugLogger: ref.watch(appDebugLoggerProvider),
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    ref.watch(appDatabaseProvider),
    ref.watch(appDebugLoggerProvider),
  );
});

final mediaSourcesRepositoryProvider = Provider<MediaSourcesRepository>((ref) {
  return MediaSourcesRepositoryImpl(
    database: ref.watch(appDatabaseProvider),
    documentTreeAccess: ref.watch(documentTreeAccessProvider),
    mediaScanner: ref.watch(mediaScannerProvider),
  );
});

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return LibraryRepositoryImpl(
    database: ref.watch(appDatabaseProvider),
    mediaScanner: ref.watch(mediaScannerProvider),
    debugLogger: ref.watch(appDebugLoggerProvider),
  );
});
