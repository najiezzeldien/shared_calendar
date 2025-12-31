import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_calendar/features/home/presentation/screens/responsive_home_scaffold.dart';
import '../../features/search/presentation/pages/search_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../../features/settings/presentation/pages/help_center_screen.dart';
import '../../features/settings/presentation/pages/visible_calendars_screen.dart';
import '../../features/settings/presentation/pages/smart_alerts_screen.dart';
import '../../features/navigation/presentation/screens/bottom_nav_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/calendar/presentation/pages/unified_calendar_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/calendar/presentation/pages/calendar_screen.dart';
import '../../features/groups/presentation/pages/join_group_screen.dart';
import '../../features/groups/domain/entities/group_member.dart';

import '../../features/events/presentation/pages/deep_link_event_screen.dart';
import '../../features/auth/presentation/pages/onboarding_screen.dart';

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
        return '/onboarding'; // Redirect to Onboarding Flow for Redesign Verification
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
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
          // Branch 3: Search
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          // Branch 4: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'help_center',
                    builder: (context, state) => const HelpCenterScreen(),
                  ),
                  GoRoute(
                    path: 'visible_calendars',
                    builder: (context, state) => const VisibleCalendarsScreen(),
                  ),
                  GoRoute(
                    path: 'smart_alerts',
                    builder: (context, state) => const SmartAlertsScreen(),
                  ),
                ],
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
