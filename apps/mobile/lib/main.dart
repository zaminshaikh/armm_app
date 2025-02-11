import 'package:armm_app/client_info.dart';
import 'package:armm_app/screens/auth/forgot_password/forgot_password.dart';
import 'package:armm_app/screens/auth/onboarding/onboarding_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:armm_app/signup_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Uncomment the desired version:
  runApp(const MyApp());
  // runApp(const MyApp());
}


/// Stateful Version
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SignUpData signUpData;

  @override
  void initState() {
    super.initState();
    // Initialize signUpData as needed
    signUpData = SignUpData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modular Flutter App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        fontFamily: 'MADE Tommy Soft',
      ),
      home: OnboardingPage(signUpData: signUpData),
    );
  }
}