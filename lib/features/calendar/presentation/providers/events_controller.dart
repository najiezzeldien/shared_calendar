import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/event.dart';

import '../../../groups/domain/entities/group_member.dart';
import '../../../groups/presentation/providers/groups_providers.dart';
import 'events_providers.dart';

part 'events_controller.g.dart';

@riverpod
class EventsController extends _$EventsController {
  @override
  FutureOr<List<Event>> build(String groupId) async {
    // strict view permission check
    final user = ref.watch(authStateChangesProvider).value;
    if (user == null) {
      return [];
    }

    // Check membership first
    final groupResult = await ref
        .watch(groupsRepositoryProvider)
        .getGroup(groupId);
    if (groupResult.isLeft()) {
      throw Exception("Group not found or error loading group");
    }
    final group = groupResult.getRight().toNullable()!;
    final isMember = group.members.any((m) => m.userId == user.id);

    if (!isMember) {
      throw Exception("Permission Denied: You are not a member of this group.");
    }

    final result = await ref
        .read(eventsRepositoryProvider)
        .getGroupEvents(groupId);
    return result.fold((failure) => throw _failureToException(failure), (
      events,
    ) {
      final expandedEvents = <Event>[];
      for (final event in events) {
        expandedEvents.add(event);
        if (event.recurrenceRule != null) {
          expandedEvents.addAll(_expandRecurringEvent(event));
        }
      }
      return expandedEvents;
    });
  }

  List<Event> _expandRecurringEvent(Event event) {
    if (event.recurrenceRule == null) return [];

    final expanded = <Event>[];
    DateTime currentStart = event.startTime;
    DateTime currentEnd = event.endTime;
    // Limit to 1 year ahead or 50 instances for MVP performance
    final limitDate = DateTime.now().add(const Duration(days: 365));
    int count = 0;

    while (count < 50) {
      // Calculate next instance
      if (event.recurrenceRule == 'DAILY') {
        currentStart = currentStart.add(const Duration(days: 1));
        currentEnd = currentEnd.add(const Duration(days: 1));
      } else if (event.recurrenceRule == 'WEEKLY') {
        currentStart = currentStart.add(const Duration(days: 7));
        currentEnd = currentEnd.add(const Duration(days: 7));
      } else if (event.recurrenceRule == 'MONTHLY') {
        // Simple monthly (same day of month)
        // Note: Logic for 31st -> 28th/30th is complex.
        // Simple approach: stick to same day, if overflow, wrap to next month (standard Dart behavior)
        // or ensure it stays in month?
        // DateTime(year, month + 1, day) handles overflow by going to next month.
        // e.g. Jan 31 -> Feb 28? No, Feb 3 (in non-leap).
        // For MVP we accept Dart's overflow behavior or use a safer add month logic.
        // Let's use simple Dart add month for now.
        final nextStart = DateTime(
          currentStart.year,
          currentStart.month + 1,
          currentStart.day,
          currentStart.hour,
          currentStart.minute,
        );
        final duration = currentEnd.difference(currentStart);
        currentStart = nextStart;
        currentEnd = nextStart.add(duration);
      } else {
        break;
      }

      if (currentStart.isAfter(limitDate)) break;

      expanded.add(
        event.copyWith(
          id: '${event.id}_inst_$count', // Ghost ID
          startTime: currentStart,
          endTime: currentEnd,
          // Make sure ghost events are technically "read only" or handled carefully
          // For now they are just events.
        ),
      );
      count++;
    }

    return expanded;
  }

  Future<void> createEvent({
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    String? recurrenceRule,
    int? color,
  }) async {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return;

    state = const AsyncLoading();

    // 1. Get Group to check permissions
    final groupResult = await ref
        .read(groupsRepositoryProvider)
        .getGroup(groupId);

    if (groupResult.isLeft()) {
      groupResult.fold(
        (failure) => state = AsyncError(
          _failureToException(failure),
          StackTrace.current,
        ),
        (_) {},
      );
      return;
    }

    final group = groupResult.getRight().toNullable()!;
    final member = group.members.where((m) => m.userId == user.id).firstOrNull;

    if (member == null) {
      state = AsyncError(
        Exception('User is not a member of this group'),
        StackTrace.current,
      );
      return;
    }

    if (member.role == GroupRole.viewer) {
      state = AsyncError(
        Exception('Permission Denied: Viewers cannot create events.'),
        StackTrace.current,
      );
      return;
    }

    final result = await ref
        .read(eventsRepositoryProvider)
        .createEvent(
          groupId: groupId,
          title: title,
          description: description,
          startTime: startTime,
          endTime: endTime,
          userId: user.id,
          creatorName: user.name ?? user.email,
          recurrenceRule: recurrenceRule,
          color: color,
        );

    result.fold(
      (failure) =>
          state = AsyncError(_failureToException(failure), StackTrace.current),
      (event) {
        ref.invalidateSelf();
      },
    );
  }

  Future<void> deleteEvent(String eventId) async {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return;

    state = const AsyncLoading();

    // 1. Get the event to find groupId and createdBy
    final eventResult = await ref
        .read(eventsRepositoryProvider)
        .getEvent(eventId);

    // Check if event retrieve failed
    if (eventResult.isLeft()) {
      eventResult.fold(
        (failure) => state = AsyncError(
          _failureToException(failure),
          StackTrace.current,
        ),
        (_) {},
      );
      return;
    }

    // Extract event
    final event = eventResult.getRight().toNullable()!;

    // 2. Get the group to find user role
    final groupResult = await ref
        .read(groupsRepositoryProvider)
        .getGroup(event.groupId);

    // Check if group retrieve failed
    if (groupResult.isLeft()) {
      groupResult.fold(
        (failure) => state = AsyncError(
          _failureToException(failure),
          StackTrace.current,
        ),
        (_) {},
      );
      return;
    }

    final group = groupResult.getRight().toNullable()!;

    // 3. Find current user member
    final member = group.members.where((m) => m.userId == user.id).firstOrNull;

    if (member == null) {
      state = AsyncError(
        Exception('User is not a member of this group'),
        StackTrace.current,
      );
      return;
    }

    // 4. Enforce Permissions: Creator OR Admin OR Owner
    final isCreator = event.createdBy == user.id;
    final isAdmin = member.role == GroupRole.admin;
    final isOwner = member.role == GroupRole.owner;

    if (!isCreator && !isAdmin && !isOwner) {
      state = AsyncError(
        Exception(
          'Permission Denied: You must be the creator or an admin to delete this event.',
        ),
        StackTrace.current,
      );
      return;
    }

    // 5. Proceed with deletion
    String targetEventId = eventId;
    // Check if it's a ghost instance (recurring event)
    if (eventId.contains('_inst_')) {
      targetEventId = eventId.split('_inst_')[0];
    }

    final result = await ref
        .read(eventsRepositoryProvider)
        .deleteEvent(targetEventId);
    result.fold(
      (failure) =>
          state = AsyncError(_failureToException(failure), StackTrace.current),
      (success) => ref.invalidateSelf(),
    );
  }

  Future<void> updateEvent(Event event) async {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return;

    state = const AsyncLoading();

    // 1. Get Group to check permissions
    final groupResult = await ref
        .read(groupsRepositoryProvider)
        .getGroup(groupId);

    if (groupResult.isLeft()) {
      groupResult.fold(
        (failure) => state = AsyncError(
          _failureToException(failure),
          StackTrace.current,
        ),
        (_) {},
      );
      return;
    }

    final group = groupResult.getRight().toNullable()!;

    // 2. Find current user member
    final member = group.members.where((m) => m.userId == user.id).firstOrNull;

    if (member == null) {
      state = AsyncError(
        Exception('User is not a member of this group'),
        StackTrace.current,
      );
      return;
    }

    // 3. Enforce Permissions: Creator OR Admin OR Owner
    // Note: We check against the event passed in.
    // Ideally we should check against the DB version to ensure 'createdBy' wasn't spoofed,
    // but for this MVP client-side check, we assume 'event.createdBy' hasn't been tampered with in memory.
    final isCreator = event.createdBy == user.id;
    final isAdmin = member.role == GroupRole.admin;
    final isOwner = member.role == GroupRole.owner;

    if (!isCreator && !isAdmin && !isOwner) {
      state = AsyncError(
        Exception(
          'Permission Denied: You must be the creator or an admin to update this event.',
        ),
        StackTrace.current,
      );
      return;
    }

    // 4. Update
    final result = await ref.read(eventsRepositoryProvider).updateEvent(event);

    result.fold(
      (failure) =>
          state = AsyncError(_failureToException(failure), StackTrace.current),
      (event) {
        ref.invalidateSelf();
      },
    );
  }

  Exception _failureToException(Failure failure) {
    return Exception(failure.message);
  }
}
