import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MiniMonthCalendar extends StatefulWidget {
  final DateTime currentDate;
  final Function(DateTime) onDateSelected;

  const MiniMonthCalendar({
    super.key,
    required this.currentDate,
    required this.onDateSelected,
  });

  @override
  State<MiniMonthCalendar> createState() => _MiniMonthCalendarState();
}

class _MiniMonthCalendarState extends State<MiniMonthCalendar> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(
      widget.currentDate.year,
      widget.currentDate.month,
    );
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isInSelectedWeek(DateTime date) {
    // Assuming 'currentDate' is the anchor for the selected week.
    // We need to define what "Selected Week" means.
    // Usually starts on Sunday (or configured start day).
    // Let's assume Sunday start for parity with WeekView.

    final currentWeekday =
        widget.currentDate.weekday % 7; // Sunday=0, ..., Saturday=6
    final startOfWeek = widget.currentDate.subtract(
      Duration(days: currentWeekday),
    );
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Check if 'date' is between start and end (inclusive) AND matches year/month/day
    // A safer check:
    return date.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    // theme variable removed
    final monthName = DateFormat('MMMM').format(_displayedMonth);
    final year = DateFormat('yyyy').format(_displayedMonth);

    // Calculate days
    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );
    // Sunday based (0=Sunday, 6=Saturday). DateTime.weekday is 1=Mon...7=Sun.
    // We want 0=Sun...6=Sat.
    final firstWeekdayOffset = firstDayOfMonth.weekday % 7;

    final totalGridCells = daysInMonth + firstWeekdayOffset;
    // Round up to nearest 7 to fill rows if needed, or just let Wrap handle it?
    // GridView is better.

    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: month year < >
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    monthName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    year,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.grey,
                  ), // Visual cue dropdown
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: _previousMonth,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Days Header (Su Mo Tu ...)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].map((day) {
              return SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (totalGridCells / 7).ceil() * 7, // Complete rows
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8, // Vertical spacing between rows
              crossAxisSpacing: 0,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - firstWeekdayOffset + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(
                _displayedMonth.year,
                _displayedMonth.month,
                dayNumber,
              );
              final isToday = _isSameDay(date, DateTime.now());
              final isSelected = _isSameDay(date, widget.currentDate);
              final inSelectedWeek = _isInSelectedWeek(date);

              // Visual styling logic
              BoxDecoration? decoration;
              Color textColor = Colors.black;

              if (isToday) {
                textColor = const Color(
                  0xFFE91E63,
                ); // Pink for today text unless selected
              }

              if (inSelectedWeek) {
                // Determine if start or end of week to round corners?
                // The screenshot shows individual circles for the range or a joined pill.
                // Screenshot 1 implies specific dates are circled in pink outline for selected day,
                // but usually ranges have a background.
                // Let's mimic standard "Selected Day" = Filled Pink Circle.
                if (isSelected) {
                  decoration = const BoxDecoration(
                    color: Color(0xFFE91E63), // Pink 500
                    shape: BoxShape.circle,
                  );
                  textColor = Colors.white;
                } else if (isToday) {
                  // Today but not selected -> Pink text, no circle
                  // Handled by textColor above
                }
              }

              return GestureDetector(
                onTap: () => widget.onDateSelected(date),
                child: Container(
                  decoration: decoration,
                  child: Center(
                    child: Text(
                      '$dayNumber',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: isSelected || isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
