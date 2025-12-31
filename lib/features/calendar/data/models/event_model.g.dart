// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
  id: json['id'] as String,
  groupId: json['groupId'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  startTime: const TimestampConverter().fromJson(
    json['startTime'] as Timestamp,
  ),
  endTime: const TimestampConverter().fromJson(json['endTime'] as Timestamp),
  createdBy: json['createdBy'] as String,
  creatorName: json['creatorName'] as String?,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  recurrenceRule: json['recurrenceRule'] as String?,
  color: (json['color'] as num?)?.toInt(),
);

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'title': instance.title,
      'description': instance.description,
      'startTime': const TimestampConverter().toJson(instance.startTime),
      'endTime': const TimestampConverter().toJson(instance.endTime),
      'createdBy': instance.createdBy,
      'creatorName': instance.creatorName,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'recurrenceRule': instance.recurrenceRule,
      'color': instance.color,
    };
