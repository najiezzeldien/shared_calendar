import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:shared_calendar/features/groups/presentation/providers/groups_controller.dart';
import 'package:shared_calendar/features/groups/presentation/providers/groups_providers.dart';
import 'package:shared_calendar/features/groups/domain/entities/group_member.dart';

import 'package:shared_calendar/l10n/app_localizations.dart';

class JoinGroupScreen extends ConsumerStatefulWidget {
  final String groupId;
  final GroupRole role;

  const JoinGroupScreen({super.key, required this.groupId, required this.role});

  @override
  ConsumerState<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends ConsumerState<JoinGroupScreen> {
  // Logic to join manually
  Future<void> _joinGroup() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      if (!mounted) return;
      await ref
          .read(groupsControllerProvider.notifier)
          .joinGroup(widget.groupId, role: widget.role);

      if (mounted) {
        context.go('/home'); // Go home after joining
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToJoin(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the group details
    final groupAsync = ref.watch(getGroupProvider(widget.groupId));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: groupAsync.when(
        data: (group) => _buildPreviewUI(context, group),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(l10n.failedToJoin(err.toString())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewUI(BuildContext context, dynamic group) {
    // Mocking calendar grid for preview
    return Row(
      children: [
        // Left Panel (Web) or Top (Mobile) - For now responsive layout or just center
        // Let's assume mobile-first since it's an app, but valid web link.
        Expanded(
          child: Stack(
            children: [
              // Background Calendar Grid (Read-only visual)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.3,
                  child: Image.network(
                    'https://placeholder.com/calendar-preview', // Placeholder or build a real grid
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Main Card
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.pink.shade100,
                        child: Text(
                          group.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Group Name
                      Text(
                        group.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.people,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          // Future: Count members
                          const Text(
                            "Shared Calendar",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Banner
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.blue),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "Unlock full capabilities! Join to edit events and add members.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Join Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _joinGroup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Join Calendar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Close button
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.go('/home'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
