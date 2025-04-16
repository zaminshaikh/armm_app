//// filepath: /Users/omarsyed/development/armm_app/apps/mobile/lib/main.dart
import 'dart:async';
import 'dart:developer';
import 'package:armm_app/auth/forgot_password/forgot_password.dart';
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/auth_check.dart';
import 'package:armm_app/components/no_internet_screen.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/faceid.dart';
import 'package:armm_app/initial_face_id.dart';
import 'package:armm_app/screens/activity/activity.dart';
import 'package:armm_app/screens/analytics/analytics.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/screens/profile/pages/authentication_page.dart';
import 'package:armm_app/screens/profile/pages/disclaimer_page.dart';
import 'package:armm_app/screens/profile/pages/documents_page.dart';
import 'package:armm_app/screens/profile/pages/my_profiles_page.dart';
import 'package:armm_app/screens/profile/pages/settings_page.dart';
import 'package:armm_app/screens/profile/pages/support_page.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'package:armm_app/components/custom_progress_indicator.dart';

// Define the AppColors.primary color at the top of the file, outside any class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services and configurations
  await _initializeServices();

  // Lock device orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Create and initialize AuthState before providing it to the app
  final authState = AuthState();
  await authState.loadSavedSettings();

  runApp(
    ChangeNotifierProvider(
      create: (context) => authState,
      child: const MyApp(),
    ),
  );
}

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late final Stream<Client?> clientStream;
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
      log('Selected time option: $selectedTimeOption');
      log('Timer duration in minutes: $selectedTimeInMinutes');
    });
  }

  Future<void> _loadAppLockState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAppLockEnabled = prefs.getBool('isAppLockEnabled') ?? false;
      log('Bruh Loaded app lock state: $_isAppLockEnabled');
    });
    if (!mounted) return;
    final appState = Provider.of<AuthState>(context, listen: false);
    if (!_isAppLockEnabled) {
      appState.setInitiallyAuthenticated(true);
      log('App lock is disabled. Setting initiallyAuthenticated to true.');
      log('initiallyAuthenticated: ${appState.initiallyAuthenticated}');
    } else {
      appState.setInitiallyAuthenticated(false);
      log('App lock is enabled. Setting initiallyAuthenticated to false.');
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

  @override
  void dispose() {
    // Remove this widget from the observer list
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    log('Timer cancelled in dispose');
    super.dispose();
  }

  /// Stream that provides Client data based on authentication state
  Stream<Client?> getClientStream() => FirebaseAuth.instance
        .userChanges()
        .asyncExpand((User? user) async* {
      if (user == null) {
        // User is not authenticated
        yield null;
      } else if (mounted) {
        // Fetch DatabaseService for the authenticated user
        DatabaseService? db = await DatabaseService.fetchCID(user.uid, context);
        if (db == null) {
          // CID doc not found
          yield null;
        } else {
          yield* db.getClientStream();
        }
      }});

    @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final appState = Provider.of<AuthState>(context, listen: false);
    log('AppLifecycleState changed: $state');
  
    if (state == AppLifecycleState.resumed) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) { return; }
      DatabaseService? db = await DatabaseService.fetchCID(user.uid, context);
      if (db != null) { 
        await db.updateField('lastLoggedIn', Timestamp.now());
      }
      
      // Cancel the timer when the app is resumed
      _inactivityTimer?.cancel();
      log('Timer cancelled on app resume');
    } else if ((state == AppLifecycleState.paused ||
                state == AppLifecycleState.inactive ||
                state == AppLifecycleState.hidden) &&
            !appState.hasNavigatedToFaceIDPage &&
            await isAuthenticated() &&
            appState.initiallyAuthenticated &&
            appState.isAppLockEnabled) {
      // log when all conditions are met
      log('All conditions met: Navigating to FaceIdPage after timer');
  
      // Start a timer for the selected amount of time
      _inactivityTimer?.cancel();
      log('Timer cancelled');
      _inactivityTimer = Timer(Duration(minutes: appState.selectedTimeInMinutes.toInt()), () {
        // Navigate to FaceIdPage when the timer completes
        appState.setHasNavigatedToFaceIDPage(true);
        navigatorKey.currentState?.pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const FaceIdPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
          ),
        );
      });
      log('Timer started for ${appState.selectedTimeInMinutes} minutes');
    } else {
      if (state != AppLifecycleState.paused &&
          state != AppLifecycleState.inactive &&
          state != AppLifecycleState.hidden) {
        log('Condition not met: AppLifecycleState is not paused, inactive, or hidden');
      }
      if (appState.hasNavigatedToFaceIDPage) {
        log('Condition not met: hasNavigatedToFaceIDPage is true');
      }
      if (!(await isAuthenticated())) {
        log('Condition not met: User is not authenticated');
      }
      if (!appState.initiallyAuthenticated) {
        log('Condition not met: initiallyAuthenticated is false');
      }
      if (!appState.isAppLockEnabled) {
        log('Condition not met: isAppLockEnabled is false');
      }
    }
  
    if (appState.justAuthenticated) {
      // Reset navigation flags when the user has just authenticated
      appState.setHasNavigatedToFaceIDPage(false);
      appState.setJustAuthenticated(false);
      log('Reset navigation flags after authentication');
      log('Reset navigation flags after authentication');
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
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged.expand((results) => results),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == ConnectivityResult.none) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: NoInternetScreen(),
          );
        }
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const Directionality(
                textDirection: TextDirection.ltr,
                child: CustomProgressIndicator(
                  shouldTimeout: true,
                ),
              );
            }
            final user = authSnapshot.data;
            return StreamProvider<Client?>(
              key: ValueKey(user?.uid),
              create: (_) => getClientStream(),
              catchError: (context, error) {
                log('main.dart: Error in fetching client stream: $error');
                return null;
              },
              initialData: null,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: '/',
                navigatorKey: navigatorKey,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    boldText: false,
                    textScaler: const TextScaler.linear(1),
                  ),
                  child: child!,
                ),
                title: 'ARMM Group',
                theme: _buildAppTheme(),
                // home: const AuthCheck(),
                routes: {
                  '/': (context) => const AuthCheck(),
                  '/login': (context) => const LoginPage(),
                  '/forgot_password': (context) => const ForgotPasswordPage(),
                  '/dashboard': (context) => const DashboardPage(),
                  '/analytics': (context) => const AnalyticsPage(),
                  '/activity': (context) => const ActivityPage(),
                  '/profile': (context) => const ProfilePage(),
                  '/onboarding': (context) => const OnboardingPage(),
                  '/authentication': (context) => const AuthenticationPage(),
                  '/support': (context) => const SupportPage(),
                  '/documents': (context) => const DocumentsPage(),
                  '/settings': (context) => const SettingsPage(),
                  '/my_profiles': (context) => const MyProfilesPage(),
                  '/disclaimer': (context) => const DisclaimerPage(),
                },
              ),
            );
          },
        );
      },
    );

      }


  /// Build the application theme
  ThemeData _buildAppTheme() => ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 251, 251, 251),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold),
          titleMedium: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold),
          titleSmall: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold),
          labelLarge:
              GoogleFonts.inter(color: Colors.white),
          labelMedium:
              GoogleFonts.inter(color: Colors.white),
          labelSmall:
              GoogleFonts.inter(color: Colors.white),
          displayLarge:
              GoogleFonts.inter(color: Colors.white),
          displayMedium:
              GoogleFonts.inter(color: Colors.white),
          displaySmall:
              GoogleFonts.inter(color: Colors.white),
          headlineLarge: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold),
          headlineMedium: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold),
          headlineSmall: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold),
          bodyLarge:
              GoogleFonts.inter(color: Colors.white),
          bodyMedium:
              GoogleFonts.inter(color: Colors.white),
          bodySmall:
              GoogleFonts.inter(color: Colors.white),
        ),
      );
}