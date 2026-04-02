import 'package:flutter/material.dart';

import '../../../app/theme/app_palette.dart';
import '../../../domain/entities/media_source.dart';

class MediaSourcesPage extends StatelessWidget {
  const MediaSourcesPage({
    super.key,
    required this.sources,
    this.onAddSource,
    this.onRescan,
    this.onReauthorize,
    this.onRemove,
  });

  final List<MediaSource> sources;
  final VoidCallback? onAddSource;
  final ValueChanged<String>? onRescan;
  final ValueChanged<String>? onReauthorize;
  final ValueChanged<String>? onRemove;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Storage roots',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppPalette.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Media Sources',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppPalette.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: onAddSource,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add source'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (sources.isEmpty)
              _EmptySourcesCard(onAddSource: onAddSource)
            else
              ...sources.map(
                (source) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SourceCard(
                    source: source,
                    onRescan: onRescan,
                    onReauthorize: onReauthorize,
                    onRemove: onRemove,
                  ),
                ),
              ),
            const SizedBox(height: 6),
            _PolicyCard(),
          ],
        ),
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.source,
    required this.onRescan,
    required this.onReauthorize,
    required this.onRemove,
  });

  final MediaSource source;
  final ValueChanged<String>? onRescan;
  final ValueChanged<String>? onReauthorize;
  final ValueChanged<String>? onRemove;

  @override
  Widget build(BuildContext context) {
    final permissionLost =
        source.permissionStatus == MediaSourcePermissionStatus.lost;
    final statusColor = permissionLost ? AppPalette.danger : AppPalette.success;
    final statusLabel = permissionLost ? 'Permission lost' : 'Healthy';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.glass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.glassBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    source.displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppPalette.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: statusColor.withValues(alpha: 0.16),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Text(
                    statusLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              source.rootUri.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppPalette.textSecondary,
                fontFamily: 'IBM Plex Sans',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${source.mediaCount} media · ${_scanStatusText(source.lastScanStatus)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppPalette.textMuted),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onRescan?.call(source.id),
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text(
                      'Rescan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    style: _actionButtonStyle(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: permissionLost
                        ? () => onReauthorize?.call(source.id)
                        : null,
                    icon: const Icon(Icons.lock_open_rounded, size: 16),
                    label: const Text(
                      'Reauthorize',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    style: _actionButtonStyle(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onRemove?.call(source.id),
                    icon: const Icon(Icons.delete_outline_rounded, size: 16),
                    label: const Text(
                      'Remove',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    style: _actionButtonStyle(
                      foregroundColor: AppPalette.danger,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

ButtonStyle _actionButtonStyle({Color? foregroundColor}) {
  return OutlinedButton.styleFrom(
    foregroundColor: foregroundColor,
    visualDensity: VisualDensity.compact,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    alignment: Alignment.center,
  );
}

class _EmptySourcesCard extends StatelessWidget {
  const _EmptySourcesCard({required this.onAddSource});

  final VoidCallback? onAddSource;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.glass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.glassBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.folder_copy_outlined,
              size: 38,
              color: AppPalette.textSecondary,
            ),
            const SizedBox(height: 10),
            Text(
              'No media source yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppPalette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add phone storage or SD card roots to start your first scan.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppPalette.textSecondary),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onAddSource,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add media source'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.glass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.glassBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan policy',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppPalette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Use deterministic media IDs from relative paths so ratings and playback progress stay stable across rescans.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppPalette.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _scanStatusText(MediaSourceScanStatus status) {
  return switch (status) {
    MediaSourceScanStatus.idle => 'idle',
    MediaSourceScanStatus.scanning => 'scanning',
    MediaSourceScanStatus.completed => 'completed',
    MediaSourceScanStatus.failed => 'failed',
  };
}
