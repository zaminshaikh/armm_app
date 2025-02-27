<<<<<<< HEAD
import 'package:armm_app/auth/auth_utils/initial_face_id.dart';
import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/screens/dashboard/components/dashboard_app_bar.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
=======
import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
>>>>>>> 6091d6a (Add AuthCheck file to manage user authentication and verification flow, triggered on Firebase Auth stream)

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
<<<<<<< HEAD
    final appState = Provider.of<AuthState>(context, listen: false);

=======
>>>>>>> 6091d6a (Add AuthCheck file to manage user authentication and verification flow, triggered on Firebase Auth stream)
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
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
              return const Center(child: CircularProgressIndicator());
            } else if (authSnapshot.hasError) {
              return Center(child: Text('Error: ${authSnapshot.error}'));
            } else if (authSnapshot.hasData && authSnapshot.data == true) {
<<<<<<< HEAD
              if (appState.isAppLockEnabled) {
                // User is authenticated, email verified, and linked
              return const InitialFaceIdPage();
              } else
              return const DashboardPage();
            } else {
              // User is not authenticated, email not verified, or not linked
              return const OnboardingPage();
=======
              // User is authenticated, email verified, and linked
              return const ProfilePage();
            } else {
              // User is not authenticated, email not verified, or not linked
<<<<<<< HEAD
              return OnboardingPage(signUpData: SignUpData());
>>>>>>> 6091d6a (Add AuthCheck file to manage user authentication and verification flow, triggered on Firebase Auth stream)
=======
              return const OnboardingPage();
>>>>>>> dc6fab8 (Remove SignUpData class and update related components to eliminate its usage)
            }
          });
        } else {
          // User is not signed in
<<<<<<< HEAD
<<<<<<< HEAD
          return const OnboardingPage();
        }
      } else {
        return const OnboardingPage();
=======
          return OnboardingPage(signUpData: SignUpData());
        }
      } else {
        return OnboardingPage(signUpData: SignUpData());
>>>>>>> 6091d6a (Add AuthCheck file to manage user authentication and verification flow, triggered on Firebase Auth stream)
=======
          return const OnboardingPage();
        }
      } else {
        return const OnboardingPage();
>>>>>>> dc6fab8 (Remove SignUpData class and update related components to eliminate its usage)
      }
    },
  );
  
}