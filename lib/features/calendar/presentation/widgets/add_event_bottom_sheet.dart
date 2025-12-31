import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/events_controller.dart';
import '../providers/calendar_view_controller.dart';

import 'package:shared_calendar/l10n/app_localizations.dart';

class AddEventBottomSheet extends ConsumerStatefulWidget {
  final String groupId;
  const AddEventBottomSheet({super.key, required this.groupId});

  @override
  ConsumerState<AddEventBottomSheet> createState() =>
      _AddEventBottomSheetState();
}

class _AddEventBottomSheetState extends ConsumerState<AddEventBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _startDate;
  late DateTime _endDate;
  String? _recurrenceRule;
  int? _selectedColor;

  @override
  void initState() {
    super.initState();
    // Default to next hour from "now" or "focused date"
    final focusedDate = ref.read(calendarViewControllerProvider).focusedDate;
    final now = DateTime.now();

    // If focused date is in the past, use now. Otherwise use focused date.
    final targetDate =
        focusedDate.isBefore(DateTime(now.year, now.month, now.day))
        ? now
        : focusedDate;

    // Default to next hour
    final baseDate = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      now.hour,
      0,
    ).add(const Duration(hours: 1));

    // Ensure we don't start in the past even if using focused date logic
    final safeStartDate = baseDate.isBefore(now)
        ? now.add(const Duration(hours: 1))
        : baseDate;

    _startDate = safeStartDate;
    _endDate = safeStartDate.add(const Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
              Text(l10n.addEvent, style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: _saveEvent,
                child: Text(
                  l10n.save,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(),
          // Title
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: l10n.eventTitle,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              prefixIcon: const Icon(Icons.title, color: Colors.grey),
            ),
            style: const TextStyle(fontSize: 20),
            autofocus: true,
          ),
          const SizedBox(height: 8),

          // Time Pickers
          ListTile(
            leading: const Icon(Icons.access_time, color: Colors.grey),
            title: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDateTime(isStart: true),
                    child: Text(
                      DateFormat('EEE, MMM d, h:mm a').format(_startDate),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDateTime(isStart: false),
                    child: Text(
                      DateFormat('h:mm a').format(_endDate),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Recurrence
          DropdownButtonFormField<String?>(
            initialValue: _recurrenceRule,
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.doesNotRepeat)),
              DropdownMenuItem(value: 'DAILY', child: Text(l10n.everyDay)),
              DropdownMenuItem(value: 'WEEKLY', child: Text(l10n.everyWeek)),
              DropdownMenuItem(value: 'MONTHLY', child: Text(l10n.everyMonth)),
            ],
            onChanged: (val) => setState(() => _recurrenceRule = val),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.repeat, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const Divider(),

          const Divider(),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(Icons.color_lens, color: Colors.grey),
            ),
            title: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    const [
                      0xFFF44336, // Red
                      0xFFE91E63, // Pink
                      0xFF9C27B0, // Purple
                      0xFF673AB7, // Deep Purple
                      0xFF3F51B5, // Indigo
                      0xFF2196F3, // Blue
                      0xFF03A9F4, // Light Blue
                      0xFF00BCD4, // Cyan
                      0xFF009688, // Teal
                      0xFF4CAF50, // Green
                      0xFF8BC34A, // Light Green
                      0xFFFFC107, // Amber
                      0xFFFF9800, // Orange
                      0xFFFF5722, // Deep Orange
                      0xFF795548, // Brown
                      0xFF607D8B, // Blue Grey
                    ].map((colorValue) {
                      final isSelected = _selectedColor == colorValue;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = colorValue;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Color(colorValue),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),

          const Divider(),

          // Description
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(Icons.notes, color: Colors.grey),
            ),
            title: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: l10n.description,
                border: InputBorder.none,
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;

    setState(() {
      final newDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      if (isStart) {
        _startDate = newDateTime;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(hours: 1));
        }
      } else {
        _endDate = newDateTime;
        if (_endDate.isBefore(_startDate)) {
          _startDate = _endDate.subtract(const Duration(hours: 1));
        }
      }
    });
  }

  Future<void> _saveEvent() async {
    final l10n = AppLocalizations.of(context)!;
    if (_titleController.text.trim().isEmpty) return;

    if (_startDate.isBefore(
      DateTime.now().subtract(const Duration(minutes: 1)),
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.cannotCreatePastEvent)),
        );
      }
      return;
    }

    try {
      // Close sheet immediately (optimistic UI)
      Navigator.pop(context);

      await ref
          .read(eventsControllerProvider(widget.groupId).notifier)
          .createEvent(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            startTime: _startDate,
            endTime: _endDate,
            recurrenceRule: _recurrenceRule,
            color: _selectedColor,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.failedToSave(e.toString()))));
      }
    }
  }
}
