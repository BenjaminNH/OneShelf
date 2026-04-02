import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_palette.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../domain/entities/media_entry.dart';
import '../../../domain/entities/media_item.dart';
import '../../library/application/library_providers.dart';
import '../../sources/application/sources_providers.dart';
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
  static const List<String> _modes = <String>['All', 'Actor', 'Folder'];
  int _activeModeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(libraryEntriesProvider);
    final recentAsync = ref.watch(recentEntriesProvider);
    final sourcesAsync = ref.watch(mediaSourcesProvider);
    final sort = ref.watch(librarySortProvider);

    final entries = entriesAsync.asData?.value ?? const <MediaEntry>[];
    final recentEntries = recentAsync.asData?.value ?? const <MediaEntry>[];
    final sources = sourcesAsync.asData?.value ?? const [];
    final isLoading =
        entriesAsync.isLoading &&
        recentAsync.isLoading &&
        sourcesAsync.isLoading;

    return Scaffold(
      extendBody: true,
      body: FrostedBackground(
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 130),
                    sliver: SliverList.list(
                      children: <Widget>[
                        _HeaderSection(
                          mediaCount: entries.length,
                          sourceCount: sources.length,
                        ),
                        const SizedBox(height: 18),
                        if (recentEntries.isNotEmpty) ...<Widget>[
                          _RecentSection(entries: recentEntries),
                          const SizedBox(height: 20),
                        ],
                        _ArchiveHeading(sort: sort, onSortTap: _showSortMenu),
                        const SizedBox(height: 12),
                        _ModeRow(
                          modes: _modes,
                          selectedIndex: _activeModeIndex,
                          onModeSelected: (int index) {
                            setState(() {
                              _activeModeIndex = index;
                            });
                            if (index != 0) {
                              _showInfo(
                                'Actor and folder browse are planned next. The archive stays focused on the core MVP flow for now.',
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 14),
                        if (isLoading) const _LoadingCard(),
                        if (!isLoading && entries.isEmpty)
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
                          return PosterTile(
                            entry: entry,
                            onTap: () {
                              Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.detail(entry.item.id));
                            },
                          );
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
                  onLeftTap: () {
                    _showInfo(
                      'The bottom archive bar is ready for richer browse modes after the MVP core is stable.',
                    );
                  },
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
        _showInfo('Media source added. First scan has started.');
      }
      return;
    }

    await ref.read(libraryActionsProvider).scanAllSources();
    _showInfo('Library rescan completed.');
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

  void _showInfo(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.mediaCount, required this.sourceCount});

  final int mediaCount;
  final int sourceCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Frosted Archive',
          style: textTheme.labelLarge?.copyWith(
            color: AppPalette.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Library',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 10),
        GlassPanel(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.folder_open_rounded,
                size: 18,
                color: AppPalette.success,
              ),
              const SizedBox(width: 8),
              Text(
                '$sourceCount sources • $mediaCount indexed',
                style: textTheme.labelLarge?.copyWith(
                  color: AppPalette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
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
            height: 104,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: entries.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 10),
              itemBuilder: (BuildContext context, int index) {
                final entry = entries[index];
                return RecentWatchTile(
                  entry: entry,
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.detail(entry.item.id));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchiveHeading extends StatelessWidget {
  const _ArchiveHeading({required this.sort, required this.onSortTap});

  final MediaSort sort;
  final VoidCallback onSortTap;

  @override
  Widget build(BuildContext context) {
    final sortLabel = switch (sort) {
      MediaSort.recentlyAdded => 'Recently added',
      MediaSort.title => 'Title',
      MediaSort.lastPlayed => 'Last played',
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          'Browse archive',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onSortTap,
          style: TextButton.styleFrom(
            foregroundColor: AppPalette.textSecondary,
            visualDensity: VisualDensity.compact,
          ),
          icon: const Icon(Icons.swap_vert_rounded, size: 16),
          label: Text(sortLabel),
        ),
      ],
    );
  }
}

class _ModeRow extends StatelessWidget {
  const _ModeRow({
    required this.modes,
    required this.selectedIndex,
    required this.onModeSelected,
  });

  final List<String> modes;
  final int selectedIndex;
  final ValueChanged<int> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List<Widget>.generate(modes.length, (int index) {
        final selected = index == selectedIndex;
        return ChoiceChip(
          selected: selected,
          onSelected: (_) => onModeSelected(index),
          label: Text(modes[index]),
          selectedColor: AppPalette.accentDim.withValues(alpha: 0.9),
          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected
                ? AppPalette.accentStrong
                : AppPalette.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(
            color: selected ? AppPalette.accent : AppPalette.glassBorder,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        );
      }),
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
