import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/auth_screen.dart';
import '../../features/dashboard/screens/home_dashboard_screen.dart';
import '../../features/editor/screens/code_editor_screen.dart';
import '../../features/history/screens/execution_history_screen.dart';
import '../../features/languages/screens/language_catalog_screen.dart';
import '../../features/lessons/screens/lesson_detail_screen.dart';
import '../../features/lessons/screens/lessons_list_screen.dart';
import '../../features/practice/screens/challenge_detail_screen.dart';
import '../../features/practice/screens/practice_list_screen.dart';
import '../../features/profile/screens/user_profile_screen.dart';
import '../../features/projects/screens/my_projects_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/snippets/screens/code_snippets_screen.dart';
import '../../shared/widgets/app_bottom_nav_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Branch 1: Home Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeDashboardScreen(),
            ),
          ],
        ),
        // Branch 2: Code Editor
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/editor',
              builder: (context, state) => const CodeEditorScreen(),
            ),
          ],
        ),
        // Branch 3: Projects
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/projects',
              builder: (context, state) => const MyProjectsScreen(),
            ),
          ],
        ),
        // Branch 4: Practice & Challenges
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/practice',
              builder: (context, state) => const PracticeListScreen(),
            ),
          ],
        ),
        // Branch 5: Lessons
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/lessons',
              builder: (context, state) => const LessonsListScreen(),
            ),
          ],
        ),
      ],
    ),

    // Sub-Routes
    GoRoute(
      path: '/languages',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LanguageCatalogScreen(),
    ),
    GoRoute(
      path: '/snippets',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CodeSnippetsScreen(),
    ),
    GoRoute(
      path: '/history',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ExecutionHistoryScreen(),
    ),
    GoRoute(
      path: '/profile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/auth',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/practice/challenge/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ChallengeDetailScreen(challengeId: id);
      },
    ),
    GoRoute(
      path: '/lessons/detail/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return LessonDetailScreen(lessonId: id);
      },
    ),
  ],
);
