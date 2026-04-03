import 'dart:async';

import 'package:docman/docman.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../data/providers/data_providers.dart';
import '../domain/entities/media_entry.dart';
import '../domain/entities/media_item.dart';
import '../features/detail/presentation/detail_page.dart';
import '../features/library/application/library_providers.dart';
import '../features/player/presentation/player_page.dart';
import '../features/settings/application/settings_providers.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/sources/application/sources_providers.dart';
import '../features/sources/presentation/media_sources_page.dart';
import '../core/navigation/app_routes.dart';
import '../shared/debug/app_debug_logger.dart';
import '../shared/media/local_video_metadata.dart';
import '../shared/media/media_asset_resolver.dart';

class DetailRoutePage extends ConsumerWidget {
  const DetailRoutePage({required this.mediaId, super.key});

  final String mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentTreeAccess = ref.read(documentTreeAccessProvider);
    final libraryActions = ref.read(libraryActionsProvider);
    final debugLogger = ref.read(appDebugLoggerProvider);
    final entryAsync = ref.watch(mediaEntryProvider(mediaId));
    return entryAsync.when(
      loading: () => const _RouteLoadingPage(label: 'Loading media details...'),
      error: (error, stackTrace) =>
          _RouteErrorPage(message: 'Failed to load detail: $error'),
      data: (entry) {
        if (entry == null) {
          return const _RouteErrorPage(message: 'Media item not found.');
        }
        final hasPlayableFile =
            (entry.item.primaryVideoUri?.isNotEmpty ?? false) ||
            (entry.item.primaryVideoRelativePath?.isNotEmpty ?? false);
        unawaited(
          debugLogger.log(
            scope: 'detail',
            event: 'route_entry_loaded',
            fields: <String, Object?>{
              'mediaId': entry.item.id,
              'hasPlayableFile': hasPlayableFile,
              'hasPoster': entry.item.posterRelativePath != null,
              'hasFanart': entry.item.fanartRelativePath != null,
            },
          ),
        );
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
        final posterAsync = entry.item.posterRelativePath == null
            ? null
            : ref.watch(
                relativeImageFileProvider(
                  RelativeImageRequest(
                    sourceId: entry.item.sourceId,
                    relativePath: entry.item.posterRelativePath!,
                    uri: entry.item.posterUri,
                    lastModified: entry.item.posterLastModified,
                    variant: RelativeImageVariant.posterDetail,
                  ),
                ),
              );
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
                  Navigator.of(context).pushNamed(AppRoutes.player(mediaId));
                }
              : null,
          onContinuePlay: entry.hasResume && hasPlayableFile
              ? () {
                  Navigator.of(context).pushNamed(AppRoutes.player(mediaId));
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
            unawaited(libraryActions.updateRating(mediaId, rating));
          },
        );
      },
    );
  }
}

class SettingsRoutePage extends ConsumerWidget {
  const SettingsRoutePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryActions = ref.read(libraryActionsProvider);
    final settingsActions = ref.read(settingsActionsProvider);
    final lastScanReportNotifier = ref.read(
      sourceLastScanReportProvider.notifier,
    );
    final settingsAsync = ref.watch(appSettingsProvider);
    final sourcesAsync = ref.watch(mediaSourcesProvider);
    final latestReport = ref.watch(sourceLastScanReportProvider);
    final showProfileLogging = !kReleaseMode;
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

        return SettingsPage(
          settings: settings,
          latestScanReport: latestReport,
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
        );
      },
    );
  }
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
