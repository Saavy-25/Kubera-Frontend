import 'package:flutter/material.dart';
import 'settings_controller.dart';  // Make sure the correct import path is used
import 'settings_theme_dropdown.dart';  // Import the dropdown widget

class SettingsScreen extends StatelessWidget {
  final SettingsController settingsController;

  // Constructor should accept settingsController as a parameter
  const SettingsScreen({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //Shows themes
            SettingsThemeDropdown(controller: settingsController),
          ],
        ),
      ),
    );
  }
}
