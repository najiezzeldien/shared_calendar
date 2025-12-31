import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../calendar/domain/entities/event.dart';
import '../providers/events_controller.dart';
import '../providers/calendar_view_controller.dart';

import 'package:shared_calendar/l10n/app_localizations.dart';

class MonthView extends ConsumerStatefulWidget {
  final String groupId;
  const MonthView({super.key, required this.groupId});

  @override
  ConsumerState<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends ConsumerState<MonthView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = ref.read(calendarViewControllerProvider).focusedDate;
    _selectedDay = _focusedDay;
  }

  List<Event> _getEventsForDay(List<Event> events, DateTime day) {
    return events.where((event) {
      return isSameDay(event.startTime, day);
    }).toList();
  }

  Color _getUserColor(String userId) {
    final colors = [
      Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple,
      Colors.teal, Colors.pink, Colors.indigo, Colors.brown, Colors.cyan,
    ];
    return colors[userId.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ref.listen(calendarViewControllerProvider, (previous, next) {
      if (previous?.focusedDate != next.focusedDate) {
        setState(() {
          _focusedDay = next.focusedDate;
          _selectedDay = next.focusedDate;
        });
      }
    });

    final eventsAsync = ref.watch(eventsControllerProvider(widget.groupId));

    return eventsAsync.when(
      data: (events) {
        final dayEvents = _selectedDay == null ? <Event>[] : _getEventsForDay(events, _selectedDay!);

        return Column(
          children: [
            TableCalendar<Event>(
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                ref.read(calendarViewControllerProvider.notifier).setFocusedDate(focusedDay);
              },
              onPageChanged: (focusedDay) {
                 _focusedDay = focusedDay;
              },
              eventLoader: (day) => _getEventsForDay(events, day),
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) return null;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: events.take(3).map((event) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: event.color != null
                              ? Color(event.color!)
                              : _getUserColor(event.createdBy),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: dayEvents.length,
                itemBuilder: (context, index) {
                  final event = dayEvents[index];
                  final userColor = event.color != null
                      ? Color(event.color!)
                      : _getUserColor(event.createdBy);
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: userColor,
                        radius: 10,
                      ),
                      title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        '${DateFormat.jm().format(event.startTime)} - ${DateFormat.jm().format(event.endTime)}\n${event.description ?? ''}',
                      ),
                      isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final isRecurring = event.recurrenceRule != null ||
                                event.id.contains('_inst_');

                            if (isRecurring) {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(l10n.deleteRecurringEvent),
                                  content: const Text(
                                      'This is a recurring event. Deleting it will remove all future instances. Are you sure?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text(l10n.cancel),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.red),
                                      child: Text(l10n.deleteAll),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm != true) return;
                            } else {
                              // Non-recurring delete confirmation
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(l10n.deleteEvent),
                                  content: Text(l10n.deleteConfirmation(event.title)),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text(l10n.cancel),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.red),
                                      child: Text(l10n.delete),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm != true) return;
                            }

                            if (context.mounted) {
                              ref
                                  .read(eventsControllerProvider(widget.groupId)
                                      .notifier)
                                  .deleteEvent(event.id);
                            }
                          },
                        ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}