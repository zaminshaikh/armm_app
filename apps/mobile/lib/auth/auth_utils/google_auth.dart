// ignore_for_file: use_build_context_synchronously


import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/signup/profile_picture_page.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:armm_app/database/auth_helper.dart';
import 'package:armm_app/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For Navigator

bool showAlert = false;

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    debugPrint('GoogleAuthService: Starting Google sign-in process.');

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        debugPrint('GoogleAuthService: Google sign-in aborted by user.');
        return null;
      }
      debugPrint('GoogleAuthService: Google sign-in successful.');

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      debugPrint('GoogleAuthService: Google authentication obtained.');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      debugPrint('GoogleAuthService: Firebase credential created.');

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      debugPrint('GoogleAuthService: Firebase sign-in successful.');

      // Check if the uid exists in Firestore
      final User? user = userCredential.user;
      if (user != null) {
        final DatabaseService? db = await DatabaseService.fetchCID(user.uid, context);
        if (db == null) {
          debugPrint(
              'GoogleAuthService: UID does not exist in Firestore. Deleting UID and redirecting to login.');

          showAlert = true;
          await showGoogleFailAlert(context);
          return null;
        }
      } else {
        debugPrint(
            'GoogleAuthService: User UID is null. Redirecting to login.');
        showAlert = true;
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        return null;
      }
          
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('notifsSwitchValue') ?? false) {
        debugPrint('login.dart: Notifications switch is ON, updating Firebase token...'); // Debugging output
        await updateFirebaseMessagingToken(userCredential.user, context);
      } else {
        debugPrint('login.dart: Notifications switch is OFF, not updating Firebase token...'); // Debugging output
      }

      // Navigate to Dashboard
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );

      return userCredential;
    } catch (e) {
      debugPrint('GoogleAuthService: Error during Google sign-in: $e');
      rethrow;
    }
  }

  Future<bool> showGoogleFailAlert(context) async {
    if (showAlert) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Google Sign-In Failed',
            message: 'The Gmail Account you tried to sign in with has not been registered with the app yet. Please try again or sign in with your email and password.',
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  Future<bool> showGoogleSignUpFailAlert(context, String message) async {
    if (showAlert) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Google Sign-In Failed',
            message: message,
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  Future<bool> wrongCIDFailAlert(context) async {
    if (showAlert) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Google Sign-Up Failed',
            message: 'The CID you entered does not exist. Please try again with a valid CID.',
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  Future<UserCredential?> signUpWithGoogle(
      BuildContext context, String cid) async {
    // Log the start of the Google sign-up process
    debugPrint('GoogleAuthService: Starting Google sign-up process.');

    try {
      // Attempt to sign in with Google
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        // If the user aborts the sign-in process, log it and return null
        debugPrint('GoogleAuthService: Google sign-up aborted by user.');
        return null;
      }
      // Log successful Google sign-in
      debugPrint('GoogleAuthService: Google sign-up successful.');

      // Obtain Google authentication details
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      // Log that Google authentication details have been obtained
      debugPrint('GoogleAuthService: Google authentication obtained.');

      // Create a credential for Firebase authentication using the Google authentication details
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      // Log that the Firebase credential has been created
      debugPrint('GoogleAuthService: Firebase credential created.');

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      // Log successful Firebase sign-in
      debugPrint('GoogleAuthService: Firebase sign-up successful.');

      // Get the user from the user credential
      final User? user = userCredential.user;
      if (user != null) {
        // Log the user's UID
        debugPrint('GoogleAuthService: User UID: ${user.uid}');
        final DatabaseService db = DatabaseService.withCID(user.uid, cid);

        // Check 1: Is this Google UID already linked to any profile?
        bool isGoogleUIDAlreadyLinked = await db.isUIDLinked(user.uid);
        if (isGoogleUIDAlreadyLinked) {
          showAlert = true;
          await showGoogleSignUpFailAlert(context,
              'This Google account is already associated with a user profile. Please try logging in or use a different Google account.');
          return null;
        }

        // Check 2: Does the target CID document exist?
        bool targetCIDExists = await db.checkDocumentExists(cid);
        if (!targetCIDExists) {
          showAlert = true;
          await wrongCIDFailAlert(context); // Shows: "The CID you entered does not exist..."
          return null;
        }

        // Check 3: Is the target CID document already linked (to a different UID, since we passed Check 1)?
        bool targetCIDLinked = await db.checkDocumentLinked(cid);
        if (targetCIDLinked) {
          showAlert = true;
          await showGoogleSignUpFailAlert(context,
              'The user profile ID ($cid) is already linked to a different account. Please choose another profile ID or contact support.');
          return null;
        }

        // All client-side checks passed. Proceed to attempt linking.
        // linkNewUser cloud function will perform the final authoritative checks.
        try {
          debugPrint('Attempting to link Google user ${user.uid} to CID: $cid');
          await db.linkNewUser(user.email!);
          await updateFirebaseMessagingToken(user, context);
        } catch (e) {
          // If there is an error adding the new user to Firestore, log the error and show an alert
          debugPrint('Error adding new user to Firestore: $e');
          showAlert = true;
          await showGoogleSignUpFailAlert(context, e.toString());
          return null;
        }
      } else {
        // If the user UID is null, log it and redirect to the login page
        debugPrint(
            'GoogleAuthService: User UID is null. Redirecting to login.');
        showAlert = true;
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  const LoginPage()),
        );
        return null;
      }

      // Navigate to the ProfilePicturePage to continue onboarding
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePicturePage(
            cid: cid,
            email: user.email ?? '',
          ),
        ),
      );

      // Return the user credential
      return userCredential;
    } catch (e) {
      // If there is an error during the Google sign-up process, log the error and rethrow it
      debugPrint('GoogleAuthService: Error during Google sign-up: $e');
    rethrow;
    }
  }

  Future<void> signOut() async {
    debugPrint('GoogleAuthService: Starting sign-out process.');

    try {
      await _googleSignIn.signOut();
      debugPrint('GoogleAuthService: Google sign-out successful.');

      await _auth.signOut();
      debugPrint('GoogleAuthService: Firebase sign-out successful.');
    } catch (e) {
      debugPrint('GoogleAuthService: Error during sign-out: $e');
      rethrow;
    }
  }
}
