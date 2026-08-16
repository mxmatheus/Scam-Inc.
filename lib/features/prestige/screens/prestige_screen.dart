import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/widgets/scam_button.dart';
import '../../../core/widgets/scam_card.dart';
import '../../../core/widgets/scam_icon.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/prestige_confirmation_dialog.dart';
import '../../../services/providers/service_providers.dart';

class PrestigeScreen extends ConsumerWidget {
  const PrestigeScreen({super.key});

  void _showPrestigeDialog(BuildContext context, WidgetRef ref) {
    final playerState = ref.read(playerStateProvider);
    final prestigeService = ref.read(prestigeServiceProvider);
    final eval = prestigeService.evaluatePrestigeEligibility(playerState);

    showDialog(
      context: context,
      builder: (ctx) => PrestigeConfirmationDialog(
        result: eval,
        onConfirmEscape: () {
          final success = ref
              .read(gameControllerProvider.notifier)
              .executePrestigeReset();
          Navigator.of(ctx).pop();
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  '🌴 Offshore Escape Successful! Laundered Cash secured & multipliers applied.',
                ),
                backgroundColor: AppColors.launderedCashDark,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerStateProvider);
    final prestigeSkills = ref.watch(prestigeSkillsProvider);
    final prestigeService = ref.watch(prestigeServiceProvider);
    final eval = prestigeService.evaluatePrestigeEligibility(playerState);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Offshore Syndicate',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Launder illicit revenue, escape authorities & buy permanent empire skills.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Laundered Cash & Prestige Status Card
          ScamCard(
            borderColor: AppColors.launderedCash,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const ScamIcon(
                  assetPath: AppAssets.resOffshoreVipCrown,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'LAUNDERED CASH BALANCE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.launderedCash,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${playerState.launderedCash.toInt()} LC',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.launderedCash,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.launderedCashBg,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    'Prestige Level: ${playerState.prestigeLevel} (${playerState.prestigeMultiplier.toStringAsFixed(2)}x Global Multiplier)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.corporateNavy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ScamButton(
                  label: eval.isEligible
                      ? 'EXECUTE OFFSHORE ESCAPE (+${eval.launderableCash.toInt()} LC)'
                      : 'ESCAPE LOCKED (Earn More Lifetime Revenue)',
                  onPressed: eval.isEligible
                      ? () => _showPrestigeDialog(context, ref)
                      : null,
                  variant: ScamButtonVariant.primary,
                  isFullWidth: true,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Permanent Skill Tree Section
          const SectionHeader(
            title: 'Permanent Skill Tree',
            subtitle: 'Spend Laundered Cash on everlasting perks',
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: prestigeSkills.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              final skill = prestigeSkills[idx];
              final isMaxed = skill.level >= skill.maxLevel;
              final cost = skill.calculateCost();
              final canAfford = playerState.launderedCash >= cost && !isMaxed;

              return ScamCard(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.launderedCashBg,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.launderedCash),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: ScamIcon(assetPath: skill.iconPath, size: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  skill.name,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                              Text(
                                'Lv. ${skill.level}/${skill.maxLevel}',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: isMaxed
                                          ? AppColors.sCoinsDark
                                          : AppColors.launderedCash,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            skill.description,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          if (isMaxed)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.sCoinsBg,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                              ),
                              child: Text(
                                'MAX LEVEL REACHED',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppColors.sCoinsDark,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            )
                          else
                            ScamButton(
                              label: 'UPGRADE (${cost.toInt()} LC)',
                              onPressed: canAfford
                                  ? () {
                                      ref
                                          .read(gameControllerProvider.notifier)
                                          .buyPrestigeSkill(skill.id);
                                    }
                                  : null,
                              variant: canAfford
                                  ? ScamButtonVariant.primary
                                  : ScamButtonVariant.secondary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
