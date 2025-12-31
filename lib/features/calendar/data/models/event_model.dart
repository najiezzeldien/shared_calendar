import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/event.dart';

part 'event_model.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@JsonSerializable()
@TimestampConverter()
class EventModel {
  final String id;
  final String groupId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String createdBy;
  final String? creatorName;
  final DateTime createdAt;
  final String? recurrenceRule;
  final int? color;

  const EventModel({
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

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  Event toEntity() {
    return Event(
      id: id,
      groupId: groupId,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      createdBy: createdBy,
      creatorName: creatorName,
      createdAt: createdAt,
      recurrenceRule: recurrenceRule,
      color: color,
    );
  }

  factory EventModel.fromEntity(Event event) {
    return EventModel(
      id: event.id,
      groupId: event.groupId,
      title: event.title,
      description: event.description,
      startTime: event.startTime,
      endTime: event.endTime,
      createdBy: event.createdBy,
      creatorName: event.creatorName,
      createdAt: event.createdAt,
      recurrenceRule: event.recurrenceRule,
      color: event.color,
    );
  }
}
