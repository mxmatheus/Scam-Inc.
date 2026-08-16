import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/repository_providers.dart';
import '../../models/player_save.dart';
import '../../models/player_state.dart';
import '../../models/operation.dart';
import '../economy_service.dart';
import '../game_clock_service.dart';
import '../../game/game_controller.dart';

/// Provider for pure [EconomyService].
final economyServiceProvider = Provider<EconomyService>((ref) {
  return const EconomyService();
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
      final gameClock = ref.watch(gameClockServiceProvider);

      return GameController(
        saveRepository: saveRepo,
        economyService: economyService,
        gameClock: gameClock,
      );
    });

/// Convenience selector for [PlayerState].
final playerStateProvider = Provider<PlayerState>((ref) {
  return ref.watch(gameControllerProvider).playerState;
});

/// Convenience selector for active/unlocked [Operation] list.
final operationsProvider = Provider<List<Operation>>((ref) {
  return ref.watch(gameControllerProvider).operations;
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
