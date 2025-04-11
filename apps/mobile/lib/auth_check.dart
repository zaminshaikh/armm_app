import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: SpinKitFoldingCube(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ));
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        final user = snapshot.data;
        if (user != null) {
        // User is signed in
        return FutureBuilder(
          future: _isAuthenticatedAndVerifiedFuture,
          builder:  (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: SpinKitFoldingCube(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ));
            } else if (authSnapshot.hasError) {
              return Center(child: Text('Error: ${authSnapshot.error}'));
            } else if (authSnapshot.hasData && authSnapshot.data == true) {
              // User is authenticated, email verified, and linked
              return const DashboardPage();
            } else {
              // User is not authenticated, email not verified, or not linked
              return const OnboardingPage();
            }
          });
        } else {
          // User is not signed in
          return const OnboardingPage();
        }
      } else {
        return const OnboardingPage();
      }
    },
  );
  
}