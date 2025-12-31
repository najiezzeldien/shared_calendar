import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_calendar/core/di/firebase_providers.dart';
import '../../domain/entities/group.dart';
import '../../domain/repositories/groups_repository.dart';
import '../../data/repositories/groups_repository_impl.dart';

part 'groups_providers.g.dart';

@riverpod
GroupsRepository groupsRepository(Ref ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return GroupsRepositoryImpl(firestore);
}

@riverpod
Future<Group> getGroup(Ref ref, String groupId) async {
  final repo = ref.watch(groupsRepositoryProvider);
  final result = await repo.getGroup(groupId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (group) => group,
  );
}
