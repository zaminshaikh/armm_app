import 'dart:developer';

import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:armm_app/components/custom_progress_indicator.dart';


class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  late Future<bool> _isAuthenticatedAndVerifiedFuture;

  /// Check if the user is authenticated, email verified, and linked
  Future<bool> isAuthenticatedAndVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    await user.reload(); 

    if (!user.emailVerified) {
      return false;
    }

    String uid = user.uid;

    DatabaseService db = DatabaseService(uid);

    bool isLinked = await db.isUIDLinked(uid);

    return isLinked;
  }

  @override
  void initState() {
    super.initState();
    _isAuthenticatedAndVerifiedFuture = isAuthenticatedAndVerified();
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
        return FutureBuilder(
          future: _isAuthenticatedAndVerifiedFuture,
          builder: (context, authSnapshot) {
            log('AuthCheck: Checking if user is authenticated, verified and linked');
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              log('AuthCheck: Waiting for verification check');
              return const CustomProgressIndicator(
                shouldTimeout: true,
              );
            } else if (authSnapshot.hasError) {
              log('AuthCheck: Error in verification check: ${authSnapshot.error}');
              return Center(child: Text('Error: ${authSnapshot.error}'));
            } else if (authSnapshot.hasData && authSnapshot.data == true) {
              // User is authenticated, email verified, and linked
              log('AuthCheck: User is authenticated, email verified, and linked - navigating to Dashboard');
              return const DashboardPage();
            } else {
              // User is not authenticated, email not verified, or not linked
              log('AuthCheck: User is NOT fully verified or linked - navigating to Onboarding');
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