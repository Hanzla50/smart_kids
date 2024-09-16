
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:smart_kids_v1/pages/Homepage/ParentalControl/Profile_Screen.dart';
import 'package:smart_kids_v1/pages/Homepage/home_page.dart';
import 'package:smart_kids_v1/pages/Start/start_page.dart'; 
import 'notification_service.dart';
import 'pages/Start/login_page.dart';
import 'pages/Start/profile_info.dart';
import 'pages/Start/sign_up.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 96, 59, 181));

var kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark, seedColor: Color.fromARGB(255, 5, 99, 125));



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationService notificationService = NotificationService();
  notificationService.initialize();
  await requestExactAlarmPermission();

  await Firebase.initializeApp();
  runApp(GetMaterialApp(home: MyApp(notificationService:notificationService)));
}

Future<void> requestExactAlarmPermission() async {
  try {
    final AndroidIntent intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    );
    await intent.launch();
  } on PlatformException catch (e) {
    print("Error requesting exact alarm permission: $e");
  }
}

class MyApp extends StatelessWidget {
  late NotificationService notificationService;
    MyApp({super.key, required this.notificationService});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DateTime specificDateTime = DateTime.now().add(Duration(seconds: 10)); // Adjust as needed
    notificationService.scheduleNotification(specificDateTime);
    return  MaterialApp(
      // themeMode: ThemeMode.light,
      // debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kColorScheme,
        cardTheme: CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kDarkColorScheme.primaryContainer,
              foregroundColor: kDarkColorScheme.onPrimaryContainer),
        ),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kColorScheme.onSecondaryContainer,
                  fontSize: 16),
            ),
      ),

      routes: {
       "/": (context) => StartPage(),
        "/login": (context) => LoginPage(),
        "/siguup": (context) => SignupPage(),
        "/profile": (context) => ProfilePage(),
        "/go": (context) => Homepage(studentName: '',),
      },
    );
    
  }
}