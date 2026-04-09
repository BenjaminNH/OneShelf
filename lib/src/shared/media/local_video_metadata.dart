import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../debug/app_debug_logger.dart';
import 'native_video_debug_bridge.dart';

class LocalVideoMetadata {
  const LocalVideoMetadata({this.durationMs, this.width, this.height});

  final int? durationMs;
  final int? width;
  final int? height;

  bool get hasAnyValue => durationMs != null || width != null || height != null;

  factory LocalVideoMetadata.fromMap(Map<Object?, Object?> map) {
    return LocalVideoMetadata(
      durationMs: _asInt(map['durationMs']),
      width: _asInt(map['width']),
      height: _asInt(map['height']),
    );
  }

  static int? _asInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }
}

class LocalVideoMetadataRequest {
  const LocalVideoMetadataRequest({required this.mediaId, required this.uri});

  final String mediaId;
  final String uri;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalVideoMetadataRequest &&
          runtimeType == other.runtimeType &&
          mediaId == other.mediaId &&
          uri == other.uri;

  @override
  int get hashCode => Object.hash(mediaId, uri);
}

class LocalVideoMetadataReader {
  const LocalVideoMetadataReader(this._logger);

  static const MethodChannel _channel = MethodChannel(
    'com.oneshelf.one_shelf/local_video_metadata',
  );
  final AppDebugLogger _logger;

  Future<LocalVideoMetadata?> read(String uri) async {
    if (uri.trim().isEmpty) {
      return null;
    }

    final stopwatch = Stopwatch()..start();
    try {
      final result = await _channel.invokeMapMethod<Object?, Object?>(
        'readMetadata',
        <String, Object?>{'uri': uri},
      );
      if (result == null || result.isEmpty) {
        await _logger.log(
          scope: 'detail',
          event: 'video_metadata_read',
          fields: <String, Object?>{
            'status': 'empty',
            'elapsedMs': stopwatch.elapsedMilliseconds,
          },
        );
        return null;
      }
      final metadata = LocalVideoMetadata.fromMap(result);
      await _logger.log(
        scope: 'detail',
        event: 'video_metadata_read',
        fields: <String, Object?>{
          'status': metadata.hasAnyValue ? 'ok' : 'empty',
          'elapsedMs': stopwatch.elapsedMilliseconds,
          'durationMs': metadata.durationMs,
          'width': metadata.width,
          'height': metadata.height,
        },
      );
      return metadata.hasAnyValue ? metadata : null;
    } on PlatformException {
      await _logger.log(
        scope: 'detail',
        event: 'video_metadata_read',
        fields: <String, Object?>{
          'status': 'platform_error',
          'elapsedMs': stopwatch.elapsedMilliseconds,
        },
      );
      return null;
    }
  }
}

final localVideoMetadataReaderProvider = Provider<LocalVideoMetadataReader>((
  ref,
) {
  final logger = ref.watch(appDebugLoggerProvider);
  NativeVideoDebugBridge.ensureInitialized(logger);
  return LocalVideoMetadataReader(logger);
});

final localVideoMetadataProvider =
    FutureProvider.family<LocalVideoMetadata?, LocalVideoMetadataRequest>((
      ref,
      request,
    ) async {
      return ref.read(localVideoMetadataReaderProvider).read(request.uri);
    });
