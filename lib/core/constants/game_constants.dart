/// SCAM INC. — Global Game Constants & Balance Thresholds
abstract class GameConstants {
  static const String appName = 'SCAM INC.';
  static const String appTagline = 'The Art of Deception';
  static const int saveSchemaVersion = 1;

  // Economy Base Balances
  static const double baseTapValue = 1.0;
  static const double baseTickIntervalSeconds = 1.0;
  static const int maxOfflineHours = 8;

  // Heat Limits
  static const double minHeat = 0.0;
  static const double maxHeat = 100.0;
  static const double heatWarningThreshold = 60.0;
  static const double heatCriticalThreshold = 85.0;
  static const double heatRaidThreshold = 95.0;

  // Trust Thresholds
  static const double minTrust = 0.0;

  // Storage Keys
  static const String keyPlayerSave = 'scam_inc_player_save_v1';
  static const String keySettings = 'scam_inc_settings_v1';
}
