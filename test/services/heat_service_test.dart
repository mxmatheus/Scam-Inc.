import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/services/heat_service.dart';

void main() {
  const heatService = HeatService();

  group('HeatService Tests', () {
    test('Clamps heat within 0.0 and 100.0', () {
      expect(heatService.clampHeat(-10.0), 0.0);
      expect(heatService.clampHeat(50.0), 50.0);
      expect(heatService.clampHeat(120.0), 100.0);
    });

    test('Identifies appropriate HeatStatus levels', () {
      expect(heatService.getHeatStatus(10.0), HeatStatus.safe);
      expect(heatService.getHeatStatus(45.0), HeatStatus.warning);
      expect(heatService.getHeatStatus(75.0), HeatStatus.danger);
      expect(heatService.getHeatStatus(95.0), HeatStatus.criticalRaid);
    });

    test('Calculates bribe cost scaling with heat and income', () {
      expect(heatService.calculateBribeCost(0.0, 100.0), 0.0);
      final cost = heatService.calculateBribeCost(50.0, 10.0);
      // (50 * 50) + (10 * 10) = 2500 + 100 = 2600.0
      expect(cost, 2600.0);
    });

    test('Provides heat cooldown delta', () {
      expect(heatService.calculateHeatCooldownDelta(), -35.0);
    });
  });
}
