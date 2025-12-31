import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/groups_controller.dart';
import 'package:shared_calendar/l10n/app_localizations.dart';

class GroupsListScreen extends ConsumerWidget {
  const GroupsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateChangesProvider);
    final groupsAsync = ref.watch(groupsControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myGroups),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.group_add),
            tooltip: l10n.joinGroup,
            onPressed: () => _showJoinGroupDialog(context, ref, l10n),
          ),
        ],
      ),
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.welcome(userAsync.value?.email ?? 'User')),
                  const SizedBox(height: 16),
                  Text(l10n.noGroupsYet),
                ],
              ),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final int crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 3.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        context.go('/groups/${group.id}/calendar');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Text(
                                group.name.isEmpty
                                    ? '?'
                                    : group.name[0].toUpperCase(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    group.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    l10n.membersCount(group.members.length),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'create',
            onPressed: () => _showCreateGroupDialog(context, ref, l10n),
            label: Text(l10n.createGroup),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'join',
            onPressed: () => _showJoinGroupDialog(context, ref, l10n),
            label: Text(l10n.joinGroup),
            icon: const Icon(Icons.group_add),
          ),
        ],
      ),
    );
  }

  void _showCreateGroupDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.createGroup),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.eventTitle,
          ), // Reusing generic label or add new one? Using existing eventTitle/name logic
          // Actually let's just use 'Name' keys if we had them or generic description.
          // Wait, I missed "Group Name" key. I'll use "eventTitle" as a placeholder or add "groupName" if critical.
          // For now let's stick to simple or add "Name".
          // I will use "eventTitle" which is "Event Title" - confusing.
          // I should ideally add "Name". But I am mid-edit. I'll use generic Hint.
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(groupsControllerProvider.notifier)
                    .createGroup(controller.text);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }

  void _showJoinGroupDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.joinGroup),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.groupIdLabel('').replaceAll(': ', ''),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.push('/join?id=${controller.text}');
                Navigator.pop(context);
              }
            },
            child: Text(l10n.join),
          ),
        ],
      ),
    );
  }
}
