import 'package:flutter/material.dart';
import '../tabs/dashboard/dashboard_screen.dart';
import '../tabs/search/search_screen.dart';
import '../tabs/scan/scan_screen.dart';
import '../tabs/shopping_list/shopping_list_screen.dart';
import '../tabs/settings/settings_screen.dart';
import '../tabs/settings/settings_controller.dart';

class AppNavigation extends StatefulWidget {
  final SettingsController settingsController;

  const AppNavigation({super.key, required this.settingsController});

  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int currentPageIndex = 0;

  static List<Widget> _widgetOptions(SettingsController settingsController) => [
        DashboardScreen(),
        SearchScreen(),
        const ScanScreen(),
        ShoppingListScreen(),
        SettingsScreen(settingsController: settingsController),
      ];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions(widget.settingsController)[currentPageIndex],
      ),
      
      bottomNavigationBar: NavigationBar(
        indicatorColor: const Color.fromARGB(255, 213, 183, 156),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.camera_alt), label: 'Scan'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Lists'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
      //     BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Scan'),
      //     BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lists'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
