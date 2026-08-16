import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'scam_icon.dart';

/// Compact chip for displaying a game resource with an icon, label, and value.
class ResourceChip extends StatelessWidget {
  final String iconAsset;
  final String label;
  final String value;
  final Color accentColor;
  final Color backgroundColor;

  const ResourceChip({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.value,
    this.accentColor = AppColors.corporateNavy,
    this.backgroundColor = AppColors.surfaceMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScamIcon(assetPath: iconAsset, size: 18),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w800,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
