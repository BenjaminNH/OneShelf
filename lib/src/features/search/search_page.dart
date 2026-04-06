import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_palette.dart';
import '../../core/navigation/app_routes.dart';
import '../../data/scanning/scan_rules.dart';
import '../../domain/entities/media_entry.dart';
import '../library/application/library_providers.dart';
import '../../shared/media/media_asset_resolver.dart';
import '../../shared/widgets/frosted_background.dart';
import '../../shared/widgets/glass_panel.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchEntriesProvider);
    final results = resultsAsync.asData?.value ?? const <MediaEntry>[];

    return Scaffold(
      body: FrostedBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeader(context),
                const SizedBox(height: 14),
                GlassPanel(
                  padding: const EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(20),
                  child: Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.search_rounded,
                          color: AppPalette.textSecondary,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          autofocus: true,
                          onChanged: ref
                              .read(searchQueryProvider.notifier)
                              .setQuery,
                          style: Theme.of(context).textTheme.bodyLarge,
                          decoration: const InputDecoration(
                            hintText: 'Find by file name',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isCollapsed: true,
                          ),
                        ),
                      ),
                      if (query.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            _controller.clear();
                            ref.read(searchQueryProvider.notifier).setQuery('');
                          },
                          icon: const Icon(Icons.close_rounded),
                          color: AppPalette.textMuted,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const <Widget>[_HintChip(text: 'File name only')],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: resultsAsync.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : results.isEmpty
                      ? _EmptyStateCard(query: query)
                      : _ResultsCard(results: results),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Archive Search',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppPalette.textSecondary,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Find by file name',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultsCard extends StatelessWidget {
  const _ResultsCard({required this.results});

  final List<MediaEntry> results;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Results',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            '${results.length} items matched',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppPalette.textMuted),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: results.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: AppPalette.glassBorder.withValues(alpha: 0.6),
                height: 14,
              ),
              itemBuilder: (BuildContext context, int index) {
                final entry = results[index];
                return _SearchResultTile(entry: entry);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends ConsumerWidget {
  const _SearchResultTile({required this.entry});

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

    final subtitle = _resultSubtitle(entry);

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.detail(entry.item.id));
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 38,
          height: 54,
          child: posterFile == null
              ? const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xFF41536E), Color(0xFF202A3A)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                )
              : Image.file(posterFile, fit: BoxFit.cover),
        ),
      ),
      title: Text(
        entry.item.resolvedTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppPalette.textSecondary),
            ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppPalette.textMuted,
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: BorderRadius.circular(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.search_off_rounded,
              size: 42,
              color: AppPalette.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              'No result example',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              query.trim().isEmpty
                  ? 'Search starts from the local filename index built during scans.'
                  : 'No file matched "$query". Try another filename fragment.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppPalette.textSecondary,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HintChip extends StatelessWidget {
  const _HintChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.glass,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPalette.glassBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppPalette.textSecondary),
        ),
      ),
    );
  }
}

String? _resultSubtitle(MediaEntry entry) {
  final title = entry.item.resolvedTitle.trim().toLowerCase();
  final fileName = entry.item.fileName.trim();
  final fileStem = fileNameWithoutExtension(fileName).trim().toLowerCase();
  if (fileName.isEmpty ||
      title == fileName.toLowerCase() ||
      title == fileStem) {
    return null;
  }
  return fileName;
}
