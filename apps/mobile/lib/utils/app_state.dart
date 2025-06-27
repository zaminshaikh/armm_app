import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Application authentication state management
/// 
/// Manages authentication-related state including biometric security settings,
/// user authentication status, and security timing preferences.
class AuthState extends ChangeNotifier {
  // Biometric security state
  bool _isBiometricSecurityEnabled = false;
  String _securityDelayOption = 'Immediately';
  double _securityDelayMinutes = 0.0;
  
  // Authentication flow state
  bool _hasJustCompletedAuthentication = false;
  bool _hasCompletedInitialAuthentication = false;
  bool _shouldForceDashboardNavigation = false;

  // Security UI state (legacy - will be phased out)
  bool _hasNavigatedToSecurityScreen = false;

  // Getters for biometric security
  bool get isBiometricSecurityEnabled => _isBiometricSecurityEnabled;
  String get securityDelayOption => _securityDelayOption;
  double get securityDelayMinutes => _securityDelayMinutes;
  
  // Getters for authentication flow
  bool get hasJustCompletedAuthentication => _hasJustCompletedAuthentication;
  bool get hasCompletedInitialAuthentication => _hasCompletedInitialAuthentication;
  bool get shouldForceDashboardNavigation => _shouldForceDashboardNavigation;
  
  // Legacy getters (for backward compatibility)
  bool get hasNavigatedToFaceIDPage => _hasNavigatedToSecurityScreen;
  bool get justAuthenticated => _hasJustCompletedAuthentication;
  bool get initiallyAuthenticated => _hasCompletedInitialAuthentication;
  bool get isAppLockEnabled => _isBiometricSecurityEnabled;
  String get selectedTimeOption => _securityDelayOption;
  double get selectedTimeInMinutes => _securityDelayMinutes;
  bool get forceDashboard => _shouldForceDashboardNavigation;

  /// Load saved security settings from SharedPreferences
  Future<void> loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load biometric security state
    final isEnabled = prefs.getBool('isAppLockEnabled') ?? false;
    _isBiometricSecurityEnabled = isEnabled;
    
    // Load security delay time option
    final timeOption = prefs.getString('selectedTimeOption') ?? 'Immediately';
    _securityDelayOption = timeOption;
    _securityDelayMinutes = _convertTimeOptionToMinutes(timeOption);
    
    notifyListeners();
  }

  /// Set biometric security enabled state
  void setBiometricSecurityEnabled(bool value) {
    _isBiometricSecurityEnabled = value;
    notifyListeners();
  }

  /// Set security delay time option
  void setSecurityDelayOption(String timeOption) {
    _securityDelayOption = timeOption;
    _securityDelayMinutes = _convertTimeOptionToMinutes(timeOption);
    notifyListeners();
  }

  /// Set just completed authentication state
  void setJustCompletedAuthentication(bool value) {
    _hasJustCompletedAuthentication = value;
    notifyListeners();
  }

  /// Set initial authentication completed state
  void setInitialAuthenticationCompleted(bool value) {
    _hasCompletedInitialAuthentication = value;
    notifyListeners();
  }

  /// Set force dashboard navigation state
  void setForceDashboardNavigation(bool value) {
    _shouldForceDashboardNavigation = value;
    notifyListeners();
  }

  /// Set security screen navigation state (legacy)
  void setSecurityScreenNavigated(bool value) {
    _hasNavigatedToSecurityScreen = value;
    notifyListeners();
  }

  // Legacy setters (for backward compatibility)
  void setHasNavigatedToFaceIDPage(bool value) => setSecurityScreenNavigated(value);
  void setJustAuthenticated(bool value) => setJustCompletedAuthentication(value);
  void setInitiallyAuthenticated(bool value) => setInitialAuthenticationCompleted(value);
  void setAppLockEnabled(bool value) => setBiometricSecurityEnabled(value);
  void setSelectedTimeOption(String timeOption) => setSecurityDelayOption(timeOption);
  void setForceDashboard(bool value) => setForceDashboardNavigation(value);
  
  /// Convert time option string to minutes
  double _convertTimeOptionToMinutes(String timeOption) {
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
        return 0.0;
    }
  }
}
