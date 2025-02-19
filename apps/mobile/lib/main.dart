<<<<<<< HEAD
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
=======
//// filepath: /Users/omarsyed/development/armm_app/apps/mobile/lib/main.dart
import 'dart:developer';
>>>>>>> d161894 (Documents Are Pulling Properly)
import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/profile/pages/authentication_page.dart';
import 'package:armm_app/screens/profile/pages/disclaimer_page.dart';
import 'package:armm_app/screens/profile/pages/documents_page.dart';
import 'package:armm_app/screens/profile/pages/my_profiles_page.dart';
import 'package:armm_app/screens/profile/pages/settings_page.dart';
import 'package:armm_app/screens/profile/pages/support_page.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:armm_app/signup_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/utils/utilities.dart';
<<<<<<< HEAD
>>>>>>> d518e85 (Migrated all cloud functions and added auth functions respectively)
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< HEAD
import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/utils/push_notification.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:armm_app/auth/auth_utils/faceid.dart';
import 'package:armm_app/auth/auth_utils/initial_face_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
=======
import 'package:provider/provider.dart';
import 'screens/profile/pages/support_page.dart';
import 'screens/profile/pages/documents_page.dart';
import 'screens/profile/pages/settings_page.dart';
import 'screens/profile/pages/my_profiles_page.dart';
import 'screens/profile/pages/authentication_page.dart';
import 'screens/profile/pages/disclaimer_page.dart';
>>>>>>> 74eb99f (Made Dummy Sub-Pages For the Profile Page)
=======
>>>>>>> d161894 (Documents Are Pulling Properly)

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

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d161894 (Documents Are Pulling Properly)
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
<<<<<<< HEAD
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

=======
>>>>>>> 74eb99f (Made Dummy Sub-Pages For the Profile Page)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD
=======

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
>>>>>>> d161894 (Documents Are Pulling Properly)
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

<<<<<<< HEAD
<<<<<<< HEAD
=======
/// Stateful Version
>>>>>>> 74eb99f (Made Dummy Sub-Pages For the Profile Page)
=======
>>>>>>> d161894 (Documents Are Pulling Properly)
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

<<<<<<< HEAD
class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String? selectedTimeOption;
  double selectedTimeInMinutes = 1.0; // Default value
  Timer? _inactivityTimer;
  bool _isAppLockEnabled = false;
    
=======
class _MyAppState extends State<MyApp> {
  late SignUpData signUpData;
  @override
  void initState() {
    super.initState();
    signUpData = SignUpData();
  }

>>>>>>> d161894 (Documents Are Pulling Properly)
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, authSnapshot) {
          final user = authSnapshot.data;
          return StreamProvider<Client?>(
            key: ValueKey(user?.uid),
            create: (_) => getClientStream(context),
            initialData: null,
            catchError: (context, error) {
              log('main.dart: Error in fetching client stream: $error');
              return null;
            },
            child: MaterialApp(
              title: 'ARMM App',
              theme: _buildAppTheme(), // your app theme function
              home: OnboardingPage(signUpData: signUpData),
              routes: {
                '/profile': (context) => ProfilePage(),
                '/support': (context) => SupportPage(),
                '/documents': (context) => DocumentsPage(),
                '/settings': (context) => SettingsPage(),
                '/my_profiles': (context) => MyProfilesPage(),
                '/authentication': (context) => AuthenticationPage(),
                '/disclaimer': (context) => DisclaimerPage(),
              },
            ),
          );
        },
      );

  ThemeData _buildAppTheme() {
    return ThemeData(
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
<<<<<<< HEAD
<<<<<<< HEAD
      home: const ForgotPasswordPage(),
=======
      home: OnboardingPage(signUpData: signUpData),
      routes: {
        '/support': (context) => SupportPage(),
        '/documents': (context) => DocumentsPage(),
        '/settings': (context) => SettingsPage(),
        '/my_profiles': (context) => MyProfilesPage(),
        '/authentication': (context) => AuthenticationPage(),
        '/disclaimer': (context) => DisclaimerPage(),
      },
>>>>>>> 74eb99f (Made Dummy Sub-Pages For the Profile Page)
=======
>>>>>>> d161894 (Documents Are Pulling Properly)
    );
  }
}