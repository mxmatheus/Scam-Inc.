import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../core/widgets/scam_card.dart';
import '../../../core/widgets/scam_icon.dart';
import '../../../services/providers/service_providers.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final save = ref.watch(gameControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardTheme.color,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Dossier & Milestones',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.sCoins,
          labelColor: isDark
              ? AppColors.darkTextPrimary
              : AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Achievements'),
            Tab(text: 'Daily Goals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 0: Achievements List
          ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: save.achievements.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              final ach = save.achievements[idx];

              return ScamCard(
                padding: const EdgeInsets.all(14.0),
                borderColor: ach.isUnlocked
                    ? AppColors.sCoins
                    : AppColors.border,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: ach.isUnlocked
                            ? AppColors.sCoinsBg
                            : AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: ach.isUnlocked
                              ? AppColors.sCoins
                              : AppColors.border,
                        ),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: ScamIcon(assetPath: ach.iconPath, size: 32),
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
                                  ach.title,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                              if (ach.isUnlocked)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.sCoinsBg,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.sm,
                                    ),
                                  ),
                                  child: Text(
                                    'UNLOCKED',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppColors.sCoinsDark,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 10,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ach.description,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          ProgressBar(
                            progress: ach.progressRatio,
                            fillColor: AppColors.sCoins,
                            height: 6,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Reward: +${ach.rewardGems} Gems',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.corporateGold,
                                  fontWeight: FontWeight.w800,
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

          // Tab 1: Daily Goals List
          ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: save.dailyGoals.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              final goal = save.dailyGoals[idx];

              return ScamCard(
                padding: const EdgeInsets.all(14.0),
                borderColor: goal.isCompleted
                    ? AppColors.trust
                    : AppColors.border,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            goal.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        Text(
                          '${goal.currentProgress.toInt()} / ${goal.targetValue.toInt()}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: goal.isCompleted
                                    ? AppColors.trust
                                    : AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goal.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ProgressBar(
                      progress: goal.progressRatio,
                      fillColor: AppColors.trust,
                      height: 6,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Reward: +${NumberFormatter.formatCurrency(goal.rewardCoins)} • +${goal.rewardGems} Gems',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.sCoins,
                        fontWeight: FontWeight.w800,
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
