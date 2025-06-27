import 'dart:async';
import 'dart:developer';
import 'package:armm_app/auth_check.dart';
import 'package:armm_app/components/no_internet_screen.dart';
import 'package:armm_app/services/biometric_security_service.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/utils/config.dart';
import 'package:armm_app/utils/push_notification.dart';
import 'package:armm_app/utils/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:armm_app/components/custom_progress_indicator.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/database/models/client_model.dart';

/// Main application entry point
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

class MyAppState extends State<MyApp> {
  late final BiometricSecurityService _biometricService;
  late final Stream<Client?> clientStream;

  @override
  void initState() {
    super.initState();
    
    // Initialize biometric security service
    _biometricService = BiometricSecurityService.instance;
    _biometricService.initialize();

    // Initialize authentication state based on saved settings
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authState = Provider.of<AuthState>(context, listen: false);
      await _initializeAuthenticationState(authState);
    });

    // Set up client data stream
    clientStream = _setupClientStream();
  }

  @override
  void dispose() {
    _biometricService.dispose();
    super.dispose();
  }

  /// Initialize authentication state based on app lock settings
  Future<void> _initializeAuthenticationState(AuthState authState) async {
    if (!authState.isBiometricSecurityEnabled) {
      // If app lock is disabled, ensure user is marked as initially authenticated
      authState.setInitialAuthenticationCompleted(true);
      log('MyApp: Biometric security disabled. Setting initiallyAuthenticated to true.');
    } else {
      // If app lock is enabled, authentication status will be managed by BiometricSecurityService
      log('MyApp: Biometric security enabled. Authentication will be managed by BiometricSecurityService.');
    }
  }

  /// Set up the client data stream based on authentication state
  Stream<Client?> _setupClientStream() {
    return FirebaseAuth.instance.userChanges().asyncExpand((User? user) async* {
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
      }
    });
  }

  /// Check if the user is authenticated and linked to a profile
  Future<bool> isAuthenticated() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      final db = DatabaseService(user.uid);
      final isLinked = await db.isUIDLinked(user.uid);
      return isLinked;
    } catch (e) {
      log('MyApp: Error checking authentication: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged.expand((results) => results),
      builder: (context, snapshot) {
        // Show no internet screen if disconnected
        if (snapshot.hasData && snapshot.data == ConnectivityResult.none) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: NoInternetScreen(),
          );
        }

        // Build main app with authentication flow
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const Directionality(
                textDirection: TextDirection.ltr,
                child: CustomProgressIndicator(shouldTimeout: true),
              );
            }

            return _buildMainApp();
          },
        );
      },
    );
  }

  /// Build the main application widget
  Widget _buildMainApp() {
    return StreamProvider<Client?>.value(
      value: clientStream,
      initialData: null,
      child: MaterialApp(
        title: 'ARMM',
        debugShowCheckedModeBanner: false,
        navigatorKey: _biometricService.navigatorKey,
        routes: AppRoutes.routes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
      catchError: (context, error) {
        log('main.dart: Error in fetching client stream: $error');
        return null;
      },
    );
  }
}
