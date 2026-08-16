import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/features/minigames/services/scam_baiter_service.dart';

void main() {
  final service = ScamBaiterService();

  group('Scam Baiter Mini-Game Tests', () {
    test('Provides scenarios with valid profiles and malicious tags', () {
      final scenarios = ScamBaiterService.getScenarios();
      expect(scenarios.length, greaterThanOrEqualTo(3));

      for (final scenario in scenarios) {
        expect(scenario.profileName.isNotEmpty, true);
        expect(scenario.directMessage.isNotEmpty, true);
        expect(scenario.redFlagExplanation.isNotEmpty, true);
      }
    });

    test('Random picker returns a valid scenario', () {
      final scenario = service.getRandomScenario();
      expect(scenario.id.startsWith('sb_'), true);
    });
  });
}
