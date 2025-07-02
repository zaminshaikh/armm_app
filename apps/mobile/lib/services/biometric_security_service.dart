/// Biometric Security Service
/// 
/// A comprehensive service that manages biometric authentication for app security.
/// This service handles:
/// - App lifecycle monitoring for background/foreground transitions
/// - Biometric authentication triggers and timing
/// - Security state management
/// - Seamless integration with the app's authentication flow

import 'dart:async';
import 'dart:developer';
import 'package:armm_app/database/database.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/screens/biometric_authentication/biometric_lock_screen.dart';

/// Manages all biometric security functionality for the application
class BiometricSecurityService with WidgetsBindingObserver {
  // Singleton pattern
  static BiometricSecurityService? _instance;
  static BiometricSecurityService get instance {
    _instance ??= BiometricSecurityService._internal();
    return _instance!;
  }

  BiometricSecurityService._internal();

  // Dependencies
  final LocalAuthentication _localAuth = LocalAuthentication();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  
  // State tracking
  Timer? _securityDelayTimer;
  bool _isAppInForeground = true;
  bool _hasShownBiometricScreen = false;
  bool _isCurrentlyAuthenticating = false;
  DateTime? _lastBackgroundTime;

  // Getters
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  bool get isAppInForeground => _isAppInForeground;
  bool get hasShownBiometricScreen => _hasShownBiometricScreen;

  /// Initialize the biometric security service
  Future<void> initialize() async {
    log('BiometricSecurityService: Initializing');
    WidgetsBinding.instance.addObserver(this);
  }

  /// Dispose of the service and clean up resources
  void dispose() {
    log('BiometricSecurityService: Disposing');
    WidgetsBinding.instance.removeObserver(this);
    _securityDelayTimer?.cancel();
  }

  /// Handle app lifecycle state changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log('BiometricSecurityService: App lifecycle changed to $state');
    
    switch (state) {
      case AppLifecycleState.resumed:
        _handleAppResumed();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        _handleAppBackgrounded();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  /// Handle when app comes to foreground
  void _handleAppResumed() async {
    log('BiometricSecurityService: App resumed');
    _isAppInForeground = true;
    _securityDelayTimer?.cancel();
    
    // No additional action needed since authentication is handled when going to background
  }

  /// Handle when app goes to background
  void _handleAppBackgrounded() async {
    log('BiometricSecurityService: App backgrounded');
    _isAppInForeground = false;
    _lastBackgroundTime = DateTime.now();
    _securityDelayTimer?.cancel();

    final context = _navigatorKey.currentContext;
    if (context == null) return;

    final authState = Provider.of<AuthState>(context, listen: false);
    final isSecurityEnabled = authState.isAppLockEnabled;
    final securityDelayMinutes = authState.selectedTimeInMinutes;

    if (!isSecurityEnabled) {
      log('BiometricSecurityService: Security disabled, no timer needed');
      return;
    }

    if (!await _isUserAuthenticatedAndLinked()) {
      log('BiometricSecurityService: User not authenticated, no timer needed');
      return;
    }

    // Show biometric screen immediately when going to background
    if (securityDelayMinutes <= 0) {
      // Immediate authentication required - show now
      log('BiometricSecurityService: Immediate authentication required, showing biometric screen');
      await _showBiometricAuthenticationScreen(context);
    } else {
      // Start timer for delayed authentication
      log('BiometricSecurityService: Starting security timer for $securityDelayMinutes minutes');
      _securityDelayTimer = Timer(Duration(minutes: securityDelayMinutes.toInt()), () async {
        log('BiometricSecurityService: Security timer expired, showing biometric screen');
        final currentContext = _navigatorKey.currentContext;
        if (currentContext != null && !_isCurrentlyAuthenticating) {
          await _showBiometricAuthenticationScreen(currentContext);
        }
      });
    }
  }

  /// Determine if biometric authentication should be shown
  Future<bool> _shouldShowBiometricAuthentication(BuildContext context) async {
    final authState = Provider.of<AuthState>(context, listen: false);
    
    // Check all conditions for showing biometric authentication
    final isSecurityEnabled = authState.isAppLockEnabled;
    final hasUserJustAuthenticated = authState.justAuthenticated;
    final isUserAuthenticatedAndLinked = await _isUserAuthenticatedAndLinked();
    final hasTimePassed = _hasSecurityDelayPassed(authState.selectedTimeInMinutes);

    log('BiometricSecurityService: Security check - '
        'Enabled: $isSecurityEnabled, '
        'JustAuth: $hasUserJustAuthenticated, '
        'UserLinked: $isUserAuthenticatedAndLinked, '
        'TimePassed: $hasTimePassed, '
        'HasShown: $_hasShownBiometricScreen');

    // Don't show if already shown or currently showing
    if (_hasShownBiometricScreen || _isCurrentlyAuthenticating) {
      return false;
    }

    // Don't show if user just authenticated successfully
    if (hasUserJustAuthenticated) {
      _resetJustAuthenticatedFlag(context);
      return false;
    }

    // Show if all conditions are met
    return isSecurityEnabled && 
           isUserAuthenticatedAndLinked && 
           hasTimePassed;
  }

  /// Check if security delay has passed since app was backgrounded
  bool _hasSecurityDelayPassed(double delayMinutes) {
    if (_lastBackgroundTime == null) return true;
    
    if (delayMinutes <= 0) return true; // Immediate authentication
    
    final timeSinceBackground = DateTime.now().difference(_lastBackgroundTime!);
    final hasDelayPassed = timeSinceBackground.inMinutes >= delayMinutes;
    
    log('BiometricSecurityService: Time since background: ${timeSinceBackground.inMinutes} minutes, '
        'Required: $delayMinutes minutes, Passed: $hasDelayPassed');
    
    return hasDelayPassed;
  }

  /// Check if user is authenticated with Firebase and linked to a profile
  Future<bool> _isUserAuthenticatedAndLinked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      final db = DatabaseService(user.uid);
      final isLinked = await db.isUIDLinked(user.uid);
      return isLinked;
    } catch (e) {
      log('BiometricSecurityService: Error checking user link status: $e');
      return false;
    }
  }

  /// Show the biometric authentication screen
  Future<void> _showBiometricAuthenticationScreen(BuildContext context) async {
    if (_isCurrentlyAuthenticating) return;
    
    log('BiometricSecurityService: Showing biometric authentication screen');
    _isCurrentlyAuthenticating = true;
    _hasShownBiometricScreen = true;

    try {
      await Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
              const BiometricLockScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => 
              child,
        ),
      );
    } catch (e) {
      log('BiometricSecurityService: Error showing biometric screen: $e');
    } finally {
      _isCurrentlyAuthenticating = false;
    }
  }

  /// Reset the just authenticated flag after successful authentication
  void _resetJustAuthenticatedFlag(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final authState = Provider.of<AuthState>(context, listen: false);
        authState.setJustAuthenticated(false);
        log('BiometricSecurityService: Reset justAuthenticated flag');
      } catch (e) {
        log('BiometricSecurityService: Error resetting justAuthenticated flag: $e');
      }
    });
  }

  /// Handle successful biometric authentication
  void onBiometricAuthenticationSuccess(BuildContext context) {
    log('BiometricSecurityService: Biometric authentication successful');
    _hasShownBiometricScreen = false;
    _isCurrentlyAuthenticating = false;
    
    // Update auth state
    final authState = Provider.of<AuthState>(context, listen: false);
    authState.setJustAuthenticated(true);
    authState.setInitiallyAuthenticated(true);
  }

  /// Handle failed biometric authentication
  void onBiometricAuthenticationFailure() {
    log('BiometricSecurityService: Biometric authentication failed');
    _hasShownBiometricScreen = false;
    _isCurrentlyAuthenticating = false;
  }

  /// Check if biometric authentication is available on device
  Future<bool> isBiometricAuthenticationAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      log('BiometricSecurityService: Error checking biometric availability: $e');
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      log('BiometricSecurityService: Error getting available biometrics: $e');
      return [];
    }
  }

  /// Perform biometric authentication
  Future<bool> authenticateWithBiometrics({
    required String reason,
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
        ),
      );
    } catch (e) {
      log('BiometricSecurityService: Authentication error: $e');
      return false;
    }
  }

  /// Enable biometric security
  Future<bool> enableBiometricSecurity(BuildContext context) async {
    try {
      // Check if biometrics are available
      if (!await isBiometricAuthenticationAvailable()) {
        return false;
      }

      // Test authentication to ensure permissions
      final canAuthenticate = await authenticateWithBiometrics(
        reason: 'Enable biometric security for ARMM app',
      );

      if (!canAuthenticate) {
        return false;
      }

      // Save preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAppLockEnabled', true);

      // Update state
      if (context.mounted) {
        final authState = Provider.of<AuthState>(context, listen: false);
        authState.setAppLockEnabled(true);
      }

      log('BiometricSecurityService: Biometric security enabled');
      return true;
    } catch (e) {
      log('BiometricSecurityService: Error enabling biometric security: $e');
      return false;
    }
  }

  /// Disable biometric security
  Future<void> disableBiometricSecurity(BuildContext context) async {
    try {
      // Save preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAppLockEnabled', false);

      // Update state
      if (context.mounted) {
        final authState = Provider.of<AuthState>(context, listen: false);
        authState.setAppLockEnabled(false);
      }

      // Cancel any pending timers
      _securityDelayTimer?.cancel();
      _hasShownBiometricScreen = false;

      log('BiometricSecurityService: Biometric security disabled');
    } catch (e) {
      log('BiometricSecurityService: Error disabling biometric security: $e');
    }
  }

  /// Set security delay time
  Future<void> setSecurityDelayTime(BuildContext context, String timeOption) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedTimeOption', timeOption);

      if (context.mounted) {
        final authState = Provider.of<AuthState>(context, listen: false);
        authState.setSelectedTimeOption(timeOption);
      }

      log('BiometricSecurityService: Security delay time set to $timeOption');
    } catch (e) {
      log('BiometricSecurityService: Error setting security delay time: $e');
    }
  }
}
