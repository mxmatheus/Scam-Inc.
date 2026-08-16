import 'package:flutter/foundation.dart';
import 'enums/game_enums.dart';
import 'event_choice.dart';

/// Represents an interactive random or triggered narrative event in the game.
@immutable
class GameEvent {
  final String id;
  final String title;
  final String description;
  final String illustrationPath;
  final EventType eventType;
  final List<EventChoice> choices;
  final int durationSeconds;
  final DateTime? expiresAt;

  const GameEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.illustrationPath,
    required this.eventType,
    required this.choices,
    this.durationSeconds = 60,
    this.expiresAt,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  GameEvent copyWith({
    String? id,
    String? title,
    String? description,
    String? illustrationPath,
    EventType? eventType,
    List<EventChoice>? choices,
    int? durationSeconds,
    DateTime? expiresAt,
  }) {
    return GameEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      illustrationPath: illustrationPath ?? this.illustrationPath,
      eventType: eventType ?? this.eventType,
      choices: choices ?? this.choices,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'illustrationPath': illustrationPath,
      'eventType': eventType.name,
      'choices': choices.map((c) => c.toJson()).toList(),
      'durationSeconds': durationSeconds,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  factory GameEvent.fromJson(Map<String, dynamic> json) {
    return GameEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      illustrationPath: json['illustrationPath'] as String,
      eventType: EventType.values.byName(json['eventType'] as String),
      choices: (json['choices'] as List<dynamic>)
          .map((e) => EventChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      durationSeconds: json['durationSeconds'] as int? ?? 60,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          illustrationPath == other.illustrationPath &&
          eventType == other.eventType &&
          listEquals(choices, other.choices) &&
          durationSeconds == other.durationSeconds &&
          expiresAt == other.expiresAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      illustrationPath.hashCode ^
      eventType.hashCode ^
      Object.hashAll(choices) ^
      durationSeconds.hashCode ^
      expiresAt.hashCode;
}
