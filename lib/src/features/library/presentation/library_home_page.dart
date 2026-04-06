import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_palette.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../domain/entities/media_entry.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/media_item.dart';
import '../../../domain/entities/media_source.dart';
import '../../library/application/library_providers.dart';
import '../../metadata/metadata_providers.dart';
import '../../settings/application/settings_providers.dart';
import '../../sources/application/sources_providers.dart';
import '../../../shared/media/media_asset_resolver.dart';
import '../../../shared/widgets/archive_bottom_bar.dart';
import '../../../shared/widgets/frosted_background.dart';
import '../../../shared/widgets/glass_panel.dart';
import 'widgets/poster_tile.dart';

class LibraryHomePage extends ConsumerStatefulWidget {
  const LibraryHomePage({super.key});

  @override
  ConsumerState<LibraryHomePage> createState() => _LibraryHomePageState();
}

class _LibraryHomePageState extends ConsumerState<LibraryHomePage> {
  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(libraryEntriesProvider);
    final recentAsync = ref.watch(recentEntriesProvider);
    final settingsAsync = ref.watch(appSettingsProvider);
    final sourcesAsync = ref.watch(mediaSourcesProvider);

    final entries = entriesAsync.asData?.value ?? const <MediaEntry>[];
    final recentEntries = recentAsync.asData?.value ?? const <MediaEntry>[];
    final settings = settingsAsync.asData?.value ?? const AppSettings();
    final sources = sourcesAsync.asData?.value ?? const [];
    final showRecentSection =
        settings.showRecentActivity && recentEntries.isNotEmpty;
    final isLoading =
        entriesAsync.isLoading &&
        recentAsync.isLoading &&
        settingsAsync.isLoading &&
        sourcesAsync.isLoading;
    final isScanning = sources.any(
      (source) => source.lastScanStatus == MediaSourceScanStatus.scanning,
    );
    final showLoadingCard = isLoading || isScanning;

    return Scaffold(
      extendBody: true,
      body: FrostedBackground(
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      18,
                      8,
                      18,
                      entries.isEmpty ? 130 : 0,
                    ),
                    sliver: SliverList.list(
                      children: <Widget>[
                        _HeaderSection(mediaCount: entries.length),
                        const SizedBox(height: 20),
                        if (showRecentSection) ...<Widget>[
                          _RecentSection(entries: recentEntries),
                          const SizedBox(height: 14),
                        ],
                        if (showLoadingCard) const _LoadingCard(),
                        if (!showLoadingCard && entries.isEmpty)
                          _EmptyLibraryCard(
                            hasSources: sources.isNotEmpty,
                            onPrimaryAction: _handlePrimaryAction,
                          ),
                      ],
                    ),
                  ),
                  if (entries.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 150),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.66,
                            ),
                        delegate: SliverChildBuilderDelegate((
                          BuildContext context,
                          int index,
                        ) {
                          final entry = entries[index];
                          return _PosterTileWithArtwork(entry: entry);
                        }, childCount: entries.length),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 14,
              child: SafeArea(
                top: false,
                child: ArchiveBottomBar(
                  onSearchTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.search);
                  },
                  onSettingsTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.settings);
                  },
                  onLeftTap: _showSortMenu,
                  leftIcon: Icons.swap_vert_rounded,
                  leftTooltip: 'Sort archive',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePrimaryAction() async {
    if ((ref.read(mediaSourcesProvider).asData?.value ?? const []).isEmpty) {
      final source = await ref.read(sourcesActionsProvider).addSource();
      if (source != null) {
        await ref.read(sourcesActionsProvider).rescanSource(source.id);
      }
      return;
    }

    await ref.read(libraryActionsProvider).scanAllSources();
  }

  Future<void> _showSortMenu() async {
    final selected = await showModalBottomSheet<MediaSort>(
      context: context,
      backgroundColor: AppPalette.bgElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: MediaSort.values
                  .map((sort) {
                    final label = switch (sort) {
                      MediaSort.recentlyAdded => 'Recently added',
                      MediaSort.title => 'Title',
                      MediaSort.lastPlayed => 'Last played',
                    };
                    return ListTile(
                      title: Text(label),
                      onTap: () => Navigator.of(context).pop(sort),
                    );
                  })
                  .toList(growable: false),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      ref.read(librarySortProvider.notifier).setSort(selected);
    }
  }
}

class _HeaderSection extends ConsumerWidget {
  const _HeaderSection({required this.mediaCount});

  final int mediaCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final metadataStatus = ref.watch(metadataPrefillStatusProvider);
    final isIndexing = metadataStatus.isRunning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'OneShelf',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: GlassPanel(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (isIndexing) ...[
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppPalette.accent,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${metadataStatus.processedItems}/${metadataStatus.totalItems} indexing',
                            maxLines: 1,
                            style: textTheme.labelMedium?.copyWith(
                              color: AppPalette.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ] else ...[
                          const Icon(
                            Icons.grid_view_rounded,
                            size: 14,
                            color: AppPalette.success,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$mediaCount indexed',
                            maxLines: 1,
                            style: textTheme.labelMedium?.copyWith(
                              color: AppPalette.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PosterTileWithArtwork extends ConsumerWidget {
  const _PosterTileWithArtwork({required this.entry});

  final MediaEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relativePath = entry.item.posterRelativePath;
    final hasLocalPoster =
        relativePath != null && relativePath.trim().isNotEmpty;

    File? posterFile;

    if (hasLocalPoster) {
      final artworkAsync = ref.watch(
        relativeImageFileProvider(
          RelativeImageRequest(
            sourceId: entry.item.sourceId,
            relativePath: relativePath,
            uri: entry.item.posterUri,
            lastModified: entry.item.posterLastModified,
            variant: RelativeImageVariant.posterThumb,
          ),
        ),
      );
      posterFile = artworkAsync.asData?.value;
    } else if (entry.item.hasAutoPoster) {
      final autoPosterAsync = ref.watch(
        autoPosterFileProvider(
          AutoPosterRequest(
            mediaId: entry.item.id,
            hasAutoPoster: entry.item.hasAutoPoster,
          ),
        ),
      );
      posterFile = autoPosterAsync.asData?.value;
    }

    return PosterTile(
      key: ValueKey(entry.item.id),
      entry: entry,
      image: posterFile == null ? null : FileImage(posterFile),
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.detail(entry.item.id));
      },
    );
  }
}

class _RecentSection extends StatelessWidget {
  const _RecentSection({required this.entries});

  final List<MediaEntry> entries;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Continue watching',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                'Recent',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppPalette.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 82,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: entries.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 10),
              itemBuilder: (BuildContext context, int index) {
                final entry = entries[index];
                return _RecentWatchTileWithArtwork(entry: entry);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentWatchTileWithArtwork extends ConsumerWidget {
  const _RecentWatchTileWithArtwork({required this.entry});

  final MediaEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relativePath = entry.item.posterRelativePath;
    final artworkAsync = relativePath == null
        ? null
        : ref.watch(
            relativeImageFileProvider(
              RelativeImageRequest(
                sourceId: entry.item.sourceId,
                relativePath: relativePath,
                uri: entry.item.posterUri,
                lastModified: entry.item.posterLastModified,
                variant: RelativeImageVariant.posterThumb,
              ),
            ),
          );
    final image = artworkAsync?.asData?.value;

    return RecentWatchTile(
      key: ValueKey(entry.item.id),
      entry: entry,
      image: image == null ? null : FileImage(image),
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.detail(entry.item.id));
      },
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        children: const [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.6),
          ),
          SizedBox(height: 14),
          Text('Loading your local archive...'),
        ],
      ),
    );
  }
}

class _EmptyLibraryCard extends StatelessWidget {
  const _EmptyLibraryCard({
    required this.hasSources,
    required this.onPrimaryAction,
  });

  final bool hasSources;
  final Future<void> Function() onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        children: [
          const Icon(
            Icons.video_library_outlined,
            size: 40,
            color: AppPalette.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            hasSources
                ? 'Your shelves are connected'
                : 'Your archive is waiting',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            hasSources
                ? 'Run a scan to index local video files, poster.jpg, fanart.jpg, and .nfo metadata.'
                : 'Add a phone storage or SD card root. The first scan builds your local poster wall.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppPalette.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onPrimaryAction,
            icon: Icon(hasSources ? Icons.refresh_rounded : Icons.add_rounded),
            label: Text(hasSources ? 'Scan library' : 'Add media source'),
          ),
        ],
      ),
    );
  }
}
