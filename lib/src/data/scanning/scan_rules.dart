import 'package:crypto/crypto.dart';

import 'dart:convert';

const Set<String> supportedVideoExtensions = {
  '.mp4',
  '.mkv',
  '.avi',
  '.mov',
  '.wmv',
  '.m4v',
  '.flv',
  '.ts',
  '.webm',
  '.mpg',
  '.mpeg',
};

const Set<String> extraFolderMarkers = {
  'extras',
  'trailers',
  'featurettes',
  'interviews',
  'deletedscenes',
  'behindthescenes',
  'clips',
  'samples',
  'other',
};

const List<String> extraFileMarkers = [
  '-trailer',
  '.trailer',
  '_trailer',
  '-sample',
  '.sample',
  '_sample',
  '-featurette',
  '.featurette',
  '-interview',
  '.interview',
  '-behindthescenes',
  '.behindthescenes',
];

String normalizePath(String path) {
  var normalized = path.replaceAll('\\', '/').trim();
  while (normalized.contains('//')) {
    normalized = normalized.replaceAll('//', '/');
  }
  if (normalized.startsWith('/')) {
    normalized = normalized.substring(1);
  }
  if (normalized.endsWith('/')) {
    normalized = normalized.substring(0, normalized.length - 1);
  }
  return normalized;
}

String? extensionOf(String fileName) {
  final dot = fileName.lastIndexOf('.');
  if (dot < 0) {
    return null;
  }
  return fileName.substring(dot).toLowerCase();
}

String fileNameWithoutExtension(String fileName) {
  final dot = fileName.lastIndexOf('.');
  if (dot <= 0) {
    return fileName;
  }
  return fileName.substring(0, dot);
}

bool isVideoFileName(String fileName) {
  final ext = extensionOf(fileName);
  if (ext == null) {
    return false;
  }
  return supportedVideoExtensions.contains(ext);
}

bool isExtraVideo({required String relativePath, required String fileName}) {
  final normalizedPath = normalizePath(relativePath).toLowerCase();
  final pathSegments = normalizedPath
      .split('/')
      .where((segment) => segment.isNotEmpty)
      .toList(growable: false);
  for (final segment in pathSegments.take(pathSegments.length - 1)) {
    final marker = segment.replaceAll(RegExp(r'[\s\-_]'), '');
    if (extraFolderMarkers.contains(marker)) {
      return true;
    }
  }

  final lowerName = fileNameWithoutExtension(fileName).toLowerCase();
  return extraFileMarkers.any(lowerName.contains);
}

String buildMediaId({
  required String sourceId,
  required String? folderRelativePath,
  required String primaryVideoRelativePath,
}) {
  final folderKey = normalizePath(folderRelativePath ?? '');
  final videoKey = normalizePath(primaryVideoRelativePath);
  final key = folderKey.isNotEmpty
      ? 'source:$sourceId|folder:$folderKey'
      : 'source:$sourceId|video:$videoKey';
  return sha1.convert(utf8.encode(key)).toString();
}

String buildSourceRelativeKey(String rootUri) {
  return sha1.convert(utf8.encode(rootUri)).toString().substring(0, 16);
}
