import 'package:armm_app/screens/forgot_password/forgot_password.dart';
import 'package:armm_app/screens/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modular Flutter App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        fontFamily: 'MADE Tommy Soft',
      ),
      home: const OnboardingPage(),
    );
  }
}