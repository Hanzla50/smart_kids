
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smart_kids_v1/pages/Homepage/home_page.dart';
import 'package:smart_kids_v1/pages/Start/start_page.dart';

import 'pages/Start/login_page.dart';
import 'pages/Start/profile_info.dart';
import 'pages/Start/sign_up.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      // home: LoginPage(),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
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