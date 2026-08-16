import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/features/minigames/services/chat_minigame_service.dart';

void main() {
  final service = ChatMinigameService();

  group('Suspicious Chat Mini-Game Tests', () {
    test('Provides educational scenarios with choices and red flags', () {
      final scenarios = ChatMinigameService.getScenarios();
      expect(scenarios.length, greaterThanOrEqualTo(3));

      for (final scenario in scenarios) {
        expect(scenario.incomingMessage.isNotEmpty, true);
        expect(scenario.redFlagSummary.isNotEmpty, true);
        expect(scenario.choices.length, 3);
        // Each scenario has at least one anti-scam safe response
        expect(scenario.choices.any((c) => c.isAntiScamWinner), true);
      }
    });

    test('Random scenario picker returns valid scenario', () {
      final scenario = service.getRandomScenario();
      expect(scenario.id.startsWith('sc_'), true);
      expect(scenario.contactName.isNotEmpty, true);
    });
  });
}
