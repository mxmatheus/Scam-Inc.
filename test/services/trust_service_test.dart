import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/models/operation.dart';
import 'package:scam_inc/services/trust_service.dart';

void main() {
  const trustService = TrustService();

  group('TrustService Tests', () {
    test('Clamps trust within 0.0 and 100.0', () {
      expect(trustService.clampTrust(-5.0), 0.0);
      expect(trustService.clampTrust(85.0), 85.0);
      expect(trustService.clampTrust(110.0), 100.0);
    });

    test('Validates operation unlock based on trust requirement', () {
      const lockedOp = Operation(
        id: 'op2',
        name: 'Op2',
        description: '',
        iconPath: '',
        baseCost: 100.0,
        baseIncome: 5.0,
        trustRequirement: 25.0,
        isUnlocked: false,
      );

      expect(trustService.isOperationUnlocked(lockedOp, 20.0), false);
      expect(trustService.isOperationUnlocked(lockedOp, 25.0), true);
      expect(trustService.isOperationUnlocked(lockedOp, 50.0), true);
    });

    test('Returns titles corresponding to trust progression', () {
      expect(trustService.getTrustTitle(5.0), 'Basement Hustler');
      expect(trustService.getTrustTitle(30.0), 'Commercial Operator');
      expect(trustService.getTrustTitle(95.0), 'Untouchable Shadow Boss');
    });
  });
}
