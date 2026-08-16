import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../models/settings_state.dart';
import '../storage/local_storage_adapter.dart';

/// Repository responsible for persisting and retrieving player settings.
class SettingsRepository {
  static const String settingsKey = 'scam_inc_settings_v1';
  final LocalStorageAdapter _storage;

  const SettingsRepository(this._storage);

  /// Loads player settings. Returns defaults if no settings are stored.
  Future<SettingsState> loadSettings() async {
    try {
      final raw = await _storage.getString(settingsKey);
      if (raw == null || raw.isEmpty) {
        return const SettingsState();
      }
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) {
        return SettingsState.fromJson(decoded);
      }
      return const SettingsState();
    } catch (e) {
      debugPrint('[SettingsRepository] Error loading settings: $e');
      return const SettingsState();
    }
  }

  /// Persists player settings.
  Future<bool> saveSettings(SettingsState settings) async {
    try {
      final jsonString = json.encode(settings.toJson());
      return await _storage.setString(settingsKey, jsonString);
    } catch (e) {
      debugPrint('[SettingsRepository] Error saving settings: $e');
      return false;
    }
  }
}
