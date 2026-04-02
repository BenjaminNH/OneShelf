import 'dart:async';

import 'package:docman/docman.dart';
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
import '../shared/media/media_asset_resolver.dart';

class DetailRoutePage extends ConsumerWidget {
  const DetailRoutePage({required this.mediaId, super.key});

  final String mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryAsync = ref.watch(mediaEntryProvider(mediaId));
    return entryAsync.when(
      loading: () => const _RouteLoadingPage(label: 'Loading media details...'),
      error: (error, stackTrace) =>
          _RouteErrorPage(message: 'Failed to load detail: $error'),
      data: (entry) {
        if (entry == null) {
          return const _RouteErrorPage(message: 'Media item not found.');
        }
        final primaryVideoAsync = entry.item.primaryVideoRelativePath == null
            ? null
            : ref.watch(
                relativeDocumentProvider(
                  RelativeAssetRequest(
                    sourceId: entry.item.sourceId,
                    relativePath: entry.item.primaryVideoRelativePath!,
                  ),
                ),
              );
        final posterAsync = entry.item.posterRelativePath == null
            ? null
            : ref.watch(
                relativeImageFileProvider(
                  RelativeAssetRequest(
                    sourceId: entry.item.sourceId,
                    relativePath: entry.item.posterRelativePath!,
                  ),
                ),
              );
        final fanartAsync = entry.item.fanartRelativePath == null
            ? null
            : ref.watch(
                relativeImageFileProvider(
                  RelativeAssetRequest(
                    sourceId: entry.item.sourceId,
                    relativePath: entry.item.fanartRelativePath!,
                  ),
                ),
              );
        final primaryVideo = primaryVideoAsync?.asData?.value;
        final posterFile = posterAsync?.asData?.value;
        final fanartFile = fanartAsync?.asData?.value;
        final hasPlayableFile = primaryVideo != null;

        return DetailPage(
          entry: entry,
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
                  final file = primaryVideo;
                  if (!context.mounted) {
                    return;
                  }
                  final opened = await ref
                      .read(documentTreeAccessProvider)
                      .open(file, title: 'Open with');
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
            unawaited(
              ref.read(libraryActionsProvider).updateRating(mediaId, rating),
            );
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
    final settingsAsync = ref.watch(appSettingsProvider);
    final sourcesAsync = ref.watch(mediaSourcesProvider);
    final latestReport = ref.watch(sourceLastScanReportProvider);

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
          onManageSources: () {
            Navigator.of(context).pushNamed(AppRoutes.sources);
          },
          onRescanAll: () async {
            final report = await ref
                .read(libraryActionsProvider)
                .scanAllSources();
            ref.read(sourceLastScanReportProvider.notifier).setReport(report);
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
            unawaited(ref.read(settingsActionsProvider).save(nextSettings));
          },
          onClearCache: () async {
            await ref.read(settingsActionsProvider).clearImageCache();
            if (context.mounted) {
              _showMessage(context, 'Image cache cleared.');
            }
          },
          onRebuildLibrary: () async {
            await ref.read(libraryActionsProvider).rebuildLibrary();
            if (context.mounted) {
              _showMessage(context, 'Library rebuilt from local sources.');
            }
          },
        );
      },
    );
  }
}

class MediaSourcesRoutePage extends ConsumerWidget {
  const MediaSourcesRoutePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sourcesAsync = ref.watch(mediaSourcesProvider);
    return sourcesAsync.when(
      loading: () => const _RouteLoadingPage(label: 'Loading sources...'),
      error: (error, stackTrace) =>
          _RouteErrorPage(message: 'Failed to load media sources: $error'),
      data: (sources) {
        return MediaSourcesPage(
          sources: sources,
          onAddSource: () async {
            final source = await ref.read(sourcesActionsProvider).addSource();
            if (source != null) {
              await ref.read(sourcesActionsProvider).rescanSource(source.id);
              if (context.mounted) {
                _showMessage(context, 'Source added and initial scan started.');
              }
            }
          },
          onRescan: (sourceId) async {
            final report = await ref
                .read(sourcesActionsProvider)
                .rescanSource(sourceId);
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
            await ref.read(sourcesActionsProvider).reauthorizeSource(sourceId);
            if (context.mounted) {
              _showMessage(context, 'Permission refreshed for this source.');
            }
          },
          onRemove: (sourceId) async {
            await ref.read(sourcesActionsProvider).removeSource(sourceId);
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

  @override
  void initState() {
    super.initState();
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

    try {
      final file = await _resolvePrimaryVideo(ref, entry.item);
      if (file == null) {
        throw StateError('Unable to resolve the local video file.');
      }

      final controller = VideoPlayerController.contentUri(Uri.parse(file.uri));
      await controller.initialize();
      controller.addListener(_onControllerChanged);

      final resumePosition = entry.userState?.lastPositionMs;
      if (resumePosition != null && resumePosition > 0) {
        await controller.seekTo(Duration(milliseconds: resumePosition));
      }

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
    } catch (error) {
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
    final current = controller.value.position;
    final targetMs = (current.inMilliseconds + delta.inMilliseconds).clamp(
      0,
      controller.value.duration.inMilliseconds,
    );
    await controller.seekTo(Duration(milliseconds: targetMs));
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

    await ref
        .read(libraryActionsProvider)
        .updatePlayback(
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
  final relativePath = item.primaryVideoRelativePath;
  if (relativePath == null || relativePath.isEmpty) {
    return null;
  }
  return ref.read(
    relativeDocumentProvider(
      RelativeAssetRequest(sourceId: item.sourceId, relativePath: relativePath),
    ).future,
  );
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
