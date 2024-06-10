import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:camera/camera.dart';


bool shouldUseFirestoreEmulator = false;

void main() async {
  //checking every thing is set up properly to run the flutter app
  WidgetsFlutterBinding.ensureInitialized();
  
  // connecting to firebase
  await Firebase.initializeApp(
    name: "translation-app-de645",
    options: DefaultFirebaseOptions.currentPlatform,
  );

//   FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.getInstance(); 
//  firebaseAppCheck.installAppCheckProviderFactory(SafetyNetAppCheckProviderFactory.getInstance());
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Device Check provider
        // 3. App Attest provider
        // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );


  // track setting wether the app closed or reopened
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }

  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();
  
  List<CameraDescription> cameras = await availableCameras();
  
  
  
  runApp(
    ProviderScope(
      child: MyApp(cameras : cameras, settingsController: settingsController),
    ),
  );
}
