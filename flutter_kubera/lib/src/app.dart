import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'ui/navigation/app_navigation.dart';
import 'ui/tabs/settings/settings_controller.dart';
import 'ui/tabs/settings/auth_provider.dart';

import 'core/themes.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthState(),
        ),
      ],
      child: ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: CustomThemes.lightTheme,
          darkTheme: CustomThemes.darkTheme,
          themeMode: settingsController.themeMode,

          // Make AppNavigation a Consumer
          home: AppNavigation(settingsController: settingsController)
          );
      }
        )
      );
  }
}
