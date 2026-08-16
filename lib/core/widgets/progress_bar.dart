import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Clean animated progress bar for Heat, Trust, and operation cooldowns.
class ProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color fillColor;
  final Color backgroundColor;
  final double height;
  final BorderRadius? borderRadius;

  const ProgressBar({
    super.key,
    required this.progress,
    this.fillColor = AppColors.corporateNavy,
    this.backgroundColor = AppColors.surfaceMuted,
    this.height = 8.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.pill);

    return Container(
      height: height,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: radius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: constraints.maxWidth * clampedProgress,
                height: height,
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: radius,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
