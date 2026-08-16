import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'enums/game_enums.dart';

/// Represents an automated or idle income-generating Scam Operation.
@immutable
class Operation {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final double baseCost;
  final double baseIncome; // base income per second at level 1
  final double baseHeatPerSecond;
  final double baseTrustPerSecond;
  final double costMultiplier;
  final int level;
  final bool isUnlocked;
  final double trustRequirement;
  final OperationTier tier;

  const Operation({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.baseCost,
    required this.baseIncome,
    this.baseHeatPerSecond = 0.0,
    this.baseTrustPerSecond = 0.0,
    this.costMultiplier = 1.15,
    this.level = 0,
    this.isUnlocked = false,
    this.trustRequirement = 0.0,
    this.tier = OperationTier.tier1Basement,
  });

  /// Calculates the cost to buy the next single level.
  double get nextUpgradeCost => calculateUpgradeCost(1);

  /// Calculates the cost to buy [count] levels starting from current [level].
  double calculateUpgradeCost(int count) {
    if (count <= 0) return 0.0;
    double total = 0.0;
    for (int i = 0; i < count; i++) {
      total += baseCost * math.pow(costMultiplier, level + i);
    }
    return total;
  }

  /// Calculates the total unmultiplied income per second for the current level.
  double get currentIncomePerSecond => baseIncome * level;
  double get incomePerSecond => currentIncomePerSecond;

  /// Calculates the total heat generated per second.
  double get currentHeatPerSecond =>
      level == 0 ? baseHeatPerSecond : baseHeatPerSecond * level;
  double get heatRate => currentHeatPerSecond;

  /// Calculates the total trust generated per second.
  double get currentTrustPerSecond => baseTrustPerSecond * level;

  Operation copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    double? baseCost,
    double? baseIncome,
    double? baseHeatPerSecond,
    double? baseTrustPerSecond,
    double? costMultiplier,
    int? level,
    bool? isUnlocked,
    double? trustRequirement,
    OperationTier? tier,
  }) {
    return Operation(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      baseCost: baseCost ?? this.baseCost,
      baseIncome: baseIncome ?? this.baseIncome,
      baseHeatPerSecond: baseHeatPerSecond ?? this.baseHeatPerSecond,
      baseTrustPerSecond: baseTrustPerSecond ?? this.baseTrustPerSecond,
      costMultiplier: costMultiplier ?? this.costMultiplier,
      level: level ?? this.level,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      trustRequirement: trustRequirement ?? this.trustRequirement,
      tier: tier ?? this.tier,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'baseCost': baseCost,
      'baseIncome': baseIncome,
      'baseHeatPerSecond': baseHeatPerSecond,
      'baseTrustPerSecond': baseTrustPerSecond,
      'costMultiplier': costMultiplier,
      'level': level,
      'isUnlocked': isUnlocked,
      'trustRequirement': trustRequirement,
      'tier': tier.name,
    };
  }

  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      iconPath: json['iconPath'] as String,
      baseCost: (json['baseCost'] as num).toDouble(),
      baseIncome: (json['baseIncome'] as num).toDouble(),
      baseHeatPerSecond: (json['baseHeatPerSecond'] as num?)?.toDouble() ?? 0.0,
      baseTrustPerSecond:
          (json['baseTrustPerSecond'] as num?)?.toDouble() ?? 0.0,
      costMultiplier: (json['costMultiplier'] as num?)?.toDouble() ?? 1.15,
      level: json['level'] as int? ?? 0,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      trustRequirement: (json['trustRequirement'] as num?)?.toDouble() ?? 0.0,
      tier: json['tier'] != null
          ? OperationTier.values.byName(json['tier'] as String)
          : OperationTier.tier1Basement,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Operation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          iconPath == other.iconPath &&
          baseCost == other.baseCost &&
          baseIncome == other.baseIncome &&
          baseHeatPerSecond == other.baseHeatPerSecond &&
          baseTrustPerSecond == other.baseTrustPerSecond &&
          costMultiplier == other.costMultiplier &&
          level == other.level &&
          isUnlocked == other.isUnlocked &&
          trustRequirement == other.trustRequirement &&
          tier == other.tier;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      iconPath.hashCode ^
      baseCost.hashCode ^
      baseIncome.hashCode ^
      baseHeatPerSecond.hashCode ^
      baseTrustPerSecond.hashCode ^
      costMultiplier.hashCode ^
      level.hashCode ^
      isUnlocked.hashCode ^
      trustRequirement.hashCode ^
      tier.hashCode;
}
