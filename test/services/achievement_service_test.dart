import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/models/player_save.dart';
import 'package:scam_inc/models/player_state.dart';
import 'package:scam_inc/services/achievement_service.dart';
import 'package:scam_inc/services/daily_goal_service.dart';

void main() {
  const achievementService = AchievementService();
  const dailyGoalService = DailyGoalService();

  group('Achievement & Daily Goal Service Tests', () {
    test('Initializes with 8 master achievements and 4 daily goals', () {
      final achs = achievementService.getInitialAchievements();
      expect(achs.length, 8);

      final goals = dailyGoalService.getInitialGoals();
      expect(goals.length, 4);
    });

    test('Evaluates revenue milestones properly', () {
      final achs = achievementService.getInitialAchievements();
      final save = PlayerSave.initial().copyWith(
        playerState: PlayerState(
          lifetimeRevenue: 1500000.0,
          lastActiveTimestamp: DateTime.now(),
        ),
      );

      final updated = achievementService.evaluateAchievements(
        currentAchievements: achs,
        playerSave: save,
      );

      final millionAch = updated.firstWhere((a) => a.id == 'ach_first_million');
      expect(millionAch.isUnlocked, true);
    });

    test('Evaluates daily tap goals properly', () {
      final goals = dailyGoalService.getInitialGoals();
      final save = PlayerSave.initial().copyWith(
        playerState: PlayerState(
          totalTaps: 150,
          lastActiveTimestamp: DateTime.now(),
        ),
      );

      final updated = dailyGoalService.evaluateDailyGoals(
        currentGoals: goals,
        playerSave: save,
      );

      final tapGoal = updated.firstWhere((g) => g.id == 'dg_taps_100');
      expect(tapGoal.isCompleted, true);
    });
  });
}
