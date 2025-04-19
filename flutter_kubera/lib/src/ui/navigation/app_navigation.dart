import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/ui/tabs/settings/auth_provider.dart';
import 'package:provider/provider.dart';
import '../tabs/dashboard/dashboard_screen.dart';
import '../tabs/search/search_screen.dart';
import '../tabs/scan/scan_screen.dart';
import '../tabs/shopping_list/shopping_list_screen.dart';
import '../tabs/settings/settings_screen.dart';
import '../tabs/settings/settings_controller.dart';

class AppNavigation extends StatefulWidget {
  final SettingsController settingsController;

  const AppNavigation(
    {
      super.key, 
      required this.settingsController
    }
  );

  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int currentPageIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Listen to AuthState changes
    final authState = context.read<AuthState>();
    authState.addListener(() {
      setState(() {
        currentPageIndex = 0; // Reset to the first page when auth state changes
      });
    });
  }

  List<Widget> _userWidgetOptions(SettingsController settingsController) => [
        DashboardScreen(),
        SearchScreen(),
        const ScanScreen(),
        ShoppingListScreen(),
        SettingsScreen(settingsController: settingsController),
      ];

  List<Widget> _guestWidgetOptions(SettingsController settingsController) => [
        SearchScreen(),
        const ScanScreen(),
        SettingsScreen(settingsController: settingsController),
      ];

  List<NavigationDestination> _userNavigationDestinations() {
    return const [
      NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
      NavigationDestination(icon: Icon(Icons.camera_alt), label: 'Scan'),
      NavigationDestination(icon: Icon(Icons.list), label: 'Lists'),
      NavigationDestination(icon: Icon(Icons.person), label: 'Account'),
    ];
  }

  List<NavigationDestination> _guestNavigationDestinations() {
    return const [
      NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
      NavigationDestination(icon: Icon(Icons.camera_alt), label: 'Scan'),
      NavigationDestination(icon: Icon(Icons.person), label: 'Account'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, authState, child) {
        return Scaffold(
          body: SafeArea(
            child: authState.isAuthorized
                ? _userWidgetOptions(widget.settingsController)[currentPageIndex]
                : _guestWidgetOptions(widget.settingsController)[currentPageIndex],
          ),
          bottomNavigationBar: NavigationBar(
            indicatorColor: const Color.fromARGB(255, 213, 183, 156),
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            selectedIndex: currentPageIndex,
            destinations: authState.isAuthorized
                ? _userNavigationDestinations()
                : _guestNavigationDestinations(),
          ),
        );
      },
    );
  }
}
