import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../core/widgets/scam_button.dart';
import '../../../core/widgets/scam_card.dart';
import '../../../core/widgets/scam_icon.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/operation_card.dart';
import '../../../core/widgets/upgrade_card.dart';
import '../../../core/widgets/offline_summary_dialog.dart';
import '../../../services/providers/service_providers.dart';
import '../../../services/heat_service.dart';

class MainDashboardScreen extends ConsumerStatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  ConsumerState<MainDashboardScreen> createState() =>
      _MainDashboardScreenState();
}

class _MainDashboardScreenState extends ConsumerState<MainDashboardScreen> {
  int _selectedTabIndex = 0;
  int _buyMultiplier = 1; // 1, 10, 100
  bool _offlineDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOfflineEarnings();
    });
  }

  void _checkOfflineEarnings() {
    if (_offlineDialogShown) return;
    final controller = ref.read(gameControllerProvider.notifier);
    final pending = controller.pendingOfflineEarnings;

    if (pending != null && pending.isEligible) {
      _offlineDialogShown = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => OfflineSummaryDialog(
          result: pending,
          onClaim: () {
            controller.claimOfflineEarnings();
            Navigator.of(ctx).pop();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTabIndex,
          children: [
            _buildHomeTab(),
            _buildOperationsTab(),
            _buildEventsTab(),
            _buildPrestigeTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1.5)),
        ),
        child: NavigationBar(
          selectedIndex: _selectedTabIndex,
          onDestinationSelected: (idx) {
            setState(() {
              _selectedTabIndex = idx;
            });
          },
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.sCoinsBg,
          destinations: const [
            NavigationDestination(
              icon: ScamIcon(assetPath: AppAssets.coreCashBriefcase, size: 22),
              label: 'HQ',
            ),
            NavigationDestination(
              icon: ScamIcon(
                assetPath: AppAssets.coreArrowUpCircleUpgrade,
                size: 22,
              ),
              label: 'Schemes',
            ),
            NavigationDestination(
              icon: ScamIcon(assetPath: AppAssets.coreSwatPoliceRaid, size: 22),
              label: 'Events',
            ),
            NavigationDestination(
              icon: ScamIcon(
                assetPath: AppAssets.resOffshoreVipCrown,
                size: 22,
              ),
              label: 'Prestige',
            ),
            NavigationDestination(
              icon: ScamIcon(
                assetPath: AppAssets.coreSettingsGearCog,
                size: 22,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 0: HOME / HEADQUARTERS
  // ==========================================
  Widget _buildHomeTab() {
    final playerState = ref.watch(playerStateProvider);
    final incomePerSec = ref.watch(incomePerSecondProvider);
    final operations = ref.watch(operationsProvider);
    final heatStatus = ref.watch(heatStatusProvider);

    final activeOps = operations.where((o) => o.level > 0).toList();

    return SingleChildScrollView(
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
                      border: Border.all(color: AppColors.border, width: 1.5),
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
              IconButton(
                icon: const ScamIcon(
                  assetPath: AppAssets.coreSettingsGearCog,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _selectedTabIndex = 4;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Total Revenue Card
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
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.sCoinsDark,
                  ),
                ),
                const SizedBox(height: 6),
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
                        fillColor:
                            heatStatus == HeatStatus.criticalRaid ||
                                heatStatus == HeatStatus.danger
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
          const SizedBox(height: 12),

          // Emergency Bribe Action (If Heat is high)
          if (playerState.heat >= 50.0)
            ScamCard(
              backgroundColor: AppColors.heatBg,
              borderColor: AppColors.heat,
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const ScamIcon(
                    assetPath: AppAssets.coreSwatPoliceRaid,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INVESTIGATION IN PROGRESS',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.heatDanger,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        Text(
                          'Bribe officials (-35% Heat)',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  ScamButton(
                    label: 'BRIBE',
                    onPressed: () {
                      ref.read(gameControllerProvider.notifier).bribePolice();
                    },
                    variant: ScamButtonVariant.danger,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                  ),
                ],
              ),
            ),
          if (playerState.heat >= 50.0) const SizedBox(height: 12),

          // Main Tap Campaign Area
          ScamCard(
            onTap: () {
              ref.read(gameControllerProvider.notifier).tap();
            },
            backgroundColor: AppColors.surface,
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.sCoinsBg,
                      border: Border.all(color: AppColors.sCoins, width: 2),
                    ),
                    child: const Center(
                      child: ScamIcon(
                        assetPath: AppAssets.coreMoneyFaucetTap,
                        size: 38,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'LAUNCH CAMPAIGN',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

          // Quick Active Operations Preview
          SectionHeader(
            title: 'Active Operations (${activeOps.length})',
            subtitle: 'Automated income sources',
          ),
          if (activeOps.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No active operations. Go to "Schemes" tab to buy your first scam!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeOps.take(3).length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, idx) {
                final op = activeOps[idx];
                return OperationCard(
                  operation: op,
                  currentCoins: playerState.coins,
                  currentTrust: playerState.trust,
                  buyMultiplier: _buyMultiplier,
                  onUpgrade: () {
                    ref
                        .read(gameControllerProvider.notifier)
                        .buyOperation(op.id, count: _buyMultiplier);
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: OPERATIONS & UPGRADES
  // ==========================================
  Widget _buildOperationsTab() {
    final playerState = ref.watch(playerStateProvider);
    final operations = ref.watch(operationsProvider);
    final upgrades = ref.watch(upgradesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with Multiplier Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Digital Schemes',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              Row(
                children: [1, 10, 100].map((multiplier) {
                  final isSelected = _buyMultiplier == multiplier;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: ChoiceChip(
                      label: Text('${multiplier}x'),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _buyMultiplier = multiplier;
                        });
                      },
                      selectedColor: AppColors.sCoins,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Upgrades Market
          if (upgrades.any((u) => !u.isPurchased)) ...[
            const SectionHeader(
              title: 'Available Upgrades',
              subtitle: 'Multipliers and automation boosts',
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upgrades.where((u) => !u.isPurchased).length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, idx) {
                final up = upgrades.where((u) => !u.isPurchased).toList()[idx];
                return UpgradeCard(
                  upgrade: up,
                  currentCoins: playerState.coins,
                  onBuy: () {
                    ref.read(gameControllerProvider.notifier).buyUpgrade(up.id);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],

          // Operations List
          const SectionHeader(
            title: 'Operation Tiers',
            subtitle: '16 Tiered Scam Syndicates',
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: operations.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              final op = operations[idx];
              return OperationCard(
                operation: op,
                currentCoins: playerState.coins,
                currentTrust: playerState.trust,
                buyMultiplier: _buyMultiplier,
                onUpgrade: () {
                  ref
                      .read(gameControllerProvider.notifier)
                      .buyOperation(op.id, count: _buyMultiplier);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: EVENTS
  // ==========================================
  Widget _buildEventsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Live Narrative Events',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Interactive corporate incidents and crisis management choices.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          ScamCard(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const ScamIcon(
                  assetPath: AppAssets.eventJournalistInvestigation,
                  size: 64,
                ),
                const SizedBox(height: 12),
                Text(
                  'No Active Crises',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your syndicates are currently flying under the radar. Random events trigger periodically as Heat and Revenue increase.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: PRESTIGE / ESCAPE
  // ==========================================
  Widget _buildPrestigeTab() {
    final playerState = ref.watch(playerStateProvider);
    final prestigeSkills = ref.watch(prestigeSkillsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Offshore Prestige',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Launder cash, escape the feds, and purchase permanent empire skills.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Prestige Balance Card
          ScamCard(
            backgroundColor: AppColors.surface,
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${playerState.launderedCash.toInt()} LC',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.launderedCash,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Prestige Level: ${playerState.prestigeLevel} (${playerState.prestigeMultiplier}x Global Multiplier)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Permanent Skill Tree Nodes
          const SectionHeader(
            title: 'Prestige Skill Tree',
            subtitle: 'Permanent Empire Perks',
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: prestigeSkills.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, idx) {
              final skill = prestigeSkills[idx];
              return ScamCard(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.launderedCashBg,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.launderedCash),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: ScamIcon(assetPath: skill.iconPath, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            skill.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            '${skill.description} (Lv. ${skill.level}/${skill.maxLevel})',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
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

  // ==========================================
  // TAB 4: SETTINGS & STATS
  // ==========================================
  Widget _buildSettingsTab() {
    final playerState = ref.watch(playerStateProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Settings & Statistics',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),

          // Statistics Card
          ScamCard(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EXECUTIVE DOSSIER',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Divider(height: 16),
                _buildStatRow(
                  'Lifetime Revenue',
                  NumberFormatter.formatCurrency(playerState.lifetimeRevenue),
                ),
                const SizedBox(height: 6),
                _buildStatRow('Total Manual Taps', '${playerState.totalTaps}'),
                const SizedBox(height: 6),
                _buildStatRow(
                  'Current Office Tier',
                  playerState.currentOfficeTier.name.replaceAll(
                    'tier',
                    'Tier ',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Danger Zone
          ScamCard(
            borderColor: AppColors.heatDanger,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SHRED ALL EVIDENCE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.heatDanger,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Wipes local save file and resets company back to the basement.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                ScamButton(
                  label: 'WIPE SAVE FILE',
                  onPressed: () {
                    ref.read(gameControllerProvider.notifier).resetGame();
                  },
                  variant: ScamButtonVariant.danger,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
