import 'package:armm_app/client_info.dart';
import 'package:armm_app/screens/auth/forgot_password/forgot_password.dart';
import 'package:armm_app/screens/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:armm_app/signup_data.dart';
import 'package:provider/provider.dart';


Future<void> requestNotificationPermission() async {
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  debugPrint('User granted permission: ${settings.authorizationStatus}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await requestNotificationPermission();
  await Config.loadConfig();
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthState>(
          create: (_) => AuthState(), // or ChangeNotifierProvider if needed
        ),
      ],
      child: MyApp(),
    ),
  );

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