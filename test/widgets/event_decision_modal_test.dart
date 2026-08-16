import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/core/widgets/event_decision_modal.dart';
import 'package:scam_inc/data/seeds/event_seeds.dart';
import 'package:scam_inc/models/event_choice.dart';

void main() {
  group('EventDecisionModal Widget Tests', () {
    testWidgets('Renders event details and choice buttons', (
      WidgetTester tester,
    ) async {
      final event = EventSeeds.getAllEvents().first;
      EventChoice? selectedChoice;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EventDecisionModal(
              event: event,
              currentCoins: 100000.0,
              onSelectChoice: (c) {
                selectedChoice = c;
              },
            ),
          ),
        ),
      );

      expect(find.text(event.title), findsOneWidget);
      expect(find.text(event.choices.first.label), findsOneWidget);

      await tester.tap(find.text('EXECUTE DECISION').first);
      expect(selectedChoice, equals(event.choices.first));
    });
  });
}
