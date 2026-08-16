import 'package:flutter/foundation.dart';

/// Represents a daily task or objective that resets every 24 hours.
@immutable
class DailyGoal {
  final String id;
  final String title;
  final String description;
  final double targetValue;
  final double currentProgress;
  final double rewardCoins;
  final int rewardGems;
  final bool isCompleted;
  final bool isClaimed;

  const DailyGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetValue,
    this.currentProgress = 0.0,
    this.rewardCoins = 1000.0,
    this.rewardGems = 5,
    this.isCompleted = false,
    this.isClaimed = false,
  });

  double get progressRatio =>
      targetValue > 0 ? (currentProgress / targetValue).clamp(0.0, 1.0) : 0.0;

  DailyGoal copyWith({
    String? id,
    String? title,
    String? description,
    double? targetValue,
    double? currentProgress,
    double? rewardCoins,
    int? rewardGems,
    bool? isCompleted,
    bool? isClaimed,
  }) {
    return DailyGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetValue: targetValue ?? this.targetValue,
      currentProgress: currentProgress ?? this.currentProgress,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      rewardGems: rewardGems ?? this.rewardGems,
      isCompleted: isCompleted ?? this.isCompleted,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetValue': targetValue,
      'currentProgress': currentProgress,
      'rewardCoins': rewardCoins,
      'rewardGems': rewardGems,
      'isCompleted': isCompleted,
      'isClaimed': isClaimed,
    };
  }

  factory DailyGoal.fromJson(Map<String, dynamic> json) {
    return DailyGoal(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      targetValue: (json['targetValue'] as num).toDouble(),
      currentProgress: (json['currentProgress'] as num?)?.toDouble() ?? 0.0,
      rewardCoins: (json['rewardCoins'] as num?)?.toDouble() ?? 1000.0,
      rewardGems: json['rewardGems'] as int? ?? 5,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isClaimed: json['isClaimed'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyGoal &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          targetValue == other.targetValue &&
          currentProgress == other.currentProgress &&
          rewardCoins == other.rewardCoins &&
          rewardGems == other.rewardGems &&
          isCompleted == other.isCompleted &&
          isClaimed == other.isClaimed;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      targetValue.hashCode ^
      currentProgress.hashCode ^
      rewardCoins.hashCode ^
      rewardGems.hashCode ^
      isCompleted.hashCode ^
      isClaimed.hashCode;
}
