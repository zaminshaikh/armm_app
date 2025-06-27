/// Application Routes Configuration
/// 
/// Defines all available routes for the application

import 'package:armm_app/auth/forgot_password/forgot_password.dart';
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/auth_check.dart';
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
import 'package:flutter/material.dart';

class AppRoutes {
  /// Map of available routes in the application
  static Map<String, WidgetBuilder> get routes => {
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
  };
}