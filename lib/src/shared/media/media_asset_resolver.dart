import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:docman/docman.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/data_providers.dart';
import '../../data/scanning/scan_rules.dart';
import '../debug/app_debug_logger.dart';

class RelativeAssetRequest {
  const RelativeAssetRequest({
    required this.sourceId,
    required this.relativePath,
    this.uri,
  });

  final String sourceId;
  final String relativePath;
  final String? uri;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelativeAssetRequest &&
          runtimeType == other.runtimeType &&
          sourceId == other.sourceId &&
          relativePath == other.relativePath &&
          uri == other.uri;

  @override
  int get hashCode => Object.hash(sourceId, relativePath, uri);
}

enum RelativeImageVariant { posterThumb, posterDetail, fanartPreview }

class RelativeImageRequest {
  const RelativeImageRequest({
    required this.sourceId,
    required this.relativePath,
    required this.variant,
    this.uri,
    this.lastModified,
  });

  final String sourceId;
  final String relativePath;
  final String? uri;
  final int? lastModified;
  final RelativeImageVariant variant;

  RelativeAssetRequest get assetRequest => RelativeAssetRequest(
    sourceId: sourceId,
    relativePath: relativePath,
    uri: uri,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelativeImageRequest &&
          runtimeType == other.runtimeType &&
          sourceId == other.sourceId &&
          relativePath == other.relativePath &&
          uri == other.uri &&
          lastModified == other.lastModified &&
          variant == other.variant;

  @override
  int get hashCode =>
      Object.hash(sourceId, relativePath, uri, lastModified, variant);
}

final relativeDocumentProvider =
    FutureProvider.family<DocumentFile?, RelativeAssetRequest>((
      ref,
      request,
    ) async {
      final logger = ref.read(appDebugLoggerProvider);
      final stopwatch = Stopwatch()..start();
      final access = ref.read(documentTreeAccessProvider);
      final directUri = request.uri?.trim();
      if (directUri != null && directUri.isNotEmpty) {
        final result = await access.resolve(directUri);
        await logger.log(
          scope: 'document',
          event: 'resolve_uri',
          fields: <String, Object?>{
            'sourceId': request.sourceId,
            'elapsedMs': stopwatch.elapsedMilliseconds,
            'resolved': result != null,
            'strategy': 'direct_uri',
          },
        );
        return result;
      }

      final database = ref.read(appDatabaseProvider);
      final source = await (database.select(
        database.mediaSourcesTable,
      )..where((tbl) => tbl.id.equals(request.sourceId))).getSingleOrNull();

      if (source == null) {
        await logger.log(
          scope: 'document',
          event: 'resolve_path',
          fields: <String, Object?>{
            'sourceId': request.sourceId,
            'relativePath': request.relativePath,
            'elapsedMs': stopwatch.elapsedMilliseconds,
            'resolved': false,
            'strategy': 'path_traversal',
            'error': 'source_not_found',
          },
        );
        return null;
      }

      final root = await access.resolve(source.rootUri);
      if (root == null || !root.exists) {
        await logger.log(
          scope: 'document',
          event: 'resolve_path',
          fields: <String, Object?>{
            'sourceId': request.sourceId,
            'relativePath': request.relativePath,
            'elapsedMs': stopwatch.elapsedMilliseconds,
            'resolved': false,
            'strategy': 'path_traversal',
            'error': 'root_not_found',
          },
        );
        return null;
      }

      DocumentFile current = root;
      final segments = normalizePath(request.relativePath)
          .split('/')
          .where((segment) => segment.isNotEmpty)
          .toList(growable: false);

      for (final segment in segments) {
        final next = await access.findChild(current, segment);
        if (next == null) {
          await logger.log(
            scope: 'document',
            event: 'resolve_path',
            fields: <String, Object?>{
              'sourceId': request.sourceId,
              'relativePath': request.relativePath,
              'elapsedMs': stopwatch.elapsedMilliseconds,
              'resolved': false,
              'strategy': 'path_traversal',
              'error': 'segment_not_found',
              'failedSegment': segment,
            },
          );
          return null;
        }
        current = next;
      }

      await logger.log(
        scope: 'document',
        event: 'resolve_path',
        fields: <String, Object?>{
          'sourceId': request.sourceId,
          'relativePath': request.relativePath,
          'elapsedMs': stopwatch.elapsedMilliseconds,
          'resolved': true,
          'strategy': 'path_traversal',
          'segmentCount': segments.length,
        },
      );
      return current;
    });

final relativeImageFileProvider =
    FutureProvider.family<File?, RelativeImageRequest>((ref, request) async {
      final logger = ref.read(appDebugLoggerProvider);
      final stopwatch = Stopwatch()..start();
      try {
        final cacheRoot = await DocMan.dir.cache();
        if (cacheRoot == null) {
          await logger.log(
            scope: 'poster',
            event: 'cache_root_missing',
            fields: <String, Object?>{
              'sourceId': request.sourceId,
              'relativePath': request.relativePath,
              'variant': request.variant.name,
            },
          );
          return null;
        }

        final variant = request.variant;
        final targetDirectory = Directory(
          '${cacheRoot.path}${Platform.pathSeparator}docManMedia'
          '${Platform.pathSeparator}oneshelf'
          '${Platform.pathSeparator}${variant.directoryName}',
        );
        if (!targetDirectory.existsSync()) {
          targetDirectory.createSync(recursive: true);
        }

        final extension = variant.fileExtension(request.relativePath);
        final targetFile = File(
          '${targetDirectory.path}${Platform.pathSeparator}'
          '${buildRelativeImageCacheFileName(request, extension: extension)}',
        );

        if (targetFile.existsSync() && !_isUsableFile(targetFile)) {
          await logger.log(
            scope: 'poster',
            event: 'corrupt_cache_deleted',
            fields: <String, Object?>{
              'sourceId': request.sourceId,
              'relativePath': request.relativePath,
              'variant': variant.name,
              'path': targetFile.path,
            },
          );
          await targetFile.delete();
        }

        final sourceLastModified = request.lastModified ?? 0;
        final hasFreshCache =
            targetFile.existsSync() &&
            targetFile.lengthSync() > 0 &&
            (sourceLastModified == 0 ||
                targetFile.lastModifiedSync().millisecondsSinceEpoch >=
                    sourceLastModified);

        if (hasFreshCache) {
          await logger.log(
            scope: 'poster',
            event: 'image_ready',
            fields: <String, Object?>{
              'sourceId': request.sourceId,
              'relativePath': request.relativePath,
              'variant': variant.name,
              'status': 'cache_hit',
              'elapsedMs': stopwatch.elapsedMilliseconds,
            },
          );
          return targetFile;
        }

        final document = await ref.watch(
          relativeDocumentProvider(request.assetRequest).future,
        );
        if (document == null || !document.exists || !document.isFile) {
          await logger.log(
            scope: 'poster',
            event: 'image_ready',
            fields: <String, Object?>{
              'sourceId': request.sourceId,
              'relativePath': request.relativePath,
              'variant': variant.name,
              'status': 'missing_source',
              'elapsedMs': stopwatch.elapsedMilliseconds,
            },
          );
          return null;
        }

        final bytes = await _readImageBytes(document);
        if (bytes == null || bytes.isEmpty) {
          await logger.log(
            scope: 'poster',
            event: 'image_ready',
            fields: <String, Object?>{
              'sourceId': request.sourceId,
              'relativePath': request.relativePath,
              'variant': variant.name,
              'status': 'materialize_failed',
              'elapsedMs': stopwatch.elapsedMilliseconds,
            },
          );
          return null;
        }

        if (targetFile.existsSync()) {
          await targetFile.delete();
        }
        await targetFile.writeAsBytes(bytes, flush: true);

        if (!_isUsableFile(targetFile)) {
          if (targetFile.existsSync()) {
            await targetFile.delete();
          }
          await logger.log(
            scope: 'poster',
            event: 'image_ready',
            fields: <String, Object?>{
              'sourceId': request.sourceId,
              'relativePath': request.relativePath,
              'variant': variant.name,
              'status': 'empty_target',
              'elapsedMs': stopwatch.elapsedMilliseconds,
            },
          );
          return null;
        }

        await targetFile.setLastModified(
          DateTime.fromMillisecondsSinceEpoch(
            document.lastModified == 0
                ? DateTime.now().millisecondsSinceEpoch
                : document.lastModified,
          ),
        );
        await logger.log(
          scope: 'poster',
          event: 'image_ready',
          fields: <String, Object?>{
            'sourceId': request.sourceId,
            'relativePath': request.relativePath,
            'variant': variant.name,
            'status': 'cache_miss',
            'elapsedMs': stopwatch.elapsedMilliseconds,
            'documentCanThumbnail': document.canThumbnail,
            'bytes': targetFile.lengthSync(),
          },
        );
        return targetFile;
      } catch (error) {
        await logger.log(
          scope: 'poster',
          event: 'image_ready',
          fields: <String, Object?>{
            'sourceId': request.sourceId,
            'relativePath': request.relativePath,
            'variant': request.variant.name,
            'status': 'exception',
            'elapsedMs': stopwatch.elapsedMilliseconds,
            'error': error.toString(),
          },
        );
        return null;
      }
    });

Future<Uint8List?> _readImageBytes(DocumentFile document) async {
  final bytes = await document.read();
  if (bytes == null || bytes.isEmpty) {
    return null;
  }
  return bytes;
}

bool _isUsableFile(File? file) {
  if (file == null || !file.existsSync()) {
    return false;
  }
  return file.lengthSync() > 0;
}

String buildRelativeImageCacheFileName(
  RelativeImageRequest request, {
  String? extension,
}) {
  final normalizedPath = normalizePath(request.relativePath);
  final digest = sha1
      .convert(
        utf8.encode(
          '${request.sourceId}:${request.variant.name}:$normalizedPath:${request.lastModified ?? 0}',
        ),
      )
      .toString();
  final normalizedExtension =
      extension ?? request.variant.fileExtension(normalizedPath);
  return '$digest$normalizedExtension';
}

extension on RelativeImageVariant {
  String get directoryName => switch (this) {
    RelativeImageVariant.posterThumb => 'poster_thumb',
    RelativeImageVariant.posterDetail => 'poster_detail',
    RelativeImageVariant.fanartPreview => 'fanart_preview',
  };

  String fileExtension(String path) {
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex <= 0 || dotIndex == path.length - 1) {
      return '.jpg';
    }
    return path.substring(dotIndex);
  }
}
