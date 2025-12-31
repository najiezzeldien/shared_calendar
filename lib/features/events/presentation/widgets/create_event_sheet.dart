import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateEventSheet extends StatefulWidget {
  final DateTime? initialStartDate;

  const CreateEventSheet({super.key, this.initialStartDate});

  @override
  State<CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends State<CreateEventSheet> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isAllDay = false;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _confirmParticipation = false;

  // Recurrence
  final String _recurrenceRule = 'Does not repeat'; // Simple string for UI now

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = widget.initialStartDate ?? now;
    _endDate = _startDate.add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 0, // ListTiles have their own padding
        right: 0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const Text(
                  'New Event',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () {
                    // Save Logic
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Form Content
          Expanded(
            child: ListView(
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
                    ),
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const Divider(height: 1, indent: 16),

                // Calendar Selection (Mock)
                ListTile(
                  leading: const Icon(Icons.circle, color: Colors.blue),
                  title: const Text('Personal Calendar'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(
                  height: 32,
                  thickness: 8,
                  color: Color(0xFFF2F2F7),
                ), // iOS style spacer
                // Time Section
                SwitchListTile(
                  title: const Text('All-day'),
                  value: _isAllDay,
                  onChanged: (val) => setState(() => _isAllDay = val),
                ),
                const Divider(height: 1, indent: 16),

                _buildDateTimeRow('Starts', _startDate),
                const Divider(height: 1, indent: 16),
                _buildDateTimeRow('Ends', _endDate),
                const Divider(height: 1, indent: 16),

                ListTile(
                  title: const Text('Time Zone'),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Riyadh', style: TextStyle(color: Colors.grey)),
                      Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 16),
                ListTile(
                  title: const Text('Repeat'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _recurrenceRule,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                  onTap: () {},
                ),

                const Divider(
                  height: 32,
                  thickness: 8,
                  color: Color(0xFFF2F2F7),
                ),

                // Location & Details
                ListTile(
                  title: const Text('Location'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 16),
                ListTile(
                  title: const Text('Reminders'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      hintText: 'Notes',
                      border: InputBorder.none,
                    ),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),

                const Divider(
                  height: 32,
                  thickness: 8,
                  color: Color(0xFFF2F2F7),
                ),

                // Confirm Participation
                SwitchListTile(
                  title: const Text('Confirm Participation'),
                  subtitle: const Text(
                    'Guests will be asked to RSVP',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  value: _confirmParticipation,
                  onChanged: (val) =>
                      setState(() => _confirmParticipation = val),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeRow(String label, DateTime dt) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              // Date
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  DateFormat('EEE, MMM d, yyyy').format(dt),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(width: 8),
              // Time
              if (!_isAllDay)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    DateFormat('h:mm a').format(dt),
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
