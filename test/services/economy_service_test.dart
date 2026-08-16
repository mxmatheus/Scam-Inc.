import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/models/operation.dart';
import 'package:scam_inc/models/player_state.dart';
import 'package:scam_inc/models/upgrade.dart';
import 'package:scam_inc/services/economy_service.dart';

void main() {
  const economy = EconomyService();

  group('EconomyService - Tap Income', () {
    test('Calculates base tap income with 0 passive income', () {
      final state = PlayerState.initial();
      final tapValue = economy.calculateTapIncome(
        playerState: state,
        operations: const [],
        upgrades: const [],
        prestigeSkills: const [],
      );

      expect(tapValue, 1.0);
    });

    test('Scales tap income with 1% of passive income', () {
      final state = PlayerState.initial();
      const op = Operation(
        id: 'op1',
        name: 'Op 1',
        description: '',
        iconPath: '',
        baseCost: 10.0,
        baseIncome: 100.0,
        level: 1,
        isUnlocked: true,
      );

      final tapValue = economy.calculateTapIncome(
        playerState: state,
        operations: const [op],
        upgrades: const [],
        prestigeSkills: const [],
      );

      // Passive income = 100.0 * 1.0 = 100.0 -> tap = 1.0 + (100.0 * 0.01) = 2.0
      expect(tapValue, 2.0);
    });

    test('Applies global tap upgrades and prestige multipliers', () {
      final state = PlayerState.initial().copyWith(prestigeMultiplier: 2.0);
      const upgrade = Upgrade(
        id: 'up_tap',
        name: 'Golden Tap',
        description: '',
        iconPath: '',
        cost: 100.0,
        targetOperationId: '', // global
        multiplier: 3.0,
        isPurchased: true,
      );

      final tapValue = economy.calculateTapIncome(
        playerState: state,
        operations: const [],
        upgrades: const [upgrade],
        prestigeSkills: const [],
      );

      // 1.0 * 3.0 (upgrade) * 2.0 (prestige) = 6.0
      expect(tapValue, 6.0);
    });
  });

  group('EconomyService - Operation Income & Multipliers', () {
    test('Returns 0 for locked or level 0 operations', () {
      const lockedOp = Operation(
        id: 'op1',
        name: 'Op 1',
        description: '',
        iconPath: '',
        baseCost: 10.0,
        baseIncome: 50.0,
        level: 5,
        isUnlocked: false,
      );

      expect(
        economy.calculateOperationIncomePerSec(
          operation: lockedOp,
          upgrades: const [],
          prestigeSkills: const [],
          trust: 0.0,
        ),
        0.0,
      );
    });

    test('Calculates operation income with upgrade and trust multipliers', () {
      const op = Operation(
        id: 'op_sms',
        name: 'SMS',
        description: '',
        iconPath: '',
        baseCost: 10.0,
        baseIncome: 10.0,
        level: 2, // base = 20.0
        isUnlocked: true,
      );

      const upgrade = Upgrade(
        id: 'up_sms',
        name: '2x SMS',
        description: '',
        iconPath: '',
        cost: 50.0,
        targetOperationId: 'op_sms',
        multiplier: 2.0,
        isPurchased: true,
      );

      // Trust at 100% gives 1.5x multiplier
      final income = economy.calculateOperationIncomePerSec(
        operation: op,
        upgrades: const [upgrade],
        prestigeSkills: const [],
        trust: 100.0,
      );

      // 20.0 * 2.0 (upgrade) * 1.5 (trust) = 60.0
      expect(income, 60.0);
    });

    test('Calculates total cumulative income across multiple operations', () {
      const op1 = Operation(
        id: 'op1',
        name: 'Op1',
        description: '',
        iconPath: '',
        baseCost: 10.0,
        baseIncome: 5.0,
        level: 2, // 10.0
        isUnlocked: true,
      );
      const op2 = Operation(
        id: 'op2',
        name: 'Op2',
        description: '',
        iconPath: '',
        baseCost: 100.0,
        baseIncome: 20.0,
        level: 1, // 20.0
        isUnlocked: true,
      );

      final total = economy.calculateTotalIncomePerSec(
        operations: const [op1, op2],
        upgrades: const [],
        prestigeSkills: const [],
        trust: 0.0, // multiplier = 1.0
      );

      expect(total, 30.0);
    });
  });

  group('EconomyService - Affordability and Trust', () {
    test('Trust multiplier scales cleanly between 1.0 and 1.5', () {
      expect(economy.calculateTrustMultiplier(0.0), 1.0);
      expect(economy.calculateTrustMultiplier(50.0), 1.25);
      expect(economy.calculateTrustMultiplier(100.0), 1.5);
      expect(economy.calculateTrustMultiplier(150.0), 1.5); // clamped
    });

    test('canAfford accurately checks balance', () {
      expect(economy.canAfford(100.0, 50.0), true);
      expect(economy.canAfford(50.0, 50.0), true);
      expect(economy.canAfford(49.99, 50.0), false);
    });
  });
}
