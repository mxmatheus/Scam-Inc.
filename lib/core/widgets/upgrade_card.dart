import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../models/upgrade.dart';
import '../utils/number_formatter.dart';
import 'scam_card.dart';
import 'scam_icon.dart';
import 'scam_button.dart';

/// Reusable card displaying an Operation/Global Multiplier Upgrade.
class UpgradeCard extends StatelessWidget {
  final Upgrade upgrade;
  final double currentCoins;
  final VoidCallback onBuy;

  const UpgradeCard({
    super.key,
    required this.upgrade,
    required this.currentCoins,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final isPurchased = upgrade.isPurchased;
    final canAfford = currentCoins >= upgrade.cost;

    return ScamCard(
      padding: const EdgeInsets.all(12.0),
      backgroundColor: isPurchased ? AppColors.surfaceMuted : AppColors.surface,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isPurchased ? AppColors.surface : AppColors.sCoinsBg,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isPurchased ? AppColors.border : AppColors.sCoins,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(6),
            child: ScamIcon(assetPath: upgrade.iconPath, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        upgrade.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.trustBg,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        '${upgrade.multiplier.toStringAsFixed(0)}x BOOST',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.trustDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  upgrade.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isPurchased)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                'ACTIVE',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.sCoinsDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          else
            ScamButton(
              label: NumberFormatter.formatCurrency(upgrade.cost),
              onPressed: canAfford ? onBuy : null,
              variant: canAfford
                  ? ScamButtonVariant.primary
                  : ScamButtonVariant.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
        ],
      ),
    );
  }
}
