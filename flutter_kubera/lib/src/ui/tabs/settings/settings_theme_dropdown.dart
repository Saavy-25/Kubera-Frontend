import 'package:flutter/material.dart';
import 'settings_controller.dart';

class SettingsThemeDropdown extends StatelessWidget {
  const SettingsThemeDropdown({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ThemeMode>(
      value: controller.themeMode,
      onChanged: controller.updateThemeMode,
      items: const [
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text('System Theme'),
        ),
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text('Light Theme'),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text('Dark Theme'),
        ),
      ],
    );
  }
}
