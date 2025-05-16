/// App Lock & Notifications Setup Page
/// 
/// This is part of the signup flow where users can:
/// 1. Enable/disable app lock with biometric authentication
/// 2. Enable/disable push notifications
///
/// When app lock is enabled, the app will request biometric authentication
/// (Face ID, Touch ID, or other available method) when the app is opened.
/// 
/// When notifications are enabled, the app will register with Firebase Cloud Messaging
/// to receive push notifications for account activities and statements.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:armm_app/database/auth_helper.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/components/custom_progress_indicator.dart';
import 'dart:developer';

/// A page that prompts users to setup app lock and notifications preferences.
///
/// This page is shown during the signup flow after creating a user account,
/// allowing users to enable/disable app lock with biometric authentication
/// and push notifications.
class AppLockPromptPage extends StatefulWidget {
  /// Creates an AppLockPromptPage.
  /// 
  /// This page always starts with both toggles in the off position,
  /// allowing users to opt-in to app lock and notifications.
  const AppLockPromptPage({Key? key}) : super(key: key);

  @override
  _AppLockPromptPageState createState() => _AppLockPromptPageState();
}

/// State for the AppLockPromptPage.
///
/// Handles the logic for:
/// 1. Requesting and managing biometric authentication permissions
/// 2. Requesting and managing notification permissions
/// 3. Saving user preferences for app lock and notifications
class _AppLockPromptPageState extends State<AppLockPromptPage> {
  // User preferences
  bool _isAppLockEnabled = false;
  bool _isNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Load user preferences from SharedPreferences.
  /// 
  /// Retrieves saved app lock and notifications settings.
  /// Checks for existing preferences, defaults to false if none found.
  Future<void> _loadSettings() async {
    log('Loading app settings');
    final prefs = await SharedPreferences.getInstance();
    
    // Check if settings already exist
    final savedAppLock = prefs.getBool('isAppLockEnabled');
    final savedNotifications = prefs.getBool('isNotificationsEnabled');
    
    // Only set defaults if they don't exist already
    if (savedAppLock == null) {
      await prefs.setBool('isAppLockEnabled', false);
    }
    
    if (savedNotifications == null) {
      await prefs.setBool('isNotificationsEnabled', false);
    }
    
    setState(() {
      _isAppLockEnabled = savedAppLock ?? false;
      _isNotificationsEnabled = savedNotifications ?? false;
    });
    
    log('Settings loaded - App lock: $_isAppLockEnabled, Notifications: $_isNotificationsEnabled');
  }

  /// Toggle app lock - requests permission but defers setup logic to Continue button
  Future<void> _toggleAppLock(bool value) async {
    log('Toggle app lock requested: $value');
    
    if (!value) {
      // Just turn it off without any permission checks
      setState(() => _isAppLockEnabled = value);
      return;
    }
    
    // Request biometric authentication permission when turning on
    log('Requesting biometric authentication permission');
    
    // Use LocalAuthentication to check if biometric authentication is available
    final LocalAuthentication localAuth = LocalAuthentication();
    bool canCheckBiometrics = false;
    
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
      log('Can check biometrics: $canCheckBiometrics');
      
      // Check which biometrics are available
      final availableBiometrics = await localAuth.getAvailableBiometrics();
      log('Available biometrics: $availableBiometrics');
    } catch (e) {
      log('Error checking biometrics: $e');
    }
    
    // If biometrics are available, just check permission status
    if (canCheckBiometrics) {
      try {
        // This will show the native permission dialog if needed, without requiring authentication
        bool canAuthenticate = false;
        
        // On iOS, this shows the permission dialog without requiring actual authentication
        // The isDeviceSupported call triggers the native "Allow ARMM app to use Face ID" dialog
        canAuthenticate = await localAuth.isDeviceSupported();
        
        if (canAuthenticate) {
          // Permission dialog was shown, update the UI state
          // The actual setup will be done when the Continue button is pressed
          setState(() => _isAppLockEnabled = value);
        } else {
          setState(() => _isAppLockEnabled = false);
        }
      } catch (e) {
        log('Error requesting biometric permission: $e');
        setState(() => _isAppLockEnabled = false);
        return;
      }
    } else {
      // Show a dialog that biometrics are not available
      if (mounted) {
        log('Showing biometrics not available dialog');
        await showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
            title: 'Biometrics Not Available',
            message: 'Your device doesn\'t support or has not set up biometric authentication.',
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        setState(() => _isAppLockEnabled = false);
      }
      return;
    }
  }
  
  /// Configures app lock based on the toggle state
  /// This method is called when the Continue button is pressed
  Future<bool> _setupAppLock() async {
    log('Setting up app lock: $_isAppLockEnabled');
    
    // Save preference and update state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAppLockEnabled', _isAppLockEnabled);
    context.read<AuthState>().setAppLockEnabled(_isAppLockEnabled);
    
    return true;
  }

  /// Toggle notifications - requests permission but defers token setup to Continue button
  Future<void> _toggleNotifications(bool value) async {
    log('Toggle notifications requested: $value');
    
    if (!value) {
      // Just turn it off without any permission checks
      setState(() => _isNotificationsEnabled = value);
      // Save the preference immediately
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isNotificationsEnabled', false);
      log('Notifications preference saved: false');
      return; // Token deletion will be handled by Continue button
    }
    
    // Request notification permission when turning on
    log('Requesting notification permission');
    
    // Request permission using FirebaseMessaging
    var settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: true,
    );
    
    log('Notification authorization status: ${settings.authorizationStatus}');
    
    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      // User denied notification permission
      log('Notification permission denied');
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
            title: 'Notifications Permission',
            message: 'Notifications permission was denied. You can enable it in your device settings.',
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      setState(() => _isNotificationsEnabled = false);
      // Save the preference immediately
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isNotificationsEnabled', false);
      log('Notifications preference saved: false');
      return;
    }
    
    // Permission was granted, update the UI state and save the preference
    setState(() => _isNotificationsEnabled = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationsEnabled', true);
    log('Notifications preference saved: true');
    
    // Get FCM token but defer registration to Continue button
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      log('FCM token retrieved: ${token != null ? 'success' : 'null'}');
    } catch (e) {
      log('Error retrieving FCM token: $e');
      // We'll try again in _setupNotifications
    }
  }
  
  /// Configures notifications based on the toggle state
  /// This method is called when the Continue button is pressed
  Future<bool> _setupNotifications() async {
    log('Setting up notifications: $_isNotificationsEnabled');
    
    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationsEnabled', _isNotificationsEnabled);
    
    // Handle Firebase messaging token
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && mounted) {
      if (_isNotificationsEnabled) {
        // Update Firebase messaging token
        log('Updating Firebase messaging token for user: ${user.uid}');
        try {
          await updateFirebaseMessagingToken(user, context);
          log('Successfully updated Firebase messaging token');
        } catch (e) {
          log('Error updating Firebase messaging token: $e');
          // Show error dialog for better user experience
          if (mounted) {
            await showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Notification Setup',
                message: 'There was an issue enabling notifications. You can try again in settings later.',
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
          // Continue despite error
        }
      } else {
        // Delete Firebase token
        log('Deleting Firebase messaging token for user: ${user.uid}');
        try {
          await deleteFirebaseMessagingToken(user, context);
          log('Successfully deleted Firebase messaging token');
        } catch (e) {
          log('Error deleting Firebase messaging token: $e');
          // Non-critical error, continue
        }
      }
    } else {
      log('No user logged in, token management will happen when user logs in');
    }
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
          child: Column(
            children: [
              // Modern header with improved layout
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Color.fromARGB(255, 102, 102, 102),
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Back',
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 102, 102, 102)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'App Lock & Notifications',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Configure your app lock and notifications settings here.',
                    style: GoogleFonts.inter(
                      fontSize: 14, 
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                    softWrap: true,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // App Lock toggle with modern styling
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/auth.svg', 
                        width: 24, 
                        height: 24,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'App Lock',
                            style: GoogleFonts.inter(
                              fontSize: 18, 
                              fontWeight: FontWeight.w600, 
                              color: Colors.black,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Secure your app with biometrics, such as Face ID.',
                            style: GoogleFonts.inter(
                              fontSize: 12, 
                              color: Colors.grey[600],
                              height: 1.3,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    CupertinoSwitch(
                      value: _isAppLockEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (v) async {
                        await _toggleAppLock(v);
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Notifications toggle with modern styling
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/notification.svg', 
                        width: 24, 
                        height: 24,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: GoogleFonts.inter(
                              fontSize: 18, 
                              fontWeight: FontWeight.w600, 
                              color: Colors.black,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Receive alerts when a transaction has occured or if a statement has been uploaded to your account.',
                            style: GoogleFonts.inter(
                              fontSize: 12, 
                              color: Colors.grey[600],
                              height: 1.3,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    CupertinoSwitch(
                      value: _isNotificationsEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (v) async {
                        await _toggleNotifications(v);
                      },
                    ),
                  ],
                ),
              ),
              
              Spacer(),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const CustomProgressIndicator();
                      },
                    );
                    
                    try {
                      // Permissions were already requested by the toggle buttons
                      // Now we need to handle the actual setup logic
                      
                      // Setup app lock
                      log('Running app lock setup');
                      await _setupAppLock();
                      
                      // Setup notifications (including token management)
                      log('Running notifications setup');
                      await _setupNotifications();
                      
                      log('Setup completed - App lock: $_isAppLockEnabled, Notifications: $_isNotificationsEnabled');
                      
                      // Close loading dialog
                      if (mounted) {
                        Navigator.pop(context);
                        
                        // Navigate to dashboard
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const DashboardPage()),
                        );
                      }
                    } catch (e) {
                      // Handle any unexpected errors
                      log('Error during setup: $e');
                      if (mounted) {
                        // Close loading dialog
                        Navigator.pop(context);
                        
                        // Show error dialog
                        showDialog(
                          context: context,
                          builder: (context) => CustomAlertDialog(
                            title: 'Setup Error',
                            message: 'There was an unexpected error during setup. You can adjust your settings later in the app.',
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 1,
                    shadowColor: AppColors.primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Footer text explaining how to change permissions later
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'You can change permissions later in your device Settings > ARMM.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ),
              
              // Page indicator dots
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
