import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/models/settings_state.dart';
import 'package:scam_inc/services/audio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioService Tests', () {
    test('Invokes without error when sound & haptics enabled', () async {
      final audioService = AudioService(
        () => const SettingsState(soundEnabled: true, hapticsEnabled: true),
      );

      await audioService.playTap();
      await audioService.playUpgrade();
      await audioService.playPurchase();
      await audioService.playBribe();
      await audioService.playWarning();
      await audioService.playPrestige();
      await audioService.playAchievement();
    });

    test('Runs silently when sound & haptics disabled', () async {
      final audioService = AudioService(
        () => const SettingsState(soundEnabled: false, hapticsEnabled: false),
      );

      await audioService.playTap();
      await audioService.playUpgrade();
    });
  });
}
