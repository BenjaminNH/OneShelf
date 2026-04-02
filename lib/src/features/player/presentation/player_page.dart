import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../app/theme/app_palette.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({
    super.key,
    required this.title,
    this.controller,
    this.position = Duration.zero,
    this.total = Duration.zero,
    this.backwardSeek = const Duration(seconds: 10),
    this.forwardSeek = const Duration(seconds: 10),
    this.holdSpeedLabel = '2.0x',
    this.isPlaying = false,
    this.onBack,
    this.onPlayPause,
    this.onSeekRelative,
    this.onHoldSpeedStart,
    this.onHoldSpeedEnd,
    this.onSpeedTap,
    this.onModeTap,
  });

  final String title;
  final VideoPlayerController? controller;
  final Duration position;
  final Duration total;
  final Duration backwardSeek;
  final Duration forwardSeek;
  final String holdSpeedLabel;
  final bool isPlaying;
  final VoidCallback? onBack;
  final VoidCallback? onPlayPause;
  final ValueChanged<Duration>? onSeekRelative;
  final VoidCallback? onHoldSpeedStart;
  final VoidCallback? onHoldSpeedEnd;
  final VoidCallback? onSpeedTap;
  final VoidCallback? onModeTap;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool _showOverlay = true;
  Timer? _overlayTimer;

  @override
  void dispose() {
    _overlayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.total;
    final position = widget.position;
    final progress = total.inMilliseconds <= 0
        ? 0.0
        : (position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleOverlay,
        child: Stack(
          children: [
            Positioned.fill(
              child: _PlayerViewport(controller: widget.controller),
            ),
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onDoubleTap: () =>
                          widget.onSeekRelative?.call(-widget.backwardSeek),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onDoubleTap: widget.onPlayPause,
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onDoubleTap: () =>
                          widget.onSeekRelative?.call(widget.forwardSeek),
                      onLongPressStart: (_) => widget.onHoldSpeedStart?.call(),
                      onLongPressEnd: (_) => widget.onHoldSpeedEnd?.call(),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: _showOverlay ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: IgnorePointer(
                ignoring: !_showOverlay,
                child: _PlayerOverlay(
                  title: widget.title,
                  isPlaying: widget.isPlaying,
                  position: position,
                  total: total,
                  progress: progress,
                  onBack:
                      widget.onBack ?? () => Navigator.of(context).maybePop(),
                  onPlayPause: widget.onPlayPause,
                  onSeekChanged: (value) {
                    final target = Duration(
                      milliseconds: (total.inMilliseconds * value).round(),
                    );
                    widget.onSeekRelative?.call(target - position);
                  },
                  onSeekBack: () =>
                      widget.onSeekRelative?.call(-widget.backwardSeek),
                  onSeekForward: () =>
                      widget.onSeekRelative?.call(widget.forwardSeek),
                  holdSpeedLabel: widget.holdSpeedLabel,
                  onSpeedTap: widget.onSpeedTap,
                  onModeTap: widget.onModeTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
    if (_showOverlay) {
      _scheduleOverlayDismiss();
    }
  }

  void _scheduleOverlayDismiss() {
    _overlayTimer?.cancel();
    _overlayTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        _showOverlay = false;
      });
    });
  }
}

class _PlayerViewport extends StatelessWidget {
  const _PlayerViewport({required this.controller});

  final VideoPlayerController? controller;

  @override
  Widget build(BuildContext context) {
    final localController = controller;
    if (localController == null || !localController.value.isInitialized) {
      return DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF161C26), Color(0xFF090B10)],
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.play_circle_outline_rounded,
            size: 64,
            color: AppPalette.textSecondary,
          ),
        ),
      );
    }
    return Center(
      child: AspectRatio(
        aspectRatio: localController.value.aspectRatio,
        child: VideoPlayer(localController),
      ),
    );
  }
}

class _PlayerOverlay extends StatelessWidget {
  const _PlayerOverlay({
    required this.title,
    required this.isPlaying,
    required this.position,
    required this.total,
    required this.progress,
    required this.onBack,
    required this.onPlayPause,
    required this.onSeekChanged,
    required this.onSeekBack,
    required this.onSeekForward,
    required this.holdSpeedLabel,
    required this.onSpeedTap,
    required this.onModeTap,
  });

  final String title;
  final bool isPlaying;
  final Duration position;
  final Duration total;
  final double progress;
  final VoidCallback onBack;
  final VoidCallback? onPlayPause;
  final ValueChanged<double> onSeekChanged;
  final VoidCallback? onSeekBack;
  final VoidCallback? onSeekForward;
  final String holdSpeedLabel;
  final VoidCallback? onSpeedTap;
  final VoidCallback? onModeTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.55),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.72),
          ],
          stops: const [0, 0.45, 1],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  _ChipButton(
                    icon: Icons.arrow_back_rounded,
                    label: 'Back',
                    onTap: onBack,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ChipButton(
                    icon: Icons.speed_rounded,
                    label: 'Speed',
                    onTap: onSpeedTap,
                  ),
                  const SizedBox(width: 8),
                  _ChipButton(
                    icon: Icons.settings_input_component_rounded,
                    label: 'Mode',
                    onTap: onModeTap,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '${_formatDuration(position)} / ${_formatDuration(total)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.textSecondary,
                  fontFamily: 'IBM Plex Sans',
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppPalette.accent,
                  inactiveTrackColor: AppPalette.glassStrong,
                  thumbColor: AppPalette.accentStrong,
                  overlayColor: AppPalette.accent.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: progress,
                  min: 0,
                  max: 1,
                  onChanged: onSeekChanged,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _RoundIconButton(
                    icon: Icons.replay_10_rounded,
                    onTap: onSeekBack,
                  ),
                  const SizedBox(width: 20),
                  _RoundIconButton(
                    icon: isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    size: 58,
                    onTap: onPlayPause,
                  ),
                  const SizedBox(width: 20),
                  _RoundIconButton(
                    icon: Icons.forward_10_rounded,
                    onTap: onSeekForward,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _HintCard(
                      title: 'Double tap left',
                      body: 'Jump backward',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _HintCard(
                      title: 'Double tap right',
                      body: 'Jump forward',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _HintCard(
                      title: 'Long press right',
                      body: 'Temporary $holdSpeedLabel',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.glass,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppPalette.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppPalette.textPrimary),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppPalette.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, this.size = 46, this.onTap});

  final IconData icon;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.glass,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppPalette.glassBorder),
          ),
          child: Icon(icon, color: AppPalette.textPrimary, size: size * 0.56),
        ),
      ),
    );
  }
}

class _HintCard extends StatelessWidget {
  const _HintCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.glass,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPalette.glassBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppPalette.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppPalette.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDuration(Duration value) {
  final totalSeconds = value.inSeconds;
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;
  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
