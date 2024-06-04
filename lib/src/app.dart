import 'package:flutter/material.dart';
import '/src/transcribe.dart';

import 'description.dart';
import 'home.dart';
import 'list.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          darkTheme: ThemeData.light(),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case HomeView.routeName:
                    return const HomeView();
                  case TabsView.routeName:
                    return const TabsView();
                  case TranscribeScreen.routeName:
                    return TranscribeScreen();
                  case Description.routeName:
                    return Description();
                  default:
                    return const HomeView();
                }
              },
            );
          },
        );
      },
    );
  }
}
