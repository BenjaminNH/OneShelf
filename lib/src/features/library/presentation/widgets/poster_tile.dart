import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../data/scanning/scan_rules.dart';
import '../../../../domain/entities/media_entry.dart';

class PosterTile extends StatelessWidget {
  const PosterTile({required this.entry, this.image, this.onTap, super.key});

  final MediaEntry entry;
  final ImageProvider<Object>? image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final seed = entry.item.id.hashCode;
    final gradient = _pickGradient(seed);
    final progress = entry.userState?.progress;
    final posterLabel = _posterLabel(entry);

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppPalette.glassBorder),
          gradient: gradient,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (image != null)
                Positioned.fill(
                  child: Image(image: image!, fit: BoxFit.cover),
                ),
              if (image != null)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.12),
                        ],
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: _ratingBadge(context),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withValues(alpha: 0),
                        Colors.black.withValues(alpha: 0.75),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 18, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          posterLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: AppPalette.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        if (progress != null) ...<Widget>[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              minHeight: 4,
                              value: progress,
                              backgroundColor: AppPalette.glass.withValues(
                                alpha: 0.8,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppPalette.accent,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingBadge(BuildContext context) {
    final rating = entry.userState?.ratingValue;
    if (rating == null) {
      return const SizedBox.shrink();
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.accentDim.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppPalette.accentStrong,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  LinearGradient _pickGradient(int seed) {
    final index = seed.abs() % _gradients.length;
    return _gradients[index];
  }

  String _posterLabel(MediaEntry entry) {
    final parsedTitle = entry.item.title?.trim();
    if (parsedTitle != null && parsedTitle.isNotEmpty) {
      return parsedTitle;
    }
    return fileNameWithoutExtension(entry.item.fileName.trim());
  }
}

const List<LinearGradient> _gradients = <LinearGradient>[
  LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFF3A485E), Color(0xFF1A2434)],
  ),
  LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFF5A4B3A), Color(0xFF28201A)],
  ),
  LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFF423A60), Color(0xFF1F1B30)],
  ),
  LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFF2E5860), Color(0xFF132A30)],
  ),
];

class RecentWatchTile extends StatelessWidget {
  const RecentWatchTile({
    required this.entry,
    this.image,
    this.onTap,
    super.key,
  });

  final MediaEntry entry;
  final ImageProvider<Object>? image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progress = entry.userState?.progress ?? 0;
    final secondaryLabel = entry.item.actorNames.isNotEmpty
        ? entry.item.actorNames.first
        : (entry.item.code?.trim().isNotEmpty == true
              ? entry.item.code!.trim()
              : fileNameWithoutExtension(entry.item.fileName));

    return SizedBox(
      width: 166,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppPalette.surfaceAlt.withValues(alpha: 0.62),
            border: Border.all(color: AppPalette.glassBorder),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 0.68,
                  child: image == null
                      ? const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF41536E),
                                Color(0xFF202A3A),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        )
                      : Image(image: image!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      entry.item.resolvedTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      secondaryLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppPalette.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}% watched',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppPalette.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        value: max(0.02, progress),
                        backgroundColor: AppPalette.bg.withValues(alpha: 0.65),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppPalette.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
