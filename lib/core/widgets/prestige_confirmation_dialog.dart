import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/constants/asset_constants.dart';
import '../widgets/scam_card.dart';
import '../widgets/scam_button.dart';
import '../widgets/scam_icon.dart';
import '../../services/prestige_service.dart';

/// Confirmation dialog modal before triggering an Offshore Escape Prestige reset.
class PrestigeConfirmationDialog extends StatelessWidget {
  final PrestigeRewardResult result;
  final VoidCallback onConfirmEscape;

  const PrestigeConfirmationDialog({
    super.key,
    required this.result,
    required this.onConfirmEscape,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 24.0,
      ),
      child: ScamCard(
        padding: const EdgeInsets.all(20.0),
        borderColor: AppColors.launderedCash,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Icon
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.launderedCashBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.launderedCash,
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: ScamIcon(
                      assetPath: AppAssets.resOffshoreVipCrown,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'OFFSHORE ESCAPE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: AppColors.launderedCash,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Liquidate your shell companies, evade federal regulators, and escape to a sovereign tax haven.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // Reward Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.launderedCashBg,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.launderedCash),
                ),
                child: Column(
                  children: [
                    Text(
                      'ESTIMATED LAUNDERED CASH YIELD',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.launderedCashDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+${result.launderableCash.toInt()} LC',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppColors.launderedCash,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'New Multiplier: ${result.newPrestigeMultiplier.toStringAsFixed(2)}x Global Boost',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.corporateNavy,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Warnings & Reset Details
              Text(
                '⚠️ WHAT WILL BE RESET:',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.heatDanger,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '• S-Coins balance, scheme levels, and active upgrades reset.\n• Heat risk drops to 0% and Trust resets to baseline.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                '🔒 WHAT STAYS PERMANENT:',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.sCoinsDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '• All Laundered Cash & Prestige Skill Tree perks.\n• Executive statistics, achievements, and settings.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              ScamButton(
                label: 'CONFIRM ESCAPE & LAUNDER',
                onPressed: result.isEligible ? onConfirmEscape : null,
                variant: ScamButtonVariant.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'STAY IN THE CITY',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
