import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/data/storage/local_storage_adapter.dart';
import 'package:scam_inc/data/repositories/save_repository.dart';
import 'package:scam_inc/services/economy_service.dart';
import 'package:scam_inc/services/heat_service.dart';
import 'package:scam_inc/services/trust_service.dart';
import 'package:scam_inc/services/offline_income_service.dart';
import 'package:scam_inc/services/event_service.dart';
import 'package:scam_inc/services/game_clock_service.dart';
import 'package:scam_inc/game/game_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameController Tests (Playable Loop)', () {
    late InMemoryStorageAdapter storage;
    late SaveRepository saveRepository;
    late EconomyService economyService;
    late HeatService heatService;
    late TrustService trustService;
    late OfflineIncomeService offlineIncomeService;
    late EventService eventService;
    late GameClockService gameClock;
    late GameController controller;

    setUp(() {
      storage = InMemoryStorageAdapter();
      saveRepository = SaveRepository(storage);
      economyService = const EconomyService();
      heatService = const HeatService();
      trustService = const TrustService();
      offlineIncomeService = const OfflineIncomeService();
      eventService = const EventService();
      gameClock = GameClockService();

      controller = GameController(
        saveRepository: saveRepository,
        economyService: economyService,
        heatService: heatService,
        trustService: trustService,
        offlineIncomeService: offlineIncomeService,
        eventService: eventService,
        gameClock: gameClock,
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initializes with default seeds', () {
      expect(controller.state.operations.isNotEmpty, true);
      expect(controller.state.operations.first.id, 'op_fake_delivery_sms');
      expect(controller.state.playerState.coins, 0.0);
    });

    test('Manual tap increments coins and totalTaps', () {
      controller.tap();
      expect(controller.state.playerState.coins, 1.0);
      expect(controller.state.playerState.totalTaps, 1);

      controller.tap();
      expect(controller.state.playerState.coins, 2.0);
      expect(controller.state.playerState.totalTaps, 2);
    });

    test('Cannot buy operation with insufficient funds', () {
      final success = controller.buyOperation('op_fake_delivery_sms');
      expect(success, false);
      expect(controller.state.operations.first.level, 0);
    });

    test('Buys operation when affordable, increments level, deducts coins', () {
      // Tap 10 times to earn 10.0 coins (cost of level 1 Fake Delivery SMS)
      for (int i = 0; i < 10; i++) {
        controller.tap();
      }
      expect(controller.state.playerState.coins, 10.0);

      final success = controller.buyOperation('op_fake_delivery_sms');
      expect(success, true);
      expect(controller.state.playerState.coins, 0.0);

      final smsOp = controller.state.operations.firstWhere(
        (o) => o.id == 'op_fake_delivery_sms',
      );
      expect(smsOp.level, 1);
      expect(smsOp.isUnlocked, true);
    });

    test('Game clock tick generates passive income from active operations', () {
      // Setup operation at level 2 (income = 2.0 / sec)
      for (int i = 0; i < 30; i++) {
        controller.tap();
      }
      controller.buyOperation('op_fake_delivery_sms'); // level 1 (cost 10)
      controller.buyOperation('op_fake_delivery_sms'); // level 2 (cost 11.5)

      final coinsBefore = controller.state.playerState.coins;

      // Simulate 5 seconds game tick
      gameClock.tickManually(const Duration(seconds: 5));

      // Level 2 baseIncome 1.0 = 2.0 S-Coins/sec * 5s = 10.0 S-Coins earned
      expect(
        controller.state.playerState.coins,
        closeTo(coinsBefore + 10.0, 0.01),
      );
    });
  });
}
