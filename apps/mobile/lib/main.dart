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
import 'dart:async';
import 'dart:developer';
>>>>>>> d161894 (Documents Are Pulling Properly)
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
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:google_fonts/google_fonts.dart';
import 'package:armm_app/auth/auth_utils/faceid.dart';
import 'package:armm_app/auth/auth_utils/initial_face_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
<<<<<<< HEAD
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
=======
import 'package:armm_app/screens/font_test_screen.dart';
=======
>>>>>>> 639e63e (Remove FontTestScreen and its route from the application)
import 'package:google_fonts/google_fonts.dart';
>>>>>>> 5502a8a (Completed Dashboard App Bar)
=======
>>>>>>> 6e88b72 (Face ID Auth has been Migrated)

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
<<<<<<< HEAD
class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String? selectedTimeOption;
  double selectedTimeInMinutes = 1.0; // Default value
  Timer? _inactivityTimer;
  bool _isAppLockEnabled = false;
    
=======
class _MyAppState extends State<MyApp> {
=======
class MyAppState extends State<MyApp> with WidgetsBindingObserver {
>>>>>>> 6e88b72 (Face ID Auth has been Migrated)
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String? selectedTimeOption;
  double selectedTimeInMinutes = 1.0; // Default value
  Timer? _inactivityTimer;
  bool _isAppLockEnabled = false;
    
  @override
  void initState() {
    super.initState();

    // Add this widget as an observer to the WidgetsBinding instance
    WidgetsBinding.instance.addObserver(this);

    // Reset navigation flags when the app initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AuthState>(context, listen: false);
      appState.setHasNavigatedToFaceIDPage(false);
    });

    // Load the selected time option and app lock state
    _loadSelectedTimeOption();
    _loadAppLockState();
  }

  Future<void> _loadSelectedTimeOption() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTimeOption = prefs.getString('selectedTimeOption') ?? '1 minute';
      selectedTimeInMinutes = _getTimeInMinutes(selectedTimeOption!);
      print('Selected time option: $selectedTimeOption');
      print('Timer duration in minutes: $selectedTimeInMinutes');
    });
  }

  Future<void> _loadAppLockState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAppLockEnabled = prefs.getBool('isAppLockEnabled') ?? false;
      print('Bruh Loaded app lock state: $_isAppLockEnabled');
    });
  
    final appState = Provider.of<AuthState>(context, listen: false);
    if (!_isAppLockEnabled) {
      appState.setInitiallyAuthenticated(true);
      print('App lock is disabled. Setting initiallyAuthenticated to true.');
      print('initiallyAuthenticated: ${appState.initiallyAuthenticated}');
    } else {
      appState.setInitiallyAuthenticated(false);
      print('App lock is enabled. Setting initiallyAuthenticated to false.');
    }
  }

  double _getTimeInMinutes(String timeOption) {
    switch (timeOption) {
      case 'Immediately':
        return 0.0;
      case '1 minute':
        return 1.0;
      case '2 minute':
        return 2.0;
      case '5 minute':
        return 5.0;
      case '10 minute':
        return 10.0;
      default:
        return 1.0; // Default to 1 minute if none match
    }
  }



  /// Check if the user is authenticated and linked
  Future<bool> isAuthenticated() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) { return false; }

    String uid = user.uid;

    DatabaseService db = DatabaseService(uid);

    bool isLinked = await db.isUIDLinked(uid);

    return isLinked;
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final appState = Provider.of<AuthState>(context, listen: false);
    print('AppLifecycleState changed: $state');

    if (state == AppLifecycleState.resumed) {
      // Cancel the inactivity timer when the app is resumed.
      _inactivityTimer?.cancel();
      print('Timer cancelled on app resume');
    } else if ((state == AppLifecycleState.paused ||
                state == AppLifecycleState.inactive ||
                state == AppLifecycleState.hidden) &&
            !appState.hasNavigatedToFaceIDPage &&
            await isAuthenticated() &&
            appState.initiallyAuthenticated &&
            appState.isAppLockEnabled) {
      print('Conditions met: starting timer for Face ID navigation');
      // Cancel any existing timer
      _inactivityTimer?.cancel();
      
      // Get the time in minutes from the app state
      double timeInMinutes = appState.selectedTimeInMinutes;
      print('Using time from app state: $timeInMinutes minutes');
      
      // Handle 'Immediately' option (0 minutes)
      if (timeInMinutes <= 0) {
        print('Immediately option selected - navigating to FaceID page without delay');
        appState.setHasNavigatedToFaceIDPage(true);
        navigatorKey.currentState?.pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const FaceIdPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                child,
          ),
        );
        print('Navigated to FaceIdPage immediately');
      } else {
        // For all other time options, set a timer
        _inactivityTimer = Timer(
          Duration(minutes: timeInMinutes.toInt()),
          () {
            appState.setHasNavigatedToFaceIDPage(true);
            navigatorKey.currentState?.pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const FaceIdPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                    child,
              ),
            );
            print('Navigated to FaceIdPage after inactivity timer of $timeInMinutes minutes');
          },
        );
        print('Timer started for $timeInMinutes minutes');
      }
    } else {
      print('Face ID conditions not met. Checking which conditions failed:');
      
      // Check each condition individually and log the results
      if (!(state == AppLifecycleState.paused || 
            state == AppLifecycleState.inactive || 
            state == AppLifecycleState.hidden)) {
        print('❌ App state condition not met: current state is $state');
      }
      
      if (appState.hasNavigatedToFaceIDPage) {
        print('❌ Already navigated to FaceID page: ${appState.hasNavigatedToFaceIDPage}');
      }
      
      // Use a safe way to check authentication to avoid potential errors
      bool isAuth = false;
      try {
        isAuth = await isAuthenticated();
        if (!isAuth) {
          print('❌ User is not authenticated');
        }
      } catch (e) {
        print('❌ Error checking authentication: $e');
      }
      
      if (!appState.initiallyAuthenticated) {
        print('❌ User not initially authenticated: initiallyAuthenticated = ${appState.initiallyAuthenticated}');
      }
      
      if (!appState.isAppLockEnabled) {
        print('❌ App lock is not enabled: isAppLockEnabled = ${appState.isAppLockEnabled}');
      }
    }

    if (appState.justAuthenticated) {
      appState.setHasNavigatedToFaceIDPage(false);
      appState.setJustAuthenticated(false);
      print('Reset navigation flags after authentication');
    }
  }

>>>>>>> d161894 (Documents Are Pulling Properly)
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
<<<<<<< HEAD
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
=======
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
>>>>>>> 5502a8a (Completed Dashboard App Bar)
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
            '/onboarding': (context) => OnboardingPage(),
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