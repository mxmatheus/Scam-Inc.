import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/models/player_state.dart';
import 'package:scam_inc/services/prestige_service.dart';

void main() {
  const service = PrestigeService();

  group('PrestigeService Tests', () {
    test('Calculates zero reward for zero or small lifetime revenue', () {
      expect(service.calculateLaunderedCash(0.0), 0.0);
      expect(service.calculateLaunderedCash(5000.0), 0.0);
    });

    test('Calculates accurate Laundered Cash for milestones', () {
      // 1,000,000 revenue -> 10 * sqrt(1) = 10 LC
      expect(service.calculateLaunderedCash(1000000.0), 10.0);
      // 4,000,000 revenue -> 10 * sqrt(4) = 20 LC
      expect(service.calculateLaunderedCash(4000000.0), 20.0);
      // 9,000,000 revenue -> 10 * sqrt(9) = 30 LC
      expect(service.calculateLaunderedCash(9000000.0), 30.0);
    });

    test('Evaluates eligibility accurately', () {
      final now = DateTime.now();
      final stateIneligible = PlayerState(
        lifetimeRevenue: 5000.0,
        lastActiveTimestamp: now,
      );
      final eval1 = service.evaluatePrestigeEligibility(stateIneligible);
      expect(eval1.isEligible, false);
      expect(eval1.launderableCash, 0.0);

      final stateEligible = PlayerState(
        lifetimeRevenue: 1000000.0,
        prestigeLevel: 0,
        lastActiveTimestamp: now,
      );
      final eval2 = service.evaluatePrestigeEligibility(stateEligible);
      expect(eval2.isEligible, true);
      expect(eval2.launderableCash, 10.0);
      expect(eval2.newPrestigeMultiplier, 1.15);
    });
  });
}
