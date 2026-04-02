import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/app_palette.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.backgroundColor = AppPalette.glassStrong,
    this.borderColor = AppPalette.glassBorder,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
