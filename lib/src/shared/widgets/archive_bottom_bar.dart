import 'package:flutter/material.dart';

import '../../app/theme/app_palette.dart';
import 'glass_panel.dart';

class ArchiveBottomBar extends StatelessWidget {
  const ArchiveBottomBar({
    required this.onSearchTap,
    required this.onSettingsTap,
    this.onLeftTap,
    this.leftIcon = Icons.auto_awesome_outlined,
    this.leftTooltip = 'Archive modes',
    super.key,
  });

  final VoidCallback onSearchTap;
  final VoidCallback onSettingsTap;
  final VoidCallback? onLeftTap;
  final IconData leftIcon;
  final String leftTooltip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        borderRadius: BorderRadius.circular(30),
        backgroundColor: AppPalette.glassStrong,
        child: Row(
          children: <Widget>[
            _CircleIconButton(
              icon: leftIcon,
              tooltip: leftTooltip,
              onTap: onLeftTap,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: onSearchTap,
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppPalette.bgSoft.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppPalette.glassBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.search_rounded,
                        color: AppPalette.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Search file name',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppPalette.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _CircleIconButton(
              icon: Icons.tune_rounded,
              tooltip: 'Settings',
              onTap: onSettingsTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        radius: 24,
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppPalette.bgSoft.withValues(alpha: 0.76),
            border: Border.all(color: AppPalette.glassBorder),
          ),
          child: Icon(icon, color: AppPalette.textPrimary, size: 20),
        ),
      ),
    );
  }
}
