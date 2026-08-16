import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/core/widgets/operation_card.dart';
import 'package:scam_inc/models/operation.dart';

void main() {
  group('OperationCard Widget Tests', () {
    testWidgets('Renders unlocked operation with upgrade button', (
      WidgetTester tester,
    ) async {
      bool upgraded = false;
      const op = Operation(
        id: 'op_sms',
        name: 'Fake Delivery SMS',
        description: 'Phishing',
        iconPath: 'assets/icons/operations/op_fake_delivery_sms.png',
        baseCost: 10.0,
        baseIncome: 1.0,
        level: 1,
        isUnlocked: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OperationCard(
              operation: op,
              currentCoins: 100.0,
              currentTrust: 10.0,
              buyMultiplier: 1,
              onUpgrade: () {
                upgraded = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Fake Delivery SMS'), findsOneWidget);
      expect(find.text('Lv. 1'), findsOneWidget);
      expect(find.text('+1 (\$11.5)'), findsOneWidget);

      await tester.tap(find.text('+1 (\$11.5)'));
      expect(upgraded, true);
    });

    testWidgets('Renders locked operation with requirement text', (
      WidgetTester tester,
    ) async {
      const lockedOp = Operation(
        id: 'op_crypto',
        name: 'Crypto Pump Room',
        description: 'Pump',
        iconPath: 'assets/icons/operations/op_crypto_pump_room.png',
        baseCost: 20000.0,
        baseIncome: 900.0,
        trustRequirement: 20.0,
        isUnlocked: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OperationCard(
              operation: lockedOp,
              currentCoins: 50000.0,
              currentTrust: 10.0,
              buyMultiplier: 1,
              onUpgrade: () {},
            ),
          ),
        ),
      );

      expect(find.text('Crypto Pump Room'), findsOneWidget);
      expect(find.text('LOCKED — Reach 20 Trust to operate'), findsOneWidget);
    });
  });
}
