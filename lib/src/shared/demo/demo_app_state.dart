import 'package:collection/collection.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/entities/media_entry.dart';
import '../../domain/entities/media_source.dart';
import '../../domain/entities/scan_report.dart';
import 'demo_media_entries.dart';

final AppSettings demoSettings = const AppSettings(
  preferExternalPlayer: false,
  seekBackwardSeconds: 10,
  seekForwardSeconds: 10,
  holdSpeed: 2.0,
  rememberPlaybackSpeed: true,
  keepResumeHistory: true,
);

final ScanReport demoScanReport = const ScanReport(
  sourcesScanned: 2,
  itemsFound: 428,
  itemsUpdated: 14,
  itemsMissing: 3,
);

final List<MediaSource> demoMediaSources = <MediaSource>[
  MediaSource(
    id: 'sorted-local',
    displayName: 'Sorted',
    rootUri: Uri.parse('/storage/emulated/0/Sorted'),
    rootRelativeKey: 'sorted',
    sourceType: MediaSourceType.localStorage,
    permissionStatus: MediaSourcePermissionStatus.granted,
    lastScanStatus: MediaSourceScanStatus.completed,
    createdAt: DateTime(2025, 1, 12),
    updatedAt: DateTime.now(),
    mediaCount: 312,
  ),
  MediaSource(
    id: 'sd-archive',
    displayName: 'Archive SD',
    rootUri: Uri.parse('/storage/3A0F-1021/Archive'),
    rootRelativeKey: 'archive',
    sourceType: MediaSourceType.sdCard,
    permissionStatus: MediaSourcePermissionStatus.lost,
    lastScanStatus: MediaSourceScanStatus.failed,
    createdAt: DateTime(2025, 2, 2),
    updatedAt: DateTime.now(),
    mediaCount: 116,
    lastError: 'Permission needs reauthorization.',
  ),
];

MediaEntry? demoEntryById(String mediaId) {
  return demoMediaEntries.firstWhereOrNull((entry) => entry.item.id == mediaId);
}
