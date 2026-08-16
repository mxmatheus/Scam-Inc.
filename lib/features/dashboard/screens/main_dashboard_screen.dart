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
import '../../../core/widgets/offline_summary_dialog.dart';
import '../../../core/widgets/event_decision_modal.dart';
import '../../../core/widgets/reset_save_confirm_dialog.dart';
import '../../../data/providers/repository_providers.dart';
import '../../../services/providers/service_providers.dart';
import '../../../services/heat_service.dart';
import '../../operations/screens/operations_screen.dart';
import '../../prestige/screens/prestige_screen.dart';
import '../../achievements/screens/achievements_screen.dart';
import '../../minigames/screens/suspicious_chat_screen.dart';
import '../../minigames/screens/scam_baiter_screen.dart';

class MainDashboardScreen extends ConsumerStatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  ConsumerState<MainDashboardScreen> createState() =>
      _MainDashboardScreenState();
}

class _MainDashboardScreenState extends ConsumerState<MainDashboardScreen> {
  int _selectedTabIndex = 0;
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: _buildActiveTab()),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkBorder
                  : AppColors.border,
              width: 1.5,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedTabIndex,
          onDestinationSelected: (idx) {
            setState(() {
              _selectedTabIndex = idx;
            });
          },
          backgroundColor: Theme.of(context).cardTheme.color,
          indicatorColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkSCoinsBg
              : AppColors.sCoinsBg,
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

  Widget _buildActiveTab() {
    switch (_selectedTabIndex) {
      case 0:
        return _HomeTab(
          onOpenSettings: () {
            setState(() {
              _selectedTabIndex = 4;
            });
          },
        );
      case 1:
        return const OperationsScreen();
      case 2:
        return const _EventsTab();
      case 3:
        return const PrestigeScreen();
      case 4:
        return const _SettingsTab();
      default:
        return const SizedBox.shrink();
    }
  }
}

// ==========================================
// TAB 0: HOME / HEADQUARTERS
// ==========================================
class _HomeTab extends StatelessWidget {
  final VoidCallback onOpenSettings;

  const _HomeTab({required this.onOpenSettings});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const ScamIcon(
                      assetPath: AppAssets.appIconMain,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GameConstants.appName,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(letterSpacing: -0.5),
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
                onPressed: onOpenSettings,
              ),
            ],
          ),
          const SizedBox(height: 16),

          const _RevenueOverviewCard(),
          const SizedBox(height: 12),

          const _TrustHeatMeters(),
          const SizedBox(height: 12),

          const _EmergencyBribeBanner(),

          const _CampaignTapCard(),
          const SizedBox(height: 16),

          const _ActiveOperationsPreview(),
        ],
      ),
    );
  }
}

class _RevenueOverviewCard extends ConsumerWidget {
  const _RevenueOverviewCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = ref.watch(playerStateProvider.select((s) => s.coins));
    final incomePerSec = ref.watch(incomePerSecondProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScamCard(
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
            NumberFormatter.formatCurrency(coins),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppColors.sCoins,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSCoinsBg : AppColors.sCoinsBg,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              NumberFormatter.formatRate(incomePerSec),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.sCoins,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustHeatMeters extends ConsumerWidget {
  const _TrustHeatMeters();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trust = ref.watch(playerStateProvider.select((s) => s.trust));
    final heat = ref.watch(playerStateProvider.select((s) => s.heat));
    final heatStatus = ref.watch(heatStatusProvider);

    return Row(
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
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: AppColors.trust),
                    ),
                    Text(
                      '${trust.toInt()} PTS',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ProgressBar(
                  progress: trust / 100.0,
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
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: AppColors.heat),
                    ),
                    Text(
                      '${heat.toInt()}%',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ProgressBar(
                  progress: heat / 100.0,
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
    );
  }
}

class _EmergencyBribeBanner extends ConsumerWidget {
  const _EmergencyBribeBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heat = ref.watch(playerStateProvider.select((s) => s.heat));
    if (heat < 50.0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ScamCard(
        backgroundColor: AppColors.heatBg,
        borderColor: AppColors.heat,
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const ScamIcon(assetPath: AppAssets.coreSwatPoliceRaid, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INVESTIGATION IN PROGRESS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.heatDanger,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Bribe officials (-35% Heat)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignTapCard extends ConsumerWidget {
  const _CampaignTapCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScamCard(
      onTap: () {
        ref.read(gameControllerProvider.notifier).tap();
      },
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
                color: isDark ? AppColors.darkSCoinsBg : AppColors.sCoinsBg,
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
    );
  }
}

class _ActiveOperationsPreview extends ConsumerWidget {
  const _ActiveOperationsPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operations = ref.watch(operationsProvider);
    final coins = ref.watch(playerStateProvider.select((s) => s.coins));
    final trust = ref.watch(playerStateProvider.select((s) => s.trust));

    final activeOps = operations.where((o) => o.level > 0).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                currentCoins: coins,
                currentTrust: trust,
                buyMultiplier: 1,
                onUpgrade: () {
                  ref
                      .read(gameControllerProvider.notifier)
                      .buyOperation(op.id, count: 1);
                },
              );
            },
          ),
      ],
    );
  }
}

// ==========================================
// TAB 2: EVENTS & MINIGAME HUB
// ==========================================
class _EventsTab extends ConsumerWidget {
  const _EventsTab();

  void _triggerEventModal(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameControllerProvider.notifier);
    final event = controller.triggerRandomEvent();
    final coins = ref.read(playerStateProvider).coins;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => EventDecisionModal(
        event: event,
        currentCoins: coins,
        onSelectChoice: (choice) {
          final result = controller.applyEventChoice(event, choice);
          Navigator.of(ctx).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.feedbackMessage),
              backgroundColor: result.isSuccess
                  ? AppColors.sCoinsDark
                  : AppColors.heatDanger,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Live Narrative Incidents',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Crisis management decisions & anti-scam training mini-games.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Mini-Game 1: Suspicious Chat
          ScamCard(
            backgroundColor: isDark ? AppColors.darkTrustBg : AppColors.trustBg,
            borderColor: AppColors.trust,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const ScamIcon(
                        assetPath: AppAssets.coreChatSpeechBubble,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SUSPICIOUS CHAT TRAINING',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.trust,
                                ),
                          ),
                          Text(
                            'Practice identifying social engineering red flags for bonus S-Coins & Trust.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ScamButton(
                  label: 'START CHAT TRAINING (+5K S-Coins)',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SuspiciousChatScreen(),
                      ),
                    );
                  },
                  variant: ScamButtonVariant.primary,
                  isFullWidth: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Mini-Game 2: Scam Baiter
          ScamCard(
            backgroundColor: isDark ? AppColors.darkHeatBg : AppColors.heatBg,
            borderColor: AppColors.heat,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const ScamIcon(
                        assetPath: AppAssets.chatDarkwebContact,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SCAM BAITER DRILL',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.heat,
                                ),
                          ),
                          Text(
                            'Quick reaction: Inspect suspicious profiles and disconnect before extortion!',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ScamButton(
                  label: 'START SCAM BAITER (+7.5K S-Coins)',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ScamBaiterScreen(),
                      ),
                    );
                  },
                  variant: ScamButtonVariant.danger,
                  isFullWidth: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Random Crisis Simulation Trigger Card
          const SectionHeader(
            title: 'Corporate Crisis Drill',
            subtitle: 'Trigger a random narrative decision event',
          ),
          ScamCard(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const ScamIcon(
                  assetPath: AppAssets.eventJournalistInvestigation,
                  size: 64,
                ),
                const SizedBox(height: 12),
                Text(
                  'Simulate Random Crisis Event',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Face sudden police raids, whistleblower leaks, or viral trend spikes and make your strategic corporate decision.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                ScamButton(
                  label: 'TRIGGER CRISIS EVENT',
                  onPressed: () => _triggerEventModal(context, ref),
                  variant: ScamButtonVariant.secondary,
                  isFullWidth: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 4: SETTINGS & STATS
// ==========================================
class _SettingsTab extends ConsumerWidget {
  const _SettingsTab();

  void _showResetConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => ResetSaveConfirmDialog(
        onConfirmReset: () {
          ref.read(gameControllerProvider.notifier).resetGame();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '💾 Evidence shredded! Save file reset back to Day 1.',
              ),
              backgroundColor: AppColors.heatDanger,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerStateProvider);
    final settings = ref.watch(settingsStateProvider);

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

          // Milestones & Achievements Hub Card
          ScamCard(
            borderColor: AppColors.corporateGold,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.sCoinsBg,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const ScamIcon(
                    assetPath: AppAssets.achUntouchableKingpinCrown,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DOSSIER & MILESTONES',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: AppColors.corporateGold,
                        ),
                      ),
                      Text(
                        'View company achievements and claim daily goal rewards.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                ScamButton(
                  label: 'VIEW',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AchievementsScreen(),
                      ),
                    );
                  },
                  variant: ScamButtonVariant.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Appearance & Controls Card
          ScamCard(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'APPEARANCE & SOUND',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          settings.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          size: 20,
                          color: AppColors.sCoins,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Dark Mode (Karanlık Tema)',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Switch(
                      value: settings.isDarkMode,
                      activeTrackColor: AppColors.sCoins,
                      onChanged: (val) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .toggleDarkMode(val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.volume_up,
                          size: 20,
                          color: AppColors.trust,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Sound Effects',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Switch(
                      value: settings.soundEnabled,
                      activeTrackColor: AppColors.trust,
                      onChanged: (val) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .toggleSound(val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.vibration,
                          size: 20,
                          color: AppColors.heat,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Haptic Feedback',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Switch(
                      value: settings.hapticsEnabled,
                      activeTrackColor: AppColors.heat,
                      onChanged: (val) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .toggleHaptics(val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Executive Dossier
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
                  context,
                  'Lifetime Revenue',
                  NumberFormatter.formatCurrency(playerState.lifetimeRevenue),
                ),
                const SizedBox(height: 6),
                _buildStatRow(
                  context,
                  'Total Manual Taps',
                  '${playerState.totalTaps}',
                ),
                const SizedBox(height: 6),
                _buildStatRow(
                  context,
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
                  onPressed: () => _showResetConfirmDialog(context, ref),
                  variant: ScamButtonVariant.danger,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Satire Disclaimer & Version Info
          Center(
            child: Column(
              children: [
                Text(
                  'SCAM INC. v1.0.0 (Satirical Cyber Education)',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'All organizations, schemes, and characters are purely fictional parodies.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
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
