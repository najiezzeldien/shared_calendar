import 'package:equatable/equatable.dart';
import 'group_member.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String creatorId;
  final String creatorName;
  final List<GroupMember> members;
  final DateTime createdAt;

  const Group({
    required this.id,
    required this.name,
    required this.creatorId,
    required this.creatorName,
    required this.members,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, name, creatorId, creatorName, members, createdAt];
}
