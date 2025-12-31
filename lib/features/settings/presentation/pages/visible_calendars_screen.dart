import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VisibleCalendarsScreen extends StatefulWidget {
  const VisibleCalendarsScreen({super.key});

  @override
  State<VisibleCalendarsScreen> createState() => _VisibleCalendarsScreenState();
}

class _VisibleCalendarsScreenState extends State<VisibleCalendarsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Visible calendars',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "Long tap for default calendar",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader("Phone"),
          _buildCalendarItem("Birthday calendar", Colors.red),
          _buildCalendarItem(
            "Birthday calendar",
            Colors.red,
          ), // Duplicate as in screenshot mock

          const Divider(),
          _buildSectionHeader("Shared calendars"),
          _buildCalendarItem("Vacation schedule", Colors.green),
          _buildCalendarItem("Example of: Family calendar", Colors.purple),
          _buildCalendarItem("Example of: Work calendar", Colors.blue),

          const Divider(),
          _buildSectionHeader("Phone"),
          _buildCalendarItem("Phone", Colors.blueGrey, isDefault: true),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors
              .blue
              .shade700, // Using blue for section headers as per some designs or just standard style
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCalendarItem(
    String name,
    Color color, {
    bool isDefault = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16)),
                if (isDefault) ...[
                  // Not strictly in screenshot but implied logic
                ],
              ],
            ),
          ),
          if (isDefault)
            const Text("Default", style: TextStyle(color: Colors.green))
          else ...[
            const Icon(Icons.notifications_none, color: Colors.black87),
            const SizedBox(width: 16),
            const Icon(Icons.visibility_outlined, color: Colors.black87),
          ],
        ],
      ),
    );
  }
}
