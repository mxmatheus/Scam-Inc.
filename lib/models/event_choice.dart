import 'package:flutter/foundation.dart';

/// Represents a single selectable choice within a [GameEvent].
@immutable
class EventChoice {
  final String id;
  final String label;
  final String description;
  final double sCoinsCost;
  final double trustCost;
  final double sCoinsReward;
  final double trustReward;
  final double heatDelta;
  final double successRate; // 0.0 to 1.0

  const EventChoice({
    required this.id,
    required this.label,
    this.description = '',
    this.sCoinsCost = 0.0,
    this.trustCost = 0.0,
    this.sCoinsReward = 0.0,
    this.trustReward = 0.0,
    this.heatDelta = 0.0,
    this.successRate = 1.0,
  });

  EventChoice copyWith({
    String? id,
    String? label,
    String? description,
    double? sCoinsCost,
    double? trustCost,
    double? sCoinsReward,
    double? trustReward,
    double? heatDelta,
    double? successRate,
  }) {
    return EventChoice(
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? this.description,
      sCoinsCost: sCoinsCost ?? this.sCoinsCost,
      trustCost: trustCost ?? this.trustCost,
      sCoinsReward: sCoinsReward ?? this.sCoinsReward,
      trustReward: trustReward ?? this.trustReward,
      heatDelta: heatDelta ?? this.heatDelta,
      successRate: successRate ?? this.successRate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'description': description,
      'sCoinsCost': sCoinsCost,
      'trustCost': trustCost,
      'sCoinsReward': sCoinsReward,
      'trustReward': trustReward,
      'heatDelta': heatDelta,
      'successRate': successRate,
    };
  }

  factory EventChoice.fromJson(Map<String, dynamic> json) {
    return EventChoice(
      id: json['id'] as String,
      label: json['label'] as String,
      description: json['description'] as String? ?? '',
      sCoinsCost: (json['sCoinsCost'] as num?)?.toDouble() ?? 0.0,
      trustCost: (json['trustCost'] as num?)?.toDouble() ?? 0.0,
      sCoinsReward: (json['sCoinsReward'] as num?)?.toDouble() ?? 0.0,
      trustReward: (json['trustReward'] as num?)?.toDouble() ?? 0.0,
      heatDelta: (json['heatDelta'] as num?)?.toDouble() ?? 0.0,
      successRate: (json['successRate'] as num?)?.toDouble() ?? 1.0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventChoice &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          description == other.description &&
          sCoinsCost == other.sCoinsCost &&
          trustCost == other.trustCost &&
          sCoinsReward == other.sCoinsReward &&
          trustReward == other.trustReward &&
          heatDelta == other.heatDelta &&
          successRate == other.successRate;

  @override
  int get hashCode =>
      id.hashCode ^
      label.hashCode ^
      description.hashCode ^
      sCoinsCost.hashCode ^
      trustCost.hashCode ^
      sCoinsReward.hashCode ^
      trustReward.hashCode ^
      heatDelta.hashCode ^
      successRate.hashCode;
}
