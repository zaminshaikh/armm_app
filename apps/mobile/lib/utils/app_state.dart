import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends ChangeNotifier {
  bool _hasNavigatedToFaceIDPage = false;
  bool _justAuthenticated = false;
  bool _initiallyAuthenticated = false;
  bool _isAppLockEnabled = false;
  String _selectedTimeOption = 'Immediately'; 
  double _selectedTimeInMinutes = 0.0; 
  bool _forceDashboard = false;

  // Getter for _hasNavigatedToFaceIDPage
  bool get hasNavigatedToFaceIDPage => _hasNavigatedToFaceIDPage;

  // Getter for _justAuthenticated
  bool get justAuthenticated => _justAuthenticated;

  // Getter for _initiallyAuthenticated
  bool get initiallyAuthenticated => _initiallyAuthenticated;

  // Getter for _isAppLockEnabled
  bool get isAppLockEnabled => _isAppLockEnabled;

  // Getter for _selectedTimeOption
  String get selectedTimeOption => _selectedTimeOption;

  // Getter for _selectedTimeInMinutes
  double get selectedTimeInMinutes => _selectedTimeInMinutes;

  // Getter for _forceDashboard
  bool get forceDashboard => _forceDashboard;

  // Load saved settings from SharedPreferences
  Future<void> loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load app lock state
    final isEnabled = prefs.getBool('isAppLockEnabled') ?? false;
    _isAppLockEnabled = isEnabled;
    
    // Load selected time option
    final timeOption = prefs.getString('selectedTimeOption') ?? 'Immediately';
    _selectedTimeOption = timeOption;
    _selectedTimeInMinutes = _getTimeInMinutes(timeOption);
    
    notifyListeners();
  }

  // Setter for _hasNavigatedToFaceIDPage
  void setHasNavigatedToFaceIDPage(bool value) {
    _hasNavigatedToFaceIDPage = value;
    notifyListeners();
  }

  // Setter for _justAuthenticated
  void setJustAuthenticated(bool value) {
    _justAuthenticated = value;
    notifyListeners();
  }

  // Setter for _initiallyAuthenticated
  void setInitiallyAuthenticated(bool value) {
    _initiallyAuthenticated = value;
    notifyListeners();
  }

  // Setter for _isAppLockEnabled
  void setAppLockEnabled(bool value) {
    _isAppLockEnabled = value;
    notifyListeners();
  }

  // Setter for _selectedTimeOption
  void setSelectedTimeOption(String timeOption) {
    _selectedTimeOption = timeOption;
    _selectedTimeInMinutes = _getTimeInMinutes(timeOption);
    notifyListeners();
  }

  // Setter for _forceDashboard
  void setForceDashboard(bool value) {
    _forceDashboard = value;
    notifyListeners();
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
        return 0.0;
    }
  }
}
