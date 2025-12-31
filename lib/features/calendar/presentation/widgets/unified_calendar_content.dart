import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_calendar/features/calendar/presentation/widgets/calendar_top_bar.dart';
import 'package:shared_calendar/features/calendar/presentation/widgets/calendar_week_view.dart';
import 'package:shared_calendar/features/events/presentation/widgets/create_event_sheet.dart';
import 'package:shared_calendar/features/calendar/presentation/providers/unified_events_provider.dart';

class UnifiedCalendarContent extends ConsumerStatefulWidget {
  const UnifiedCalendarContent({super.key});

  @override
  ConsumerState<UnifiedCalendarContent> createState() =>
      _UnifiedCalendarContentState();
}

class _UnifiedCalendarContentState
    extends ConsumerState<UnifiedCalendarContent> {
  DateTime _currentDate = DateTime.now();
  String _currentView = 'Week';

  @override
  Widget build(BuildContext context) {
    // Calculate range based on view
    DateTime start = _currentDate;
    DateTime end = _currentDate;

    if (_currentView == 'Week') {
      int weekday = _currentDate.weekday;
      start = _currentDate.subtract(Duration(days: weekday % 7));
      end = start.add(const Duration(days: 7));
    } else {
      // Month/Day logic placeholders
      start = _currentDate;
      end = _currentDate.add(const Duration(days: 1));
    }

    // Watch unified events
    final eventsAsync = ref.watch(
      unifiedEventsProvider(startDate: start, endDate: end),
    );
    final events = eventsAsync.asData?.value ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea isn't strictly necessary if embedded in a larger layout,
      // but good for mobile standalone. We can make it conditional or leave it.
      // If we are embedding, we might want to remove Scaffold.
      // But keeping Scaffold helps with FAB positioning within this panel.
      // Let's use a Stack for FAB if we want to avoid nested Scaffolds,
      // or just keep Scaffold because Flutter allows nested Scaffolds.
      // Nested Scaffold is fine for layout regions.
      body: Column(
        children: [
          // Custom Top Bar matching screenshot
          CalendarTopBar(
            currentDate: _currentDate,
            onTodayPressed: () {
              setState(() => _currentDate = DateTime.now());
            },
            onPrevious: () {
              setState(
                () => _currentDate = _currentDate.subtract(
                  const Duration(days: 7),
                ),
              );
            },
            onNext: () {
              setState(
                () => _currentDate = _currentDate.add(const Duration(days: 7)),
              );
            },
            currentView: _currentView,
            onViewChanged: (value) {
              setState(() => _currentView = value);
            },
            onDateSelected: (date) {
              setState(() => _currentDate = date);
            },
          ),

          // Divider
          const Divider(height: 1, color: Colors.grey),

          // Calendar Grid Area
          Expanded(
            child: _currentView == 'Week'
                ? CalendarWeekView(
                    currentDate: _currentDate,
                    events: events,
                    scrollController: ScrollController(
                      initialScrollOffset: 8 * 60.0,
                    ), // Start at 8 AM
                  )
                : Center(child: Text('$_currentView View coming soon')),
          ),
        ],
      ),
      // White Pill FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) =>
                CreateEventSheet(initialStartDate: _currentDate),
          );
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text(
          "Event",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
