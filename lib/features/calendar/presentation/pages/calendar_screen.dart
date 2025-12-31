import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calendar_view_controller.dart';
import '../widgets/main_calendar_scaffold.dart';
import '../views/month_view.dart';
import '../views/day_view.dart';
import '../views/week_view.dart';

import '../widgets/add_event_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_calendar/l10n/app_localizations.dart';

class CalendarScreen extends ConsumerWidget {
  final String groupId;
  const CalendarScreen({super.key, required this.groupId});

  void _showAddEventDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddEventBottomSheet(groupId: groupId),
    );
  }

  void _shareGroup(BuildContext context, AppLocalizations l10n) {
    final link = 'https://myapp.com/join?id=$groupId&role=viewer';
    final text = l10n.shareGroupMessage(groupId, link);

    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(calendarViewControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    Widget body;
    switch (viewState.viewType) {
      case CalendarViewType.month:
        body = MonthView(groupId: groupId);
        break;
      case CalendarViewType.day:
        body = DayView(groupId: groupId);
        break;
      case CalendarViewType.week:
        body = WeekView(groupId: groupId);
        break;
    }

    return MainCalendarScaffold(
      title: l10n.groupCalendar,
      body: body,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareGroup(context, l10n),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
