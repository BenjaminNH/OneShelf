import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/data_providers.dart';
import '../../../domain/entities/media_entry.dart';
import '../../../domain/entities/media_item.dart';
import '../../../domain/entities/scan_report.dart';
import '../../../domain/repositories/library_repository.dart';

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

  Future<ScanReport> scanAllSources() {
    return _repository.scanAllSources();
  }

  Future<ScanReport> scanSource(String sourceId) {
    return _repository.scanSource(sourceId);
  }

  Future<void> rebuildLibrary() {
    return _repository.rebuildLibrary();
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
