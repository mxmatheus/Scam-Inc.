import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/settings_repository.dart';
import '../models/settings_state.dart';

class SettingsController extends StateNotifier<SettingsState> {
  final SettingsRepository _repository;

  SettingsController(this._repository) : super(const SettingsState()) {
    _load();
  }

  Future<void> _load() async {
    final loaded = await _repository.loadSettings();
    state = loaded;
  }

  Future<void> toggleDarkMode(bool isDark) async {
    state = state.copyWith(isDarkMode: isDark);
    await _repository.saveSettings(state);
  }

  Future<void> toggleSound(bool enabled) async {
    state = state.copyWith(soundEnabled: enabled);
    await _repository.saveSettings(state);
  }

  Future<void> toggleHaptics(bool enabled) async {
    state = state.copyWith(hapticsEnabled: enabled);
    await _repository.saveSettings(state);
  }
}
