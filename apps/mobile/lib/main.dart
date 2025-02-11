//// filepath: /Users/omarsyed/development/armm_app/apps/mobile/lib/main.dart
import 'dart:async';
import 'dart:developer';
import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/auth_check.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/profile/pages/authentication_page.dart';
import 'package:armm_app/screens/profile/pages/disclaimer_page.dart';
import 'package:armm_app/screens/profile/pages/documents_page.dart';
import 'package:armm_app/screens/profile/pages/my_profiles_page.dart';
import 'package:armm_app/screens/profile/pages/settings_page.dart';
import 'package:armm_app/screens/profile/pages/support_page.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/utils/push_notification.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:armm_app/auth/auth_utils/faceid.dart';
import 'package:armm_app/auth/auth_utils/initial_face_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Initialize third-party services and configurations
Future<void> _initializeServices() async {
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp();
  await PushNotificationService().initialize();
  await Config.loadConfig();
  await _resetFirestore();
}

Future<void> _resetFirestore() async {
  await FirebaseFirestore.instance.terminate();
  await FirebaseFirestore.instance.clearPersistence();
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
}

/// Stream that provides Client data based on authentication state
Stream<Client?> getClientStream(BuildContext context) =>
    FirebaseAuth.instance.userChanges().asyncExpand((User? user) async* {
      if (user == null) {
        yield null;
      } else {
        // Fetch DatabaseService for the authenticated user
        DatabaseService? db = await DatabaseService.fetchCID(user.uid, context);
        if (db == null) {
          yield null;
        } else {
          yield* db.getClientStream();
        }
      }
    });

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeServices();
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String? selectedTimeOption;
  double selectedTimeInMinutes = 1.0; // Default value
  Timer? _inactivityTimer;
  bool _isAppLockEnabled = false;
    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modular Flutter App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        fontFamily: 'MADE Tommy Soft',
      ),
      home: const ForgotPasswordPage(),
    );
  }
}