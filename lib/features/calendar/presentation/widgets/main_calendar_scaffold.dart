import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calendar_view_controller.dart';
import 'calendar_drawer.dart';
import 'package:shared_calendar/l10n/app_localizations.dart';

class MainCalendarScaffold extends ConsumerWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const MainCalendarScaffold({
    super.key,
    required this.body,
    required this.title,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(calendarViewControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const CalendarDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(title),
              actions: [
                ...?actions,
                // "Today" button
                IconButton(
                  icon: const Icon(Icons.today),
                  tooltip: l10n.today,
                  onPressed: () {
                     ref.read(calendarViewControllerProvider.notifier).setFocusedDate(DateTime.now());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CalendarViewType>(
                        value: viewState.viewType,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        dropdownColor: Colors.blue,
                        style: const TextStyle(color: Colors.white),
                        items: [
                          DropdownMenuItem(
                            value: CalendarViewType.day,
                            child: Text(l10n.day),
                          ),
                          DropdownMenuItem(
                            value: CalendarViewType.week,
                            child: Text(l10n.week),
                          ),
                          DropdownMenuItem(
                            value: CalendarViewType.month,
                            child: Text(l10n.month),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            ref
                                .read(calendarViewControllerProvider.notifier)
                                .setViewType(value);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
              floating: true,
              snap: true,
            ),
          ];
        },
        body: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
