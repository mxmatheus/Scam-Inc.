enum HeatStatus { safe, warning, danger, criticalRaid }

/// Centralized service for Police Investigation Heat management.
class HeatService {
  const HeatService();

  /// Clamps heat between 0.0% and 100.0%.
  double clampHeat(double heat) {
    return heat.clamp(0.0, 100.0);
  }

  /// Evaluates the visual and risk level of current heat.
  HeatStatus getHeatStatus(double heat) {
    final clamped = clampHeat(heat);
    if (clamped >= 90.0) return HeatStatus.criticalRaid;
    if (clamped >= 70.0) return HeatStatus.danger;
    if (clamped >= 40.0) return HeatStatus.warning;
    return HeatStatus.safe;
  }

  /// Calculates the S-Coin bribe/legal retainer cost to cool down heat.
  double calculateBribeCost(double currentHeat, double incomePerSec) {
    if (currentHeat <= 0.0) return 0.0;
    // Scaled formula based on current heat severity and income capability
    final baseCost = currentHeat * 50.0;
    final incomeFactor = (incomePerSec * 10.0).clamp(0.0, 1000000.0);
    return (baseCost + incomeFactor).roundToDouble();
  }

  /// Calculates heat reduction amount on successful bribe (defaults to -35%).
  double calculateHeatCooldownDelta({double cooldownAmount = 35.0}) {
    return -cooldownAmount;
  }
}
