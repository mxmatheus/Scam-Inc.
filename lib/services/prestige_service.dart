import 'dart:math' as math;
import '../models/player_state.dart';

class PrestigeRewardResult {
  final double launderableCash;
  final bool isEligible;
  final double newPrestigeMultiplier;

  const PrestigeRewardResult({
    required this.launderableCash,
    required this.isEligible,
    required this.newPrestigeMultiplier,
  });
}

/// Service calculating offshore prestige escape formulas and reset transactions.
class PrestigeService {
  const PrestigeService();

  /// Calculates the earned Laundered Cash based on total lifetime revenue.
  double calculateLaunderedCash(double lifetimeRevenue) {
    if (lifetimeRevenue <= 0) return 0.0;
    // Formula: floor(10 * sqrt(lifetimeRevenue / 1,000,000))
    final val = 10.0 * math.sqrt(lifetimeRevenue / 1000000.0);
    return math.max(0.0, val.floorToDouble());
  }

  /// Evaluates whether the player has accumulated enough wealth to trigger an escape.
  PrestigeRewardResult evaluatePrestigeEligibility(PlayerState playerState) {
    final reward = calculateLaunderedCash(playerState.lifetimeRevenue);
    // Requires earning at least 1 new Laundered Cash
    final isEligible = reward > 0;
    final newMultiplier =
        1.0 + ((playerState.prestigeLevel + 1) * 0.15); // +15% per escape

    return PrestigeRewardResult(
      launderableCash: reward,
      isEligible: isEligible,
      newPrestigeMultiplier: newMultiplier,
    );
  }
}
