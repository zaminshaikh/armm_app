import 'dart:developer';

import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/auth/signup/client_id_page.dart';
import 'package:armm_app/auth/signup/verify_email_page.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/screens/biometric_authentication/biometric_lock_screen.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/screens/profile/pages/authentication_page.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:armm_app/components/custom_progress_indicator.dart';


class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  late Future<Map<String, dynamic>> _authCheckFuture;
  late AuthState _authState;

  @override
  void initState() {
    super.initState();
    _authState = Provider.of<AuthState>(context, listen: false);
    _authCheckFuture = checkAuthAndCID();
  }

  /// Check if the user is authenticated, email verified, and linked
  /// Also check if there's a stored CID in SharedPreferences
  Future<Map<String, dynamic>> checkAuthAndCID() async {
    final result = <String, dynamic>{
      'isAuthenticated': false,
      'isEmailVerified': false,
      'isLinked': false,
      'storedCID': null as String?,
    };
    
    // Check for a stored CID in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final String? storedCID = prefs.getString('cid');
    result['storedCID'] = storedCID;
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return result;
    }

    await user.reload();
    result['isEmailVerified'] = user.emailVerified;
    
    String uid = user.uid;
    DatabaseService db = DatabaseService(uid);
    
    bool isLinked = await db.isUIDLinked(uid);
    result['isLinked'] = isLinked;
    
    result['isAuthenticated'] = true; // User is not null here
    
    log('AuthCheck: checkAuthAndCID result: $result');
    
    return result;
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
    stream: FirebaseAuth.instance.userChanges(),
    builder: (BuildContext context,AsyncSnapshot<User?> snapshot) {
      log('AuthCheck: StreamBuilder executing with state ${snapshot.connectionState}');
      if (snapshot.connectionState == ConnectionState.waiting) {
        log('AuthCheck: Waiting for authentication state');
        return const CustomProgressIndicator(
          shouldTimeout: true,
        );
      } else if (snapshot.hasError) {
        log('AuthCheck: Error in authentication stream: ${snapshot.error}');
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        final user = snapshot.data;
        log('AuthCheck: User data received, user is ${user != null ? "signed in" : "null"}');
        if (user != null) {
        // User is signed in
        return FutureBuilder<Map<String, dynamic>>(
          future: _authCheckFuture,
          builder: (context, authSnapshot) {
            log('AuthCheck: Checking authentication status');
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              log('AuthCheck: Waiting for authentication check');
              return const CustomProgressIndicator(
                shouldTimeout: true,
              );
            } else if (authSnapshot.hasError) {
              log('AuthCheck: Error in authentication check: ${authSnapshot.error}');
              return Center(child: Text('Error: ${authSnapshot.error}'));
            } else if (authSnapshot.hasData) {
              final data = authSnapshot.data!;
              final bool isEmailVerified = data['isEmailVerified'] ?? false;
              final bool isLinked = data['isLinked'] ?? false;
              final String? storedCID = data['storedCID'];
              
              // Case 1: User is fully authenticated (email verified and UID linked)
              if (isEmailVerified && isLinked) {
                log('AuthCheck: User is authenticated, email verified, and linked - navigating to Dashboard');
                // If there's still a storedCID, clean it up since we don't need it anymore
                if (storedCID != null) {
                  SharedPreferences.getInstance().then((prefs) => prefs.remove('cid'));
                }
                if (_authState.isBiometricSecurityEnabled && !_authState.hasAuthenticatedThisSession) {
                  return const BiometricLockScreen();
                }
                return const DashboardPage();
              }
              
              // Case 2: User has a Firebase account, but email not verified yet, and we have a stored CID
              else if (!isEmailVerified && storedCID != null) {
                log('AuthCheck: User has unverified email and stored CID - navigating to VerifyEmailPage');
                return VerifyEmailPage(cid: storedCID);
              }
              
              // Case 3: User's email is verified, not linked, but we have a stored CID
              else if (isEmailVerified && !isLinked && storedCID != null) {
                log('AuthCheck: User has verified email, is not linked, and has stored CID - navigating to VerifyEmailPage to complete linking');
                return VerifyEmailPage(cid: storedCID);
              }
              
              // Case 4: User's email is verified but not linked, and no stored CID
              else if (isEmailVerified && !isLinked && storedCID == null) {
                log('AuthCheck: User has verified email but no CID - navigating to ClientIDPage');
                return const ClientIDPage();
              }
              
              // Default case: Something's incomplete with the signup process
              log('AuthCheck: User exists but authentication flow is incomplete - navigating to Onboarding');
              return const OnboardingPage();
            } else {
              log('AuthCheck: No authentication data available - navigating to Onboarding');
              return const OnboardingPage();
            }
          });
        } else {
          // User is not signed in
          log('AuthCheck: User is not signed in - navigating to Onboarding');
          return const OnboardingPage();
        }
      } else {
        log('AuthCheck: No user data - navigating to Onboarding');
        return const OnboardingPage();
      }
    },
  );
}