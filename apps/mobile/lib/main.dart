import 'package:armm_app/screens/profile/profile.dart';
import 'package:armm_app/auth/forgot_password/forgot_password.dart';
import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/utils/push_notification.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'screens/profile/pages/support_page.dart';
import 'screens/profile/pages/documents_page.dart';
import 'screens/profile/pages/settings_page.dart';
import 'screens/profile/pages/my_profiles_page.dart';
import 'screens/profile/pages/authentication_page.dart';
import 'screens/profile/pages/disclaimer_page.dart';

/// Initialize third-party services and configurations
Future<void> _initializeServices() async {
  // Ensure screen size is initialized
  await ScreenUtil.ensureScreenSize();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize push notifications
  await PushNotificationService().initialize();

  // Load application configuration
  await Config.loadConfig();

  // Reset Firestore settings to ensure a clean state
  await _resetFirestore();
}

/// Reset Firestore settings to ensure a clean state
Future<void> _resetFirestore() async {
  // Terminate Firestore to detach any active listeners
  await FirebaseFirestore.instance.terminate();

  // Clear persisted data
  await FirebaseFirestore.instance.clearPersistence();

  // Disable persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services and configurations
  await _initializeServices();

  // Lock device orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthState(),
      child: const MyApp(),
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
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(letterSpacing: -0.5),
          bodyMedium: TextStyle(letterSpacing: -0.5),
          displayLarge: TextStyle(letterSpacing: -0.5),
          displayMedium: TextStyle(letterSpacing: -0.5),
          displaySmall: TextStyle(letterSpacing: -0.5),
          headlineMedium: TextStyle(letterSpacing: -0.5),
          headlineSmall: TextStyle(letterSpacing: -0.5),
          titleLarge: TextStyle(letterSpacing: -0.5),
          titleMedium: TextStyle(letterSpacing: -0.5),
          titleSmall: TextStyle(letterSpacing: -0.5),
          bodySmall: TextStyle(letterSpacing: -0.5),
          labelLarge: TextStyle(letterSpacing: -0.5),
          labelSmall: TextStyle(letterSpacing: -0.5),
        ),
      ),
      home: OnboardingPage(signUpData: signUpData),
      routes: {
        '/support': (context) => SupportPage(),
        '/documents': (context) => DocumentsPage(),
        '/settings': (context) => SettingsPage(),
        '/my_profiles': (context) => MyProfilesPage(),
        '/authentication': (context) => AuthenticationPage(),
        '/disclaimer': (context) => DisclaimerPage(),
      },
    );
  }
}