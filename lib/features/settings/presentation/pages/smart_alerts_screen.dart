import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SmartAlertsScreen extends StatefulWidget {
  const SmartAlertsScreen({super.key});

  @override
  State<SmartAlertsScreen> createState() => _SmartAlertsScreenState();
}

class _SmartAlertsScreenState extends State<SmartAlertsScreen> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Smart Alerts',
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
        children: [
          _buildSectionHeader("DAILY AGENDA NOTIFICATIONS"),
          ListTile(
            title: const Text(
              "Enable daily agenda notifications",
              style: TextStyle(fontSize: 16),
            ),
            trailing: Switch(
              value: _enabled,
              onChanged: (val) => setState(() => _enabled = val),
              activeThumbColor: Colors.red,
            ),
          ),
          if (_enabled) ...[
            _buildTimeRow("Tomorrow's agenda", "20:30"),
            _buildTimeRow("Today's agenda", "8:30"),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildTimeRow(String title, String time) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Text(
        time,
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ),
      onTap: () {
        // Show time picker
      },
    );
  }
}
