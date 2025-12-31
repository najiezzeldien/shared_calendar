import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_calendar/features/events/presentation/widgets/event_details_sheet.dart';
import 'package:shared_calendar/features/calendar/domain/entities/unified_event.dart';

class DeepLinkEventScreen extends ConsumerWidget {
  final String eventId;

  const DeepLinkEventScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch event by ID. For now, show a mock.
    final mockEvent = UnifiedEvent(
      id: eventId,
      title: 'Deep Linked Event',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      color: Colors.blue,
      isAllDay: false,
      isLocal: false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Shared Event')),
      body: Center(
        child: SingleChildScrollView(
          child: EventDetailsSheet(event: mockEvent),
        ),
      ),
    );
  }
}
