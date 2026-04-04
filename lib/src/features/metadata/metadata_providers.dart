import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/data_providers.dart';
import '../../shared/debug/app_debug_logger.dart';
import '../../shared/media/local_video_metadata.dart';
import 'metadata_prefill_service.dart';

final metadataPrefillServiceProvider = Provider<MetadataPrefillService>((ref) {
  final statusNotifier = ref.watch(metadataPrefillStatusProvider.notifier);
  return MetadataPrefillService(
    database: ref.watch(appDatabaseProvider),
    metadataReader: ref.watch(localVideoMetadataReaderProvider),
    logger: ref.watch(appDebugLoggerProvider),
    onProgress: (processed, total) {
      statusNotifier.progress(processed, total);
    },
  );
});

final metadataPrefillStatusProvider =
    NotifierProvider<MetadataPrefillStatusNotifier, MetadataPrefillStatus>(
      MetadataPrefillStatusNotifier.new,
    );

class MetadataPrefillStatus {
  const MetadataPrefillStatus({
    this.isRunning = false,
    this.isPending = false,
    this.totalItems = 0,
    this.processedItems = 0,
    this.updatedItems = 0,
    this.lastError,
  });

  final bool isRunning;
  final bool isPending;
  final int totalItems;
  final int processedItems;
  final int updatedItems;
  final String? lastError;

  MetadataPrefillStatus copyWith({
    bool? isRunning,
    bool? isPending,
    int? totalItems,
    int? processedItems,
    int? updatedItems,
    String? lastError,
  }) {
    return MetadataPrefillStatus(
      isRunning: isRunning ?? this.isRunning,
      isPending: isPending ?? this.isPending,
      totalItems: totalItems ?? this.totalItems,
      processedItems: processedItems ?? this.processedItems,
      updatedItems: updatedItems ?? this.updatedItems,
      lastError: lastError,
    );
  }
}

class MetadataPrefillStatusNotifier extends Notifier<MetadataPrefillStatus> {
  @override
  MetadataPrefillStatus build() => const MetadataPrefillStatus();

  void pending(int totalItems) {
    state = MetadataPrefillStatus(isPending: true, totalItems: totalItems);
  }

  void start(int totalItems) {
    state = MetadataPrefillStatus(isRunning: true, totalItems: totalItems);
  }

  void progress(int processed, int updated) {
    state = state.copyWith(processedItems: processed, updatedItems: updated);
  }

  void complete(int updatedItems) {
    state = MetadataPrefillStatus(
      isRunning: false,
      totalItems: state.totalItems,
      processedItems: state.processedItems,
      updatedItems: updatedItems,
    );
  }

  void error(String message) {
    state = state.copyWith(
      isRunning: false,
      isPending: false,
      lastError: message,
    );
  }
}

final shouldShowPrefillIndicatorProvider = Provider<bool>((ref) {
  if (kReleaseMode) {
    return false;
  }
  return ref.watch(metadataPrefillStatusProvider).isRunning;
});
