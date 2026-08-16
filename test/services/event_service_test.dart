import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/services/event_service.dart';
import 'package:scam_inc/data/seeds/event_seeds.dart';

void main() {
  final eventService = EventService(events: EventSeeds.getAllEvents());

  group('EventService Tests', () {
    test('Contains all 8 master narrative events', () {
      expect(eventService.events.length, 8);
      expect(eventService.events.map((e) => e.id), contains('ev_police_raid'));
      expect(
        eventService.events.map((e) => e.id),
        contains('ev_journalist_investigation'),
      );
    });

    test('Random event picker returns valid event', () {
      final event = eventService.getRandomEvent();
      expect(event, isNotNull);
      expect(event.choices.isNotEmpty, true);
    });

    test('Deterministic success choice resolution', () {
      final raidEvent = eventService.events.firstWhere(
        (e) => e.id == 'ev_police_raid',
      );
      final choice = raidEvent.choices.first;

      // Mock random returning 0.0 (always <= successRate)
      final result = eventService.resolveChoice(
        event: raidEvent,
        choice: choice,
        random: math.Random(1),
      );

      expect(result.isSuccess, true);
      expect(result.heatDelta, -30.0);
      expect(result.trustDelta, -5.0);
    });
  });
}
