//// filepath: /Users/omarsyed/development/armm_app/apps/mobile/lib/main.dart
import 'dart:developer';
import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/auth_check.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
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
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
          navigatorKey: navigatorKey,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                boldText: false,
                textScaler: const TextScaler.linear(1),
              ),
              child: child!,
            ),
          title: 'ARMM',
          theme: _buildAppTheme(), // your app theme function
          routes: {
            '/': (context) => const AuthCheck(),
            '/onboarding': (context) => const OnboardingPage(),
            '/dashboard': (context) => const DashboardPage(),
            '/profile': (context) => const ProfilePage(),
            '/support': (context) => const SupportPage(),
            '/documents': (context) => const DocumentsPage(),
            '/settings': (context) => const SettingsPage(),
            '/my_profiles': (context) => const MyProfilesPage(),
            '/authentication': (context) => const AuthenticationPage(),
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
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
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
    );
  }
}