import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_calendar_repository.g.dart';

class DeviceCalendarRepository {
  final DeviceCalendarPlugin _plugin;

  DeviceCalendarRepository(this._plugin);

  Future<bool> requestPermissions() async {
    var permissionsGranted = await _plugin.hasPermissions();
    if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
      permissionsGranted = await _plugin.requestPermissions();
      if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
        return false;
      }
    }
    return true;
  }

  Future<List<Calendar>> retrieveCalendars() async {
    final permissions = await requestPermissions();
    if (!permissions) return [];

    final result = await _plugin.retrieveCalendars();
    return result.data ?? [];
  }

  Future<List<Event>> retrieveEvents(
    String calendarId,
    DateTime start,
    DateTime end,
  ) async {
    final result = await _plugin.retrieveEvents(
      calendarId,
      RetrieveEventsParams(startDate: start, endDate: end),
    );
    return result.data ?? [];
  }

  // Fetch from ALL calendars
  Future<List<Event>> retrieveAllEvents(
    List<String> calendarIds,
    DateTime start,
    DateTime end,
  ) async {
    List<Event> allEvents = [];
    for (var id in calendarIds) {
      final events = await retrieveEvents(id, start, end);
      allEvents.addAll(events);
    }
    return allEvents;
  }
}

@riverpod
DeviceCalendarRepository deviceCalendarRepository(Ref ref) {
  return DeviceCalendarRepository(DeviceCalendarPlugin());
}
