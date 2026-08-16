import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Reusable modern corporate card container with dynamic Dark/Light theme adaptability.
class ScamCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;

  const ScamCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBg =
        backgroundColor ?? (isDark ? AppColors.darkSurface : AppColors.surface);
    final resolvedBorder =
        borderColor ?? (isDark ? AppColors.darkBorder : AppColors.border);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: resolvedBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: resolvedBorder, width: 1.5),
        boxShadow: isDark ? null : AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
