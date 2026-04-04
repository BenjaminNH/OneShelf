import 'package:flutter/material.dart';

import '../../../app/theme/app_palette.dart';

class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.bg,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppPalette.bgSoft.withValues(alpha: 0.3),
                  AppPalette.bg,
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBarSkeleton(),
                  const SizedBox(height: 16),
                  _buildPosterAndInfoSkeleton(),
                  const SizedBox(height: 16),
                  _buildActionRowSkeleton(),
                  const SizedBox(height: 12),
                  _buildCardSkeleton(height: 80),
                  const SizedBox(height: 16),
                  _buildCardSkeleton(height: 100),
                  const SizedBox(height: 12),
                  _buildCardSkeleton(height: 120),
                  const SizedBox(height: 12),
                  _buildCardSkeleton(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBarSkeleton() {
    return Row(
      children: [
        _buildCircleSkeleton(44),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              color: AppPalette.glass,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPosterAndInfoSkeleton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 122,
          height: 184,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppPalette.glass,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: AppPalette.glass,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppPalette.glass,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  3,
                  (i) => Container(
                    width: 60 + i * 10.0,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppPalette.glass,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionRowSkeleton() {
    return Row(
      children: List.generate(
        3,
        (i) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 2 ? 10 : 0),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppPalette.glass,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSkeleton({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppPalette.glass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.glassBorder),
      ),
    );
  }

  Widget _buildCircleSkeleton(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppPalette.glass,
        shape: BoxShape.circle,
        border: Border.all(color: AppPalette.glassBorder),
      ),
    );
  }
}
