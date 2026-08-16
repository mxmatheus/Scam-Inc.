import 'package:flutter/foundation.dart';
import 'player_state.dart';
import 'operation.dart';
import 'upgrade.dart';
import 'prestige_skill.dart';
import 'achievement.dart';
import 'daily_goal.dart';
import 'settings_state.dart';

/// Master Aggregate Root Snapshot used for offline persistence and migration.
@immutable
class PlayerSave {
  static const int currentVersion = 1;

  final int version;
  final DateTime savedAt;
  final PlayerState playerState;
  final List<Operation> operations;
  final List<Upgrade> upgrades;
  final List<PrestigeSkill> prestigeSkills;
  final List<Achievement> achievements;
  final List<DailyGoal> dailyGoals;
  final SettingsState settings;

  const PlayerSave({
    this.version = currentVersion,
    required this.savedAt,
    required this.playerState,
    this.operations = const [],
    this.upgrades = const [],
    this.prestigeSkills = const [],
    this.achievements = const [],
    this.dailyGoals = const [],
    this.settings = const SettingsState(),
  });

  /// Factory to generate a default new-player save file.
  factory PlayerSave.initial({
    List<Operation>? operations,
    List<Upgrade>? upgrades,
    List<PrestigeSkill>? prestigeSkills,
    List<Achievement>? achievements,
    List<DailyGoal>? dailyGoals,
    SettingsState? settings,
  }) {
    return PlayerSave(
      version: currentVersion,
      savedAt: DateTime.now(),
      playerState: PlayerState.initial(),
      operations: operations ?? const [],
      upgrades: upgrades ?? const [],
      prestigeSkills: prestigeSkills ?? const [],
      achievements: achievements ?? const [],
      dailyGoals: dailyGoals ?? const [],
      settings: settings ?? const SettingsState(),
    );
  }

  PlayerSave copyWith({
    int? version,
    DateTime? savedAt,
    PlayerState? playerState,
    List<Operation>? operations,
    List<Upgrade>? upgrades,
    List<PrestigeSkill>? prestigeSkills,
    List<Achievement>? achievements,
    List<DailyGoal>? dailyGoals,
    SettingsState? settings,
  }) {
    return PlayerSave(
      version: version ?? this.version,
      savedAt: savedAt ?? this.savedAt,
      playerState: playerState ?? this.playerState,
      operations: operations ?? this.operations,
      upgrades: upgrades ?? this.upgrades,
      prestigeSkills: prestigeSkills ?? this.prestigeSkills,
      achievements: achievements ?? this.achievements,
      dailyGoals: dailyGoals ?? this.dailyGoals,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'savedAt': savedAt.toIso8601String(),
      'playerState': playerState.toJson(),
      'operations': operations.map((o) => o.toJson()).toList(),
      'upgrades': upgrades.map((u) => u.toJson()).toList(),
      'prestigeSkills': prestigeSkills.map((s) => s.toJson()).toList(),
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'dailyGoals': dailyGoals.map((g) => g.toJson()).toList(),
      'settings': settings.toJson(),
    };
  }

  factory PlayerSave.fromJson(Map<String, dynamic> json) {
    return PlayerSave(
      version: json['version'] as int? ?? currentVersion,
      savedAt: json['savedAt'] != null
          ? DateTime.parse(json['savedAt'] as String)
          : DateTime.now(),
      playerState: json['playerState'] != null
          ? PlayerState.fromJson(json['playerState'] as Map<String, dynamic>)
          : PlayerState.initial(),
      operations:
          (json['operations'] as List<dynamic>?)
              ?.map((e) => Operation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      upgrades:
          (json['upgrades'] as List<dynamic>?)
              ?.map((e) => Upgrade.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      prestigeSkills:
          (json['prestigeSkills'] as List<dynamic>?)
              ?.map((e) => PrestigeSkill.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      achievements:
          (json['achievements'] as List<dynamic>?)
              ?.map((e) => Achievement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dailyGoals:
          (json['dailyGoals'] as List<dynamic>?)
              ?.map((e) => DailyGoal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      settings: json['settings'] != null
          ? SettingsState.fromJson(json['settings'] as Map<String, dynamic>)
          : const SettingsState(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerSave &&
          runtimeType == other.runtimeType &&
          version == other.version &&
          savedAt == other.savedAt &&
          playerState == other.playerState &&
          listEquals(operations, other.operations) &&
          listEquals(upgrades, other.upgrades) &&
          listEquals(prestigeSkills, other.prestigeSkills) &&
          listEquals(achievements, other.achievements) &&
          listEquals(dailyGoals, other.dailyGoals) &&
          settings == other.settings;

  @override
  int get hashCode =>
      version.hashCode ^
      savedAt.hashCode ^
      playerState.hashCode ^
      Object.hashAll(operations) ^
      Object.hashAll(upgrades) ^
      Object.hashAll(prestigeSkills) ^
      Object.hashAll(achievements) ^
      Object.hashAll(dailyGoals) ^
      settings.hashCode;
}
