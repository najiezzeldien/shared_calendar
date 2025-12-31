import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_calendar/features/calendar/presentation/widgets/unified_calendar_content.dart';

class UnifiedCalendarScreen extends ConsumerWidget {
  const UnifiedCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Just a wrapper now
    return const UnifiedCalendarContent();
  }
}
