import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/group.dart';
import 'group_member_model.dart';

part 'group_model.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@JsonSerializable(explicitToJson: true)
@TimestampConverter()
class GroupModel {
  final String id;
  final String name;
  final String creatorId;
  final String creatorName;
  final List<GroupMemberModel> members;
  final DateTime createdAt;

  const GroupModel({
    required this.id,
    required this.name,
    required this.creatorId,
    required this.creatorName,
    required this.members,
    required this.createdAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupModelToJson(this);

  Group toEntity() {
    return Group(
      id: id,
      name: name,
      creatorId: creatorId,
      creatorName: creatorName,
      members: members,
      createdAt: createdAt,
    );
  }

  factory GroupModel.fromEntity(Group group) {
    return GroupModel(
      id: group.id,
      name: group.name,
      creatorId: group.creatorId,
      creatorName: group.creatorName,
      members: group.members
          .map((m) => GroupMemberModel.fromEntity(m))
          .toList(),
      createdAt: group.createdAt,
    );
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? creatorId,
    String? creatorName,
    List<GroupMemberModel>? members,
    DateTime? createdAt,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
