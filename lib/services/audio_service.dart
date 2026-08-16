import 'package:flutter/services.dart';
import '../models/settings_state.dart';

/// Sound effect types available across SCAM INC.
enum SoundEffect {
  tap,
  purchase,
  upgrade,
  bribe,
  event,
  warning,
  prestige,
  achievement,
}

/// Procedural Audio and Haptic Feedback service.
/// Provides instant native tactile and auditory responses without blocking gameplay.
class AudioService {
  final SettingsState Function() _getSettings;

  const AudioService(this._getSettings);

  /// Plays audio and haptic feedback corresponding to manual campaign tap.
  Future<void> playTap() async {
    final settings = _getSettings();
    if (settings.hapticsEnabled) {
      await HapticFeedback.lightImpact();
    }
    if (settings.soundEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// Plays feedback when an operation level is purchased.
  Future<void> playUpgrade() async {
    final settings = _getSettings();
    if (settings.hapticsEnabled) {
      await HapticFeedback.mediumImpact();
    }
    if (settings.soundEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// Plays feedback when an upgrade multiplier or perk is acquired.
  Future<void> playPurchase() async {
    final settings = _getSettings();
    if (settings.hapticsEnabled) {
      await HapticFeedback.selectionClick();
    }
    if (settings.soundEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// Plays feedback when bribing law enforcement or cooling Heat.
  Future<void> playBribe() async {
    final settings = _getSettings();
    if (settings.hapticsEnabled) {
      await HapticFeedback.heavyImpact();
    }
    if (settings.soundEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// Plays feedback for high-risk investigations or raid alarms.
  Future<void> playWarning() async {
    final settings = _getSettings();
    if (settings.hapticsEnabled) {
      await HapticFeedback.vibrate();
    }
    if (settings.soundEnabled) {
      await SystemSound.play(SystemSoundType.alert);
    }
  }

  /// Plays triumphant feedback when executing Offshore Escape prestige.
  Future<void> playPrestige() async {
    final settings = _getSettings();
    if (settings.hapticsEnabled) {
      await HapticFeedback.heavyImpact();
    }
    if (settings.soundEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// Plays feedback when an achievement or daily goal is claimed.
  Future<void> playAchievement() async {
    final settings = _getSettings();
    if (settings.hapticsEnabled) {
      await HapticFeedback.mediumImpact();
    }
    if (settings.soundEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }
}
