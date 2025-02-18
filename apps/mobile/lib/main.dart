<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
import 'package:armm_app/client_info.dart';
=======
import 'package:armm_app/profile.dart';
>>>>>>> 05a2cb1 (Profile Page UI Elements Have Been Added)
=======
import 'package:armm_app/screens/profile/profile.dart';
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
import 'package:armm_app/auth/forgot_password/forgot_password.dart';
import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/utils/utilities.dart';
>>>>>>> d518e85 (Migrated all cloud functions and added auth functions respectively)
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
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
=======
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
>>>>>>> d743458 (Set the cloud functions)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD
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
=======
  await Firebase.initializeApp();
  await requestNotificationPermission();
  await Config.loadConfig();
<<<<<<< HEAD
  runApp(const MyApp());
>>>>>>> d518e85 (Migrated all cloud functions and added auth functions respectively)
=======
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

>>>>>>> d743458 (Set the cloud functions)
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