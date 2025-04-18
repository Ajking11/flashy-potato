import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/filter_json_screen.dart';
import '../screens/machine_list_screen.dart';
import '../screens/document_repository_screen.dart';
import '../screens/dashboard_screen.dart';
import '../constants.dart';

final selectedNavigationIndexProvider = StateProvider<int>((ref) => 0);

class AppNavigator extends ConsumerStatefulWidget {
  const AppNavigator({super.key});

  @override
  ConsumerState<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends ConsumerState<AppNavigator> {
  // Public method to allow navigation from other widgets
  void navigateTo(int index) {
    ref.read(selectedNavigationIndexProvider.notifier).state = index;
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardScreen(),
      const FilterJsonScreen(),
      const MachineListScreen(),
      const DocumentRepositoryScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedNavigationIndexProvider);

    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: navigateTo,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: costaRed,
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
        ],
      ),
    );
  }
}