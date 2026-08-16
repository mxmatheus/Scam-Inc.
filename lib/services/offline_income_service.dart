import 'package:flutter/foundation.dart';
import '../models/operation.dart';
import '../models/player_state.dart';
import '../models/prestige_skill.dart';
import '../models/upgrade.dart';
import 'economy_service.dart';

@immutable
class OfflineEarningsResult {
  final Duration elapsed;
  final Duration cappedDuration;
  final double earnedCoins;
  final double earnedHeat;
  final double earnedTrust;
  final bool isEligible;

  const OfflineEarningsResult({
    required this.elapsed,
    required this.cappedDuration,
    required this.earnedCoins,
    required this.earnedHeat,
    required this.earnedTrust,
    required this.isEligible,
  });

  factory OfflineEarningsResult.none() {
    return const OfflineEarningsResult(
      elapsed: Duration.zero,
      cappedDuration: Duration.zero,
      earnedCoins: 0.0,
      earnedHeat: 0.0,
      earnedTrust: 0.0,
      isEligible: false,
    );
  }
}

/// Computes deterministic passive progression while player was away.
class OfflineIncomeService {
  static const Duration maxOfflineDuration = Duration(hours: 8);
  static const Duration minimumOfflineThreshold = Duration(seconds: 15);

  final EconomyService _economyService;

  const OfflineIncomeService({
    EconomyService economyService = const EconomyService(),
  }) : _economyService = economyService;

  OfflineEarningsResult calculateOfflineEarnings({
    required PlayerState playerState,
    required List<Operation> operations,
    required List<Upgrade> upgrades,
    required List<PrestigeSkill> prestigeSkills,
    required DateTime now,
  }) {
    final lastActive = playerState.lastActiveTimestamp;

    // Safety check for clock manipulation or future dates
    if (now.isBefore(lastActive)) {
      return OfflineEarningsResult.none();
    }

    final elapsed = now.difference(lastActive);
    if (elapsed < minimumOfflineThreshold) {
      return OfflineEarningsResult.none();
    }

    // Cap duration at 8 hours maximum
    final cappedDuration = elapsed > maxOfflineDuration
        ? maxOfflineDuration
        : elapsed;
    final seconds = cappedDuration.inMicroseconds / 1000000.0;

    final incomePerSec = _economyService.calculateTotalIncomePerSec(
      operations: operations,
      upgrades: upgrades,
      prestigeSkills: prestigeSkills,
      trust: playerState.trust,
      prestigeMultiplier: playerState.prestigeMultiplier,
    );

    if (incomePerSec <= 0.0) {
      return OfflineEarningsResult.none();
    }

    final earnedCoins = incomePerSec * seconds;
    // Offline heat and trust accumulate at 50% speed for balanced player return
    final earnedHeat =
        _economyService.calculateTotalHeatPerSec(
          operations: operations,
          prestigeSkills: prestigeSkills,
        ) *
        seconds *
        0.5;
    final earnedTrust =
        _economyService.calculateTotalTrustPerSec(operations: operations) *
        seconds *
        0.5;

    return OfflineEarningsResult(
      elapsed: elapsed,
      cappedDuration: cappedDuration,
      earnedCoins: earnedCoins,
      earnedHeat: earnedHeat,
      earnedTrust: earnedTrust,
      isEligible: true,
    );
  }
}
