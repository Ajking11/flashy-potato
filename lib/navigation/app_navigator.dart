import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/filter_json_screen.dart';
import '../screens/machine_list_screen.dart';
import '../screens/document_repository_screen.dart';
import '../screens/dashboard_screen.dart';
import '../providers/document_provider.dart';
import '../providers/preferences_provider.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _selectedIndex = 0;

  // Flag to control bottom navigation bar visibility
  final bool showBottomNavigationBar = false;

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardScreen(),
      FilterJsonScreen(
        onDashboardPressed: () => _navigateTo(0),
      ),
      MachineListScreen(
        onDashboardPressed: () => _navigateTo(0),
      ),
      const DocumentRepositoryScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Get the providers from the parent context
    final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
    final preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);

    return MultiProvider(
      providers: [
        // Re-provide the necessary providers to make them available to all pages
        ChangeNotifierProvider<DocumentProvider>.value(
          value: documentProvider,
        ),
        ChangeNotifierProvider<PreferencesProvider>.value(
          value: preferencesProvider,
        ),
      ],
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: showBottomNavigationBar
            ? BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateTo,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.filter_list),
              label: 'Filter',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Machines',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: 'Documents',
            ),
          ],
        )
            : null,
      ),
    );
  }
}