import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart' hide Group;
import 'package:shared_calendar/features/groups/data/models/group_model.dart';
import 'package:shared_calendar/features/groups/domain/entities/group.dart';
import 'package:shared_calendar/features/groups/domain/entities/group_member.dart';
import 'package:shared_calendar/features/groups/domain/repositories/groups_repository.dart';
import 'package:shared_calendar/features/groups/data/models/group_member_model.dart';

import '../../../../core/errors/failures.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final FirebaseFirestore _firestore;

  GroupsRepositoryImpl(this._firestore);

  @override
  Future<Either<Failure, Group>> createGroup({
    required String name,
    required String creatorId,
    required String creatorName,
  }) async {
    try {
      final groupsCollection = _firestore.collection('groups');
      final newGroupDoc = groupsCollection.doc();

      final now = DateTime.now();

      // We manually construct the JSON to include memberIds for querying
      final groupModel = GroupModel(
        id: newGroupDoc.id,
        name: name,
        creatorId: creatorId,
        creatorName: creatorName,
        members: [GroupMemberModel(userId: creatorId, role: GroupRole.owner)],
        createdAt: now,
      );

      final json = groupModel.toJson();
      json['memberIds'] = [creatorId]; // Add this field for efficient querying

      await newGroupDoc.set(json);

      return Right(groupModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Group>>> getUserGroups(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('groups')
          .where('memberIds', arrayContains: userId)
          .get();

      final groups = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return GroupModel.fromJson(data).toEntity();
      }).toList();

      return Right(groups);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinGroup({
    required String groupId,
    required String userId,
    GroupRole role = GroupRole.viewer,
  }) async {
    try {
      final groupRef = _firestore.collection('groups').doc(groupId);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(groupRef);
        if (!snapshot.exists) {
          throw Exception("Group not found");
        }

        final data = snapshot.data()!;
        final groupModel = GroupModel.fromJson(data);

        if (groupModel.members.any((m) => m.userId == userId)) {
          // Already a member, just return success or throw specific error?
          // If already member, we can consider it success.
          return;
        }

        final newMember = GroupMemberModel(userId: userId, role: role);
        final updatedMembers = [...groupModel.members, newMember];

        // Update both fields
        transaction.update(groupRef, {
          'members': updatedMembers.map((m) => m.toJson()).toList(),
          'memberIds': FieldValue.arrayUnion([userId]),
        });
      });

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Group>> getGroup(String groupId) async {
    try {
      final doc = await _firestore.collection('groups').doc(groupId).get();
      if (!doc.exists) {
        return const Left(ServerFailure('Group not found'));
      }
      return Right(GroupModel.fromJson(doc.data()!).toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
