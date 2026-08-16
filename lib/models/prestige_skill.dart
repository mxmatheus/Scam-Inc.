import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'enums/game_enums.dart';

/// Represents a permanent skill node in the Prestige Skill Tree.
@immutable
class PrestigeSkill {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final double baseCost;
  final double costMultiplier;
  final int level;
  final int maxLevel;
  final PrestigeBranch branch;
  final double effectValuePerLevel; // e.g. 0.05 for +5% per level

  const PrestigeSkill({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.baseCost,
    this.costMultiplier = 1.5,
    this.level = 0,
    this.maxLevel = 10,
    this.branch = PrestigeBranch.stealthOffshore,
    this.effectValuePerLevel = 0.05,
  });

  bool get isMaxed => level >= maxLevel;

  /// Current cost to upgrade to the next level in Laundered Cash.
  double get nextUpgradeCost {
    if (isMaxed) return 0.0;
    return baseCost * math.pow(costMultiplier, level);
  }

  /// Calculates upgrade cost in Laundered Cash.
  double calculateCost() => nextUpgradeCost;

  /// Current cumulative bonus value (e.g. 0.25 for +25%).
  double get currentBonusValue => level * effectValuePerLevel;

  PrestigeSkill copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    double? baseCost,
    double? costMultiplier,
    int? level,
    int? maxLevel,
    PrestigeBranch? branch,
    double? effectValuePerLevel,
  }) {
    return PrestigeSkill(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      baseCost: baseCost ?? this.baseCost,
      costMultiplier: costMultiplier ?? this.costMultiplier,
      level: level ?? this.level,
      maxLevel: maxLevel ?? this.maxLevel,
      branch: branch ?? this.branch,
      effectValuePerLevel: effectValuePerLevel ?? this.effectValuePerLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'baseCost': baseCost,
      'costMultiplier': costMultiplier,
      'level': level,
      'maxLevel': maxLevel,
      'branch': branch.name,
      'effectValuePerLevel': effectValuePerLevel,
    };
  }

  factory PrestigeSkill.fromJson(Map<String, dynamic> json) {
    return PrestigeSkill(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      iconPath: json['iconPath'] as String,
      baseCost: (json['baseCost'] as num).toDouble(),
      costMultiplier: (json['costMultiplier'] as num?)?.toDouble() ?? 1.5,
      level: json['level'] as int? ?? 0,
      maxLevel: json['maxLevel'] as int? ?? 10,
      branch: json['branch'] != null
          ? PrestigeBranch.values.byName(json['branch'] as String)
          : PrestigeBranch.stealthOffshore,
      effectValuePerLevel:
          (json['effectValuePerLevel'] as num?)?.toDouble() ?? 0.05,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrestigeSkill &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          iconPath == other.iconPath &&
          baseCost == other.baseCost &&
          costMultiplier == other.costMultiplier &&
          level == other.level &&
          maxLevel == other.maxLevel &&
          branch == other.branch &&
          effectValuePerLevel == other.effectValuePerLevel;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      iconPath.hashCode ^
      baseCost.hashCode ^
      costMultiplier.hashCode ^
      level.hashCode ^
      maxLevel.hashCode ^
      branch.hashCode ^
      effectValuePerLevel.hashCode;
}
