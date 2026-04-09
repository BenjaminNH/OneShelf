import 'package:flutter/services.dart';

import '../debug/app_debug_logger.dart';

class NativeVideoDebugBridge {
  NativeVideoDebugBridge._();

  static const MethodChannel _channel = MethodChannel(
    'com.oneshelf.one_shelf/native_debug_log',
  );
  static bool _initialized = false;

  static void ensureInitialized(AppDebugLogger logger) {
    if (_initialized) {
      return;
    }
    _initialized = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'log') {
        return;
      }

      final arguments = call.arguments;
      if (arguments is! Map<Object?, Object?>) {
        return;
      }

      final scopeValue = arguments['scope'];
      final eventValue = arguments['event'];
      final fieldsValue = arguments['fields'];
      final scope = scopeValue is String && scopeValue.trim().isNotEmpty
          ? scopeValue.trim()
          : 'native_video';
      final event = eventValue is String && eventValue.trim().isNotEmpty
          ? eventValue.trim()
          : 'native_event';
      final fields = <String, Object?>{};

      if (fieldsValue is Map<Object?, Object?>) {
        for (final entry in fieldsValue.entries) {
          final key = entry.key;
          if (key is String && key.isNotEmpty) {
            fields[key] = entry.value;
          }
        }
      }

      await logger.log(scope: scope, event: event, fields: fields);
    });
  }
}
