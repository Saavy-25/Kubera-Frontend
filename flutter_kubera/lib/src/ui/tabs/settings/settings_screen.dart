import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/ui/tabs/settings/authentication/account_profile.dart';
import 'package:provider/provider.dart';
import 'settings_controller.dart';
import 'settings_theme_dropdown.dart';
import 'auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController settingsController;

  const SettingsScreen({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, authState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Kubera'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileScreen(),
                const SizedBox(height: 16),
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                // Shows themes
                SettingsThemeDropdown(controller: settingsController),
              ],
            ),
          ),
        );
      },
    );
  }
}
