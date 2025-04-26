import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/dashboard_screen.dart';
import '../screens/filter_json_screen.dart';
import '../screens/machine_list_screen.dart';
import '../screens/document_repository_screen.dart';
import '../screens/login_screen.dart';
import '../screens/machine_detail_screen.dart';
import '../screens/document_viewer_screen.dart';
import '../screens/permissions_intro_screen.dart';
import '../screens/preferences_screen.dart';
import '../screens/software_repository_screen.dart';
import '../screens/software_detail_screen.dart';
import '../services/session_manager.dart';

// Shell route branch for the main app with bottom navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    // Using redirect callbacks with a StatefulWidget wrapper is a more reliable approach
    // See StatefulShellRoute example in go_router documentation
    redirect: (BuildContext context, GoRouterState state) {
      final String location = state.matchedLocation;
      
      // We'll check for login state here (this doesn't require async)
      final bool isLoggedIn = SessionManager.isLoggedIn();
      final bool isLoggingIn = location == '/login';
      final bool isPermissionIntro = location == '/permissions';
      
      // If on login page but already logged in, go to home
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }
      
      // For permission intro logic, we'll handle it in the main.dart with a wrapper widget
      // This keeps the router simpler and avoids async issues
      
      // If not logged in and not on login page or permissions page, redirect to login
      if (!isLoggedIn && !isLoggingIn && !isPermissionIntro) {
        return '/login';
      }
      
      // No redirect needed
      return null;
    },
    routes: [
      // Permissions intro route
      GoRoute(
        path: '/permissions',
        name: 'permissions',
        builder: (context, state) => const PermissionsIntroScreen(),
      ),
      
      // Login route
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          // Dashboard tab
          GoRoute(
            path: '/',
            name: 'dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
            routes: [
              // Preferences screen (accessed from dashboard)
              GoRoute(
                path: 'preferences',
                name: 'preferences',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const PreferencesScreen(),
              ),
            ],
          ),
          
          // Filters tab
          GoRoute(
            path: '/filters',
            name: 'filters',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FilterJsonScreen(),
            ),
          ),
          
          // Machines tab
          GoRoute(
            path: '/machines',
            name: 'machines',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MachineListScreen(),
            ),
            routes: [
              // Machine detail screen
              GoRoute(
                path: ':machineId',
                name: 'machine-detail',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final machineId = state.pathParameters['machineId']!;
                  // Just pass the machineId directly to the MachineDetailScreen
                  // It will handle loading the machine data appropriately
                  return MachineDetailScreen(machineId: machineId);
                },
              ),
            ],
          ),
          
          // Documents tab
          GoRoute(
            path: '/documents',
            name: 'documents',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DocumentRepositoryScreen(),
            ),
            routes: [
              // Document viewer screen
              GoRoute(
                path: ':documentId',
                name: 'document-viewer',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final documentId = state.pathParameters['documentId']!;
                  return DocumentViewerScreen(documentId: documentId);
                },
              ),
            ],
          ),

          // Software tab
          GoRoute(
            path: '/software',
            name: 'software',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SoftwareRepositoryScreen(),
            ),
            routes: [
              // Software detail screen
              GoRoute(
                path: ':softwareId',
                name: 'software-detail',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final softwareId = state.pathParameters['softwareId']!;
                  return SoftwareDetailScreen.fromId(softwareId: softwareId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Scaffold with bottom navigation bar
class ScaffoldWithNavBar extends StatefulWidget {
  final Widget child;

  const ScaffoldWithNavBar({
    super.key,
    required this.child,
  });

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop),
            label: 'Filters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee),
            label: 'Machines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.system_update),
            label: 'Software',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/filters')) {
      return 1;
    }
    if (location.startsWith('/machines')) {
      return 2;
    }
    if (location.startsWith('/documents')) {
      return 3;
    }
    if (location.startsWith('/software')) {
      return 4;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/filters');
        break;
      case 2:
        GoRouter.of(context).go('/machines');
        break;
      case 3:
        GoRouter.of(context).go('/documents');
        break;
      case 4:
        GoRouter.of(context).go('/software');
        break;
    }
  }
}