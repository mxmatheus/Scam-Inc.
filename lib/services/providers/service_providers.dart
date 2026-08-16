import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/repository_providers.dart';
import '../../models/player_save.dart';
import '../../models/player_state.dart';
import '../../models/operation.dart';
import '../../models/upgrade.dart';
import '../../models/prestige_skill.dart';
import '../economy_service.dart';
import '../game_clock_service.dart';
import '../heat_service.dart';
import '../trust_service.dart';
import '../offline_income_service.dart';
import '../event_service.dart';
import '../prestige_service.dart';
import '../achievement_service.dart';
import '../daily_goal_service.dart';
import '../audio_service.dart';
import '../../features/minigames/services/chat_minigame_service.dart';
import '../../features/minigames/services/scam_baiter_service.dart';
import '../../game/game_controller.dart';

/// Provider for pure [EconomyService].
final economyServiceProvider = Provider<EconomyService>((ref) {
  return const EconomyService();
});

/// Provider for [HeatService].
final heatServiceProvider = Provider<HeatService>((ref) {
  return const HeatService();
});

/// Provider for [TrustService].
final trustServiceProvider = Provider<TrustService>((ref) {
  return const TrustService();
});

/// Provider for [OfflineIncomeService].
final offlineIncomeServiceProvider = Provider<OfflineIncomeService>((ref) {
  final economy = ref.watch(economyServiceProvider);
  return OfflineIncomeService(economyService: economy);
});

/// Provider for [EventService].
final eventServiceProvider = Provider<EventService>((ref) {
  return const EventService();
});

/// Provider for [PrestigeService].
final prestigeServiceProvider = Provider<PrestigeService>((ref) {
  return const PrestigeService();
});

/// Provider for [AchievementService].
final achievementServiceProvider = Provider<AchievementService>((ref) {
  return const AchievementService();
});

/// Provider for [DailyGoalService].
final dailyGoalServiceProvider = Provider<DailyGoalService>((ref) {
  return const DailyGoalService();
});

/// Provider for [ChatMinigameService].
final chatMinigameServiceProvider = Provider<ChatMinigameService>((ref) {
  return ChatMinigameService();
});

/// Provider for [ScamBaiterService].
final scamBaiterServiceProvider = Provider<ScamBaiterService>((ref) {
  return ScamBaiterService();
});

/// Provider for [AudioService].
final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService(() => ref.read(settingsStateProvider));
});

/// Provider for singleton [GameClockService].
final gameClockServiceProvider = Provider<GameClockService>((ref) {
  final clock = GameClockService();
  ref.onDispose(() {
    clock.stop();
  });
  return clock;
});

/// Master StateNotifierProvider for [GameController] and [PlayerSave].
final gameControllerProvider =
    StateNotifierProvider<GameController, PlayerSave>((ref) {
      final saveRepo = ref.watch(saveRepositoryProvider);
      final economyService = ref.watch(economyServiceProvider);
      final heatService = ref.watch(heatServiceProvider);
      final trustService = ref.watch(trustServiceProvider);
      final offlineIncomeService = ref.watch(offlineIncomeServiceProvider);
      final eventService = ref.watch(eventServiceProvider);
      final prestigeService = ref.watch(prestigeServiceProvider);
      final achievementService = ref.watch(achievementServiceProvider);
      final dailyGoalService = ref.watch(dailyGoalServiceProvider);
      final audioService = ref.watch(audioServiceProvider);
      final gameClock = ref.watch(gameClockServiceProvider);

      return GameController(
        saveRepository: saveRepo,
        economyService: economyService,
        heatService: heatService,
        trustService: trustService,
        offlineIncomeService: offlineIncomeService,
        eventService: eventService,
        prestigeService: prestigeService,
        achievementService: achievementService,
        dailyGoalService: dailyGoalService,
        audioService: audioService,
        gameClock: gameClock,
      );
    });

/// Convenience selector for [PlayerState].
final playerStateProvider = Provider<PlayerState>((ref) {
  return ref.watch(gameControllerProvider).playerState;
});

/// Convenience selector for [Operation] list.
final operationsProvider = Provider<List<Operation>>((ref) {
  return ref.watch(gameControllerProvider).operations;
});

/// Convenience selector for [Upgrade] list.
final upgradesProvider = Provider<List<Upgrade>>((ref) {
  return ref.watch(gameControllerProvider).upgrades;
});

/// Convenience selector for [PrestigeSkill] list.
final prestigeSkillsProvider = Provider<List<PrestigeSkill>>((ref) {
  return ref.watch(gameControllerProvider).prestigeSkills;
});

/// Convenience selector for current total income per second.
final incomePerSecondProvider = Provider<double>((ref) {
  final save = ref.watch(gameControllerProvider);
  final economy = ref.watch(economyServiceProvider);

  return economy.calculateTotalIncomePerSec(
    operations: save.operations,
    upgrades: save.upgrades,
    prestigeSkills: save.prestigeSkills,
    trust: save.playerState.trust,
    prestigeMultiplier: save.playerState.prestigeMultiplier,
  );
});

/// Convenience selector for Heat Status.
final heatStatusProvider = Provider<HeatStatus>((ref) {
  final heat = ref.watch(playerStateProvider).heat;
  final heatService = ref.watch(heatServiceProvider);
  return heatService.getHeatStatus(heat);
});
