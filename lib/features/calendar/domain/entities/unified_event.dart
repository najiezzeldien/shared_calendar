import 'dart:ui';
import 'package:equatable/equatable.dart';

enum RsvpStatus { going, maybe, declined, none }

class UnifiedEvent extends Equatable {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final bool isAllDay;
  final bool isLocal;
  final String? groupId;
  final String? groupName;
  final RsvpStatus rsvpStatus;

  const UnifiedEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.color,
    this.isAllDay = false,
    required this.isLocal,
    this.groupId,
    this.groupName,
    this.rsvpStatus = RsvpStatus.none,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    startTime,
    endTime,
    color,
    isAllDay,
    isLocal,
    groupId,
    groupName,
    rsvpStatus,
  ];
}
