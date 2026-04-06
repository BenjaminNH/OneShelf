import 'package:flutter/material.dart';

import '../../../app/theme/app_palette.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/scan_report.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.settings,
    this.latestScanReport,
    this.posterCacheSizeLabel,
    this.permissionHealthLabel,
    this.onManageSources,
    this.onRescanAll,
    this.onSave,
    this.onClearCache,
    this.onRebuildLibrary,
    this.onShareDebugLog,
    this.onClearDebugLog,
    this.debugLogPathLabel,
    this.showProfileLogging = true,
    this.onExportBackup,
    this.onImportBackup,
  });

  final AppSettings settings;
  final ScanReport? latestScanReport;
  final String? posterCacheSizeLabel;
  final String? permissionHealthLabel;
  final VoidCallback? onManageSources;
  final VoidCallback? onRescanAll;
  final ValueChanged<AppSettings>? onSave;
  final VoidCallback? onClearCache;
  final VoidCallback? onRebuildLibrary;
  final VoidCallback? onShareDebugLog;
  final VoidCallback? onClearDebugLog;
  final String? debugLogPathLabel;
  final bool showProfileLogging;
  final VoidCallback? onExportBackup;
  final VoidCallback? onImportBackup;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AppSettings _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.settings;
  }

  @override
  void didUpdateWidget(covariant SettingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      _draft = widget.settings;
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.latestScanReport;
    final reportText = report == null
        ? 'No scan history yet.'
        : report.hasError
        ? 'Last scan failed: ${report.errorMessage}'
        : 'Last scan: ${report.itemsFound} found · ${report.itemsUpdated} updated · ${report.itemsMissing} missing';

    return Scaffold(
      backgroundColor: AppPalette.bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.55, -0.9),
                  radius: 1.08,
                  colors: [
                    AppPalette.bgSoft.withValues(alpha: 0.92),
                    AppPalette.bg,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Text(
                  'Management',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppPalette.textMuted,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppPalette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Quiet utility cards instead of a crowded system-settings wall.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppPalette.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                _GlassCard(
                  child: _SectionColumn(
                    title: 'Media sources',
                    subtitle:
                        'Phone storage and SD card stay visible as first-class shelves.',
                    child: FilledButton.tonalIcon(
                      onPressed: widget.onManageSources,
                      icon: const Icon(Icons.folder_open_rounded),
                      label: const Text('Manage sources'),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _GlassCard(
                  child: _SectionColumn(
                    title: 'Scan',
                    subtitle: reportText,
                    child: Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: widget.onRescanAll,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Rescan all'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: widget.onRebuildLibrary,
                            icon: const Icon(Icons.construction_rounded),
                            label: const Text('Full rebuild'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _GlassCard(
                  child: _SectionColumn(
                    title: 'Playback preferences',
                    subtitle:
                        'Set defaults for gestures and playback behavior. All actions stay explicit in player UI.',
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Prefer external player'),
                          value: _draft.preferExternalPlayer,
                          activeThumbColor: AppPalette.accent,
                          onChanged: (value) => _update(
                            _draft.copyWith(preferExternalPlayer: value),
                          ),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Remember playback speed'),
                          value: _draft.rememberPlaybackSpeed,
                          activeThumbColor: AppPalette.accent,
                          onChanged: (value) => _update(
                            _draft.copyWith(rememberPlaybackSpeed: value),
                          ),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Show playback progress'),
                          value: _draft.keepResumeHistory,
                          activeThumbColor: AppPalette.accent,
                          onChanged: (value) => _update(
                            _draft.copyWith(keepResumeHistory: value),
                          ),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Show recent watching'),
                          value: _draft.showRecentActivity,
                          activeThumbColor: AppPalette.accent,
                          onChanged: (value) => _update(
                            _draft.copyWith(showRecentActivity: value),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _LabeledSlider(
                          label: 'Seek backward',
                          valueLabel: '${_draft.seekBackwardSeconds}s',
                          min: 5,
                          max: 60,
                          divisions: 11,
                          value: _draft.seekBackwardSeconds.toDouble(),
                          onChanged: (value) => _update(
                            _draft.copyWith(seekBackwardSeconds: value.round()),
                          ),
                        ),
                        _LabeledSlider(
                          label: 'Seek forward',
                          valueLabel: '${_draft.seekForwardSeconds}s',
                          min: 5,
                          max: 60,
                          divisions: 11,
                          value: _draft.seekForwardSeconds.toDouble(),
                          onChanged: (value) => _update(
                            _draft.copyWith(seekForwardSeconds: value.round()),
                          ),
                        ),
                        _LabeledSlider(
                          label: 'Hold-right speed',
                          valueLabel: '${_draft.holdSpeed.toStringAsFixed(1)}x',
                          min: 1.25,
                          max: 3.0,
                          divisions: 7,
                          value: _draft.holdSpeed,
                          onChanged: (value) =>
                              _update(_draft.copyWith(holdSpeed: value)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _GlassCard(
                  child: _SectionColumn(
                    title: 'Cache & permissions',
                    subtitle:
                        'Poster cache ${widget.posterCacheSizeLabel ?? 'Unknown'} · Permissions ${widget.permissionHealthLabel ?? 'Unknown'}',
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: widget.onClearCache,
                            icon: const Icon(Icons.cleaning_services_rounded),
                            label: const Text('Clear cache'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _GlassCard(
                  child: _SectionColumn(
                    title: 'Backup & restore',
                    subtitle:
                        'Export your ratings and playback progress to a JSON file. Import to restore after clearing data.',
                    child: Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: widget.onExportBackup,
                            icon: const Icon(Icons.file_upload_rounded),
                            label: const Text('Export'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: widget.onImportBackup,
                            icon: const Icon(Icons.file_download_rounded),
                            label: const Text('Import'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.showProfileLogging) ...[
                  const SizedBox(height: 12),
                  _GlassCard(
                    child: _SectionColumn(
                      title: 'Profile logging',
                      subtitle:
                          'Performance logs are written to ${widget.debugLogPathLabel ?? 'app storage'}. Run a repro on the phone, then share the log file back.',
                      child: Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: widget.onShareDebugLog,
                              icon: const Icon(Icons.ios_share_rounded),
                              label: const Text('Share log'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: widget.onClearDebugLog,
                              icon: const Icon(Icons.delete_sweep_rounded),
                              label: const Text('Clear log'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _update(AppSettings value) {
    setState(() {
      _draft = value;
    });
    widget.onSave?.call(_draft);
  }
}

class _SectionColumn extends StatelessWidget {
  const _SectionColumn({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppPalette.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppPalette.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _LabeledSlider extends StatelessWidget {
  const _LabeledSlider({
    required this.label,
    required this.valueLabel,
    required this.min,
    required this.max,
    required this.divisions,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String valueLabel;
  final double min;
  final double max;
  final int divisions;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                valueLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppPalette.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: AppPalette.accent,
            inactiveColor: AppPalette.glassStrong,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.glass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.glassBorder),
      ),
      child: Padding(padding: const EdgeInsets.all(14), child: child),
    );
  }
}
