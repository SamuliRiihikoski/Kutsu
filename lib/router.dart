import 'package:flutter/material.dart';
import 'package:kutsu/src/features/login/login_screen.dart';
import 'package:kutsu/src/features/login/about_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:kutsu/src/features/loading/loading.dart';
import 'package:kutsu/src/features/lists/lists.dart';
import 'package:kutsu/src/classes/classes.dart' as app;
import 'package:kutsu/src/features/datecard/datecard.dart';
import 'package:kutsu/auth_gate.dart';
import 'package:kutsu/src/features/login/pin_panel.dart';
import 'package:kutsu/src/features/login/delete_screen.dart';

class TabDestination {
  const TabDestination({required this.label, required this.route});

  final String label;
  final String route;
}

const List<TabDestination> destinations = [
  TabDestination(label: 'Kutsut', route: '/dates/calendar'),
  TabDestination(label: 'Omat', route: '/dates/created'),
  TabDestination(label: 'Tykkää', route: '/dates/joined'),
  TabDestination(label: 'Profiili', route: '/profile'),
];

class NavigationDestination {
  const NavigationDestination({
    required this.route,
    required this.label,
    required this.icon,
    this.child,
  });

  final String route;
  final String label;
  final Icon icon;
  final Widget? child;
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage<void>(
        child: AuthGateScreen(),
      ),
      routes: [
        GoRoute(
          name: 'date_card',
          path: 'date_card',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: LoadingLayout(
              child: DateCardScreen(date: state.extra as app.Date),
            ),
          ),
        ),
        GoRoute(
          path: 'create',
          pageBuilder: (context, state) => MaterialPage<void>(
            child: LoadingLayout(child: CreateDateScreen()),
          ),
        ),
        GoRoute(
          path: 'about',
          pageBuilder: (context, state) => const MaterialPage<void>(
            child: LoadingLayout(child: AboutScreen()),
          ),
        ),
        GoRoute(
          path: 'delete',
          pageBuilder: (context, state) => MaterialPage<void>(
            child: LoadingLayout(child: DeleteProfileScreen()),
          ),
        ),
      ],
    ),
  ],
);
