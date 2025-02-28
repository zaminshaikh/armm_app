import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:shared_preferences/shared_preferences.dart';
=======
>>>>>>> d518e85 (Migrated all cloud functions and added auth functions respectively)
=======
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> 9295e18 (Enhance inactivity timer logic with shared prefs)

class AuthState extends ChangeNotifier {
  bool _hasNavigatedToFaceIDPage = false;
  bool _justAuthenticated = false;
  bool _initiallyAuthenticated = false;
  bool _isAppLockEnabled = false;
  String _selectedTimeOption = '1 minute';
  double _selectedTimeInMinutes = 1.0;

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9295e18 (Enhance inactivity timer logic with shared prefs)
  // Constructor that loads saved settings
  AuthState() {
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _selectedTimeOption = prefs.getString('selectedTimeOption') ?? '1 minute';
      _selectedTimeInMinutes = _getTimeInMinutes(_selectedTimeOption);
      _isAppLockEnabled = prefs.getBool('isAppLockEnabled') ?? false;
      print('AuthState: Loaded settings - option: $_selectedTimeOption, minutes: $_selectedTimeInMinutes, enabled: $_isAppLockEnabled');
      notifyListeners();
    } catch (e) {
      print('AuthState: Error loading settings: $e');
    }
  }

  // Getters
<<<<<<< HEAD
  bool get hasNavigatedToFaceIDPage => _hasNavigatedToFaceIDPage;
  bool get justAuthenticated => _justAuthenticated;
  bool get initiallyAuthenticated => _initiallyAuthenticated;
  bool get isAppLockEnabled => _isAppLockEnabled;
  String get selectedTimeOption => _selectedTimeOption;
=======
  // Getter for _hasNavigatedToFaceIDPage
=======
>>>>>>> 9295e18 (Enhance inactivity timer logic with shared prefs)
  bool get hasNavigatedToFaceIDPage => _hasNavigatedToFaceIDPage;
  bool get justAuthenticated => _justAuthenticated;
  bool get initiallyAuthenticated => _initiallyAuthenticated;
  bool get isAppLockEnabled => _isAppLockEnabled;
  String get selectedTimeOption => _selectedTimeOption;
<<<<<<< HEAD

  // Getter for _selectedTimeInMinutes
>>>>>>> d518e85 (Migrated all cloud functions and added auth functions respectively)
=======
>>>>>>> 9295e18 (Enhance inactivity timer logic with shared prefs)
  double get selectedTimeInMinutes => _selectedTimeInMinutes;

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

<<<<<<< HEAD
<<<<<<< HEAD
  // Setter for _isAppLockEnabled - also saves to SharedPreferences
  void setAppLockEnabled(bool value) async {
    _isAppLockEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAppLockEnabled', value);
    print('AuthState: Saved app lock state: $value');
    notifyListeners();
  }

  // Setter for _selectedTimeOption - also saves to SharedPreferences and updates minutes
  void setSelectedTimeOption(String timeOption) async {
    _selectedTimeOption = timeOption;
    _selectedTimeInMinutes = _getTimeInMinutes(timeOption);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTimeOption', timeOption);
    await prefs.setDouble('selectedTimeInMinutes', _selectedTimeInMinutes);
    print('AuthState: Saved selected time option: $timeOption, minutes: $_selectedTimeInMinutes');
=======
  // Setter for _isAppLockEnabled
  void setAppLockEnabled(bool value) {
=======
  // Setter for _isAppLockEnabled - also saves to SharedPreferences
  void setAppLockEnabled(bool value) async {
>>>>>>> 9295e18 (Enhance inactivity timer logic with shared prefs)
    _isAppLockEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAppLockEnabled', value);
    print('AuthState: Saved app lock state: $value');
    notifyListeners();
  }

  // Setter for _selectedTimeOption - also saves to SharedPreferences and updates minutes
  void setSelectedTimeOption(String timeOption) async {
    _selectedTimeOption = timeOption;
    _selectedTimeInMinutes = _getTimeInMinutes(timeOption);
<<<<<<< HEAD
>>>>>>> d518e85 (Migrated all cloud functions and added auth functions respectively)
=======
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTimeOption', timeOption);
    await prefs.setDouble('selectedTimeInMinutes', _selectedTimeInMinutes);
    print('AuthState: Saved selected time option: $timeOption, minutes: $_selectedTimeInMinutes');
>>>>>>> 9295e18 (Enhance inactivity timer logic with shared prefs)
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
        return 1.0; // Default to 1 minute if none match
    }
  }
}
