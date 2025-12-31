import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/group.dart';
import 'groups_providers.dart';

import '../../domain/entities/group_member.dart';

part 'groups_controller.g.dart';

@riverpod
class GroupsController extends _$GroupsController {
  @override
  FutureOr<List<Group>> build() async {
    final user = ref.watch(authStateChangesProvider).value;
    if (user == null) {
      return [];
    }

    final result = await ref
        .read(groupsRepositoryProvider)
        .getUserGroups(user.id);
    return result.fold(
      (failure) => throw _failureToException(failure),
      (groups) => groups,
    );
  }

  Future<void> createGroup(String name) async {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return;

    state = const AsyncLoading();

    final result = await ref
        .read(groupsRepositoryProvider)
        .createGroup(
          name: name,
          creatorId: user.id,
          creatorName: user.name ?? user.email,
        );

    result.fold(
      (failure) =>
          state = AsyncError(_failureToException(failure), StackTrace.current),
      (group) async {
        // Subscribe to group notifications
        try {
          await FirebaseMessaging.instance.subscribeToTopic(
            'group_${group.id}',
          );
        } catch (e) {
          // Ignore FCM errors on non-GMS devices
          debugPrint('FCM Subscription failed: $e');
        }
        // Refresh the list
        ref.invalidateSelf();
      },
    );
  }

  Future<void> joinGroup(
    String groupId, {
    GroupRole role = GroupRole.viewer,
  }) async {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return;

    state = const AsyncLoading();

    final result = await ref
        .read(groupsRepositoryProvider)
        .joinGroup(groupId: groupId, userId: user.id, role: role);

    result.fold(
      (failure) =>
          state = AsyncError(_failureToException(failure), StackTrace.current),
      (success) async {
        // Subscribe to group notifications
        try {
          await FirebaseMessaging.instance.subscribeToTopic('group_$groupId');
        } catch (e) {
          debugPrint('FCM Subscription failed: $e');
        }
        ref.invalidateSelf();
      },
    );
  }

  Exception _failureToException(Failure failure) {
    return Exception(failure.message);
  }
}
