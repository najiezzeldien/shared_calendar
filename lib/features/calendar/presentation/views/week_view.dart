import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../calendar/domain/entities/event.dart';
import '../providers/events_controller.dart';
import '../providers/calendar_view_controller.dart';
import '../widgets/time_grid.dart';
import 'package:shared_calendar/l10n/app_localizations.dart';

class WeekView extends ConsumerStatefulWidget {
  final String groupId;
  const WeekView({super.key, required this.groupId});

  @override
  ConsumerState<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends ConsumerState<WeekView> {
  late PageController _pageController;
  // Calculate initial page based on some epoch or fixed date
  // For simplicity, let's assume page 0 is "this week" (surrounding "now")
  // Or better, calculate page from 2020-01-01
  final DateTime _baseDate = DateTime(2020, 1, 6); // A Monday

  @override
  void initState() {
    super.initState();
    final focusedDate = ref.read(calendarViewControllerProvider).focusedDate;
    final initialPage = _calculatePageForDate(focusedDate);
    _pageController = PageController(initialPage: initialPage);
  }

  int _calculatePageForDate(DateTime date) {
    final diff = date.difference(_baseDate).inDays;
    return (diff / 7).floor();
  }

  DateTime _calculateDateForPage(int page) {
    return _baseDate.add(Duration(days: page * 7));
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsControllerProvider(widget.groupId));

    // Listen to global date changes (e.g. from Today button)
    ref.listen(calendarViewControllerProvider, (previous, next) {
      if (previous?.focusedDate != next.focusedDate) {
        final newPage = _calculatePageForDate(next.focusedDate);
        if (_pageController.hasClients &&
            _pageController.page?.round() != newPage) {
          _pageController.jumpToPage(newPage);
        }
      }
    });

    return eventsAsync.when(
      data: (events) {
        return Column(
          children: [
            // Week Header (Mon 12, Tue 13...)
            // Controlled by the PageView (scrolling page updates header? or Header inside Page)
            // Header inside page is easier
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  // Update focused date to the Monday of this week
                  final newDate = _calculateDateForPage(page);
                  ref
                      .read(calendarViewControllerProvider.notifier)
                      .setFocusedDate(newDate);
                },
                itemBuilder: (context, index) {
                  final weekStart = _calculateDateForPage(index);
                  return _buildWeekPage(weekStart, events);
                },
              ),
            ),
          ],
        );
      },
      error: (err, stack) =>
          Center(child: Text('${AppLocalizations.of(context)!.error}: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildWeekPage(DateTime weekStart, List<Event> events) {
    final days = List.generate(
      7,
      (index) => weekStart.add(Duration(days: index)),
    );

    return Column(
      children: [
        // Header Row
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 50), // Spacing for time labels
              ...days.map((day) {
                final isToday = isSameDay(day, DateTime.now());
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.E().format(day),
                        style: TextStyle(
                          color: isToday ? Colors.blue : Colors.grey,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: isToday
                            ? const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: Text(
                          "${day.day}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isToday ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        // Grid
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Labels (Only once on the left)
                // We can use a TimeGrid that only shows labels and no events?
                // Or we can manually build labels here.
                // Better: Use TimeGrid(day: ..., showTimeLabels: true) for first day?
                // But TimeGrid has built-in labels column.

                // Let's manually build one Labels column + 7 Day Columns
                // Or, use TimeGrid for each day, but only enabled labels for the first one?
                // But TimeGrid labels take up width. If we enable for first one, the first column is wider.
                // Correct approach: Labels Column separate, then 7 equal columns.
                SizedBox(
                  width: 50,
                  child: Column(
                    children: List.generate(24, (hour) {
                      return SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 8.0),
                          child: Text(
                            DateFormat.j().format(DateTime(2024, 1, 1, hour)),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                ...days.map((day) {
                  final dayEvents = events
                      .where((e) => isSameDay(e.startTime, day))
                      .toList();
                  return Expanded(
                    child: TimeGrid(
                      day: day,
                      events: dayEvents,
                      showTimeLabels: false, // We render labels outside
                      onEventMoved: (event, newStartTime) {
                        ref
                            .read(
                              eventsControllerProvider(widget.groupId).notifier,
                            )
                            .updateEvent(
                              event.copyWith(
                                startTime: newStartTime,
                                endTime: newStartTime.add(
                                  event.endTime.difference(event.startTime),
                                ),
                              ),
                            );
                      },
                      onEventResized: (event, newEndTime) {
                        ref
                            .read(
                              eventsControllerProvider(widget.groupId).notifier,
                            )
                            .updateEvent(event.copyWith(endTime: newEndTime));
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
