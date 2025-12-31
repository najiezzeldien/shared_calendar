import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/group_member.dart';

part 'group_member_model.g.dart';

@JsonSerializable()
class GroupMemberModel extends GroupMember {
  const GroupMemberModel({
    required super.userId,
    required super.role,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberModelToJson(this);

  factory GroupMemberModel.fromEntity(GroupMember member) {
    return GroupMemberModel(
      userId: member.userId,
      role: member.role,
    );
  }
}
