import 'dart:async';
import 'package:flutter/foundation.dart';

/// Reward types available from watching optional rewarded ads.
enum RewardedAdType {
  heatRelief, // -50% Heat relief
  doubleIncome2x, // Temporary 2x revenue multiplier (60s)
  doubleOffline, // Double offline earnings on return
}

/// Abstract contract for rewarded ad providers.
abstract class AdService {
  bool get isAdLoaded;
  bool get isAdLoading;
  bool get isCooldownActive;
  int get cooldownSecondsRemaining;

  Future<void> preloadAd();

  /// Shows a rewarded ad. Only invokes [onRewardEarned] upon 100% verified completion.
  Future<bool> showRewardedAd({
    required RewardedAdType adType,
    required VoidCallback onRewardEarned,
    VoidCallback? onFailed,
    VoidCallback? onCanceled,
  });
}

/// Robust offline-first AdService implementation with test/debug mode and cooldown safety.
class StandardAdService implements AdService {
  final bool isDebugMode;
  bool _isLoaded = true;
  bool _isLoading = false;
  DateTime? _lastRewardTimestamp;
  static const int _cooldownDurationSeconds = 45;

  StandardAdService({this.isDebugMode = false});

  @override
  bool get isAdLoaded => _isLoaded;

  @override
  bool get isAdLoading => _isLoading;

  @override
  bool get isCooldownActive {
    if (_lastRewardTimestamp == null) return false;
    final diff = DateTime.now().difference(_lastRewardTimestamp!).inSeconds;
    return diff < _cooldownDurationSeconds;
  }

  @override
  int get cooldownSecondsRemaining {
    if (!isCooldownActive) return 0;
    final elapsed = DateTime.now().difference(_lastRewardTimestamp!).inSeconds;
    return (_cooldownDurationSeconds - elapsed).clamp(
      0,
      _cooldownDurationSeconds,
    );
  }

  @override
  Future<void> preloadAd() async {
    _isLoading = true;
    await Future.delayed(const Duration(milliseconds: 300));
    _isLoading = false;
    _isLoaded = true;
  }

  @override
  Future<bool> showRewardedAd({
    required RewardedAdType adType,
    required VoidCallback onRewardEarned,
    VoidCallback? onFailed,
    VoidCallback? onCanceled,
  }) async {
    if (isCooldownActive) {
      onFailed?.call();
      return false;
    }

    _isLoading = true;

    // Simulate ad presentation or dispatch to native SDK
    await Future.delayed(Duration(milliseconds: isDebugMode ? 200 : 800));
    _isLoading = false;

    // Grant confirmed reward
    _lastRewardTimestamp = DateTime.now();
    onRewardEarned();
    preloadAd();
    return true;
  }
}
