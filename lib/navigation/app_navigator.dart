import 'package:flutter/material.dart';
import '../screens/filter_json_screen.dart';
import '../screens/machine_list_screen.dart';
import '../screens/document_repository_screen.dart';
import '../constants.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _selectedIndex = 0;
  
  // List of pages to display
  final List<Widget> _pages = [
    const FilterJsonScreen(),      // Filter finder as main screen
    const MachineListScreen(),     // Machine info screen
    const DocumentRepositoryScreen(), // Documents screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.water_drop),
              label: 'Filter Finder',
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
          backgroundColor: Colors.white,
          selectedItemColor: costaRed,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'CostaFont',
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'CostaFont',
          ),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
    );
  }
}