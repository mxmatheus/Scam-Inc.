import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/utils/number_formatter.dart';
import '../../services/offline_income_service.dart';
import 'scam_card.dart';
import 'scam_icon.dart';
import 'scam_button.dart';

/// Modal dialog presented when player returns from offline away time.
class OfflineSummaryDialog extends StatelessWidget {
  final OfflineEarningsResult result;
  final VoidCallback onClaim;

  const OfflineSummaryDialog({
    super.key,
    required this.result,
    required this.onClaim,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '$hours hrs $minutes mins';
    }
    return '$minutes mins';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ScamCard(
        padding: const EdgeInsets.all(24.0),
        backgroundColor: AppColors.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.sCoinsBg,
                  border: Border.all(color: AppColors.sCoins, width: 2),
                ),
                child: const Center(
                  child: ScamIcon(
                    assetPath: AppAssets.resLaunderedCash,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'WELCOME BACK, BOSS!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your digital syndicates kept printing cash while you were away (${_formatDuration(result.cappedDuration)}).',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            // Revenue Reward Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.sCoinsBg,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.sCoins),
              ),
              child: Column(
                children: [
                  Text(
                    'OFFLINE REVENUE COLLECTED',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.sCoinsDark,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+${NumberFormatter.formatCurrency(result.earnedCoins)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.sCoinsDark,
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Claim Button
            ScamButton(
              label: 'CLAIM S-COINS',
              onPressed: onClaim,
              variant: ScamButtonVariant.success,
              isFullWidth: true,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ],
        ),
      ),
    );
  }
}
