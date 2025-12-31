import 'package:flutter/material.dart';

class CreateGroupModal extends StatefulWidget {
  const CreateGroupModal({super.key});

  @override
  State<CreateGroupModal> createState() => _CreateGroupModalState();
}

class _CreateGroupModalState extends State<CreateGroupModal> {
  final TextEditingController _nameController = TextEditingController();
  Color _selectedColor = Colors.red;
  bool _isChannel = false;

  final List<Color> _swatches = [
    Colors.red,
    Colors.green,
    Colors.grey,
    const Color(0xFFFA8072), // Salmon
    // Gradient placeholder color (handled separately in UI)
    Colors.purpleAccent,
  ];

  @override
  void dispose() {
    _nameController.dispose();
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
        left: 16,
        right: 16,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + 24, // Keyboard padding
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'New Shared Calendar', // Or "Edit" based on context
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Save logic
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Theme primary color
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Icon Selector
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              size: 32,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          // Color Palette
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _swatches.map((color) {
              final isGradient = color == Colors.purpleAccent; // Just a marker
              final isSelected = _selectedColor == color;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedColor = color);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isGradient ? null : color,
                      gradient: isGradient
                          ? const LinearGradient(
                              colors: [
                                Colors.purple,
                                Colors.blue,
                                Colors.green,
                                Colors.yellow,
                                Colors.red,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 2)
                          : null,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Name Input
          TextField(
            controller: _nameController,
            maxLength: 25,
            decoration: InputDecoration(
              hintText: 'Enter calendar name',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Settings Rows
          _buildSettingsRow(
            icon: Icons.settings,
            text: 'Calendar Permissions',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingsRow(
            icon: null, // Custom implementation below
            text: 'Set as a calendar channel',
            customContent: Row(
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Set as a calendar channel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.workspace_premium,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isChannel,
                  onChanged: (val) => setState(() => _isChannel = val),
                  activeThumbColor: Colors.green,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Text(
            'Calendar channels are a one-to-many tool for broadcasting your calendar to unlimited audiences.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSettingsRow({
    IconData? icon,
    required String text,
    Widget? trailing,
    Widget? customContent,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child:
            customContent ??
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.black54),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
      ),
    );
  }
}
