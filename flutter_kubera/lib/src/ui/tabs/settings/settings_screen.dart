import 'package:flutter/material.dart';
import 'settings_controller.dart';
import 'settings_theme_dropdown.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController settingsController;

  const SettingsScreen({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kubera'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            //Shows themes
            SettingsThemeDropdown(controller: settingsController),
          ],
        ),
      ),
    );
  }
}
