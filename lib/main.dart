import 'package:cloud_firestore/cloud_firestore.dart';
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
