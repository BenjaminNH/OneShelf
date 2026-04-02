import 'package:flutter/material.dart';

import '../../../app/theme/app_palette.dart';
import '../../../domain/entities/media_entry.dart';
import '../../../domain/entities/media_item.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.entry,
    this.onPlay,
    this.onContinuePlay,
    this.onOpenExternal,
    this.onRatingChanged,
    this.heroImage,
    this.posterImage,
  });

  final MediaEntry entry;
  final VoidCallback? onPlay;
  final VoidCallback? onContinuePlay;
  final VoidCallback? onOpenExternal;
  final ValueChanged<double?>? onRatingChanged;
  final ImageProvider<Object>? heroImage;
  final ImageProvider<Object>? posterImage;

  @override
  Widget build(BuildContext context) {
    final item = entry.item;
    final title = item.resolvedTitle;
    final subtitle = [
      if (item.code != null && item.code!.isNotEmpty) item.code!,
      if (item.durationMs != null) _formatDurationMs(item.durationMs!),
      if (item.width != null && item.height != null)
        '${item.width}x${item.height}',
    ].join(' · ');

    return Scaffold(
      backgroundColor: AppPalette.bg,
      body: Stack(
        children: [
          _HeroLayer(image: heroImage),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopBar(title: title),
                  const SizedBox(height: 16),
                  _PosterAndInfo(
                    title: title,
                    subtitle: subtitle,
                    actorNames: item.actorNames,
                    posterImage: posterImage,
                  ),
                  const SizedBox(height: 16),
                  _ActionRow(
                    hasResume: entry.hasResume,
                    onPlay: onPlay,
                    onContinuePlay: onContinuePlay,
                  ),
                  const SizedBox(height: 12),
                  _SecondaryActions(
                    onOpenExternal: onOpenExternal,
                    currentRating: entry.userState?.ratingValue,
                    onRatingChanged: onRatingChanged,
                  ),
                  const SizedBox(height: 16),
                  _InfoCard(
                    title: 'Synopsis',
                    body: item.plot?.trim().isNotEmpty == true
                        ? item.plot!.trim()
                        : 'No local synopsis found. The entry still stays playable and searchable.',
                  ),
                  const SizedBox(height: 12),
                  _MetaGrid(item: item),
                  const SizedBox(height: 12),
                  _InfoCard(
                    title: 'Media path',
                    body:
                        item.primaryVideoRelativePath ??
                        item.folderRelativePath ??
                        item.fileName,
                    monospaced: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroLayer extends StatelessWidget {
  const _HeroLayer({required this.image});

  final ImageProvider<Object>? image;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppPalette.bgSoft.withValues(alpha: 0.55), AppPalette.bg],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (image != null)
              Opacity(
                opacity: 0.22,
                child: Image(image: image!, fit: BoxFit.cover),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppPalette.bg.withValues(alpha: 0.92),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleButton(
          icon: Icons.arrow_back_rounded,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppPalette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _PosterAndInfo extends StatelessWidget {
  const _PosterAndInfo({
    required this.title,
    required this.subtitle,
    required this.actorNames,
    required this.posterImage,
  });

  final String title;
  final String subtitle;
  final List<String> actorNames;
  final ImageProvider<Object>? posterImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 122,
          height: 184,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: posterImage == null
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF243245), Color(0xFF1A2430)],
                  )
                : null,
            image: posterImage == null
                ? null
                : DecorationImage(image: posterImage!, fit: BoxFit.cover),
            border: Border.all(color: AppPalette.glassBorder),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppPalette.accentDim,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                '4K',
                style: TextStyle(
                  color: AppPalette.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppPalette.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppPalette.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final actor in actorNames.take(3))
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.glass,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppPalette.glassBorder),
                      ),
                      child: Text(
                        actor,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppPalette.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  if (actorNames.isEmpty)
                    Text(
                      'No actor metadata',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppPalette.textMuted,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.hasResume,
    required this.onPlay,
    required this.onContinuePlay,
  });

  final bool hasResume;
  final VoidCallback? onPlay;
  final VoidCallback? onContinuePlay;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: onPlay,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Play now'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: AppPalette.accent,
              foregroundColor: AppPalette.bg,
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: hasResume ? onContinuePlay : null,
            icon: const Icon(Icons.play_circle_outline_rounded),
            label: Text(hasResume ? 'Continue' : 'No resume'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: AppPalette.textPrimary,
              side: const BorderSide(color: AppPalette.glassBorder),
            ),
          ),
        ),
      ],
    );
  }
}

class _SecondaryActions extends StatelessWidget {
  const _SecondaryActions({
    required this.onOpenExternal,
    required this.currentRating,
    required this.onRatingChanged,
  });

  final VoidCallback? onOpenExternal;
  final double? currentRating;
  final ValueChanged<double?>? onRatingChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GlassCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'External player',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppPalette.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: onOpenExternal,
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: const Text('Open'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(42),
                    foregroundColor: AppPalette.textPrimary,
                    backgroundColor: AppPalette.glassStrong,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _GlassCard(
            padding: const EdgeInsets.all(12),
            child: _RatingSelector(
              rating: currentRating,
              onChanged: onRatingChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingSelector extends StatefulWidget {
  const _RatingSelector({required this.rating, required this.onChanged});

  final double? rating;
  final ValueChanged<double?>? onChanged;

  @override
  State<_RatingSelector> createState() => _RatingSelectorState();
}

class _RatingSelectorState extends State<_RatingSelector> {
  late double? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.rating;
  }

  @override
  void didUpdateWidget(covariant _RatingSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rating != oldWidget.rating) {
      _value = widget.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratingText = _value == null
        ? 'Not rated'
        : _value!.toStringAsFixed(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Local rating',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppPalette.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          ratingText,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppPalette.accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        Slider(
          value: _value ?? 0,
          min: 0,
          max: 10,
          divisions: 20,
          activeColor: AppPalette.accent,
          inactiveColor: AppPalette.glassStrong,
          onChanged: (value) {
            setState(() {
              _value = value;
            });
          },
          onChangeEnd: (value) => widget.onChanged?.call(value),
        ),
        TextButton(
          onPressed: _value == null
              ? null
              : () {
                  setState(() {
                    _value = null;
                  });
                  widget.onChanged?.call(null);
                },
          style: TextButton.styleFrom(
            foregroundColor: AppPalette.textMuted,
            minimumSize: const Size(0, 32),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Clear rating'),
        ),
      ],
    );
  }
}

class _MetaGrid extends StatelessWidget {
  const _MetaGrid({required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final pairs = <(String, String)>[
      ('File', item.fileName),
      (
        'Size',
        item.fileSizeBytes == null
            ? 'Unknown'
            : _formatBytes(item.fileSizeBytes),
      ),
      (
        'Resolution',
        item.width == null || item.height == null
            ? 'Unknown'
            : '${item.width} x ${item.height}',
      ),
      ('Source', item.sourceId),
    ];

    return _GlassCard(
      child: Column(
        children: [
          for (var i = 0; i < pairs.length; i++) ...[
            if (i != 0) const Divider(height: 1, color: AppPalette.glassBorder),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      pairs[i].$1,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppPalette.textMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      pairs[i].$2,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppPalette.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.body,
    this.monospaced = false,
  });

  final String title;
  final String body;
  final bool monospaced;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppPalette.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppPalette.textPrimary,
              height: 1.45,
              fontFamily: monospaced ? 'IBM Plex Sans' : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.glass,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppPalette.glassBorder),
          ),
          child: Icon(icon, color: AppPalette.textPrimary),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.glass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.glassBorder),
      ),
      child: Padding(padding: padding ?? const EdgeInsets.all(0), child: child),
    );
  }
}

String _formatDurationMs(int durationMs) {
  final duration = Duration(milliseconds: durationMs);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
}

String _formatBytes(int? bytes) {
  if (bytes == null) return 'Unknown';
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}
