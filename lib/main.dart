

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:king/screens/app_lock/app_lock_screen.dart';
import 'package:king/screens/settings/settings.dart';
import 'package:king/utils/keys.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  AudioPlayer.global.setAudioContext(AudioContextConfig(/*...*/).build());
  await SettingsData.init();
  const keyApplicationId = 'dPcwSslm2ETuGAjSkOfBIj6tLkhEXKbaI1oPciV1';
  const keyClientKey = 'oBiOybDbm3VfgPjo8vUpUHtzKFMzEk1c7c6nav5l';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,clientKey: keyClientKey, debug: true);

  runApp(Phoenix(child: const MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Keys.navigatorKey,
      title: 'Ecsc.sy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
        ),
      ),
      // home: const PasswordScreen(),
      home: Overlay(
        key: Keys.overlayKey,
        initialEntries: [
          OverlayEntry(
            builder: (context) => const AppLockScreen(),
          ),
        ],
      ),
    );
  }
}

