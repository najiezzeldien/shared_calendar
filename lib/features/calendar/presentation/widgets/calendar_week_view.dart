import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_calendar/features/calendar/domain/entities/unified_event.dart';

class CalendarWeekView extends StatelessWidget {
  final DateTime currentDate;
  final ScrollController scrollController;
  final VoidCallback? onTimeSlotTapped;
  final List<UnifiedEvent> events;

  const CalendarWeekView({
    super.key,
    required this.currentDate,
    required this.scrollController,
    required this.events,
    this.onTimeSlotTapped,
    this.onEventTapped,
  });

  final Function(UnifiedEvent)? onEventTapped;

  @override
  Widget build(BuildContext context) {
    // Generate valid week days (Sun -> Sat) based on currentDate
    final startOfWeek = currentDate.subtract(
      Duration(days: currentDate.weekday % 7),
    );
    final weekDays = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );

    final hours = List.generate(24, (index) => index);

    return Column(
      children: [
        // 1. Week Header
        Container(
          height: 60,
          color: Colors.white,
          child: Row(
            children: [
              const SizedBox(width: 50), // Spacing for time labels
              ...weekDays.map((date) {
                final isToday = _isSameDay(date, DateTime.now());
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('d').format(date),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isToday
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isToday ? Colors.red : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEEE').format(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isToday ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        // 2. Scrollable Time Grid
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Labels
                SizedBox(
                  width: 50,
                  child: Column(
                    children: hours.map((hour) {
                      return SizedBox(
                        height: 60,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _formatHour(hour),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Days Grid & Events
                // Days Grid & Events
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final dayWidth = constraints.maxWidth / 7;
                      return Stack(
                        children: [
                          // Background Grid Lines
                          Column(
                            children: hours.map((hour) {
                              return Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          // Vertical Dividers
                          Row(
                            children: weekDays
                                .map(
                                  (_) => Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: Colors.grey.shade100,
                                          ),
                                        ),
                                      ),
                                      height: 24 * 60.0,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),

                          // Render Events
                          ...events.map((event) {
                            return _buildEventTile(
                              context,
                              event,
                              startOfWeek,
                              dayWidth,
                            );
                          }),

                          // Current Time Indicator
                          if (weekDays.any(
                            (d) => _isSameDay(d, DateTime.now()),
                          ))
                            _buildCurrentTimeIndicator(startOfWeek),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventTile(
    BuildContext context,
    UnifiedEvent event,
    DateTime startOfWeek,
    double dayWidth,
  ) {
    // 1. Check if event falls in this week
    if (event.startTime.isBefore(startOfWeek) ||
        event.startTime.isAfter(startOfWeek.add(const Duration(days: 7)))) {
      return const SizedBox.shrink();
    }

    final dayIndex = event.startTime.difference(startOfWeek).inDays;
    if (dayIndex < 0 || dayIndex > 6) return const SizedBox.shrink();

    // Top offset
    final top = (event.startTime.hour * 60.0) + event.startTime.minute;

    // Height
    final durationMinutes = event.endTime.difference(event.startTime).inMinutes;
    final height = (durationMinutes > 0 ? durationMinutes : 60)
        .toDouble(); // Min height 60 for visibility if 0

    return Positioned(
      top: top,
      left: dayIndex * dayWidth + 1, // +1 for spacing
      width: dayWidth - 2,
      height: height,
      child: GestureDetector(
        onTap: () => onEventTapped?.call(event),
        child: Container(
          decoration: BoxDecoration(
            color: event.color,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Re-write of build to include LayoutBuilder
  // ... (Actually, simpler to just inject LayoutBuilder in the stack)

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour == 12) return '12 PM';
    if (hour < 12) return '$hour AM';
    return '${hour - 12} PM';
  }

  Widget _buildCurrentTimeIndicator(DateTime startOfWeek) {
    // ... same logic
    final now = DateTime.now();
    if (now.isBefore(startOfWeek) ||
        now.isAfter(startOfWeek.add(const Duration(days: 7)))) {
      return const SizedBox.shrink();
    }

    final dayIndex = now.difference(startOfWeek).inDays;
    final topOffset = (now.hour * 60.0) + now.minute;

    return Positioned(
      top: topOffset,
      left: 0,
      right: 0,
      child: Row(
        children: List.generate(7, (index) {
          if (index == dayIndex) {
            return Expanded(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(height: 2, color: Colors.red),
                  const CircleAvatar(radius: 3, backgroundColor: Colors.red),
                ],
              ),
            );
          }
          return const Expanded(child: SizedBox());
        }),
      ),
    );
  }
}
