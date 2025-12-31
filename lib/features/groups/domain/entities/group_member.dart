import 'package:equatable/equatable.dart';

enum GroupRole { owner, admin, member, viewer }

class GroupMember extends Equatable {
  final String userId;
  final GroupRole role;

  const GroupMember({
    required this.userId,
    required this.role,
  });

  @override
  List<Object> get props => [userId, role];
}
