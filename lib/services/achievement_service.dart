import '../models/achievement.dart';
import '../models/player_save.dart';
import '../data/seeds/achievement_seeds.dart';

class AchievementService {
  const AchievementService();

  List<Achievement> getInitialAchievements() =>
      AchievementSeeds.getInitialAchievements();

  /// Updates progress for all achievements against the current player state snapshot.
  List<Achievement> evaluateAchievements({
    required List<Achievement> currentAchievements,
    required PlayerSave playerSave,
  }) {
    final state = playerSave.playerState;
    final activeOpsCount = playerSave.operations
        .where((o) => o.level > 0)
        .length
        .toDouble();

    return currentAchievements.map((ach) {
      if (ach.isUnlocked) return ach;

      double progress = ach.currentProgress;

      switch (ach.id) {
        case 'ach_first_scheme':
          progress = activeOpsCount >= 1 ? 1.0 : 0.0;
          break;
        case 'ach_first_million':
          progress = state.lifetimeRevenue;
          break;
        case 'ach_first_prestige':
          progress = state.prestigeLevel.toDouble();
          break;
        case 'ach_high_trust':
          progress = state.trust;
          break;
        case 'ach_heat_surfer':
          progress = state.heat;
          break;
        case 'ach_automation_master':
          progress = activeOpsCount;
          break;
        case 'ach_tap_tycoon':
          progress = state.totalTaps.toDouble();
          break;
        case 'ach_untouchable_kingpin':
          progress = state.prestigeLevel.toDouble();
          break;
      }

      final isNowUnlocked = progress >= ach.targetValue;

      return ach.copyWith(
        currentProgress: progress,
        isUnlocked: isNowUnlocked,
        unlockedAt: isNowUnlocked ? DateTime.now() : ach.unlockedAt,
      );
    }).toList();
  }
}
