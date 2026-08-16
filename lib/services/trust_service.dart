import '../models/operation.dart';

/// Centralized service for Public Trust and Corporate Reputation management.
class TrustService {
  const TrustService();

  /// Clamps trust score between 0.0 and 100.0 points.
  double clampTrust(double trust) {
    return trust.clamp(0.0, 100.0);
  }

  /// Determines if an operation's trust requirement is fulfilled.
  bool isOperationUnlocked(Operation operation, double currentTrust) {
    if (operation.isUnlocked) return true;
    return currentTrust >= operation.trustRequirement;
  }

  /// Returns corporate title tier based on Trust level.
  String getTrustTitle(double trust) {
    final clamped = clampTrust(trust);
    if (clamped >= 90.0) return 'Untouchable Shadow Boss';
    if (clamped >= 70.0) return 'Global Executive Mogul';
    if (clamped >= 50.0) return 'Corporate Syndicate';
    if (clamped >= 25.0) return 'Commercial Operator';
    if (clamped >= 10.0) return 'Garage Entrepreneur';
    return 'Basement Hustler';
  }
}
