import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_calendar/features/auth/presentation/providers/auth_controller.dart';
import 'package:shared_calendar/features/auth/presentation/providers/auth_providers.dart';
import 'package:shared_calendar/features/groups/domain/entities/group.dart';
import 'package:shared_calendar/features/groups/presentation/providers/groups_controller.dart';
import 'package:shared_calendar/features/groups/presentation/widgets/create_group_modal.dart';
import 'package:shared_calendar/features/home/presentation/widgets/video_bubble.dart';
import 'package:shared_calendar/features/home/presentation/providers/video_bubble_provider.dart';
import 'package:shared_calendar/features/calendar/presentation/widgets/account_selection_modal.dart';
import 'package:shared_calendar/l10n/app_localizations.dart';

class HomeContent extends ConsumerWidget {
  final VoidCallback onCalendarTap;
  final Function(String groupId) onGroupTap;

  const HomeContent({
    super.key,
    required this.onCalendarTap,
    required this.onGroupTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final groupsAsync = ref.watch(groupsControllerProvider);
    final userAsync = ref.watch(authStateChangesProvider);
    final user = userAsync.value;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. Profile & Header (SliverAppBar)
              SliverAppBar(
                backgroundColor: Colors.white,
                floating: true,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.person, color: Colors.grey[500]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.email ?? l10n.addYourName,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            "+966 50 000 0000",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black87),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ],
                automaticallyImplyLeading: false,
              ),

              // 2. Search & Filter Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: onCalendarTap,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFCDD2),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.layers, color: Colors.red[900]),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.allCalendars,
                                      style: TextStyle(
                                        color: Colors.red[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.red[900],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(
                              l10n.lastUpdated,
                              isSelected: true,
                            ),
                            _buildFilterChip(l10n.nextEvent),
                            _buildFilterChip(l10n.unread),
                            _buildFilterChip(l10n.archived),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Groups List
              groupsAsync.when(
                data: (groups) {
                  if (groups.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(child: Text(l10n.noGroupsYet)),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final group = groups[index];
                      return _GroupCard(
                        group: group,
                        onTap: () => onGroupTap(group.id),
                      );
                    }, childCount: groups.length),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SliverFillRemaining(
                  child: Center(child: Text('${l10n.error}: $err')),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
          if (ref.watch(videoBubbleProvider).isVisible)
            VideoBubble(
              onClose: () =>
                  ref.read(videoBubbleProvider.notifier).hideBubble(),
              onExpand: () {},
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateGroupDialog(context, ref, l10n),
        label: Text(l10n.createGroup),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      endDrawer: _buildSettingsDrawer(context, l10n, ref),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool value) {},
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFFFCDD2),
        labelStyle: TextStyle(
          color: isSelected ? Colors.red[900] : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.red[200]! : Colors.grey.shade300,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildSettingsDrawer(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  l10n.calendarAccounts,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                // Add Account Button
                OutlinedButton.icon(
                  onPressed: () {
                    context.pop(); // Close drawer
                    showDialog(
                      context: context,
                      builder: (context) => const AccountSelectionModal(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Account"),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.settings, l10n.settings),
          const Divider(),
          _buildDrawerItem(Icons.help_outline, l10n.helpCenter),
          _buildDrawerItem(Icons.person_outline, l10n.account),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
            onTap: () {
              ref.read(authControllerProvider.notifier).signOut();
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {},
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  void _showCreateGroupDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateGroupModal(),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const _GroupCard({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final avatarColor =
        Colors.primaries[group.id.hashCode % Colors.primaries.length];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: avatarColor.withValues(alpha: 0.2),
                child: Icon(Icons.group, color: avatarColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Created by ${group.creatorName}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "10:41 AM",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Icon(Icons.star_border, color: Colors.grey[400]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
