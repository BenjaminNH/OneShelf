class MediaUserState {
  const MediaUserState({
    required this.mediaId,
    this.ratingValue,
    this.lastPositionMs,
    this.durationMsSnapshot,
    this.lastPlayedAt,
    this.playCount = 0,
    this.isFinished = false,
  });

  final String mediaId;
  final double? ratingValue;
  final int? lastPositionMs;
  final int? durationMsSnapshot;
  final DateTime? lastPlayedAt;
  final int playCount;
  final bool isFinished;

  double? get progress {
    final duration = durationMsSnapshot;
    final position = lastPositionMs;
    if (duration == null || duration <= 0 || position == null) {
      return null;
    }
    return (position / duration).clamp(0.0, 1.0);
  }
}
