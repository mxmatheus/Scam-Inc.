import 'dart:async';

/// Master telemetry and product analytics events.
enum AnalyticsEvent {
  tutorialCompleted,
  firstTap,
  firstOperation,
  firstUpgrade,
  firstHeatEvent,
  firstMinigame,
  firstPrestige,
  rewardedAdStarted,
  rewardedAdCompleted,
  purchaseStarted,
  purchaseCompleted,
}

/// Abstract contract for privacy-preserving product analytics and crash reporting.
abstract class AnalyticsService {
  Future<void> logEvent(AnalyticsEvent event, [Map<String, dynamic>? params]);
  Future<void> recordError(dynamic exception, StackTrace? stackTrace);
}

/// Lightweight privacy-safe analytics implementation without PII or sensitive data.
class StandardAnalyticsService implements AnalyticsService {
  final bool isEnabled;
  final List<String> loggedEvents = [];

  StandardAnalyticsService({this.isEnabled = true});

  @override
  Future<void> logEvent(
    AnalyticsEvent event, [
    Map<String, dynamic>? params,
  ]) async {
    if (!isEnabled) return;
    loggedEvents.add(event.name);
  }

  @override
  Future<void> recordError(dynamic exception, StackTrace? stackTrace) async {
    if (!isEnabled) return;
    // Log crash telemetry safely without sensitive user payload
  }
}
