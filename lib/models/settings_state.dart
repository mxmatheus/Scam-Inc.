import 'package:flutter/foundation.dart';

/// Represents local player settings and preferences.
@immutable
class SettingsState {
  final bool soundEnabled;
  final bool musicEnabled;
  final bool hapticsEnabled;
  final bool notificationsEnabled;
  final bool compactNumberFormat;
  final String languageCode;

  const SettingsState({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.hapticsEnabled = true,
    this.notificationsEnabled = true,
    this.compactNumberFormat = true,
    this.languageCode = 'en',
  });

  SettingsState copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? hapticsEnabled,
    bool? notificationsEnabled,
    bool? compactNumberFormat,
    String? languageCode,
  }) {
    return SettingsState(
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
          soundEnabled == other.soundEnabled &&
          musicEnabled == other.musicEnabled &&
          hapticsEnabled == other.hapticsEnabled &&
          notificationsEnabled == other.notificationsEnabled &&
          compactNumberFormat == other.compactNumberFormat &&
          languageCode == other.languageCode;

  @override
  int get hashCode =>
      soundEnabled.hashCode ^
      musicEnabled.hashCode ^
      hapticsEnabled.hashCode ^
      notificationsEnabled.hashCode ^
      compactNumberFormat.hashCode ^
      languageCode.hashCode;
}
