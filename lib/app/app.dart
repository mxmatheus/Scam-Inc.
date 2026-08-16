import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/asset_constants.dart';
import '../core/constants/game_constants.dart';
import '../core/utils/number_formatter.dart';
import '../core/widgets/progress_bar.dart';
import '../core/widgets/scam_button.dart';
import '../core/widgets/scam_card.dart';
import '../core/widgets/scam_icon.dart';
import '../core/widgets/section_header.dart';
import '../services/providers/service_providers.dart';
import 'theme.dart';

class ScamIncApp extends StatelessWidget {
  const ScamIncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GameConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ScamBootstrapScreen(),
    );
  }
}

class ScamBootstrapScreen extends ConsumerWidget {
  const ScamBootstrapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerStateProvider);
    final incomePerSec = ref.watch(incomePerSecondProvider);
    final operations = ref.watch(operationsProvider);

    // Find the first MVP operation: Fake Delivery SMS
    final smsOperation = operations.isNotEmpty
        ? operations.firstWhere(
            (o) => o.id == 'op_fake_delivery_sms',
            orElse: () => operations.first,
          )
        : null;

    final nextCost = smsOperation?.nextUpgradeCost ?? 10.0;
    final canUpgrade = playerState.coins >= nextCost;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header & Branding
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const ScamIcon(
                          assetPath: AppAssets.logoScamInc,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GameConstants.appName,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  letterSpacing: -0.5,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          Text(
                            GameConstants.appTagline,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: IconButton(
                      icon: const ScamIcon(
                        assetPath: AppAssets.coreSettingsGearCog,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Currency Overview Card
              ScamCard(
                backgroundColor: AppColors.surface,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'TOTAL REVENUE',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormatter.formatCurrency(playerState.coins),
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.sCoinsDark,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sCoinsBg,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        NumberFormatter.formatRate(incomePerSec),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.sCoinsDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Trust & Heat Meters
              Row(
                children: [
                  Expanded(
                    child: ScamCard(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TRUST',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: AppColors.trustDark),
                              ),
                              Text(
                                '${playerState.trust.toInt()} PTS',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ProgressBar(
                            progress: playerState.trust / 100.0,
                            fillColor: AppColors.trust,
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ScamCard(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'HEAT',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: AppColors.heatDark),
                              ),
                              Text(
                                '${playerState.heat.toInt()}%',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ProgressBar(
                            progress: playerState.heat / 100.0,
                            fillColor: playerState.heat > 60
                                ? AppColors.heatDanger
                                : AppColors.heat,
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Main Tap Area
              ScamCard(
                onTap: () {
                  ref.read(gameControllerProvider.notifier).tap();
                },
                backgroundColor: AppColors.surface,
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.sCoinsBg,
                          border: Border.all(color: AppColors.sCoins, width: 2),
                        ),
                        child: const Center(
                          child: ScamIcon(
                            assetPath: AppAssets.coreMoneyFaucetTap,
                            size: 36,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'LAUNCH CAMPAIGN',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to generate S-Coins',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Operations Preview Section
              const SectionHeader(
                title: 'Active Operations',
                subtitle: 'Automated digital schemes',
              ),
              if (smsOperation != null)
                ScamCard(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.border),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: ScamIcon(
                          assetPath: smsOperation.iconPath,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              smsOperation.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            Text(
                              'Level ${smsOperation.level} • +${NumberFormatter.formatCurrency(smsOperation.currentIncomePerSecond)}/s',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 12,
                                    color: AppColors.sCoinsDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      ScamButton(
                        label: smsOperation.level == 0
                            ? 'Buy (${NumberFormatter.formatCurrency(nextCost)})'
                            : 'Upgrade (${NumberFormatter.formatCurrency(nextCost)})',
                        onPressed: canUpgrade
                            ? () {
                                ref
                                    .read(gameControllerProvider.notifier)
                                    .buyOperation(smsOperation.id);
                              }
                            : null,
                        variant: canUpgrade
                            ? ScamButtonVariant.success
                            : ScamButtonVariant.secondary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
