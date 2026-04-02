import 'dart:io';

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
      return document.cache();
    });
