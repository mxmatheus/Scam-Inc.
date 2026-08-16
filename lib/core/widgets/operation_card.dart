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
    final isLocked = !operation.isUnlocked;
    final cost = operation.calculateUpgradeCost(buyMultiplier);
    final canAfford = currentCoins >= cost;

    return ScamCard(
      padding: const EdgeInsets.all(14.0),
      backgroundColor: isLocked ? AppColors.surfaceMuted : AppColors.surface,
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
                  color: isLocked ? AppColors.surface : AppColors.sCoinsBg,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isLocked ? AppColors.border : AppColors.sCoins,
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
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
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
                            ? AppColors.trustDark
                            : AppColors.textSecondary,
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
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'Lv. ${operation.level}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Rates & Upgrade Row
          if (!isLocked)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Revenue Rate & Heat Generator
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sCoinsBg,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        '+${NumberFormatter.formatCurrency(operation.currentIncomePerSecond)}/s',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.sCoinsDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (operation.baseHeatPerSecond > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.heatBg,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          '+${operation.currentHeatPerSecond.toStringAsFixed(1)} Heat/s',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.heatDark,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Upgrade / Buy Button
                ScamButton(
                  label: operation.level == 0
                      ? 'Unlock (${NumberFormatter.formatCurrency(cost)})'
                      : '+$buyMultiplier (${NumberFormatter.formatCurrency(cost)})',
                  onPressed: canAfford ? onUpgrade : null,
                  variant: canAfford
                      ? ScamButtonVariant.success
                      : ScamButtonVariant.secondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: Text(
                'LOCKED — Reach ${operation.trustRequirement.toInt()} Trust to operate',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
