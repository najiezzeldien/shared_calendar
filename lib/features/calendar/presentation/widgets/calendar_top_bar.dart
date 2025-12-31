import 'package:flutter/material.dart';
import 'package:shared_calendar/l10n/app_localizations.dart';
import 'package:shared_calendar/features/calendar/presentation/widgets/mini_month_calendar.dart';

class CalendarTopBar extends StatelessWidget {
  final DateTime currentDate;
  final VoidCallback onTodayPressed;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Function(DateTime)? onDateSelected; // New callback
  final String currentView; // 'Week', 'Month', 'Day'
  final ValueChanged<String> onViewChanged;

  const CalendarTopBar({
    super.key,
    required this.currentDate,
    required this.onTodayPressed,
    required this.onPrevious,
    required this.onNext,
    required this.currentView,
    required this.onViewChanged,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Column(
        children: [
          // Row 1: Title & Avatars
          Row(
            children: [
              // Avatar Stack (Placeholder for now)
              SizedBox(
                width: 50,
                height: 32,
                child: Stack(
                  children: [
                    _buildAvatar(Colors.purple, 0),
                    _buildAvatar(Colors.orange, 15),
                    _buildAvatar(Colors.pink, 30),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Title
              Expanded(
                child: Text(
                  l10n.allCalendars,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Row 2: Controls
          Row(
            children: [
              // Navigation Arrows
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.black54),
                onPressed: onPrevious,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.black54),
                onPressed: onNext,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),

              const SizedBox(width: 16),
              // Date Range Text
              // Date Range Text
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.only(
                          top: 100,
                          left: 16,
                          right: 16,
                        ),
                        alignment: Alignment.topCenter,
                        child: MiniMonthCalendar(
                          currentDate: currentDate,
                          onDateSelected: (date) {
                            Navigator.pop(context, date);
                          },
                        ),
                      ),
                    ).then((selectedDate) {
                      if (selectedDate != null && selectedDate is DateTime) {
                        onDateSelected?.call(selectedDate);
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDateRange(currentDate), // Helper to format
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),

              // View Selector Dropdown (Simple Text Button with Arrow for styling)
              PopupMenuButton<String>(
                initialValue: currentView,
                onSelected: onViewChanged,
                child: Row(
                  children: [
                    Text(
                      currentView,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                    ),
                  ],
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'Week', child: Text(l10n.week)),
                  PopupMenuItem(value: 'Month', child: Text(l10n.month)),
                  PopupMenuItem(value: 'Day', child: Text(l10n.day)),
                ],
              ),

              const SizedBox(width: 12),

              // Today Button (Pill)
              InkWell(
                onTap: onTodayPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Text(
                    l10n.today,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),
              // Search Icon
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(Icons.search, size: 20, color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(Color color, double left) {
    return Positioned(
      left: left,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(
          radius: 14,
          backgroundColor: color,
          child: const Icon(Icons.person, size: 16, color: Colors.white),
        ),
      ),
    );
  }

  // Temporary date formatter
  String _formatDateRange(DateTime date) {
    // Logic to show "Dec 28 - Jan 03, 2026" based on current view
    // For now returning simple string
    return "Dec 28 - Jan 03";
  }
}
