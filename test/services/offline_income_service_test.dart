import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/models/operation.dart';
import 'package:scam_inc/models/player_state.dart';
import 'package:scam_inc/services/economy_service.dart';
import 'package:scam_inc/services/offline_income_service.dart';

void main() {
  const offlineService = OfflineIncomeService(economyService: EconomyService());

  group('OfflineIncomeService Tests', () {
    test(
      'Returns none when offline duration is below minimum threshold (15s)',
      () {
        final now = DateTime.utc(2026, 8, 16, 12, 0, 10);
        final lastActive = DateTime.utc(
          2026,
          8,
          16,
          12,
          0,
          0,
        ); // 10s difference
        final state = PlayerState.initial().copyWith(
          lastActiveTimestamp: lastActive,
        );

        final result = offlineService.calculateOfflineEarnings(
          playerState: state,
          operations: const [
            Operation(
              id: 'op1',
              name: '',
              description: '',
              iconPath: '',
              baseCost: 10,
              baseIncome: 5,
              level: 1,
              isUnlocked: true,
            ),
          ],
          upgrades: const [],
          prestigeSkills: const [],
          now: now,
        );

        expect(result.isEligible, false);
        expect(result.earnedCoins, 0.0);
      },
    );

    test('Safely handles future timestamp clock manipulation', () {
      final now = DateTime.utc(2026, 8, 16, 11, 0, 0);
      final futureLastActive = DateTime.utc(2026, 8, 16, 12, 0, 0);
      final state = PlayerState.initial().copyWith(
        lastActiveTimestamp: futureLastActive,
      );

      final result = offlineService.calculateOfflineEarnings(
        playerState: state,
        operations: const [],
        upgrades: const [],
        prestigeSkills: const [],
        now: now,
      );

      expect(result.isEligible, false);
    });

    test('Calculates offline earnings for 1 hour', () {
      final now = DateTime.utc(2026, 8, 16, 13, 0, 0);
      final lastActive = DateTime.utc(
        2026,
        8,
        16,
        12,
        0,
        0,
      ); // 1 hour = 3600 seconds
      final state = PlayerState.initial().copyWith(
        lastActiveTimestamp: lastActive,
      );

      const op = Operation(
        id: 'op1',
        name: '',
        description: '',
        iconPath: '',
        baseCost: 10,
        baseIncome: 2.0, // 2.0 S-Coins / sec
        level: 1,
        isUnlocked: true,
      );

      final result = offlineService.calculateOfflineEarnings(
        playerState: state,
        operations: const [op],
        upgrades: const [],
        prestigeSkills: const [],
        now: now,
      );

      expect(result.isEligible, true);
      expect(result.cappedDuration, const Duration(hours: 1));
      // 3600 seconds * 2.0 S-Coins = 7200.0 S-Coins
      expect(result.earnedCoins, 7200.0);
    });

    test('Caps offline duration at 8 hours maximum', () {
      final now = DateTime.utc(2026, 8, 17, 12, 0, 0); // 24 hours later
      final lastActive = DateTime.utc(2026, 8, 16, 12, 0, 0);
      final state = PlayerState.initial().copyWith(
        lastActiveTimestamp: lastActive,
      );

      const op = Operation(
        id: 'op1',
        name: '',
        description: '',
        iconPath: '',
        baseCost: 10,
        baseIncome: 1.0,
        level: 1,
        isUnlocked: true,
      );

      final result = offlineService.calculateOfflineEarnings(
        playerState: state,
        operations: const [op],
        upgrades: const [],
        prestigeSkills: const [],
        now: now,
      );

      expect(result.isEligible, true);
      expect(result.cappedDuration, const Duration(hours: 8));
      // 8 hours = 28800 seconds * 1.0 = 28800.0 S-Coins
      expect(result.earnedCoins, 28800.0);
    });
  });
}
