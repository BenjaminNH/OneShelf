import 'dart:convert';

import '../../domain/entities/app_settings.dart' as domain;
import '../../domain/entities/media_entry.dart';
import '../../domain/entities/media_item.dart' as domain;
import '../../domain/entities/media_source.dart' as domain;
import '../../domain/entities/media_user_state.dart' as domain;
import 'app_database.dart';

extension MediaSourceRowMapper on MediaSourcesTableData {
  domain.MediaSource toDomain() {
    return domain.MediaSource(
      id: id,
      displayName: displayName,
      rootUri: Uri.parse(rootUri),
      rootRelativeKey: rootRelativeKey,
      sourceType: _parseSourceType(sourceType),
      permissionStatus: _parsePermissionStatus(permissionStatus),
      lastScanStatus: _parseScanStatus(lastScanStatus),
      isEnabled: isEnabled,
      mediaCount: mediaCount,
      lastScanStartedAt: lastScanStartedAt,
      lastScanFinishedAt: lastScanFinishedAt,
      lastError: lastError,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension MediaItemRowMapper on MediaItemsTableData {
  domain.MediaItem toDomain() {
    return domain.MediaItem(
      id: id,
      sourceId: sourceId,
      title: title,
      displayLabel: displayLabel,
      actorNames: _decodeActorNames(actorNamesJson),
      code: code,
      plot: plot,
      posterRelativePath: posterRelativePath,
      posterUri: posterUri,
      posterLastModified: posterLastModified,
      fanartRelativePath: fanartRelativePath,
      fanartUri: fanartUri,
      fanartLastModified: fanartLastModified,
      folderRelativePath: folderRelativePath,
      primaryVideoRelativePath: primaryVideoRelativePath,
      primaryVideoUri: primaryVideoUri,
      primaryVideoLastModified: primaryVideoLastModified,
      nfoRelativePath: nfoRelativePath,
      nfoUri: nfoUri,
      fileName: fileName,
      fileSizeBytes: fileSizeBytes,
      durationMs: durationMs,
      width: width,
      height: height,
      isPlayable: isPlayable,
      isMissing: isMissing,
      firstSeenAt: firstSeenAt,
      lastSeenAt: lastSeenAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension MediaUserStateRowMapper on MediaUserStatesTableData {
  domain.MediaUserState toDomain() {
    return domain.MediaUserState(
      mediaId: mediaId,
      ratingValue: ratingValue,
      lastPositionMs: lastPositionMs,
      durationMsSnapshot: durationMsSnapshot,
      lastPlayedAt: lastPlayedAt,
      playCount: playCount,
      isFinished: isFinished,
    );
  }
}

extension AppSettingsRowMapper on AppSettingsTableData {
  domain.AppSettings toDomain() {
    return domain.AppSettings(
      preferExternalPlayer: preferExternalPlayer,
      seekBackwardSeconds: seekBackwardSeconds,
      seekForwardSeconds: seekForwardSeconds,
      holdSpeed: holdSpeed,
      rememberPlaybackSpeed: rememberPlaybackSpeed,
      keepResumeHistory: keepResumeHistory,
      showRecentActivity: showRecentActivity,
    );
  }
}

MediaEntry toMediaEntry(
  MediaItemsTableData item,
  MediaUserStatesTableData? userState,
) {
  return MediaEntry(item: item.toDomain(), userState: userState?.toDomain());
}

List<String> _decodeActorNames(String encoded) {
  if (encoded.isEmpty) {
    return const <String>[];
  }
  try {
    final dynamic raw = jsonDecode(encoded);
    if (raw is! List) {
      return const <String>[];
    }
    return raw.whereType<String>().toList(growable: false);
  } catch (_) {
    return const <String>[];
  }
}

String encodeActorNames(List<String> actorNames) {
  return jsonEncode(actorNames);
}

domain.MediaSourceType sourceTypeFromUri(String uri) {
  final upper = uri.toUpperCase();
  final isSd = RegExp(r'[0-9A-F]{4}-[0-9A-F]{4}').hasMatch(upper);
  return isSd
      ? domain.MediaSourceType.sdCard
      : domain.MediaSourceType.localStorage;
}

String sourceTypeToDb(domain.MediaSourceType value) {
  return switch (value) {
    domain.MediaSourceType.localStorage => 'local_storage',
    domain.MediaSourceType.sdCard => 'sd_card',
  };
}

String permissionStatusToDb(domain.MediaSourcePermissionStatus value) {
  return switch (value) {
    domain.MediaSourcePermissionStatus.granted => 'granted',
    domain.MediaSourcePermissionStatus.lost => 'lost',
  };
}

String scanStatusToDb(domain.MediaSourceScanStatus value) {
  return switch (value) {
    domain.MediaSourceScanStatus.idle => 'idle',
    domain.MediaSourceScanStatus.scanning => 'scanning',
    domain.MediaSourceScanStatus.completed => 'completed',
    domain.MediaSourceScanStatus.failed => 'failed',
  };
}

domain.MediaSourceType _parseSourceType(String value) {
  return switch (value) {
    'sd_card' => domain.MediaSourceType.sdCard,
    _ => domain.MediaSourceType.localStorage,
  };
}

domain.MediaSourcePermissionStatus _parsePermissionStatus(String value) {
  return switch (value) {
    'lost' => domain.MediaSourcePermissionStatus.lost,
    _ => domain.MediaSourcePermissionStatus.granted,
  };
}

domain.MediaSourceScanStatus _parseScanStatus(String value) {
  return switch (value) {
    'scanning' => domain.MediaSourceScanStatus.scanning,
    'completed' => domain.MediaSourceScanStatus.completed,
    'failed' => domain.MediaSourceScanStatus.failed,
    _ => domain.MediaSourceScanStatus.idle,
  };
}
