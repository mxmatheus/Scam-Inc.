import 'dart:math' as math;
import '../models/game_event.dart';
import '../models/event_choice.dart';
import '../data/seeds/event_seeds.dart';

class EventResolutionResult {
  final bool isSuccess;
  final double coinsDelta;
  final double heatDelta;
  final double trustDelta;
  final String feedbackMessage;

  const EventResolutionResult({
    required this.isSuccess,
    required this.coinsDelta,
    required this.heatDelta,
    required this.trustDelta,
    required this.feedbackMessage,
  });
}

/// Service managing random event triggering, cooldowns, and choice resolutions.
class EventService {
  final List<GameEvent> _events;
  static const Duration defaultCooldown = Duration(seconds: 45);

  const EventService({List<GameEvent>? events}) : _events = events ?? const [];

  List<GameEvent> get events =>
      _events.isNotEmpty ? _events : EventSeeds.getAllEvents();

  /// Picks a random narrative event from the available pool.
  GameEvent getRandomEvent({math.Random? random}) {
    final rand = random ?? math.Random();
    final all = events;
    return all[rand.nextInt(all.length)];
  }

  /// Resolves the consequences of selecting a choice.
  EventResolutionResult resolveChoice({
    required GameEvent event,
    required EventChoice choice,
    math.Random? random,
  }) {
    final rand = random ?? math.Random();
    final roll = rand.nextDouble();
    final isSuccess = roll <= choice.successRate;

    if (isSuccess) {
      final coinsDelta = choice.sCoinsReward - choice.sCoinsCost;
      final trustDelta = choice.trustReward - choice.trustCost;
      final heatDelta = choice.heatDelta;

      return EventResolutionResult(
        isSuccess: true,
        coinsDelta: coinsDelta,
        heatDelta: heatDelta,
        trustDelta: trustDelta,
        feedbackMessage:
            'Operation Successful: ${choice.label} executed with optimal outcome.',
      );
    } else {
      // Failure penalty: Costs still deducted, no reward, added heat risk
      final coinsDelta = -choice.sCoinsCost;
      final trustDelta = -choice.trustCost - 5.0;
      final heatDelta = (choice.heatDelta + 15.0).clamp(0.0, 30.0);

      return EventResolutionResult(
        isSuccess: false,
        coinsDelta: coinsDelta,
        heatDelta: heatDelta,
        trustDelta: trustDelta,
        feedbackMessage:
            'Complication: Investigators anticipated your move. Additional Heat incurred!',
      );
    }
  }
}
