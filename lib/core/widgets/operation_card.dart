import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../models/operation.dart';
import '../utils/number_formatter.dart';
import 'scam_card.dart';
import 'scam_icon.dart';
import 'scam_button.dart';

/// Reusable Operation card displaying scheme details, rates, and upgrade actions.
class OperationCard extends StatelessWidget {
  final Operation operation;
  final double currentCoins;
  final double currentTrust;
  final int buyMultiplier; // 1, 10, 100
  final VoidCallback onUpgrade;

  const OperationCard({
    super.key,
    required this.operation,
    required this.currentCoins,
    required this.currentTrust,
    this.buyMultiplier = 1,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLocked = !operation.isUnlocked;
    final cost = operation.calculateUpgradeCost(buyMultiplier);
    final canAfford = currentCoins >= cost;
    final heatRate = operation.heatRate;

    return ScamCard(
      padding: const EdgeInsets.all(14.0),
      backgroundColor: isLocked
          ? (isDark ? AppColors.darkSurfaceMuted : AppColors.surfaceMuted)
          : (isDark ? AppColors.darkSurface : AppColors.surface),
      borderColor: isLocked
          ? (isDark ? AppColors.darkBorder : AppColors.border)
          : (isDark ? AppColors.darkBorder : AppColors.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Operation Icon Frame
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isLocked
                      ? (isDark ? AppColors.darkSurface : AppColors.surface)
                      : (isDark ? AppColors.darkSCoinsBg : AppColors.sCoinsBg),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isLocked
                        ? (isDark ? AppColors.darkBorder : AppColors.border)
                        : AppColors.sCoins,
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(6),
                child: ScamIcon(
                  assetPath: operation.iconPath,
                  size: 32,
                  color: isLocked ? AppColors.textMuted : null,
                ),
              ),
              const SizedBox(width: 12),

              // Title and Tier Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            operation.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isLocked
                                      ? (isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary)
                                      : (isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textPrimary),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isLocked
                          ? 'Requires ${operation.trustRequirement.toInt()} Trust Points'
                          : 'Level ${operation.level} • ${operation.tier.name.replaceAll('tier', 'Tier ')}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isLocked
                            ? AppColors.trust
                            : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary),
                        fontWeight: isLocked
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Level indicator badge
              if (!isLocked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceMuted
                        : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Text(
                    'Lv. ${operation.level}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Bottom Action Row: Income/Heat Stats + Upgrade Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Income & Heat Rates
              Row(
                children: [
                  // Income Rate Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSCoinsBg
                          : AppColors.sCoinsBg,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      isLocked
                          ? '+\$0/s'
                          : '+${NumberFormatter.formatCurrency(operation.incomePerSecond)}/s',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.sCoinsDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Heat Rate Pill (Supports Negative Cooling Heat)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isLocked
                          ? (isDark
                                ? AppColors.darkSurfaceMuted
                                : AppColors.surfaceMuted)
                          : (heatRate < 0
                                ? (isDark
                                      ? AppColors.darkTrustBg
                                      : AppColors.trustBg)
                                : (isDark
                                      ? AppColors.darkHeatBg
                                      : AppColors.heatBg)),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      isLocked
                          ? '+0.0 Heat/s'
                          : (heatRate < 0
                                ? '${heatRate.toStringAsFixed(1)} Heat/s 🛡️'
                                : '+${heatRate.toStringAsFixed(1)} Heat/s'),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isLocked
                            ? (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary)
                            : (heatRate < 0
                                  ? AppColors.trust
                                  : AppColors.heatDanger),
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              // Upgrade / Unlock Button
              ScamButton(
                label: isLocked
                    ? 'Unlock (${NumberFormatter.formatCurrency(operation.baseCost)})'
                    : '+$buyMultiplier (${NumberFormatter.formatCurrency(cost)})',
                onPressed:
                    (canAfford && !isLocked) ||
                        (isLocked &&
                            currentTrust >= operation.trustRequirement &&
                            canAfford)
                    ? onUpgrade
                    : null,
                variant: isLocked
                    ? ScamButtonVariant.secondary
                    : ScamButtonVariant.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
