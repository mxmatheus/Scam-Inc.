import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../models/player_save.dart';
import '../storage/local_storage_adapter.dart';
import '../migrations/save_migrator.dart';

/// Repository responsible for persisting and retrieving player game data.
class SaveRepository {
  static const String saveKey = 'scam_inc_player_save_v1';
  final LocalStorageAdapter _storage;

  const SaveRepository(this._storage);

  /// Checks if a save file exists in local storage.
  Future<bool> hasSave() async {
    return _storage.containsKey(saveKey);
  }

  /// Loads the player save file. If no save exists or data is corrupt,
  /// returns a default [PlayerSave.initial()].
  Future<PlayerSave> loadSave() async {
    try {
      final raw = await _storage.getString(saveKey);
      if (raw == null || raw.isEmpty) {
        return PlayerSave.initial();
      }
      return SaveMigrator.safeParse(raw);
    } catch (e) {
      debugPrint('[SaveRepository] Error loading save: $e');
      return PlayerSave.initial();
    }
  }

  /// Atomically persists [save] to local storage as formatted JSON.
  Future<bool> writeSave(PlayerSave save) async {
    try {
      final jsonString = json.encode(save.toJson());
      return await _storage.setString(saveKey, jsonString);
    } catch (e) {
      debugPrint('[SaveRepository] Error writing save: $e');
      return false;
    }
  }

  /// Deletes the local save file.
  Future<bool> clearSave() async {
    return _storage.remove(saveKey);
  }
}
