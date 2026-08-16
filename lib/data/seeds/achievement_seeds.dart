import '../../core/constants/asset_constants.dart';
import '../../models/achievement.dart';
import '../../models/daily_goal.dart';
import '../../models/enums/game_enums.dart';

class AchievementSeeds {
  static List<Achievement> getInitialAchievements() {
    return const [
      Achievement(
        id: 'ach_first_scheme',
        title: 'Basement Syndicate Founded',
        description: 'Purchase your first automated digital scheme.',
        iconPath: AppAssets.achDeskTycoonFirstOffice,
        category: AchievementCategory.wealth,
        targetValue: 1.0,
        rewardGems: 10,
      ),
      Achievement(
        id: 'ach_first_million',
        title: 'The Seven-Figure Club',
        description: 'Accumulate \$1,000,000 in lifetime company revenue.',
        iconPath: AppAssets.achFirstMillionVault,
        category: AchievementCategory.wealth,
        targetValue: 1000000.0,
        rewardGems: 25,
      ),
      Achievement(
        id: 'ach_first_prestige',
        title: 'Pacific Island Escape',
        description: 'Liquidate assets and execute your first Offshore Escape.',
        iconPath: AppAssets.achOffshoreEscapeFirstPrestige,
        category: AchievementCategory.prestigeEscape,
        targetValue: 1.0,
        rewardGems: 30,
      ),
      Achievement(
        id: 'ach_high_trust',
        title: 'Corporate Respectability',
        description: 'Reach 50 Trust Points with public institutions.',
        iconPath: AppAssets.achFirstTrustPartnership,
        category: AchievementCategory.trustEmpire,
        targetValue: 50.0,
        rewardGems: 15,
      ),
      Achievement(
        id: 'ach_heat_surfer',
        title: 'Living on the Edge',
        description: 'Surpass 80% investigation Heat without bankruptcy.',
        iconPath: AppAssets.achHeatWaveSurvivedRaid,
        category: AchievementCategory.heatSurfer,
        targetValue: 80.0,
        rewardGems: 20,
      ),
      Achievement(
        id: 'ach_automation_master',
        title: 'Autonomous Swarm Empire',
        description: 'Automate 5 distinct operation schemes simultaneously.',
        iconPath: AppAssets.achBotArmyAutomation,
        category: AchievementCategory.automationMaster,
        targetValue: 5.0,
        rewardGems: 20,
      ),
      Achievement(
        id: 'ach_tap_tycoon',
        title: 'Master Campaigner',
        description: 'Execute 500 manual campaign taps.',
        iconPath: AppAssets.achBigPaydayBriefcase,
        category: AchievementCategory.wealth,
        targetValue: 500.0,
        rewardGems: 15,
      ),
      Achievement(
        id: 'ach_untouchable_kingpin',
        title: 'Untouchable Sovereign Kingpin',
        description: 'Ascend to Prestige Level 5 in offshore havens.',
        iconPath: AppAssets.achUntouchableKingpinCrown,
        category: AchievementCategory.prestigeEscape,
        targetValue: 5.0,
        rewardGems: 50,
      ),
    ];
  }

  static List<DailyGoal> getInitialDailyGoals() {
    return const [
      DailyGoal(
        id: 'dg_taps_100',
        title: 'Manual Engagement',
        description: 'Execute 100 manual campaign taps today.',
        targetValue: 100.0,
        rewardCoins: 5000.0,
        rewardGems: 5,
      ),
      DailyGoal(
        id: 'dg_earn_coins',
        title: 'Daily Corporate Quota',
        description: 'Earn \$50,000 in company revenue.',
        targetValue: 50000.0,
        rewardCoins: 10000.0,
        rewardGems: 5,
      ),
      DailyGoal(
        id: 'dg_cool_heat',
        title: 'Damage Control',
        description: 'Bribe officials or survive high heat once.',
        targetValue: 1.0,
        rewardCoins: 7500.0,
        rewardGems: 5,
      ),
      DailyGoal(
        id: 'dg_play_minigame',
        title: 'Anti-Scam Protocol Drill',
        description: 'Complete 1 interactive anti-scam training scenario.',
        targetValue: 1.0,
        rewardCoins: 8000.0,
        rewardGems: 10,
      ),
    ];
  }
}
