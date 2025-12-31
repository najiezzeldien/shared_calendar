import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_calendar/features/home/presentation/screens/responsive_home_scaffold.dart';
import '../../features/navigation/presentation/screens/bottom_nav_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/calendar/presentation/pages/unified_calendar_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/calendar/presentation/pages/calendar_screen.dart';
import '../../features/groups/presentation/pages/join_group_screen.dart';
import '../../features/groups/domain/entities/group_member.dart';

import '../../features/events/presentation/pages/deep_link_event_screen.dart';

part 'app_router.g.dart';

final _key = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    navigatorKey: _key,
    initialLocation:
        '/login', // Initial verify logic will redirect if logged in
    redirect: (context, state) {
      final value = authState.value;
      final isLoading = authState.isLoading;
      final hasError = authState.hasError;
      final isLoggedIn = value != null;
      final isLoginRoute = state.uri.path == '/login';

      if (isLoading || hasError) return null;

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      if (isLoggedIn && isLoginRoute) {
        return '/home'; // Redirect to new Home
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Home (Dashboard)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const ResponsiveHomeScaffold(),
                routes: [
                  // Group Calendar is a sub-page of Home stack
                  GoRoute(
                    path: 'group/:groupId',
                    builder: (context, state) {
                      final groupId = state.pathParameters['groupId']!;
                      // We can reuse CalendarScreen for specific group view
                      return CalendarScreen(groupId: groupId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Unified Calendar
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const UnifiedCalendarScreen(),
              ),
            ],
          ),
          // Branch 3: Settings (Placeholder for now)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text("Settings"))),
              ),
            ],
          ),
        ],
      ),
      // Keep /join accessible outside or inside?
      // GroupCal invite links open the app.
      // Deep Link: Join Group
      GoRoute(
        path: '/join/:groupId',
        builder: (context, state) {
          final groupId = state.pathParameters['groupId'];
          final roleString = state.uri.queryParameters['role'];

          if (groupId == null) return const HomeScreen();

          final role = roleString == 'admin'
              ? GroupRole.admin
              : GroupRole.viewer;

          return JoinGroupScreen(groupId: groupId, role: role);
        },
      ),
      // Deep Link: Shared Event
      GoRoute(
        path: '/event/:eventId',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId'];
          if (eventId == null) return const HomeScreen();
          return DeepLinkEventScreen(eventId: eventId);
        },
      ),
    ],
  );
}
