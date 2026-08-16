import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/services/game_clock_service.dart';

void main() {
  group('GameClockService Tests', () {
    late GameClockService clock;

    setUp(() {
      clock = GameClockService();
    });

    tearDown(() {
      clock.stop();
    });

    test('Initializes in stopped state', () {
      expect(clock.isRunning, false);
      expect(clock.isPaused, false);
    });

    test('Notifies listeners on manual deterministic tick', () {
      Duration? receivedDelta;
      clock.addListener((delta) {
        receivedDelta = delta;
      });

      clock.tickManually(const Duration(milliseconds: 500));
      expect(receivedDelta, const Duration(milliseconds: 500));
    });

    test('Pause and resume state management', () {
      clock.pause();
      expect(clock.isPaused, true);

      clock.resume();
      expect(clock.isPaused, false);
    });

    test('Properly adds and removes listeners', () {
      int tickCount = 0;
      void listener(Duration delta) {
        tickCount++;
      }

      clock.addListener(listener);
      clock.tickManually(const Duration(seconds: 1));
      expect(tickCount, 1);

      clock.removeListener(listener);
      clock.tickManually(const Duration(seconds: 1));
      expect(tickCount, 1); // no increment
    });
  });
}
