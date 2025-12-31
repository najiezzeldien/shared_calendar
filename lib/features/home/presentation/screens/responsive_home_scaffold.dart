import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_calendar/features/home/presentation/widgets/home_content.dart';
import 'package:shared_calendar/features/calendar/presentation/widgets/unified_calendar_content.dart';

part 'responsive_home_scaffold.g.dart';

// State to track selected content in Desktop view
@riverpod
class DesktopSelectedGroup extends _$DesktopSelectedGroup {
  @override
  String? build() => null;

  void selectGroup(String? groupId) {
    state = groupId;
  }
}

class ResponsiveHomeScaffold extends ConsumerWidget {
  const ResponsiveHomeScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 700) {
          // DESKTOP / WIDE SCREEN
          return Scaffold(
            body: Row(
              children: [
                // Left Sidebar (HomeContent)
                SizedBox(
                  width: 350,
                  child: HomeContent(
                    onCalendarTap: () {
                      // Set selected group to null (shows Unified/All Calendars)
                      ref
                          .read(desktopSelectedGroupProvider.notifier)
                          .selectGroup(null);
                    },
                    onGroupTap: (groupId) {
                      ref
                          .read(desktopSelectedGroupProvider.notifier)
                          .selectGroup(groupId);
                    },
                  ),
                ),
                // Vertical Divider
                const VerticalDivider(width: 1),
                // Right Content (Calendar)
                Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final selectedGroup = ref.watch(
                        desktopSelectedGroupProvider,
                      );
                      if (selectedGroup == null) {
                        return const UnifiedCalendarContent();
                      } else {
                        // Show specific group view
                        // We can reuse UnifiedCalendarContent but maybe pass filter?
                        // Or just show a placeholder for now as we didn't refactor GroupDetails yet.
                        return const UnifiedCalendarContent();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          // MOBILE / NARROW SCREEN
          return HomeContent(
            onCalendarTap: () => context.push('/calendar'),
            onGroupTap: (groupId) => context.push('/groups/$groupId'),
          );
        }
      },
    );
  }
}
