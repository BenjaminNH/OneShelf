enum MediaSourceType { localStorage, sdCard }

enum MediaSourcePermissionStatus { granted, lost }

enum MediaSourceScanStatus { idle, scanning, completed, failed }

class MediaSource {
  const MediaSource({
    required this.id,
    required this.displayName,
    required this.rootUri,
    required this.rootRelativeKey,
    required this.sourceType,
    required this.permissionStatus,
    required this.lastScanStatus,
    required this.createdAt,
    required this.updatedAt,
    this.isEnabled = true,
    this.mediaCount = 0,
    this.lastScanStartedAt,
    this.lastScanFinishedAt,
    this.lastError,
  });

  final String id;
  final String displayName;
  final Uri rootUri;
  final String rootRelativeKey;
  final MediaSourceType sourceType;
  final MediaSourcePermissionStatus permissionStatus;
  final MediaSourceScanStatus lastScanStatus;
  final bool isEnabled;
  final int mediaCount;
  final DateTime? lastScanStartedAt;
  final DateTime? lastScanFinishedAt;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;
}
