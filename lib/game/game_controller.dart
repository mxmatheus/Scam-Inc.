import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player_save.dart';
import '../models/operation.dart';
import '../models/upgrade.dart';
import '../models/prestige_skill.dart';
import '../models/game_event.dart';
import '../models/event_choice.dart';
import '../data/repositories/save_repository.dart';
import '../data/seeds/game_seeds.dart';
import '../services/economy_service.dart';
import '../services/heat_service.dart';
import '../services/trust_service.dart';
import '../services/offline_income_service.dart';
import '../services/event_service.dart';
import '../services/prestige_service.dart';
import '../services/achievement_service.dart';
import '../services/daily_goal_service.dart';
import '../services/audio_service.dart';
import '../services/game_clock_service.dart';

/// Central Game State Controller managing active progression, tick events, and persistence.
class GameController extends StateNotifier<PlayerSave> {
  final SaveRepository _saveRepository;
  final EconomyService _economyService;
  final HeatService _heatService;
  final TrustService _trustService;
  final OfflineIncomeService _offlineIncomeService;
  final EventService _eventService;
  final PrestigeService _prestigeService;
  final AchievementService _achievementService;
  final DailyGoalService _dailyGoalService;
  final AudioService _audioService;
  final GameClockService _gameClock;
  Timer? _autoSaveTimer;

  OfflineEarningsResult? _pendingOfflineEarnings;
  OfflineEarningsResult? get pendingOfflineEarnings => _pendingOfflineEarnings;

  GameEvent? _activeEvent;
  GameEvent? get activeEvent => _activeEvent;

  GameController({
    required SaveRepository saveRepository,
    required EconomyService economyService,
    required HeatService heatService,
    required TrustService trustService,
    required OfflineIncomeService offlineIncomeService,
    required EventService eventService,
    required PrestigeService prestigeService,
    required AchievementService achievementService,
    required DailyGoalService dailyGoalService,
    required AudioService audioService,
    required GameClockService gameClock,
    PlayerSave? initialSave,
  }) : _saveRepository = saveRepository,
       _economyService = economyService,
       _heatService = heatService,
       _trustService = trustService,
       _offlineIncomeService = offlineIncomeService,
       _eventService = eventService,
       _prestigeService = prestigeService,
       _achievementService = achievementService,
       _dailyGoalService = dailyGoalService,
       _audioService = audioService,
       _gameClock = gameClock,
       super(
         initialSave ??
             PlayerSave.initial(
               operations: GameSeeds.getInitialOperations(),
               upgrades: GameSeeds.getInitialUpgrades(),
               prestigeSkills: GameSeeds.getInitialPrestigeSkills(),
               achievements: achievementService.getInitialAchievements(),
               dailyGoals: dailyGoalService.getInitialGoals(),
             ),
       ) {
    _init();
  }

  Future<void> _init() async {
    // If no explicit initialSave was passed, attempt loading from repository
    if (state.operations.isEmpty || state.playerState.coins == 0.0) {
      final loaded = await _saveRepository.loadSave();
      if (loaded.operations.isNotEmpty) {
        state = loaded;
      } else {
        // First-time player with seed data
        state = PlayerSave.initial(
          operations: GameSeeds.getInitialOperations(),
          upgrades: GameSeeds.getInitialUpgrades(),
          prestigeSkills: GameSeeds.getInitialPrestigeSkills(),
          achievements: _achievementService.getInitialAchievements(),
          dailyGoals: _dailyGoalService.getInitialGoals(),
        );
      }
    }

    // Check for offline progress earnings
    final offlineResult = _offlineIncomeService.calculateOfflineEarnings(
      playerState: state.playerState,
      operations: state.operations,
      upgrades: state.upgrades,
      prestigeSkills: state.prestigeSkills,
      now: DateTime.now(),
    );

    if (offlineResult.isEligible) {
      _pendingOfflineEarnings = offlineResult;
    }

    // Attach clock listener and start tick engine
    _gameClock.addListener(_onGameTick);
    _gameClock.start();

    // Auto-save every 30 seconds
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      saveGame();
    });
  }

  /// Claims and applies pending offline earnings.
  void claimOfflineEarnings() {
    if (_pendingOfflineEarnings == null ||
        !_pendingOfflineEarnings!.isEligible) {
      return;
    }

    _audioService.playPurchase();
    final result = _pendingOfflineEarnings!;
    final updatedPlayerState = state.playerState.copyWith(
      coins: state.playerState.coins + result.earnedCoins,
      lifetimeRevenue: state.playerState.lifetimeRevenue + result.earnedCoins,
      heat: _heatService.clampHeat(state.playerState.heat + result.earnedHeat),
      trust: _trustService.clampTrust(
        state.playerState.trust + result.earnedTrust,
      ),
      lastActiveTimestamp: DateTime.now(),
    );

    _pendingOfflineEarnings = null;
    state = state.copyWith(playerState: updatedPlayerState);
    saveGame();
  }

  /// Handles manual user screen tap action.
  void tap() {
    _audioService.playTap();
    final tapValue = _economyService.calculateTapIncome(
      playerState: state.playerState,
      operations: state.operations,
      upgrades: state.upgrades,
      prestigeSkills: state.prestigeSkills,
    );

    final updatedState = state.playerState.copyWith(
      coins: state.playerState.coins + tapValue,
      lifetimeRevenue: state.playerState.lifetimeRevenue + tapValue,
      totalTaps: state.playerState.totalTaps + 1,
      lastActiveTimestamp: DateTime.now(),
    );

    state = state.copyWith(playerState: updatedState);
  }

  /// Purchases or levels up an operation (supporting 1x, 10x, 100x).
  bool buyOperation(String operationId, {int count = 1}) {
    final opIndex = state.operations.indexWhere((o) => o.id == operationId);
    if (opIndex == -1) return false;

    final op = state.operations[opIndex];
    final cost = op.calculateUpgradeCost(count);

    if (!_economyService.canAfford(state.playerState.coins, cost)) {
      return false;
    }

    _audioService.playUpgrade();
    final updatedOp = op.copyWith(level: op.level + count, isUnlocked: true);

    final updatedOperations = List<Operation>.from(state.operations);
    updatedOperations[opIndex] = updatedOp;

    final updatedPlayerState = state.playerState.copyWith(
      coins: state.playerState.coins - cost,
      lastActiveTimestamp: DateTime.now(),
    );

    state = state.copyWith(
      playerState: updatedPlayerState,
      operations: updatedOperations,
    );

    return true;
  }

  /// Purchases an operation or global multiplier upgrade.
  bool buyUpgrade(String upgradeId) {
    final upIndex = state.upgrades.indexWhere((u) => u.id == upgradeId);
    if (upIndex == -1) return false;

    final upgrade = state.upgrades[upIndex];
    if (upgrade.isPurchased) return false;

    if (!_economyService.canAfford(state.playerState.coins, upgrade.cost)) {
      return false;
    }

    _audioService.playPurchase();
    final updatedUpgrade = upgrade.copyWith(isPurchased: true);
    final updatedUpgrades = List<Upgrade>.from(state.upgrades);
    updatedUpgrades[upIndex] = updatedUpgrade;

    final updatedPlayerState = state.playerState.copyWith(
      coins: state.playerState.coins - upgrade.cost,
      lastActiveTimestamp: DateTime.now(),
    );

    state = state.copyWith(
      playerState: updatedPlayerState,
      upgrades: updatedUpgrades,
    );

    return true;
  }

  /// Purchases a permanent Prestige skill using Laundered Cash.
  bool buyPrestigeSkill(String skillId) {
    final skillIndex = state.prestigeSkills.indexWhere((s) => s.id == skillId);
    if (skillIndex == -1) return false;

    final skill = state.prestigeSkills[skillIndex];
    if (skill.level >= skill.maxLevel) return false;

    final cost = skill.calculateCost();
    if (state.playerState.launderedCash < cost) return false;

    _audioService.playUpgrade();
    final updatedSkill = skill.copyWith(level: skill.level + 1);
    final updatedSkills = List<PrestigeSkill>.from(state.prestigeSkills);
    updatedSkills[skillIndex] = updatedSkill;

    final updatedPlayerState = state.playerState.copyWith(
      launderedCash: state.playerState.launderedCash - cost,
      lastActiveTimestamp: DateTime.now(),
    );

    state = state.copyWith(
      playerState: updatedPlayerState,
      prestigeSkills: updatedSkills,
    );

    saveGame();
    return true;
  }

  /// Bribes police/investigators to cool down Heat.
  bool bribePolice() {
    final currentHeat = state.playerState.heat;
    if (currentHeat <= 0.0) return false;

    final incomePerSec = _economyService.calculateTotalIncomePerSec(
      operations: state.operations,
      upgrades: state.upgrades,
      prestigeSkills: state.prestigeSkills,
      trust: state.playerState.trust,
      prestigeMultiplier: state.playerState.prestigeMultiplier,
    );

    final cost = _heatService.calculateBribeCost(currentHeat, incomePerSec);
    if (!_economyService.canAfford(state.playerState.coins, cost)) {
      return false;
    }

    _audioService.playBribe();
    final delta = _heatService.calculateHeatCooldownDelta();
    final updatedHeat = _heatService.clampHeat(currentHeat + delta);

    final updatedPlayerState = state.playerState.copyWith(
      coins: state.playerState.coins - cost,
      heat: updatedHeat,
      lastActiveTimestamp: DateTime.now(),
    );

    state = state.copyWith(playerState: updatedPlayerState);
    return true;
  }

  /// Executes an offshore escape prestige reset transaction.
  bool executePrestigeReset() {
    final eval = _prestigeService.evaluatePrestigeEligibility(
      state.playerState,
    );
    if (!eval.isEligible) return false;

    _audioService.playPrestige();
    final updatedPlayerState = state.playerState.copyWith(
      coins: 0.0,
      heat: 0.0,
      trust: 0.0,
      launderedCash: state.playerState.launderedCash + eval.launderableCash,
      prestigeLevel: state.playerState.prestigeLevel + 1,
      prestigeMultiplier: eval.newPrestigeMultiplier,
      lastActiveTimestamp: DateTime.now(),
    );

    final resetOperations = GameSeeds.getInitialOperations();
    final resetUpgrades = GameSeeds.getInitialUpgrades();

    state = state.copyWith(
      playerState: updatedPlayerState,
      operations: resetOperations,
      upgrades: resetUpgrades,
    );

    saveGame();
    return true;
  }

  /// Manually triggers or sets an active random narrative event.
  GameEvent triggerRandomEvent() {
    _audioService.playWarning();
    final event = _eventService.getRandomEvent();
    _activeEvent = event;
    return event;
  }

  /// Resolves an event choice and applies economic/heat/trust consequences.
  EventResolutionResult applyEventChoice(GameEvent event, EventChoice choice) {
    final result = _eventService.resolveChoice(event: event, choice: choice);

    if (result.isSuccess) {
      _audioService.playPurchase();
    } else {
      _audioService.playWarning();
    }

    final updatedCoins = (state.playerState.coins + result.coinsDelta).clamp(
      0.0,
      double.infinity,
    );
    final updatedHeat = _heatService.clampHeat(
      state.playerState.heat + result.heatDelta,
    );
    final updatedTrust = _trustService.clampTrust(
      state.playerState.trust + result.trustDelta,
    );

    final updatedPlayerState = state.playerState.copyWith(
      coins: updatedCoins,
      heat: updatedHeat,
      trust: updatedTrust,
      lastActiveTimestamp: DateTime.now(),
    );

    _activeEvent = null;
    state = state.copyWith(playerState: updatedPlayerState);
    return result;
  }

  /// Applies minigame rewards from educational Suspicious Chat completion.
  void applyMinigameReward({
    required double coins,
    required double trust,
    required double heatDelta,
  }) {
    if (coins > 0) {
      _audioService.playAchievement();
    } else {
      _audioService.playWarning();
    }

    final updatedCoins = state.playerState.coins + coins;
    final updatedTrust = _trustService.clampTrust(
      state.playerState.trust + trust,
    );
    final updatedHeat = _heatService.clampHeat(
      state.playerState.heat + heatDelta,
    );

    final updatedPlayerState = state.playerState.copyWith(
      coins: updatedCoins,
      lifetimeRevenue: state.playerState.lifetimeRevenue + coins,
      trust: updatedTrust,
      heat: updatedHeat,
      lastActiveTimestamp: DateTime.now(),
    );

    state = state.copyWith(playerState: updatedPlayerState);
    saveGame();
  }

  /// Invoked on every logical game clock tick.
  void _onGameTick(Duration delta) {
    if (delta.inMicroseconds <= 0) return;

    final seconds = delta.inMicroseconds / 1000000.0;

    final incomePerSec = _economyService.calculateTotalIncomePerSec(
      operations: state.operations,
      upgrades: state.upgrades,
      prestigeSkills: state.prestigeSkills,
      trust: state.playerState.trust,
      prestigeMultiplier: state.playerState.prestigeMultiplier,
    );

    final heatPerSec = _economyService.calculateTotalHeatPerSec(
      operations: state.operations,
      prestigeSkills: state.prestigeSkills,
    );

    final trustPerSec = _economyService.calculateTotalTrustPerSec(
      operations: state.operations,
    );

    final earnedCoins = incomePerSec * seconds;
    final heatDelta = heatPerSec * seconds;
    final trustDelta = trustPerSec * seconds;

    // Check operation unlocks based on new Trust only when trust threshold is reached
    final newTrust = _trustService.clampTrust(
      state.playerState.trust + trustDelta,
    );
    List<Operation> operationsList = state.operations;
    for (int i = 0; i < state.operations.length; i++) {
      final op = state.operations[i];
      if (!op.isUnlocked && _trustService.isOperationUnlocked(op, newTrust)) {
        if (identical(operationsList, state.operations)) {
          operationsList = List<Operation>.from(state.operations);
        }
        operationsList[i] = op.copyWith(isUnlocked: true);
      }
    }

    final updatedPlayerState = state.playerState.copyWith(
      coins: state.playerState.coins + earnedCoins,
      lifetimeRevenue: state.playerState.lifetimeRevenue + earnedCoins,
      heat: _heatService.clampHeat(state.playerState.heat + heatDelta),
      trust: newTrust,
      lastActiveTimestamp: DateTime.now(),
    );

    // Evaluate achievements and daily goals
    final updatedAchievements = _achievementService.evaluateAchievements(
      currentAchievements: state.achievements,
      playerSave: state,
    );

    final updatedDailyGoals = _dailyGoalService.evaluateDailyGoals(
      currentGoals: state.dailyGoals,
      playerSave: state,
    );

    state = state.copyWith(
      playerState: updatedPlayerState,
      operations: operationsList,
      achievements: updatedAchievements,
      dailyGoals: updatedDailyGoals,
      savedAt: DateTime.now(),
    );
  }

  /// Persists current game state to local storage repository.
  Future<bool> saveGame() async {
    return await _saveRepository.writeSave(state);
  }

  /// Resets player save to default starting conditions.
  Future<void> resetGame() async {
    await _saveRepository.clearSave();
    state = PlayerSave.initial(
      operations: GameSeeds.getInitialOperations(),
      upgrades: GameSeeds.getInitialUpgrades(),
      prestigeSkills: GameSeeds.getInitialPrestigeSkills(),
      achievements: _achievementService.getInitialAchievements(),
      dailyGoals: _dailyGoalService.getInitialGoals(),
    );
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _gameClock.removeListener(_onGameTick);
    saveGame();
    super.dispose();
  }
}
