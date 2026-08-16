import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../models/player_save.dart';

/// Handles version migration and corruption fallback for player save files.
class SaveMigrator {
  static const int currentSchemaVersion = PlayerSave.currentVersion;

  /// Migrates raw JSON map data to the latest schema version.
  static Map<String, dynamic> migrateJson(Map<String, dynamic> rawJson) {
    int version = (rawJson['version'] as num?)?.toInt() ?? 1;

    // Sequential migration pipeline
    while (version < currentSchemaVersion) {
      switch (version) {
        case 1:
          // Placeholder for future v1 -> v2 migration step
          version = 2;
          rawJson['version'] = version;
          break;
        default:
          version = currentSchemaVersion;
          break;
      }
    }

    return rawJson;
  }

  /// Safely parses a JSON string into [PlayerSave] with corruption fallback.
  static PlayerSave safeParse(String jsonString) {
    try {
      final decoded = json.decode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        debugPrint(
          '[SaveMigrator] Invalid JSON structure. Using initial save.',
        );
        return PlayerSave.initial();
      }

      final migrated = migrateJson(Map<String, dynamic>.from(decoded));
      return PlayerSave.fromJson(migrated);
    } catch (e, stack) {
      debugPrint('[SaveMigrator] Save file corrupted: $e\n$stack');
      return PlayerSave.initial();
    }
  }
}
