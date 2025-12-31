import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String groupId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String createdBy;
  final String? creatorName; // Display name of creator
  final DateTime createdAt;
  final String? recurrenceRule; // e.g., 'DAILY', 'WEEKLY', 'MONTHLY'
  final int? color; // Color value

  const Event({
    required this.id,
    required this.groupId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
    this.creatorName,
    required this.createdAt,
    this.recurrenceRule,
    this.color,
  });

  Event copyWith({
    String? id,
    String? groupId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? createdBy,
    String? creatorName,
    DateTime? createdAt,
    String? recurrenceRule,
    int? color,
  }) {
    return Event(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdBy: createdBy ?? this.createdBy,
      creatorName: creatorName ?? this.creatorName,
      createdAt: createdAt ?? this.createdAt,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [
        id,
        groupId,
        title,
        description,
        startTime,
        endTime,
        createdBy,
        creatorName,
        createdAt,
        recurrenceRule,
        color,
      ];
}
