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
    this.effectiveDurationMs,
    this.effectiveWidth,
    this.effectiveHeight,
    this.isResolvingTechnicalMetadata = false,
  });

  final MediaEntry entry;
  final VoidCallback? onPlay;
  final VoidCallback? onContinuePlay;
  final VoidCallback? onOpenExternal;
  final ValueChanged<double?>? onRatingChanged;
  final ImageProvider<Object>? heroImage;
  final ImageProvider<Object>? posterImage;
  final int? effectiveDurationMs;
  final int? effectiveWidth;
  final int? effectiveHeight;
  final bool isResolvingTechnicalMetadata;

  @override
  Widget build(BuildContext context) {
    final item = entry.item;
    final title = item.resolvedTitle;
    final durationMs = effectiveDurationMs ?? item.durationMs;
    final width = effectiveWidth ?? item.width;
    final height = effectiveHeight ?? item.height;
    final resolutionBadge = _buildResolutionBadge(width: width, height: height);
    final subtitle = [
      if (item.code != null && item.code!.isNotEmpty) item.code!,
      if (durationMs != null) _formatDurationMs(durationMs),
      if (width != null && height != null) '${width}x$height',
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
                    resolutionBadge: resolutionBadge,
                  ),
                  const SizedBox(height: 16),
                  _ActionRow(
                    hasResume: entry.hasResume,
                    onPlay: onPlay,
                    onContinuePlay: onContinuePlay,
                    onOpenExternal: onOpenExternal,
                  ),
                  const SizedBox(height: 12),
                  _RatingCard(
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
                  _MetaGrid(
                    item: item,
                    effectiveWidth: width,
                    effectiveHeight: height,
                    isResolvingTechnicalMetadata: isResolvingTechnicalMetadata,
                  ),
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
    required this.resolutionBadge,
  });

  final String title;
  final String subtitle;
  final List<String> actorNames;
  final ImageProvider<Object>? posterImage;
  final String? resolutionBadge;

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
            child: resolutionBadge == null
                ? const SizedBox.shrink()
                : Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppPalette.accentDim,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      resolutionBadge!,
                      style: const TextStyle(
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
    required this.onOpenExternal,
  });

  final bool hasResume;
  final VoidCallback? onPlay;
  final VoidCallback? onContinuePlay;
  final VoidCallback? onOpenExternal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            onPressed: onPlay,
            icon: Icons.play_arrow_rounded,
            label: 'Play now',
            filled: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            onPressed: hasResume ? onContinuePlay : null,
            icon: Icons.play_circle_outline_rounded,
            label: hasResume ? 'Continue' : 'No resume',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            onPressed: onOpenExternal,
            icon: Icons.open_in_new_rounded,
            label: 'Open',
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.filled = false,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = filled ? AppPalette.bg : AppPalette.textPrimary;
    final buttonStyle = filled
        ? FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: AppPalette.accent,
            foregroundColor: foregroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          )
        : OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            foregroundColor: foregroundColor,
            side: const BorderSide(color: AppPalette.glassBorder),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          );

    final child = FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label, maxLines: 1, softWrap: false),
        ],
      ),
    );

    if (filled) {
      return FilledButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: child,
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: child,
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard({
    required this.currentRating,
    required this.onRatingChanged,
  });

  final double? currentRating;
  final ValueChanged<double?>? onRatingChanged;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(12),
      child: _RatingSelector(rating: currentRating, onChanged: onRatingChanged),
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
        const SizedBox(height: 6),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppPalette.accent,
            inactiveTrackColor: AppPalette.glassStrong,
            thumbColor: AppPalette.accentStrong,
            overlayColor: AppPalette.accent.withValues(alpha: 0.18),
            trackHeight: 4,
            activeTickMarkColor: AppPalette.accentStrong,
            inactiveTickMarkColor: AppPalette.textMuted,
            tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 1.8),
          ),
          child: Slider(
            value: _value ?? 0,
            min: 0,
            max: 10,
            divisions: 20,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
            onChangeEnd: (value) => widget.onChanged?.call(value),
          ),
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
  const _MetaGrid({
    required this.item,
    this.effectiveWidth,
    this.effectiveHeight,
    this.isResolvingTechnicalMetadata = false,
  });

  final MediaItem item;
  final int? effectiveWidth;
  final int? effectiveHeight;
  final bool isResolvingTechnicalMetadata;

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
        effectiveWidth == null || effectiveHeight == null
            ? (isResolvingTechnicalMetadata ? 'Reading…' : 'Unknown')
            : '$effectiveWidth x $effectiveHeight',
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

String? _buildResolutionBadge({required int? width, required int? height}) {
  final longerEdge = [width, height].whereType<int>().fold<int>(
    0,
    (current, value) => value > current ? value : current,
  );
  if (longerEdge >= 3800) {
    return '4K';
  }
  if (longerEdge >= 1900) {
    return '1080p';
  }
  if (longerEdge >= 1200) {
    return '720p';
  }
  return null;
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
