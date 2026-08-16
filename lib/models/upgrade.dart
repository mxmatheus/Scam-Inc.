import 'package:flutter/foundation.dart';

/// Represents an efficiency or automation upgrade for an operation or global mechanic.
@immutable
class Upgrade {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final double cost;
  final String targetOperationId; // Empty string if global
  final double multiplier; // e.g. 2.0 for 2x income
  final bool isPurchased;
  final int requiredOperationLevel;

  const Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.cost,
    this.targetOperationId = '',
    this.multiplier = 2.0,
    this.isPurchased = false,
    this.requiredOperationLevel = 1,
  });

  Upgrade copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    double? cost,
    String? targetOperationId,
    double? multiplier,
    bool? isPurchased,
    int? requiredOperationLevel,
  }) {
    return Upgrade(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      cost: cost ?? this.cost,
      targetOperationId: targetOperationId ?? this.targetOperationId,
      multiplier: multiplier ?? this.multiplier,
      isPurchased: isPurchased ?? this.isPurchased,
      requiredOperationLevel:
          requiredOperationLevel ?? this.requiredOperationLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'cost': cost,
      'targetOperationId': targetOperationId,
      'multiplier': multiplier,
      'isPurchased': isPurchased,
      'requiredOperationLevel': requiredOperationLevel,
    };
  }

  factory Upgrade.fromJson(Map<String, dynamic> json) {
    return Upgrade(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      iconPath: json['iconPath'] as String,
      cost: (json['cost'] as num).toDouble(),
      targetOperationId: json['targetOperationId'] as String? ?? '',
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 2.0,
      isPurchased: json['isPurchased'] as bool? ?? false,
      requiredOperationLevel: json['requiredOperationLevel'] as int? ?? 1,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Upgrade &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          iconPath == other.iconPath &&
          cost == other.cost &&
          targetOperationId == other.targetOperationId &&
          multiplier == other.multiplier &&
          isPurchased == other.isPurchased &&
          requiredOperationLevel == other.requiredOperationLevel;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      iconPath.hashCode ^
      cost.hashCode ^
      targetOperationId.hashCode ^
      multiplier.hashCode ^
      isPurchased.hashCode ^
      requiredOperationLevel.hashCode;
}
