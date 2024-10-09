

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:king/screens/login_accounts/login_accounts.dart';
import 'package:king/screens/password/password_screen.dart';
import 'package:king/screens/settings/settings.dart';
import 'package:king/screens/work_type/select_work_type_screen.dart';
import 'package:king/utils/keys.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  AudioPlayer.global.setAudioContext(AudioContextConfig(/*...*/).build());
  await SettingsData.init();

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
            // builder: (context) => SettingsData.hasToken() ? const SelectWorkType() : const LoginPhonePasswordScreen(),
            builder: (context) => const PasswordScreen(),
          ),
        ],
      ),
    );
  }
}

