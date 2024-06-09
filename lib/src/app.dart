import 'package:flutter/material.dart';
import 'package:sign_language_translater/src/transcribe.dart';

import 'description.dart';
import 'home.dart';
import 'list.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'settings/settings_service.dart';

import 'package:camera/camera.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();
  SettingsService _settingsService = SettingsService();
  SettingsController settingsController = SettingsController(_settingsService);
  runApp(MyApp(cameras: cameras, settingsController: settingsController));
}


/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  final SettingsController settingsController;

  const MyApp({
    super.key,
    required this.settingsController,
    required this.cameras,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor:  const Color(0xFF4053B5),
            primaryColorLight: const Color(0xFF4053B5),
          ),
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
                    return TranscribeScreen(cameras: cameras);
                  case Description.routeName:
                    return const Description();
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
