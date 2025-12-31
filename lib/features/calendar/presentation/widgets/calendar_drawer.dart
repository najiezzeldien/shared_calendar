import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../groups/presentation/providers/groups_controller.dart';
import '../providers/calendar_view_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_calendar/core/providers/theme_provider.dart';
import 'package:shared_calendar/l10n/app_localizations.dart';

class CalendarDrawer extends ConsumerWidget {
  const CalendarDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final groupsAsync = ref.watch(groupsControllerProvider);
    final viewState = ref.watch(calendarViewControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? 'User'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                (user?.name ?? 'U')[0].toUpperCase(),
                style: const TextStyle(fontSize: 24.0, color: Colors.blue),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_view_day),
            title: Text(l10n.dayView),
            selected: viewState.viewType == CalendarViewType.day,
            onTap: () {
              ref
                  .read(calendarViewControllerProvider.notifier)
                  .setViewType(CalendarViewType.day);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.view_week),
            title: Text(l10n.weekView),
            selected: viewState.viewType == CalendarViewType.week,
            onTap: () {
              ref
                  .read(calendarViewControllerProvider.notifier)
                  .setViewType(CalendarViewType.week);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(l10n.monthView),
            selected: viewState.viewType == CalendarViewType.month,
            onTap: () {
              ref
                  .read(calendarViewControllerProvider.notifier)
                  .setViewType(CalendarViewType.month);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(l10n.myGroups, style: TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: groupsAsync.when(
              data: (groups) {
                // visual selection logic
                final String? selectedGroupId = GoRouterState.of(
                  context,
                ).pathParameters['groupId'];

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    final isSelected = group.id == selectedGroupId;

                    return ListTile(
                      leading: const Icon(Icons.group),
                      title: Text(group.name),
                      selected: isSelected,
                      selectedTileColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      selectedColor: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer,
                      onTap: () {
                        context.go('/groups/${group.id}/calendar');
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
          const Divider(),
          Consumer(
            builder: (context, ref, child) {
              final themeMode = ref.watch(themeControllerProvider);
              final isDark = themeMode == ThemeMode.dark;
              return SwitchListTile(
                title: Text(l10n.theme),
                subtitle: Text(isDark ? l10n.darkMode : l10n.lightMode),
                secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                value: isDark,
                onChanged: (val) {
                  ref.read(themeControllerProvider.notifier).toggleTheme();
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.logout),
            onTap: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
    );
  }
}
