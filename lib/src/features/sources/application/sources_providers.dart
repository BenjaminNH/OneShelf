import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/data_providers.dart';
import '../../../domain/entities/media_source.dart';
import '../../../domain/entities/scan_report.dart';
import '../../../domain/repositories/media_sources_repository.dart';
import '../../metadata/metadata_providers.dart';

final mediaSourcesProvider = StreamProvider<List<MediaSource>>((ref) {
  final repository = ref.watch(mediaSourcesRepositoryProvider);
  return repository.watchSources();
});

final sourcesActionsProvider = Provider<SourcesActions>((ref) {
  return SourcesActions(ref);
});

final sourceLastScanReportProvider =
    NotifierProvider<SourceLastScanReportNotifier, ScanReport?>(
      SourceLastScanReportNotifier.new,
    );

class SourcesActions {
  const SourcesActions(this._ref);

  final Ref _ref;

  MediaSourcesRepository get _repository =>
      _ref.read(mediaSourcesRepositoryProvider);

  Future<MediaSource?> addSource() => _repository.addSource();

  Future<void> removeSource(String sourceId) =>
      _repository.removeSource(sourceId);

  Future<void> reauthorizeSource(String sourceId) =>
      _repository.reauthorizeSource(sourceId);

  Future<ScanReport> rescanSource(String sourceId) async {
    final report = await _repository.rescanSource(sourceId);
    _ref.read(sourceLastScanReportProvider.notifier).setReport(report);
    unawaited(_triggerMetadataPrefill());
    return report;
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

class SourceLastScanReportNotifier extends Notifier<ScanReport?> {
  @override
  ScanReport? build() => null;

  void setReport(ScanReport report) {
    state = report;
  }
}
