import 'package:flutter/material.dart';

import '../../app/theme/app_palette.dart';

class FrostedBackground extends StatelessWidget {
  const FrostedBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFF151C24), AppPalette.bg],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: -160,
            left: -70,
            child: _glow(
              color: AppPalette.accent.withValues(alpha: 0.18),
              size: 300,
            ),
          ),
          Positioned(
            top: 70,
            right: -110,
            child: _glow(
              color: const Color(0xFF5F88C3).withValues(alpha: 0.22),
              size: 320,
            ),
          ),
          Positioned(
            bottom: -180,
            left: -80,
            child: _glow(
              color: const Color(0xFF1F334F).withValues(alpha: 0.33),
              size: 340,
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _glow({required Color color, required double size}) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
