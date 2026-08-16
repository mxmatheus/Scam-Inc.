import '../models/daily_goal.dart';
import '../models/player_save.dart';
import '../data/seeds/achievement_seeds.dart';

class DailyGoalService {
  const DailyGoalService();

  List<DailyGoal> getInitialGoals() => AchievementSeeds.getInitialDailyGoals();

  /// Updates daily goal completion status against player progression.
  List<DailyGoal> evaluateDailyGoals({
    required List<DailyGoal> currentGoals,
    required PlayerSave playerSave,
  }) {
    final state = playerSave.playerState;

    return currentGoals.map((goal) {
      if (goal.isClaimed) return goal;

      double progress = goal.currentProgress;

      switch (goal.id) {
        case 'dg_taps_100':
          progress = state.totalTaps.toDouble();
          break;
        case 'dg_earn_coins':
          progress = state.lifetimeRevenue;
          break;
        case 'dg_cool_heat':
          progress = state.heat <= 30 ? 1.0 : 0.0;
          break;
        case 'dg_play_minigame':
          progress = state.lifetimeRevenue > 0 ? 1.0 : 0.0;
          break;
      }

      final isCompleted = progress >= goal.targetValue;

      return goal.copyWith(currentProgress: progress, isCompleted: isCompleted);
    }).toList();
  }
}
