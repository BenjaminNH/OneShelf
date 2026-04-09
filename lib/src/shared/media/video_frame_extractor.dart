import 'package:flutter/services.dart';

import '../debug/app_debug_logger.dart';

class VideoFrameExtractor {
  const VideoFrameExtractor(this._logger);

  static const MethodChannel _channel = MethodChannel(
    'com.oneshelf.one_shelf/local_video_metadata',
  );
  final AppDebugLogger _logger;

  Future<Uint8List?> extractFrame(String uri, {int? positionMs}) async {
    if (uri.trim().isEmpty) {
      return null;
    }

    final stopwatch = Stopwatch()..start();
    try {
      final result = await _channel.invokeMethod<Uint8List>(
        'extractFrame',
        <String, Object?>{'uri': uri, 'positionMs': positionMs ?? 0},
      );

      if (result == null || result.isEmpty) {
        await _logger.log(
          scope: 'video_frame',
          event: 'extract_frame',
          fields: <String, Object?>{
            'status': 'empty_result',
            'elapsedMs': stopwatch.elapsedMilliseconds,
            'positionMs': positionMs ?? 0,
            'uriHash': uri.hashCode,
          },
        );
        return null;
      }

      await _logger.log(
        scope: 'video_frame',
        event: 'extract_frame',
        fields: <String, Object?>{
          'status': 'ok',
          'elapsedMs': stopwatch.elapsedMilliseconds,
          'bytes': result.length,
          'positionMs': positionMs ?? 0,
          'uriHash': uri.hashCode,
        },
      );
      return result;
    } on PlatformException catch (error) {
      await _logger.log(
        scope: 'video_frame',
        event: 'extract_frame',
        fields: <String, Object?>{
          'status': 'platform_error',
          'elapsedMs': stopwatch.elapsedMilliseconds,
          'error': error.message,
          'details': error.details?.toString(),
          'positionMs': positionMs ?? 0,
          'uriHash': uri.hashCode,
        },
      );
      return null;
    } catch (error) {
      await _logger.log(
        scope: 'video_frame',
        event: 'extract_frame',
        fields: <String, Object?>{
          'status': 'exception',
          'elapsedMs': stopwatch.elapsedMilliseconds,
          'error': error.toString(),
          'positionMs': positionMs ?? 0,
          'uriHash': uri.hashCode,
        },
      );
      return null;
    }
  }
}
