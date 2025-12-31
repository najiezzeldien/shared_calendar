import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_calendar/features/calendar/domain/entities/unified_event.dart';
import 'package:shared_calendar/features/home/presentation/providers/video_bubble_provider.dart';

class EventDetailsSheet extends StatelessWidget {
  final UnifiedEvent event;

  const EventDetailsSheet({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header with Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // 2. Title & Group
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.circle, color: event.color, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      event.groupName ?? 'Personal Calendar',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. Date & Time
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.access_time, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, MMMM d').format(event.startTime),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 4. RSVP Section
                const Text(
                  'Going?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildRsvpButton(
                        context,
                        label: 'Going',
                        icon: Icons.check_circle_outline,
                        color: Colors.green,
                        isSelected: event.rsvpStatus == RsvpStatus.going,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRsvpButton(
                        context,
                        label: 'Maybe',
                        icon: Icons.help_outline,
                        color: Colors.orange,
                        isSelected: event.rsvpStatus == RsvpStatus.maybe,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRsvpButton(
                        context,
                        label: 'No',
                        icon: Icons.cancel_outlined,
                        color: Colors.red,
                        isSelected: event.rsvpStatus == RsvpStatus.declined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 5. Video/Media Placeholder (Part of Advanced Features)
                Consumer(
                  builder: (context, ref, _) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Close sheet
                        ref
                            .read(videoBubbleProvider.notifier)
                            .showBubble('https://example.com/video');
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://placeholder.com/video-thumbnail',
                            ), // Placeholder
                            fit: BoxFit.cover,
                            opacity: 0.6,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                const Text(
                  'Watch Event Preview',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRsvpButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isSelected
                ? (icon == Icons.check_circle_outline
                      ? Icons.check_circle
                      : icon)
                : icon,
            color: isSelected ? color : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? color : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
