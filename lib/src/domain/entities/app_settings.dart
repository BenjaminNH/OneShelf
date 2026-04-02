class AppSettings {
  const AppSettings({
    this.preferExternalPlayer = false,
    this.seekBackwardSeconds = 10,
    this.seekForwardSeconds = 10,
    this.holdSpeed = 2.0,
    this.rememberPlaybackSpeed = true,
    this.keepResumeHistory = true,
  });

  final bool preferExternalPlayer;
  final int seekBackwardSeconds;
  final int seekForwardSeconds;
  final double holdSpeed;
  final bool rememberPlaybackSpeed;
  final bool keepResumeHistory;

  AppSettings copyWith({
    bool? preferExternalPlayer,
    int? seekBackwardSeconds,
    int? seekForwardSeconds,
    double? holdSpeed,
    bool? rememberPlaybackSpeed,
    bool? keepResumeHistory,
  }) {
    return AppSettings(
      preferExternalPlayer: preferExternalPlayer ?? this.preferExternalPlayer,
      seekBackwardSeconds: seekBackwardSeconds ?? this.seekBackwardSeconds,
      seekForwardSeconds: seekForwardSeconds ?? this.seekForwardSeconds,
      holdSpeed: holdSpeed ?? this.holdSpeed,
      rememberPlaybackSpeed:
          rememberPlaybackSpeed ?? this.rememberPlaybackSpeed,
      keepResumeHistory: keepResumeHistory ?? this.keepResumeHistory,
    );
  }
}
