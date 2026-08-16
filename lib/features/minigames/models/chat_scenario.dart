import 'package:flutter/foundation.dart';

@immutable
class ChatChoice {
  final String id;
  final String text;
  final bool isAntiScamWinner;
  final double rewardCoins;
  final double trustReward;
  final double heatDelta;
  final String explanation;

  const ChatChoice({
    required this.id,
    required this.text,
    required this.isAntiScamWinner,
    this.rewardCoins = 1000.0,
    this.trustReward = 5.0,
    this.heatDelta = -10.0,
    required this.explanation,
  });
}

@immutable
class ChatScenario {
  final String id;
  final String contactName;
  final String contactRole;
  final String avatarAsset;
  final String incomingMessage;
  final List<ChatChoice> choices;
  final String redFlagSummary;

  const ChatScenario({
    required this.id,
    required this.contactName,
    required this.contactRole,
    required this.avatarAsset,
    required this.incomingMessage,
    required this.choices,
    required this.redFlagSummary,
  });
}
