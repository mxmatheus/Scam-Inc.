import 'package:flutter/material.dart';
import '../../app/theme.dart';

enum ScamButtonVariant { primary, secondary, danger, success, ghost }

class ScamButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final ScamButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;

  const ScamButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = ScamButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color borderColor;

    switch (variant) {
      case ScamButtonVariant.primary:
        bgColor = AppColors.corporateNavy;
        textColor = Colors.white;
        borderColor = AppColors.corporateNavy;
        break;
      case ScamButtonVariant.secondary:
        bgColor = AppColors.surfaceMuted;
        textColor = AppColors.textPrimary;
        borderColor = AppColors.border;
        break;
      case ScamButtonVariant.danger:
        bgColor = AppColors.heatBg;
        textColor = AppColors.heatDanger;
        borderColor = AppColors.heatDanger.withValues(alpha: 0.3);
        break;
      case ScamButtonVariant.success:
        bgColor = AppColors.sCoins;
        textColor = Colors.white;
        borderColor = AppColors.sCoinsDark;
        break;
      case ScamButtonVariant.ghost:
        bgColor = Colors.transparent;
        textColor = AppColors.textSecondary;
        borderColor = Colors.transparent;
        break;
    }

    final bool enabled = onPressed != null && !isLoading;

    final button = Container(
      decoration: BoxDecoration(
        color: enabled ? bgColor : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: enabled ? borderColor : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                ] else if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: enabled ? textColor : AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
