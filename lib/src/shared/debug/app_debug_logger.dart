import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:docman/docman.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDebugLogger {
  AppDebugLogger();

  static const String _fileName = 'oneshelf_profile.log';
  static const int _maxBytes = 5 * 1024 * 1024;

  Future<void> _writeQueue = Future<void>.value();
  File? _logFile;
  bool _sessionStarted = false;

  Future<File?> getLogFile() async {
    if (_logFile != null) {
      return _logFile;
    }

    final dataDir =
        await DocMan.dir.data() ??
        await DocMan.dir.files() ??
        await DocMan.dir.cache();
    if (dataDir == null) {
      return null;
    }

    final directory = Directory(
      '${dataDir.path}${Platform.pathSeparator}debug_logs',
    );
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final file = File('${directory.path}${Platform.pathSeparator}$_fileName');
    if (file.existsSync() && file.lengthSync() > _maxBytes) {
      await file.writeAsString('', mode: FileMode.write);
    }
    _logFile = file;
    return file;
  }

  Future<void> clear() async {
    final file = await getLogFile();
    if (file == null) {
      return;
    }
    await file.writeAsString('', mode: FileMode.write);
    _sessionStarted = false;
    await log(scope: 'session', event: 'log_cleared');
  }

  Future<void> log({
    required String scope,
    required String event,
    Map<String, Object?> fields = const <String, Object?>{},
  }) async {
    final line = _buildLine(scope: scope, event: event, fields: fields);
    developer.log(line, name: 'OneShelfProfile');

    _writeQueue = _writeQueue.then((_) async {
      final file = await getLogFile();
      if (file == null) {
        return;
      }
      if (!_sessionStarted) {
        _sessionStarted = true;
        final sessionLine = _buildLine(
          scope: 'session',
          event: 'started',
          fields: <String, Object?>{
            'pid': pid,
            'platform': Platform.operatingSystem,
            'timeZone': DateTime.now().timeZoneName,
          },
        );
        await file.writeAsString('$sessionLine\n', mode: FileMode.append);
      }
      await file.writeAsString('$line\n', mode: FileMode.append);
    });

    await _writeQueue;
  }

  Future<T> measure<T>({
    required String scope,
    required String event,
    Map<String, Object?> fields = const <String, Object?>{},
    required Future<T> Function() action,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await action();
      await log(
        scope: scope,
        event: event,
        fields: <String, Object?>{
          ...fields,
          'elapsedMs': stopwatch.elapsedMilliseconds,
          'status': 'ok',
        },
      );
      return result;
    } catch (error) {
      await log(
        scope: scope,
        event: event,
        fields: <String, Object?>{
          ...fields,
          'elapsedMs': stopwatch.elapsedMilliseconds,
          'status': 'error',
          'error': error.toString(),
        },
      );
      rethrow;
    }
  }

  String _buildLine({
    required String scope,
    required String event,
    required Map<String, Object?> fields,
  }) {
    final encodedFields = fields.isEmpty ? '{}' : jsonEncode(fields);
    return '${DateTime.now().toIso8601String()} [$scope] $event $encodedFields';
  }
}

final appDebugLoggerProvider = Provider<AppDebugLogger>((ref) {
  return AppDebugLogger();
});
