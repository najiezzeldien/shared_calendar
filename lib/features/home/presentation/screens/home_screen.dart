import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_calendar/features/home/presentation/widgets/home_content.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeContent(
      onCalendarTap: () => context.push('/calendar'),
      onGroupTap: (groupId) => context.push('/groups/$groupId'),
    );
  }
}
