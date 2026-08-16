import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/models/player_state.dart';
import 'package:scam_inc/services/economy_service.dart';
import 'package:scam_inc/services/heat_service.dart';
import 'package:scam_inc/services/trust_service.dart';
import 'package:scam_inc/services/offline_income_service.dart';
import 'package:scam_inc/data/seeds/game_seeds.dart';

void main() {
  const economy = EconomyService();
  const heatService = HeatService();
  const trustService = TrustService();
  const offlineService = OfflineIncomeService();

  group('PROMPT 27 — Security, Edge Cases & Data Integrity Audit', () {
    test(
      'Clock manipulation backwards does not generate negative or runaway resources',
      () {
        final pastTime = DateTime.now().subtract(const Duration(hours: 5));
        final state = PlayerState(lastActiveTimestamp: DateTime.now());

        // Attempt calculating offline earnings with a manipulated past timestamp
        final result = offlineService.calculateOfflineEarnings(
          playerState: state,
          operations: GameSeeds.getInitialOperations(),
          upgrades: GameSeeds.getInitialUpgrades(),
          prestigeSkills: GameSeeds.getInitialPrestigeSkills(),
          now: pastTime,
        );

        expect(result.isEligible, false);
        expect(result.earnedCoins, 0.0);
      },
    );

    test(
      'Heat & Trust remain strictly clamped between 0.0 and 100.0 regardless of wild inputs',
      () {
        expect(heatService.clampHeat(-999.0), 0.0);
        expect(heatService.clampHeat(999999.0), 100.0);

        expect(trustService.clampTrust(-50.0), 0.0);
        expect(trustService.clampTrust(150.0), 100.0);
      },
    );

    test(
      'Affordability evaluator safely handles negative and zero balances',
      () {
        expect(economy.canAfford(-100.0, 50.0), false);
        expect(economy.canAfford(0.0, 1.0), false);
        expect(economy.canAfford(100.0, 100.0), true);
      },
    );

    test('Negative heat operations cool down company heat rate correctly', () {
      final operations = GameSeeds.getInitialOperations();
      final prCrisisOp = operations.firstWhere((o) => o.id == 'op_pr_crisis');

      expect(prCrisisOp.baseHeatPerSecond < 0, true);
    });
  });
}
