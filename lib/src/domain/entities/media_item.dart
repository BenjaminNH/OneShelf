enum MediaSort { recentlyAdded, title, lastPlayed }

class MediaItem {
  const MediaItem({
    required this.id,
    required this.sourceId,
    required this.fileName,
    required this.displayLabel,
    required this.firstSeenAt,
    required this.lastSeenAt,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.code,
    this.plot,
    this.actorNames = const <String>[],
    this.posterRelativePath,
    this.posterUri,
    this.posterLastModified,
    this.hasAutoPoster = false,
    this.autoPosterTimeMs,
    this.fanartRelativePath,
    this.fanartUri,
    this.fanartLastModified,
    this.folderRelativePath,
    this.primaryVideoRelativePath,
    this.primaryVideoUri,
    this.primaryVideoLastModified,
    this.nfoRelativePath,
    this.nfoUri,
    this.fileSizeBytes,
    this.durationMs,
    this.width,
    this.height,
    this.isPlayable = true,
    this.isMissing = false,
  });

  final String id;
  final String sourceId;
  final String? title;
  final String displayLabel;
  final List<String> actorNames;
  final String? code;
  final String? plot;
  final String? posterRelativePath;
  final String? posterUri;
  final int? posterLastModified;
  final bool hasAutoPoster;
  final int? autoPosterTimeMs;
  final String? fanartRelativePath;
  final String? fanartUri;
  final int? fanartLastModified;
  final String? folderRelativePath;
  final String? primaryVideoRelativePath;
  final String? primaryVideoUri;
  final int? primaryVideoLastModified;
  final String? nfoRelativePath;
  final String? nfoUri;
  final String fileName;
  final int? fileSizeBytes;
  final int? durationMs;
  final int? width;
  final int? height;
  final bool isPlayable;
  final bool isMissing;
  final DateTime firstSeenAt;
  final DateTime lastSeenAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get resolvedTitle =>
      title?.trim().isNotEmpty == true ? title!.trim() : displayLabel;
}
