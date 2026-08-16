import 'package:flutter/foundation.dart';
import 'enums/game_enums.dart';

/// Represents an in-game achievement with milestone progress.
@immutable
class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final AchievementCategory category;
  final double targetValue;
  final double currentProgress;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int rewardGems;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.category,
    required this.targetValue,
    this.currentProgress = 0.0,
    this.isUnlocked = false,
    this.unlockedAt,
    this.rewardGems = 10,
  });

  double get progressRatio =>
      targetValue > 0 ? (currentProgress / targetValue).clamp(0.0, 1.0) : 0.0;

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? iconPath,
    AchievementCategory? category,
    double? targetValue,
    double? currentProgress,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? rewardGems,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      category: category ?? this.category,
      targetValue: targetValue ?? this.targetValue,
      currentProgress: currentProgress ?? this.currentProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rewardGems: rewardGems ?? this.rewardGems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconPath': iconPath,
      'category': category.name,
      'targetValue': targetValue,
      'currentProgress': currentProgress,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'rewardGems': rewardGems,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      iconPath: json['iconPath'] as String,
      category: AchievementCategory.values.byName(json['category'] as String),
      targetValue: (json['targetValue'] as num).toDouble(),
      currentProgress: (json['currentProgress'] as num?)?.toDouble() ?? 0.0,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      rewardGems: json['rewardGems'] as int? ?? 10,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Achievement &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          iconPath == other.iconPath &&
          category == other.category &&
          targetValue == other.targetValue &&
          currentProgress == other.currentProgress &&
          isUnlocked == other.isUnlocked &&
          unlockedAt == other.unlockedAt &&
          rewardGems == other.rewardGems;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      iconPath.hashCode ^
      category.hashCode ^
      targetValue.hashCode ^
      currentProgress.hashCode ^
      isUnlocked.hashCode ^
      unlockedAt.hashCode ^
      rewardGems.hashCode;
}
