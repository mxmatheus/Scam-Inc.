import 'package:flutter/foundation.dart';
import 'enums/game_enums.dart';

/// Represents the central real-time state of the player and economic resources.
@immutable
class PlayerState {
  final double coins;
  final double trust; // 0.0 to 100.0
  final double heat; // 0.0 to 100.0
  final double launderedCash;
  final int gems;
  final double lifetimeRevenue;
  final OperationTier currentOfficeTier;
  final int prestigeLevel;
  final double prestigeMultiplier;
  final int totalTaps;
  final DateTime lastActiveTimestamp;

  const PlayerState({
    this.coins = 0.0,
    this.trust = 0.0,
    this.heat = 0.0,
    this.launderedCash = 0.0,
    this.gems = 0,
    this.lifetimeRevenue = 0.0,
    this.currentOfficeTier = OperationTier.tier1Basement,
    this.prestigeLevel = 0,
    this.prestigeMultiplier = 1.0,
    this.totalTaps = 0,
    required this.lastActiveTimestamp,
  });

  /// True when police raid triggers at max heat.
  bool get isBusted => heat >= 100.0;

  /// True when trust is fully maximized.
  bool get isMaxTrust => trust >= 100.0;

  /// Creates a default initial state for a brand-new player.
  factory PlayerState.initial() {
    return PlayerState(
      coins: 0.0,
      trust: 0.0,
      heat: 0.0,
      launderedCash: 0.0,
      gems: 0,
      lifetimeRevenue: 0.0,
      currentOfficeTier: OperationTier.tier1Basement,
      prestigeLevel: 0,
      prestigeMultiplier: 1.0,
      totalTaps: 0,
      lastActiveTimestamp: DateTime.now(),
    );
  }

  PlayerState copyWith({
    double? coins,
    double? trust,
    double? heat,
    double? launderedCash,
    int? gems,
    double? lifetimeRevenue,
    OperationTier? currentOfficeTier,
    int? prestigeLevel,
    double? prestigeMultiplier,
    int? totalTaps,
    DateTime? lastActiveTimestamp,
  }) {
    return PlayerState(
      coins: coins ?? this.coins,
      trust: trust != null ? trust.clamp(0.0, 100.0) : this.trust,
      heat: heat != null ? heat.clamp(0.0, 100.0) : this.heat,
      launderedCash: launderedCash ?? this.launderedCash,
      gems: gems ?? this.gems,
      lifetimeRevenue: lifetimeRevenue ?? this.lifetimeRevenue,
      currentOfficeTier: currentOfficeTier ?? this.currentOfficeTier,
      prestigeLevel: prestigeLevel ?? this.prestigeLevel,
      prestigeMultiplier: prestigeMultiplier ?? this.prestigeMultiplier,
      totalTaps: totalTaps ?? this.totalTaps,
      lastActiveTimestamp: lastActiveTimestamp ?? this.lastActiveTimestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coins': coins,
      'trust': trust,
      'heat': heat,
      'launderedCash': launderedCash,
      'gems': gems,
      'lifetimeRevenue': lifetimeRevenue,
      'currentOfficeTier': currentOfficeTier.name,
      'prestigeLevel': prestigeLevel,
      'prestigeMultiplier': prestigeMultiplier,
      'totalTaps': totalTaps,
      'lastActiveTimestamp': lastActiveTimestamp.toIso8601String(),
    };
  }

  factory PlayerState.fromJson(Map<String, dynamic> json) {
    return PlayerState(
      coins: (json['coins'] as num?)?.toDouble() ?? 0.0,
      trust: ((json['trust'] as num?)?.toDouble() ?? 0.0).clamp(0.0, 100.0),
      heat: ((json['heat'] as num?)?.toDouble() ?? 0.0).clamp(0.0, 100.0),
      launderedCash: (json['launderedCash'] as num?)?.toDouble() ?? 0.0,
      gems: json['gems'] as int? ?? 0,
      lifetimeRevenue: (json['lifetimeRevenue'] as num?)?.toDouble() ?? 0.0,
      currentOfficeTier: json['currentOfficeTier'] != null
          ? OperationTier.values.byName(json['currentOfficeTier'] as String)
          : OperationTier.tier1Basement,
      prestigeLevel: json['prestigeLevel'] as int? ?? 0,
      prestigeMultiplier:
          (json['prestigeMultiplier'] as num?)?.toDouble() ?? 1.0,
      totalTaps: json['totalTaps'] as int? ?? 0,
      lastActiveTimestamp: json['lastActiveTimestamp'] != null
          ? DateTime.parse(json['lastActiveTimestamp'] as String)
          : DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerState &&
          runtimeType == other.runtimeType &&
          coins == other.coins &&
          trust == other.trust &&
          heat == other.heat &&
          launderedCash == other.launderedCash &&
          gems == other.gems &&
          lifetimeRevenue == other.lifetimeRevenue &&
          currentOfficeTier == other.currentOfficeTier &&
          prestigeLevel == other.prestigeLevel &&
          prestigeMultiplier == other.prestigeMultiplier &&
          totalTaps == other.totalTaps &&
          lastActiveTimestamp == other.lastActiveTimestamp;

  @override
  int get hashCode =>
      coins.hashCode ^
      trust.hashCode ^
      heat.hashCode ^
      launderedCash.hashCode ^
      gems.hashCode ^
      lifetimeRevenue.hashCode ^
      currentOfficeTier.hashCode ^
      prestigeLevel.hashCode ^
      prestigeMultiplier.hashCode ^
      totalTaps.hashCode ^
      lastActiveTimestamp.hashCode;
}
