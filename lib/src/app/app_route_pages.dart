import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:docman/docman.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../data/providers/data_providers.dart';
import '../domain/entities/media_entry.dart';
import '../domain/entities/media_item.dart';
import '../features/detail/presentation/detail_page.dart';
import '../features/detail/presentation/detail_skeleton.dart';
import '../features/library/application/library_providers.dart';
import '../features/player/presentation/player_page.dart';
import '../features/backup/application/backup_providers.dart';
import '../features/settings/application/settings_providers.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/sources/application/sources_providers.dart';
import '../features/sources/presentation/media_sources_page.dart';
import '../core/navigation/app_routes.dart';
import '../shared/debug/app_debug_logger.dart';
import '../shared/media/local_video_metadata.dart';
import '../shared/media/media_asset_resolver.dart';

const _githubOwner = 'BenjaminNH';
const _githubRepo = 'OneShelf';
const _githubRepositoryUrl = 'https://github.com/$_githubOwner/$_githubRepo';
const _githubReleasesUrl = '$_githubRepositoryUrl/releases';
const _githubLatestReleaseApi =
    'https://api.github.com/repos/$_githubOwner/$_githubRepo/releases/latest';
const _updateApiOverride = String.fromEnvironment(
  'ONESHELF_UPDATE_API',
  defaultValue: '',
);

String? buildSettingsUpdateFeedUrlLabel({
  required bool showDebugFeedUrl,
  required String effectiveUpdateFeedApi,
}) {
  if (!showDebugFeedUrl) {
    return null;
  }
  return effectiveUpdateFeedApi;
}

class DetailRoutePage extends ConsumerStatefulWidget {
  const DetailRoutePage({required this.mediaId, super.key});

  final String mediaId;

  @override
  ConsumerState<DetailRoutePage> createState() => _DetailRoutePageState();
}

class _DetailRoutePageState extends ConsumerState<DetailRoutePage> {
  final Stopwatch _pageStopwatch = Stopwatch();
  bool _loggedInitialLoad = false;

  @override
  void initState() {
    super.initState();
    _pageStopwatch.start();
  }

  @override
  Widget build(BuildContext context) {
    final documentTreeAccess = ref.read(documentTreeAccessProvider);
    final libraryActions = ref.read(libraryActionsProvider);
    final debugLogger = ref.read(appDebugLoggerProvider);
    final entryAsync = ref.watch(mediaEntryProvider(widget.mediaId));
    return entryAsync.when(
      loading: () => const DetailSkeleton(),
      error: (error, stackTrace) =>
          _RouteErrorPage(message: 'Failed to load detail: $error'),
      data: (entry) {
        if (entry == null) {
          return const _RouteErrorPage(message: 'Media item not found.');
        }
        final hasPlayableFile =
            (entry.item.primaryVideoUri?.isNotEmpty ?? false) ||
            (entry.item.primaryVideoRelativePath?.isNotEmpty ?? false);
        if (!_loggedInitialLoad) {
          _loggedInitialLoad = true;
          unawaited(
            debugLogger.log(
              scope: 'detail',
              event: 'entry_loaded',
              fields: <String, Object?>{
                'mediaId': entry.item.id,
                'hasPlayableFile': hasPlayableFile,
                'hasPoster': entry.item.posterRelativePath != null,
                'hasFanart': entry.item.fanartRelativePath != null,
                'needsMetadata':
                    entry.item.durationMs == null ||
                    entry.item.width == null ||
                    entry.item.height == null,
                'elapsedMs': _pageStopwatch.elapsedMilliseconds,
              },
            ),
          );
        }
        final metadataAsync =
            (entry.item.primaryVideoUri?.isNotEmpty ?? false) &&
                (entry.item.durationMs == null ||
                    entry.item.width == null ||
                    entry.item.height == null)
            ? ref.watch(
                localVideoMetadataProvider(
                  LocalVideoMetadataRequest(
                    mediaId: entry.item.id,
                    uri: entry.item.primaryVideoUri!,
                  ),
                ),
              )
            : null;

        final hasLocalPoster =
            entry.item.posterRelativePath != null &&
            entry.item.posterRelativePath!.isNotEmpty;

        final posterAsync = hasLocalPoster
            ? ref.watch(
                relativeImageFileProvider(
                  RelativeImageRequest(
                    sourceId: entry.item.sourceId,
                    relativePath: entry.item.posterRelativePath!,
                    uri: entry.item.posterUri,
                    lastModified: entry.item.posterLastModified,
                    variant: RelativeImageVariant.posterDetail,
                  ),
                ),
              )
            : entry.item.hasAutoPoster
            ? ref.watch(
                autoPosterFileProvider(
                  AutoPosterRequest(
                    mediaId: entry.item.id,
                    hasAutoPoster: entry.item.hasAutoPoster,
                  ),
                ),
              )
            : null;

        final fanartAsync = entry.item.fanartRelativePath == null
            ? null
            : ref.watch(
                relativeImageFileProvider(
                  RelativeImageRequest(
                    sourceId: entry.item.sourceId,
                    relativePath: entry.item.fanartRelativePath!,
                    uri: entry.item.fanartUri,
                    lastModified: entry.item.fanartLastModified,
                    variant: RelativeImageVariant.fanartPreview,
                  ),
                ),
              );
        final metadata = metadataAsync?.asData?.value;
        final posterFile = posterAsync?.asData?.value;
        final fanartFile = fanartAsync?.asData?.value;

        final allLoaded =
            (metadataAsync == null || !metadataAsync.isLoading) &&
            (posterAsync == null || !posterAsync.isLoading) &&
            (fanartAsync == null || !fanartAsync.isLoading);
        if (allLoaded && _pageStopwatch.isRunning) {
          _pageStopwatch.stop();
          unawaited(
            debugLogger.log(
              scope: 'detail',
              event: 'page_ready',
              fields: <String, Object?>{
                'mediaId': entry.item.id,
                'hasMetadata': metadata != null,
                'hasPoster': posterFile != null,
                'hasFanart': fanartFile != null,
                'elapsedMs': _pageStopwatch.elapsedMilliseconds,
              },
            ),
          );
        }

        return DetailPage(
          entry: entry,
          effectiveDurationMs: metadata?.durationMs,
          effectiveWidth: metadata?.width,
          effectiveHeight: metadata?.height,
          isResolvingTechnicalMetadata: metadataAsync?.isLoading ?? false,
          heroImage: fanartFile == null ? null : FileImage(fanartFile),
          posterImage: posterFile == null ? null : FileImage(posterFile),
          onPlay: hasPlayableFile
              ? () {
                  Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.player(widget.mediaId));
                }
              : null,
          onContinuePlay: entry.hasResume && hasPlayableFile
              ? () {
                  Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.player(widget.mediaId));
                }
              : null,
          onOpenExternal: hasPlayableFile
              ? () async {
                  final file = await _resolvePrimaryVideo(ref, entry.item);
                  if (file == null) {
                    if (context.mounted) {
                      _showMessage(
                        context,
                        'Unable to resolve the local video file.',
                      );
                    }
                    return;
                  }
                  if (!context.mounted) {
                    return;
                  }
                  final opened = await documentTreeAccess.open(
                    file,
                    title: 'Open with',
                  );
                  if (!context.mounted) {
                    return;
                  }
                  if (!opened) {
                    _showMessage(
                      context,
                      'No external player was able to open this file.',
                    );
                  }
                }
              : null,
          onRatingChanged: (rating) {
            unawaited(libraryActions.updateRating(widget.mediaId, rating));
          },
        );
      },
    );
  }
}

class SettingsRoutePage extends ConsumerStatefulWidget {
  const SettingsRoutePage({super.key});

  @override
  ConsumerState<SettingsRoutePage> createState() => _SettingsRoutePageState();
}

class _SettingsRoutePageState extends ConsumerState<SettingsRoutePage> {
  late final Future<PackageInfo> _packageInfoFuture;
  var _checkingUpdate = false;
  var _updateStatusLabel = _updateApiOverride.trim().isNotEmpty
      ? 'Using local update feed.'
      : 'Checks GitHub releases for new builds.';

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final libraryActions = ref.read(libraryActionsProvider);
    final settingsActions = ref.read(settingsActionsProvider);
    final backupActions = ref.read(backupActionsProvider);
    final lastScanReportNotifier = ref.read(
      sourceLastScanReportProvider.notifier,
    );
    final settingsAsync = ref.watch(appSettingsProvider);
    final sourcesAsync = ref.watch(mediaSourcesProvider);
    final latestReport = ref.watch(sourceLastScanReportProvider);
    final showProfileLogging = !kReleaseMode;
    final showDebugUpdateFeed = kDebugMode;
    final debugLogPathAsync = showProfileLogging
        ? ref.watch(debugLogPathProvider)
        : const AsyncValue<String?>.data(null);

    return settingsAsync.when(
      loading: () => const _RouteLoadingPage(label: 'Loading settings...'),
      error: (error, stackTrace) =>
          _RouteErrorPage(message: 'Failed to load settings: $error'),
      data: (settings) {
        final sources = sourcesAsync.asData?.value ?? const [];
        final lostCount = sources
            .where((source) => source.permissionStatus.name == 'lost')
            .length;

        return FutureBuilder<PackageInfo>(
          future: _packageInfoFuture,
          builder: (context, packageSnapshot) {
            final packageInfo = packageSnapshot.data;
            return SettingsPage(
              settings: settings,
              latestScanReport: latestReport,
              appVersionLabel: _buildVersionLabel(packageInfo),
              updateFeedUrlLabel: buildSettingsUpdateFeedUrlLabel(
                showDebugFeedUrl: showDebugUpdateFeed,
                effectiveUpdateFeedApi: _effectiveUpdateFeedApi(),
              ),
              updateStatusLabel: _checkingUpdate
                  ? 'Checking GitHub releases...'
                  : _updateStatusLabel,
              posterCacheSizeLabel: 'Managed by app cache',
              permissionHealthLabel: lostCount == 0
                  ? 'Healthy'
                  : '$lostCount source(s) need attention',
              showProfileLogging: showProfileLogging,
              debugLogPathLabel: debugLogPathAsync.asData?.value,
              onManageSources: () {
                Navigator.of(context).pushNamed(AppRoutes.sources);
              },
              onRescanAll: () async {
                final report = await libraryActions.scanAllSources();
                lastScanReportNotifier.setReport(report);
                if (context.mounted) {
                  _showMessage(
                    context,
                    report.hasError
                        ? 'Scan finished with issues: ${report.errorMessage}'
                        : 'Scan finished: ${report.itemsFound} items found.',
                  );
                }
              },
              onSave: (nextSettings) {
                unawaited(settingsActions.save(nextSettings));
              },
              onClearCache: () async {
                await settingsActions.clearImageCache();
                if (context.mounted) {
                  _showMessage(context, 'Image cache cleared.');
                }
              },
              onRebuildLibrary: () async {
                await libraryActions.rebuildLibrary();
                if (context.mounted) {
                  _showMessage(context, 'Library rebuilt from local sources.');
                }
              },
              onShareDebugLog: showProfileLogging
                  ? () async {
                      final shared = await settingsActions.shareDebugLog();
                      if (context.mounted) {
                        _showMessage(
                          context,
                          shared
                              ? 'Profile log ready to share.'
                              : 'Profile log is not available yet.',
                        );
                      }
                    }
                  : null,
              onClearDebugLog: showProfileLogging
                  ? () async {
                      await settingsActions.clearDebugLog();
                      ref.invalidate(debugLogPathProvider);
                      if (context.mounted) {
                        _showMessage(context, 'Profile log cleared.');
                      }
                    }
                  : null,
              onExportBackup: () async {
                final result = await backupActions.export();
                if (context.mounted) {
                  _showMessage(
                    context,
                    result.success
                        ? 'Backup saved to Download/OneShelf (${result.recordCount} records)'
                        : 'Export failed: ${result.error}',
                  );
                }
              },
              onImportBackup: () async {
                final filePath = await backupActions.pickBackupFile();
                if (filePath == null) return;
                final result = await backupActions.import(filePath);
                if (context.mounted) {
                  _showMessage(
                    context,
                    result.success
                        ? 'Restored: ${result.exactMatchCount} exact, ${result.fuzzyMatchCount} fuzzy, ${result.skippedCount} skipped'
                        : 'Import failed: ${result.error}',
                  );
                }
              },
              onCheckUpdate: () {
                unawaited(_checkForGithubUpdate(packageInfo));
              },
              onOpenGithub: () {
                unawaited(_openGithubRepository());
              },
            );
          },
        );
      },
    );
  }

  String _buildVersionLabel(PackageInfo? packageInfo) {
    if (packageInfo == null) {
      return 'Unknown';
    }
    final version = packageInfo.version.trim();
    final buildNumber = packageInfo.buildNumber.trim();
    if (version.isEmpty) {
      return 'Unknown';
    }
    if (buildNumber.isEmpty) {
      return 'v$version';
    }
    return 'v$version+$buildNumber';
  }

  Future<void> _checkForGithubUpdate(PackageInfo? packageInfo) async {
    if (_checkingUpdate) {
      return;
    }
    setState(() {
      _checkingUpdate = true;
    });
    try {
      final release = await _fetchLatestGithubRelease();
      final latestTag = release.tagName?.trim().isNotEmpty == true
          ? release.tagName!.trim()
          : (release.name?.trim().isNotEmpty == true
                ? release.name!.trim()
                : 'latest release');
      final comparison = _compareFlutterVersion(
        latestTag: latestTag,
        currentVersion: packageInfo?.version,
        currentBuildNumber: packageInfo?.buildNumber,
      );

      if (comparison != null && comparison > 0) {
        setState(() {
          _updateStatusLabel = 'New version available: $latestTag';
        });
        if (!Platform.isAndroid) {
          if (mounted) {
            _showMessage(
              context,
              'Update found: $latestTag. Automatic install is Android-only.',
            );
          }
          final targetUrl = release.htmlUrl ?? _githubReleasesUrl;
          await _openExternalUrl(
            Uri.parse(targetUrl),
            errorMessage: 'Unable to open release page.',
          );
          return;
        }
        final apkUrl = release.apkUrl;
        if (apkUrl == null || apkUrl.isEmpty) {
          if (mounted) {
            _showMessage(
              context,
              'Update found: $latestTag, but no APK asset was found on GitHub.',
            );
          }
          final targetUrl = release.htmlUrl ?? _githubReleasesUrl;
          await _openExternalUrl(
            Uri.parse(targetUrl),
            errorMessage: 'Unable to open release page.',
          );
          return;
        }
        await _downloadAndInstallUpdate(apkUrl: apkUrl, releaseTag: latestTag);
        return;
      }

      if (comparison != null && comparison <= 0) {
        setState(() {
          _updateStatusLabel = 'Already up to date.';
        });
        if (mounted) {
          _showMessage(context, 'You are already on the latest version.');
        }
        return;
      }

      setState(() {
        _updateStatusLabel = 'Latest release: $latestTag';
      });
      if (mounted) {
        _showMessage(context, 'Opened latest release details.');
      }
      final targetUrl = release.htmlUrl ?? _githubReleasesUrl;
      await _openExternalUrl(
        Uri.parse(targetUrl),
        errorMessage: 'Unable to open release page.',
      );
    } catch (error) {
      if (mounted) {
        _showMessage(context, 'Update check failed: $error');
      }
      setState(() {
        _updateStatusLabel = 'Update check failed. Tap to retry.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _checkingUpdate = false;
        });
      }
    }
  }

  Future<void> _openGithubRepository() async {
    await _openExternalUrl(
      Uri.parse(_githubRepositoryUrl),
      errorMessage: 'Unable to open GitHub repository.',
    );
  }

  Future<void> _downloadAndInstallUpdate({
    required String apkUrl,
    required String releaseTag,
  }) async {
    if (mounted) {
      setState(() {
        _updateStatusLabel = 'Downloading update...';
      });
      _showMessage(context, 'Downloading update $releaseTag...');
    }
    final apkFile = await _downloadApkFile(
      apkUrl: apkUrl,
      releaseTag: releaseTag,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _updateStatusLabel = 'Download complete. Opening installer...';
    });
    final result = await OpenFilex.open(
      apkFile.path,
      type: 'application/vnd.android.package-archive',
    );
    if (result.type != ResultType.done) {
      final normalizedMessage = result.message.trim();
      final suffix = normalizedMessage.isEmpty
          ? result.type.name
          : normalizedMessage;
      throw StateError('Installer launch failed: $suffix');
    }
    if (mounted) {
      setState(() {
        _updateStatusLabel = 'Installer opened for $releaseTag.';
      });
      _showMessage(context, 'Installer opened. Continue in Android installer.');
    }
  }

  Future<File> _downloadApkFile({
    required String apkUrl,
    required String releaseTag,
  }) async {
    final uri = Uri.parse(apkUrl);
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.userAgentHeader, 'OneShelf-Updater');
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw StateError('APK download failed with ${response.statusCode}');
      }
      final cacheDir = await getTemporaryDirectory();
      final updateDir = Directory(
        '${cacheDir.path}${Platform.pathSeparator}updates',
      );
      if (!await updateDir.exists()) {
        await updateDir.create(recursive: true);
      }
      final targetFile = File(
        '${updateDir.path}${Platform.pathSeparator}${_apkFileName(uri, releaseTag)}',
      );
      if (await targetFile.exists()) {
        await targetFile.delete();
      }
      final sink = targetFile.openWrite();
      final totalBytes = response.contentLength;
      var receivedBytes = 0;
      var lastPercent = -1;
      try {
        await for (final chunk in response) {
          receivedBytes += chunk.length;
          sink.add(chunk);
          if (!mounted || totalBytes <= 0) {
            continue;
          }
          final percent = ((receivedBytes / totalBytes) * 100).round().clamp(
            0,
            100,
          );
          if (percent == 100 || percent >= lastPercent + 5) {
            lastPercent = percent;
            setState(() {
              _updateStatusLabel = 'Downloading update... $percent%';
            });
          }
        }
      } finally {
        await sink.flush();
        await sink.close();
      }
      final size = await targetFile.length();
      if (size <= 0) {
        throw const FormatException('Downloaded APK is empty.');
      }
      return targetFile;
    } finally {
      client.close(force: true);
    }
  }

  String _apkFileName(Uri apkUri, String releaseTag) {
    final sourceName = apkUri.pathSegments.isEmpty
        ? ''
        : apkUri.pathSegments.last;
    if (sourceName.toLowerCase().endsWith('.apk')) {
      return sourceName;
    }
    final sanitizedTag = releaseTag.replaceAll(RegExp(r'[^0-9A-Za-z._-]'), '_');
    return 'oneshelf-$sanitizedTag.apk';
  }

  Future<void> _openExternalUrl(Uri uri, {required String errorMessage}) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      _showMessage(context, errorMessage);
    }
  }

  Future<_GithubReleaseInfo> _fetchLatestGithubRelease() async {
    final feedUrl = _effectiveUpdateFeedApi();
    final feedUri = Uri.parse(feedUrl);
    final client = HttpClient();
    try {
      final request = await client.getUrl(feedUri);
      if (feedUri.host == 'api.github.com') {
        request.headers.set(
          HttpHeaders.acceptHeader,
          'application/vnd.github+json',
        );
      }
      request.headers.set(
        HttpHeaders.userAgentHeader,
        'OneShelf-UpdateChecker',
      );
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != HttpStatus.ok) {
        throw StateError('Update feed returned ${response.statusCode}');
      }
      final parsed = jsonDecode(body);
      if (parsed is! Map<String, dynamic>) {
        throw const FormatException('Unexpected release payload.');
      }
      return _GithubReleaseInfo.fromJson(parsed, baseUri: feedUri);
    } finally {
      client.close(force: true);
    }
  }

  String _effectiveUpdateFeedApi() {
    final override = _updateApiOverride.trim();
    if (override.isNotEmpty) {
      return override;
    }
    return _githubLatestReleaseApi;
  }
}

class _GithubReleaseInfo {
  const _GithubReleaseInfo({
    required this.tagName,
    required this.name,
    required this.htmlUrl,
    required this.apkUrl,
  });

  final String? tagName;
  final String? name;
  final String? htmlUrl;
  final String? apkUrl;

  factory _GithubReleaseInfo.fromJson(
    Map<String, dynamic> json, {
    required Uri baseUri,
  }) {
    final tagName =
        json['tag_name'] as String? ??
        json['version'] as String? ??
        json['latestVersion'] as String? ??
        json['latestVersionName'] as String?;
    final name = json['name'] as String? ?? json['title'] as String?;
    final htmlUrl = _resolveUrl(
      json['html_url'] as String? ??
          json['releaseUrl'] as String? ??
          json['pageUrl'] as String?,
      baseUri,
    );
    final directApkUrl = _resolveUrl(
      json['apkUrl'] as String? ?? json['downloadUrl'] as String?,
      baseUri,
    );

    final assets = json['assets'];
    String? apkUrl;
    if (directApkUrl != null) {
      apkUrl = directApkUrl;
    }
    if (assets is List) {
      for (final asset in assets) {
        if (asset is! Map<String, dynamic>) {
          continue;
        }
        final assetName = (asset['name'] as String?)?.toLowerCase() ?? '';
        final downloadUrl = _resolveUrl(
          asset['browser_download_url'] as String? ?? asset['url'] as String?,
          baseUri,
        );
        if (downloadUrl == null || downloadUrl.isEmpty) {
          continue;
        }
        if (assetName.endsWith('.apk')) {
          apkUrl = downloadUrl;
          break;
        }
      }
    }
    return _GithubReleaseInfo(
      tagName: tagName,
      name: name,
      htmlUrl: htmlUrl,
      apkUrl: apkUrl,
    );
  }
}

String? _resolveUrl(String? raw, Uri baseUri) {
  final candidate = raw?.trim();
  if (candidate == null || candidate.isEmpty) {
    return null;
  }
  final parsed = Uri.tryParse(candidate);
  if (parsed == null) {
    return null;
  }
  if (parsed.hasScheme) {
    return parsed.toString();
  }
  return baseUri.resolveUri(parsed).toString();
}

int? _compareFlutterVersion({
  required String latestTag,
  required String? currentVersion,
  required String? currentBuildNumber,
}) {
  if (currentVersion == null || currentVersion.trim().isEmpty) {
    return null;
  }
  final latest = _parseFlutterVersion(latestTag);
  final current = _parseFlutterVersion(
    currentVersion,
    fallbackBuildNumber: currentBuildNumber,
  );
  if (latest == null || current == null) {
    return null;
  }
  final maxLength = latest.core.length > current.core.length
      ? latest.core.length
      : current.core.length;
  for (var index = 0; index < maxLength; index++) {
    final latestPart = index < latest.core.length ? latest.core[index] : 0;
    final currentPart = index < current.core.length ? current.core[index] : 0;
    if (latestPart != currentPart) {
      return latestPart.compareTo(currentPart);
    }
  }
  return latest.build.compareTo(current.build);
}

_ParsedFlutterVersion? _parseFlutterVersion(
  String raw, {
  String? fallbackBuildNumber,
}) {
  var value = raw.trim();
  if (value.isEmpty) {
    return null;
  }
  value = value.replaceFirst(RegExp(r'^[vV]'), '');
  var build = 0;

  if (value.contains('+')) {
    final sections = value.split('+');
    value = sections.first;
    if (sections.length > 1) {
      build = int.tryParse(sections[1].split('-').first) ?? 0;
    }
  } else {
    build = int.tryParse(fallbackBuildNumber?.trim() ?? '') ?? 0;
  }

  value = value.split('-').first;
  final numbers = RegExp(r'\d+(?:\.\d+)*').firstMatch(value)?.group(0);
  if (numbers == null || numbers.isEmpty) {
    return null;
  }
  final parts = numbers.split('.');
  final core = <int>[];
  for (final part in parts) {
    final parsed = int.tryParse(part);
    if (parsed == null) {
      return null;
    }
    core.add(parsed);
  }
  return _ParsedFlutterVersion(core: core, build: build);
}

class _ParsedFlutterVersion {
  const _ParsedFlutterVersion({required this.core, required this.build});

  final List<int> core;
  final int build;
}

class MediaSourcesRoutePage extends ConsumerWidget {
  const MediaSourcesRoutePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sourcesActions = ref.read(sourcesActionsProvider);
    final sourcesAsync = ref.watch(mediaSourcesProvider);
    return sourcesAsync.when(
      loading: () => const _RouteLoadingPage(label: 'Loading sources...'),
      error: (error, stackTrace) =>
          _RouteErrorPage(message: 'Failed to load media sources: $error'),
      data: (sources) {
        return MediaSourcesPage(
          sources: sources,
          onAddSource: () async {
            final source = await sourcesActions.addSource();
            if (source != null) {
              await sourcesActions.rescanSource(source.id);
              if (context.mounted) {
                _showMessage(context, 'Source added and initial scan started.');
              }
            }
          },
          onRescan: (sourceId) async {
            final report = await sourcesActions.rescanSource(sourceId);
            if (context.mounted) {
              _showMessage(
                context,
                report.hasError
                    ? 'Rescan failed: ${report.errorMessage}'
                    : 'Rescan finished: ${report.itemsFound} items found.',
              );
            }
          },
          onReauthorize: (sourceId) async {
            await sourcesActions.reauthorizeSource(sourceId);
            if (context.mounted) {
              _showMessage(context, 'Permission refreshed for this source.');
            }
          },
          onRemove: (sourceId) async {
            await sourcesActions.removeSource(sourceId);
            if (context.mounted) {
              _showMessage(context, 'Source removed from the library.');
            }
          },
        );
      },
    );
  }
}

class PlayerRoutePage extends ConsumerStatefulWidget {
  const PlayerRoutePage({required this.mediaId, super.key});

  final String mediaId;

  @override
  ConsumerState<PlayerRoutePage> createState() => _PlayerRoutePageState();
}

class _PlayerRoutePageState extends ConsumerState<PlayerRoutePage> {
  VideoPlayerController? _controller;
  bool _initializing = false;
  bool _persisted = false;
  String? _loadedMediaId;
  String? _errorMessage;
  double _lastPlaybackSpeed = 1.0;
  late final LibraryActions _libraryActions;
  late final AppDebugLogger _debugLogger;

  @override
  void initState() {
    super.initState();
    _libraryActions = ref.read(libraryActionsProvider);
    _debugLogger = ref.read(appDebugLoggerProvider);
    unawaited(
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]),
    );
    unawaited(
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
    );
  }

  @override
  void dispose() {
    unawaited(_persistProgress());
    unawaited(
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]),
    );
    unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
    final controller = _controller;
    _controller = null;
    unawaited(controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entryAsync = ref.watch(mediaEntryProvider(widget.mediaId));
    final settingsAsync = ref.watch(appSettingsProvider);

    return settingsAsync.when(
      loading: () => const _RouteLoadingPage(label: 'Preparing playback...'),
      error: (error, stackTrace) =>
          _RouteErrorPage(message: 'Failed to load playback settings: $error'),
      data: (settings) {
        return entryAsync.when(
          loading: () =>
              const _RouteLoadingPage(label: 'Opening local video...'),
          error: (error, stackTrace) =>
              _RouteErrorPage(message: 'Failed to load player entry: $error'),
          data: (entry) {
            if (entry == null) {
              return const _RouteErrorPage(message: 'Media item not found.');
            }
            _ensureController(entry);

            if (_errorMessage != null) {
              return _RouteErrorPage(message: _errorMessage!);
            }

            final controller = _controller;
            final value = controller?.value;
            final duration = value?.isInitialized == true
                ? value!.duration
                : Duration(milliseconds: entry.item.durationMs ?? 0);
            final position = value?.position ?? Duration.zero;

            return PopScope(
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) {
                  unawaited(_persistProgress());
                }
              },
              child: PlayerPage(
                title: entry.item.resolvedTitle,
                controller: controller,
                position: position,
                total: duration,
                isPlaying: value?.isPlaying ?? false,
                backwardSeek: Duration(seconds: settings.seekBackwardSeconds),
                forwardSeek: Duration(seconds: settings.seekForwardSeconds),
                holdSpeedLabel: '${settings.holdSpeed.toStringAsFixed(1)}x',
                onBack: () async {
                  await _persistProgress();
                  if (context.mounted) {
                    Navigator.of(context).maybePop();
                  }
                },
                onPlayPause: _togglePlayback,
                onSeekRelative: _seekRelative,
                onHoldSpeedStart: () => _setPlaybackSpeed(settings.holdSpeed),
                onHoldSpeedEnd: () => _setPlaybackSpeed(_lastPlaybackSpeed),
                onSpeedTap: _cyclePlaybackSpeed,
                onModeTap: () {
                  _showMessage(
                    context,
                    'Using the built-in player with local progress tracking.',
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _ensureController(MediaEntry entry) async {
    if (_loadedMediaId == entry.item.id || _initializing) {
      return;
    }
    _initializing = true;
    _errorMessage = null;
    _persisted = false;
    final stopwatch = Stopwatch()..start();

    try {
      final file = await _resolvePrimaryVideo(ref, entry.item);
      if (file == null) {
        throw StateError('Unable to resolve the local video file.');
      }

      final controller = VideoPlayerController.contentUri(Uri.parse(file.uri));
      await controller.initialize();
      controller.addListener(_onControllerChanged);
      final initializedDurationMs = controller.value.duration.inMilliseconds;
      final initializedSize = controller.value.size;
      if (initializedDurationMs > 0 ||
          initializedSize.width > 0 ||
          initializedSize.height > 0) {
        unawaited(
          _libraryActions.updateTechnicalMetadata(
            mediaId: entry.item.id,
            durationMs: initializedDurationMs > 0
                ? initializedDurationMs
                : null,
            width: initializedSize.width > 0
                ? initializedSize.width.round()
                : null,
            height: initializedSize.height > 0
                ? initializedSize.height.round()
                : null,
          ),
        );
      }

      final resumePosition = entry.userState?.lastPositionMs;
      if (resumePosition != null && resumePosition > 0) {
        await controller.seekTo(Duration(milliseconds: resumePosition));
      }
      await controller.play();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      final previous = _controller;
      setState(() {
        _controller = controller;
        _loadedMediaId = entry.item.id;
        _lastPlaybackSpeed = controller.value.playbackSpeed;
      });
      await previous?.dispose();
      await _debugLogger.log(
        scope: 'player',
        event: 'controller_initialized',
        fields: <String, Object?>{
          'mediaId': entry.item.id,
          'elapsedMs': stopwatch.elapsedMilliseconds,
          'durationMs': initializedDurationMs,
          'width': initializedSize.width.round(),
          'height': initializedSize.height.round(),
        },
      );
    } catch (error) {
      await _debugLogger.log(
        scope: 'player',
        event: 'controller_initialize_failed',
        fields: <String, Object?>{
          'mediaId': entry.item.id,
          'elapsedMs': stopwatch.elapsedMilliseconds,
          'error': error.toString(),
        },
      );
      if (mounted) {
        setState(() {
          _errorMessage = error.toString();
        });
      }
    } finally {
      _initializing = false;
    }
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _togglePlayback() async {
    final controller = _controller;
    if (controller == null) {
      return;
    }
    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }
  }

  Future<void> _seekRelative(Duration delta) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    final stopwatch = Stopwatch()..start();
    final current = controller.value.position;
    final targetMs = (current.inMilliseconds + delta.inMilliseconds).clamp(
      0,
      controller.value.duration.inMilliseconds,
    );
    await controller.seekTo(Duration(milliseconds: targetMs));
    await _debugLogger.log(
      scope: 'player',
      event: 'seek_completed',
      fields: <String, Object?>{
        'mediaId': widget.mediaId,
        'deltaMs': delta.inMilliseconds,
        'targetMs': targetMs,
        'elapsedMs': stopwatch.elapsedMilliseconds,
      },
    );
  }

  Future<void> _setPlaybackSpeed(double speed) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    _lastPlaybackSpeed = controller.value.playbackSpeed;
    await controller.setPlaybackSpeed(speed);
  }

  Future<void> _cyclePlaybackSpeed() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    const speeds = <double>[1.0, 1.25, 1.5, 2.0];
    final current = controller.value.playbackSpeed;
    final nextIndex =
        (speeds.indexWhere((speed) => speed >= current) + 1) % speeds.length;
    await controller.setPlaybackSpeed(speeds[nextIndex]);
  }

  Future<void> _persistProgress() async {
    if (_persisted) {
      return;
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    _persisted = true;
    final durationMs = controller.value.duration.inMilliseconds;
    final positionMs = controller.value.position.inMilliseconds;
    final isFinished = durationMs > 0 && positionMs / durationMs >= 0.95;

    await _libraryActions.updatePlayback(
      mediaId: widget.mediaId,
      positionMs: positionMs,
      durationMs: durationMs,
      isFinished: isFinished,
    );
  }
}

class _RouteLoadingPage extends StatelessWidget {
  const _RouteLoadingPage({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _RouteErrorPage extends StatelessWidget {
  const _RouteErrorPage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

Future<DocumentFile?> _resolvePrimaryVideo(
  WidgetRef ref,
  MediaItem item,
) async {
  final debugLogger = ref.read(appDebugLoggerProvider);
  final stopwatch = Stopwatch()..start();
  final directUri = item.primaryVideoUri?.trim();
  if (directUri != null && directUri.isNotEmpty) {
    final document = await ref.read(
      relativeDocumentProvider(
        RelativeAssetRequest(
          sourceId: item.sourceId,
          relativePath: item.primaryVideoRelativePath ?? item.fileName,
          uri: directUri,
        ),
      ).future,
    );
    await debugLogger.log(
      scope: 'player',
      event: 'resolve_primary_video',
      fields: <String, Object?>{
        'mediaId': item.id,
        'strategy': 'direct_uri',
        'resolved': document != null,
        'elapsedMs': stopwatch.elapsedMilliseconds,
      },
    );
    return document;
  }

  final relativePath = item.primaryVideoRelativePath;
  if (relativePath == null || relativePath.isEmpty) {
    await debugLogger.log(
      scope: 'player',
      event: 'resolve_primary_video',
      fields: <String, Object?>{
        'mediaId': item.id,
        'strategy': 'missing_path',
        'resolved': false,
        'elapsedMs': stopwatch.elapsedMilliseconds,
      },
    );
    return null;
  }

  final document = await ref.read(
    relativeDocumentProvider(
      RelativeAssetRequest(sourceId: item.sourceId, relativePath: relativePath),
    ).future,
  );
  await debugLogger.log(
    scope: 'player',
    event: 'resolve_primary_video',
    fields: <String, Object?>{
      'mediaId': item.id,
      'strategy': 'relative_path',
      'resolved': document != null,
      'elapsedMs': stopwatch.elapsedMilliseconds,
    },
  );
  return document;
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
