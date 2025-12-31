import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_calendar/features/calendar/data/repositories/device_calendar_repository.dart';
import 'package:shared_calendar/features/calendar/domain/entities/unified_event.dart';
import 'package:shared_calendar/features/calendar/presentation/providers/events_providers.dart';
import 'package:shared_calendar/features/groups/presentation/providers/groups_controller.dart';
import 'package:flutter/material.dart'; // For Colors

part 'unified_events_provider.g.dart';

@riverpod
class UnifiedEvents extends _$UnifiedEvents {
  @override
  FutureOr<List<UnifiedEvent>> build({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final groups = ref.watch(groupsControllerProvider).asData?.value ?? [];
    final deviceRepo = ref.watch(deviceCalendarRepositoryProvider);
    final eventsRepo = ref.watch(eventsRepositoryProvider);

    final List<UnifiedEvent> allEvents = [];

    // 1. Fetch Shared Group Events
    // In a real app we might optimize this or cache it, but for now we fetch live.
    // We can also use a provider that returns *all* events, but simpler to just fetch here.
    // Actually, watching `eventsProvider` for each group is better for caching.
    // But `eventsProvider` logic might be "fetch for one group".

    for (final group in groups) {
      final result = await eventsRepo.getGroupEvents(group.id);
      result.fold(
        (l) => null, // Ignore failures for individual groups for now
        (events) {
          allEvents.addAll(
            events.map((e) {
              // Filter by range if needed, though getGroupEvents gets ALL.
              // Ideally we should query by range.
              if (e.startTime.isAfter(endDate) ||
                  e.endTime.isBefore(startDate)) {
                return null;
              }
              return UnifiedEvent(
                id: e.id,
                title: e.title,
                startTime: e.startTime,
                endTime: e.endTime,
                color: Color(e.color ?? 0xFF0000FF),
                isLocal: false,
                groupId: group.id,
                groupName: group.name,
              );
            }).whereType<UnifiedEvent>(),
          );
        },
      );
    }

    // 2. Fetch Device Events
    try {
      // We fetch from all calendars for now.
      // Ideally we store selected calendar IDs in preferences.
      final calendars = await deviceRepo.retrieveCalendars();
      final calendarIds = calendars.map((c) => c.id!).toList();

      final deviceEvents = await deviceRepo.retrieveAllEvents(
        calendarIds,
        startDate,
        endDate,
      );

      allEvents.addAll(
        deviceEvents.map((e) {
          return UnifiedEvent(
            id: e.eventId ?? '',
            title: e.title ?? 'No Title',
            startTime: e.start ?? DateTime.now(),
            endTime: e.end ?? DateTime.now(),
            color: Colors
                .blueGrey, // Default local color or map from e.calendarId?
            isAllDay: e.allDay ?? false,
            isLocal: true,
          );
        }),
      );
    } catch (e) {
      // Handle permission errors or fetch errors
      // print('Error fetching device events: $e');
    }

    // Sort
    allEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

    return allEvents;
  }
}
