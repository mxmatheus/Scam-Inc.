import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/data/storage/local_storage_adapter.dart';
import 'package:scam_inc/data/repositories/save_repository.dart';
import 'package:scam_inc/data/repositories/settings_repository.dart';
import 'package:scam_inc/data/migrations/save_migrator.dart';
import 'package:scam_inc/models/enums/game_enums.dart';
import 'package:scam_inc/models/player_save.dart';
import 'package:scam_inc/models/player_state.dart';
import 'package:scam_inc/models/operation.dart';
import 'package:scam_inc/models/settings_state.dart';

void main() {
  group('SaveRepository Tests', () {
    late InMemoryStorageAdapter storage;
    late SaveRepository repository;

    setUp(() {
      storage = InMemoryStorageAdapter();
      repository = SaveRepository(storage);
    });

    test('Loads initial default save when storage is empty', () async {
      expect(await repository.hasSave(), false);

      final save = await repository.loadSave();
      expect(save.version, PlayerSave.currentVersion);
      expect(save.playerState.coins, 0.0);
      expect(save.playerState.trust, 0.0);
      expect(save.playerState.heat, 0.0);
      expect(save.operations, isEmpty);
    });

    test('Writes and successfully reloads save file', () async {
      final customSave = PlayerSave(
        version: 1,
        savedAt: DateTime.utc(2026, 8, 16, 12, 0, 0),
        playerState: PlayerState(
          coins: 50000.0,
          trust: 35.0,
          heat: 15.0,
          launderedCash: 250.0,
          gems: 10,
          lifetimeRevenue: 100000.0,
          currentOfficeTier: OperationTier.tier2Garage,
          prestigeLevel: 1,
          prestigeMultiplier: 1.15,
          totalTaps: 300,
          lastActiveTimestamp: DateTime.utc(2026, 8, 16, 12, 0, 0),
        ),
        operations: const [
          Operation(
            id: 'op_sms',
            name: 'Fake SMS',
            description: 'Phishing',
            iconPath: 'assets/icons/operations/op_fake_delivery_sms.png',
            baseCost: 100.0,
            baseIncome: 5.0,
            level: 3,
            isUnlocked: true,
          ),
        ],
      );

      final writeResult = await repository.writeSave(customSave);
      expect(writeResult, true);
      expect(await repository.hasSave(), true);

      final loaded = await repository.loadSave();
      expect(loaded, equals(customSave));
      expect(loaded.playerState.coins, 50000.0);
      expect(loaded.operations.first.level, 3);
    });

    test('Falls back to initial save when stored JSON is corrupted', () async {
      await storage.setString(SaveRepository.saveKey, 'NOT_A_VALID_JSON{:::');

      final fallbackSave = await repository.loadSave();
      expect(fallbackSave.version, PlayerSave.currentVersion);
      expect(fallbackSave.playerState.coins, 0.0);
    });

    test('Clears save file properly', () async {
      await repository.writeSave(PlayerSave.initial());
      expect(await repository.hasSave(), true);

      await repository.clearSave();
      expect(await repository.hasSave(), false);
    });
  });

  group('SaveMigrator Tests', () {
    test('Handles schema upgrades seamlessly', () {
      final oldJson = {
        'version': 1,
        'savedAt': '2026-08-16T10:00:00.000Z',
        'playerState': {
          'coins': 1234.0,
          'trust': 10.0,
          'heat': 5.0,
          'lastActiveTimestamp': '2026-08-16T10:00:00.000Z',
        },
      };

      final migrated = SaveMigrator.migrateJson(
        Map<String, dynamic>.from(oldJson),
      );
      expect(migrated['version'], PlayerSave.currentVersion);
    });

    test('SafeParse returns default save for non-map json', () {
      final result = SaveMigrator.safeParse('["not", "a", "map"]');
      expect(result, isA<PlayerSave>());
      expect(result.playerState.coins, 0.0);
    });
  });

  group('SettingsRepository Tests', () {
    late InMemoryStorageAdapter storage;
    late SettingsRepository repository;

    setUp(() {
      storage = InMemoryStorageAdapter();
      repository = SettingsRepository(storage);
    });

    test('Loads default settings when empty', () async {
      final settings = await repository.loadSettings();
      expect(settings.soundEnabled, true);
      expect(settings.musicEnabled, true);
      expect(settings.languageCode, 'en');
    });

    test('Saves and reloads custom settings', () async {
      const custom = SettingsState(
        soundEnabled: false,
        musicEnabled: false,
        hapticsEnabled: true,
        notificationsEnabled: false,
        compactNumberFormat: false,
        languageCode: 'tr',
      );

      final success = await repository.saveSettings(custom);
      expect(success, true);

      final loaded = await repository.loadSettings();
      expect(loaded, equals(custom));
      expect(loaded.languageCode, 'tr');
      expect(loaded.soundEnabled, false);
    });
  });
}
