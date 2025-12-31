import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Settings',
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
          _buildSectionHeader("GENERAL"),
          _buildSettingsItem(
            context,
            "Temperature units",
            trailing: _buildToggleSwitch(false), // Mock
          ),
          _buildSettingsItem(
            context,
            "Password Lock",
            trailing: _buildToggleSwitch(false),
          ),
          _buildSettingsItem(
            context,
            "Sound Effects",
            trailing: _buildToggleSwitch(true, activeColor: Colors.red),
          ),
          _buildSettingsItem(
            context,
            "Display appearance",
            subtitle: "Same as Device",
          ),
          _buildSettingsItem(
            context,
            "Default reminders time",
            subtitle: "one hour before",
          ),
          _buildSettingsItem(
            context,
            "Reminders sounds",
            subtitle: "Default Reminder",
          ),

          _buildSectionHeader("CALENDAR"),
          _buildSettingsItem(
            context,
            "Visible calendars",
            onTap: () => context.push('/settings/visible_calendars'),
          ),
          _buildSettingsItem(
            context,
            "Smart Alerts",
            onTap: () => context.push('/settings/smart_alerts'),
          ),
          _buildSettingsItem(context, "Start of the week", subtitle: "Sunday"),
          _buildSettingsItem(
            context,
            "Week Numbers",
            trailing: _buildToggleSwitch(false),
          ),

          _buildSectionHeader("ACCOUNT"),
          _buildSettingsItem(
            context,
            "Help Center",
            onTap: () => context.push('/settings/help_center'),
          ),
          _buildSettingsItem(context, "Terms & Privacy"),
          _buildSettingsItem(
            context,
            "Logout",
            onTap: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
          _buildSettingsItem(
            context,
            "Delete Account",
            textColor: Colors.red,
            onTap: () {}, // Add delete logic
          ),
          const SizedBox(height: 32),
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
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title, {
    String? subtitle,
    Widget? trailing,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: textColor ?? Colors.black87),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.grey.shade600))
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
    );
  }

  Widget _buildToggleSwitch(bool value, {Color? activeColor}) {
    return Transform.scale(
      scale: 0.8,
      child: Switch(
        value: value,
        onChanged: (val) {},
        activeThumbColor: activeColor ?? Colors.red,
        activeTrackColor: (activeColor ?? Colors.red).withOpacity(0.4),
      ),
    );
  }
}
