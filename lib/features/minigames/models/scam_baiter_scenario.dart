import 'package:flutter/foundation.dart';

@immutable
class ScamBaiterScenario {
  final String id;
  final String profileName;
  final String handle;
  final String avatarAsset;
  final String bio;
  final String directMessage;
  final bool isMalicious;
  final String redFlagExplanation;
  final double sCoinsReward;
  final double trustReward;
  final double heatDelta;

  const ScamBaiterScenario({
    required this.id,
    required this.profileName,
    required this.handle,
    required this.avatarAsset,
    required this.bio,
    required this.directMessage,
    required this.isMalicious,
    required this.redFlagExplanation,
    this.sCoinsReward = 7500.0,
    this.trustReward = 15.0,
    this.heatDelta = -20.0,
  });
}
