import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/data_providers.dart';
import '../../../domain/entities/media_entry.dart';
import '../../../domain/entities/media_item.dart';
import '../../../domain/entities/scan_report.dart';
import '../../../domain/repositories/library_repository.dart';
import '../../metadata/metadata_providers.dart';

final librarySortProvider = NotifierProvider<LibrarySortNotifier, MediaSort>(
  LibrarySortNotifier.new,
);

final libraryEntriesProvider = StreamProvider<List<MediaEntry>>((ref) {
  final repository = ref.watch(libraryRepositoryProvider);
  final sort = ref.watch(librarySortProvider);
  return repository.watchLibrary(sort: sort);
});

final recentEntriesProvider = StreamProvider<List<MediaEntry>>((ref) {
  final repository = ref.watch(libraryRepositoryProvider);
  return repository.watchRecent();
});

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

final searchEntriesProvider = StreamProvider<List<MediaEntry>>((ref) {
  final repository = ref.watch(libraryRepositoryProvider);
  final query = ref.watch(searchQueryProvider);
  return repository.watchSearch(query);
});

final mediaEntryProvider = StreamProvider.family<MediaEntry?, String>((
  ref,
  mediaId,
) {
  final repository = ref.watch(libraryRepositoryProvider);
  return repository.watchEntry(mediaId);
});

final libraryActionsProvider = Provider<LibraryActions>((ref) {
  return LibraryActions(ref);
});

class LibraryActions {
  const LibraryActions(this._ref);

  final Ref _ref;

  LibraryRepository get _repository => _ref.read(libraryRepositoryProvider);

  Future<void> updateRating(String mediaId, double? rating) {
    return _repository.updateRating(mediaId, rating);
  }

  Future<void> updatePlayback({
    required String mediaId,
    required int positionMs,
    int? durationMs,
    required bool isFinished,
  }) {
    return _repository.updatePlayback(
      mediaId: mediaId,
      positionMs: positionMs,
      durationMs: durationMs,
      isFinished: isFinished,
    );
  }

  Future<void> updateTechnicalMetadata({
    required String mediaId,
    int? durationMs,
    int? width,
    int? height,
  }) {
    return _repository.updateTechnicalMetadata(
      mediaId: mediaId,
      durationMs: durationMs,
      width: width,
      height: height,
    );
  }

  Future<ScanReport> scanAllSources() async {
    final report = await _repository.scanAllSources();
    unawaited(_triggerMetadataPrefillWithDelay());
    return report;
  }

  Future<ScanReport> scanSource(String sourceId) async {
    final report = await _repository.scanSource(sourceId);
    unawaited(_triggerMetadataPrefillWithDelay());
    return report;
  }

  Future<void> rebuildLibrary() async {
    await _repository.rebuildLibrary();
    unawaited(_triggerMetadataPrefillWithDelay());
  }

  Future<void> _triggerMetadataPrefillWithDelay() async {
    final service = _ref.read(metadataPrefillServiceProvider);

    if (_ref.read(metadataPrefillStatusProvider).isRunning) {
      return;
    }

    final items = await service.getItemsNeedingMetadata();
    if (items.isEmpty) {
      return;
    }

    final statusNotifier = _ref.read(metadataPrefillStatusProvider.notifier);
    statusNotifier.pending(items.length);

    await Future.delayed(service.delayBeforeStart);

    if (_ref.read(metadataPrefillStatusProvider).isRunning) {
      return;
    }

    statusNotifier.start(items.length);
    try {
      final updated = await service.prefillMissingMetadata();
      statusNotifier.complete(updated);
    } catch (e) {
      statusNotifier.error(e.toString());
    }
  }

  Future<void> _triggerMetadataPrefill() async {
    final service = _ref.read(metadataPrefillServiceProvider);
    final statusNotifier = _ref.read(metadataPrefillStatusProvider.notifier);

    if (_ref.read(metadataPrefillStatusProvider).isRunning) {
      return;
    }

    final items = await service.getItemsNeedingMetadata();
    if (items.isEmpty) {
      return;
    }

    statusNotifier.start(items.length);
    try {
      final updated = await service.prefillMissingMetadata();
      statusNotifier.complete(updated);
    } catch (e) {
      statusNotifier.error(e.toString());
    }
  }
}

class LibrarySortNotifier extends Notifier<MediaSort> {
  @override
  MediaSort build() => MediaSort.recentlyAdded;

  void setSort(MediaSort sort) {
    state = sort;
  }
}

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) {
    state = value;
  }
}
