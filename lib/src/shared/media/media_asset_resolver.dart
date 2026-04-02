import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:docman/docman.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/data_providers.dart';
import '../../data/scanning/scan_rules.dart';

class RelativeAssetRequest {
  const RelativeAssetRequest({
    required this.sourceId,
    required this.relativePath,
  });

  final String sourceId;
  final String relativePath;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelativeAssetRequest &&
          runtimeType == other.runtimeType &&
          sourceId == other.sourceId &&
          relativePath == other.relativePath;

  @override
  int get hashCode => Object.hash(sourceId, relativePath);
}

final relativeDocumentProvider =
    FutureProvider.family<DocumentFile?, RelativeAssetRequest>((
      ref,
      request,
    ) async {
      final database = ref.read(appDatabaseProvider);
      final source = await (database.select(
        database.mediaSourcesTable,
      )..where((tbl) => tbl.id.equals(request.sourceId))).getSingleOrNull();

      if (source == null) {
        return null;
      }

      final access = ref.read(documentTreeAccessProvider);
      final root = await access.resolve(source.rootUri);
      if (root == null || !root.exists) {
        return null;
      }

      DocumentFile current = root;
      final segments = normalizePath(request.relativePath)
          .split('/')
          .where((segment) => segment.isNotEmpty)
          .toList(growable: false);

      for (final segment in segments) {
        final children = await access.listChildren(current);
        DocumentFile? next;
        for (final child in children) {
          if (child.name == segment) {
            next = child;
            break;
          }
        }
        if (next == null) {
          return null;
        }
        current = next;
      }

      return current;
    });

final relativeImageFileProvider =
    FutureProvider.family<File?, RelativeAssetRequest>((ref, request) async {
      final document = await ref.watch(
        relativeDocumentProvider(request).future,
      );
      if (document == null || !document.exists || !document.isFile) {
        return null;
      }

      final cacheRoot = await DocMan.dir.cache();
      if (cacheRoot == null) {
        return null;
      }

      final access = ref.read(documentTreeAccessProvider);
      final extension = _fileExtension(document.name);
      final targetDirectory = Directory(
        '${cacheRoot.path}${Platform.pathSeparator}docManMedia'
        '${Platform.pathSeparator}oneshelf',
      );
      if (!targetDirectory.existsSync()) {
        targetDirectory.createSync(recursive: true);
      }

      final targetFile = File(
        '${targetDirectory.path}${Platform.pathSeparator}'
        '${buildRelativeAssetCacheFileName(request, extension: extension)}',
      );
      final hasFreshCache =
          targetFile.existsSync() &&
          targetFile.lengthSync() > 0 &&
          (document.lastModified == 0 ||
              targetFile.lastModifiedSync().millisecondsSinceEpoch >=
                  document.lastModified);

      if (hasFreshCache) {
        return targetFile;
      }

      final bytes = await access.readBytes(document);
      if (bytes == null || bytes.isEmpty) {
        return null;
      }

      await targetFile.writeAsBytes(bytes, flush: true);
      return targetFile;
    });

String buildRelativeAssetCacheFileName(
  RelativeAssetRequest request, {
  String? extension,
}) {
  final normalizedPath = normalizePath(request.relativePath);
  final digest = sha1
      .convert(utf8.encode('${request.sourceId}:$normalizedPath'))
      .toString();
  final normalizedExtension = extension ?? _fileExtension(normalizedPath);
  return '$digest$normalizedExtension';
}

String _fileExtension(String name) {
  final dotIndex = name.lastIndexOf('.');
  if (dotIndex <= 0 || dotIndex == name.length - 1) {
    return '';
  }
  return name.substring(dotIndex);
}
