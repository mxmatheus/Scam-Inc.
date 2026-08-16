import 'package:flutter/foundation.dart';

/// Represents local player settings and preferences.
@immutable
class SettingsState {
  final bool isDarkMode;
  final bool soundEnabled;
  final bool musicEnabled;
  final bool hapticsEnabled;
  final bool notificationsEnabled;
  final bool compactNumberFormat;
  final String languageCode;

  const SettingsState({
    this.isDarkMode = true,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.hapticsEnabled = true,
    this.notificationsEnabled = true,
    this.compactNumberFormat = true,
    this.languageCode = 'en',
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? soundEnabled,
    bool? musicEnabled,
    bool? hapticsEnabled,
    bool? notificationsEnabled,
    bool? compactNumberFormat,
    String? languageCode,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      compactNumberFormat: compactNumberFormat ?? this.compactNumberFormat,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'soundEnabled': soundEnabled,
      'musicEnabled': musicEnabled,
      'hapticsEnabled': hapticsEnabled,
      'notificationsEnabled': notificationsEnabled,
      'compactNumberFormat': compactNumberFormat,
      'languageCode': languageCode,
    };
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      isDarkMode: json['isDarkMode'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      compactNumberFormat: json['compactNumberFormat'] as bool? ?? true,
      languageCode: json['languageCode'] as String? ?? 'en',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsState &&
          runtimeType == other.runtimeType &&
          isDarkMode == other.isDarkMode &&
          soundEnabled == other.soundEnabled &&
          musicEnabled == other.musicEnabled &&
          hapticsEnabled == other.hapticsEnabled &&
          notificationsEnabled == other.notificationsEnabled &&
          compactNumberFormat == other.compactNumberFormat &&
          languageCode == other.languageCode;

  @override
  int get hashCode =>
      isDarkMode.hashCode ^
      soundEnabled.hashCode ^
      musicEnabled.hashCode ^
      hapticsEnabled.hashCode ^
      notificationsEnabled.hashCode ^
      compactNumberFormat.hashCode ^
      languageCode.hashCode;
}
