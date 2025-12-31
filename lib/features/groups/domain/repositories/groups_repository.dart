import 'package:fpdart/fpdart.dart' hide Group;
import '../../../../core/errors/failures.dart';
import '../entities/group.dart';
import '../entities/group_member.dart';

abstract interface class GroupsRepository {
  Future<Either<Failure, Group>> createGroup({
    required String name,
    required String creatorId,
    required String creatorName,
  });

  Future<Either<Failure, List<Group>>> getUserGroups(String userId);

  Future<Either<Failure, void>> joinGroup({
    required String groupId,
    required String userId,
    GroupRole role = GroupRole.viewer,
  });

  Future<Either<Failure, Group>> getGroup(String groupId);

  // Future<Either<Failure, void>> leaveGroup();
  // Future<Either<Failure, void>> deleteGroup();
}
