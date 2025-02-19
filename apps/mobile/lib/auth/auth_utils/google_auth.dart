// ignore_for_file: use_build_context_synchronously


import 'package:armm_app/auth/login/login.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/database/auth_helper.dart';
import 'package:armm_app/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
=======
import 'package:armm_app/client_info.dart';
=======
import 'package:armm_app/profile.dart';
>>>>>>> 05a2cb1 (Profile Page UI Elements Have Been Added)
=======
import 'package:armm_app/screens/profile/profile.dart';
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
import 'package:armm_app/database/auth_helper.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/signup_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
>>>>>>> b41e58d (Added google auth functions)
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart'; // For Navigator

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
<<<<<<< HEAD
          MaterialPageRoute(builder: (context) => const LoginPage()),
=======
          MaterialPageRoute(builder: (context) => LoginPage(signUpData: SignUpData())),
>>>>>>> b41e58d (Added google auth functions)
        );
        return null;
      }
          
      await updateFirebaseMessagingToken(user, context);

      // Navigate to Dashboard
      await Navigator.pushReplacement(
        context,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        MaterialPageRoute(builder: (context) => const DashboardPage()),
=======
        MaterialPageRoute(builder: (context) => const ClientInfoPage(cid: '12345678',)),
>>>>>>> b41e58d (Added google auth functions)
=======
        MaterialPageRoute(builder: (context) => const ProfilePage(cid: '12345678',)),
>>>>>>> 05a2cb1 (Profile Page UI Elements Have Been Added)
=======
        MaterialPageRoute(builder: (context) => const ProfilePage()),
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
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
          return AlertDialog(
        title: const Text('Google Sign-In Failed'),
        content: const Text(
            'The Gmail Account you tried to sign in with has not been registered with the app yet. Please try again or sign in with your email and password.'),
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
          return AlertDialog(
        title: const Text('Google Sign-In Failed'),
        content: Text(message),
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
          return AlertDialog(
        title: const Text('Google Sign-Up Failed'),
        content: const Text(
            'The CID you entered does not exist. Please try again with a valid CID.'),
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
        // Check if the user exists in Firestore by fetching the CID
        final DatabaseService db = DatabaseService.withCID(user.uid, cid);

<<<<<<< HEAD
<<<<<<< HEAD
        bool uidLinked = await db.isUIDLinked(user.uid);
        bool docExists = await db.checkDocumentExists(cid);
        bool docLinked = await db.checkDocumentLinked(cid);
=======
        bool uidLinked = await db.f_isUIDLinked(user.uid);
        bool docExists = await db.f_checkDocumentExists(cid);
        bool docLinked = await db.f_checkDocumentLinked(cid);
>>>>>>> b41e58d (Added google auth functions)
=======
        bool uidLinked = await db.isUIDLinked(user.uid);
        bool docExists = await db.checkDocumentExists(cid);
        bool docLinked = await db.checkDocumentLinked(cid);
>>>>>>> b8aafa4 (Refactor authentication utility methods to remove 'f_' prefix for consistency)

        // Check if CID exists and is not linked.
        if (uidLinked && docExists && !docLinked) {
          showAlert = true;
          await showGoogleSignUpFailAlert(context,
              'Email ${user.email} is already associated with a different account. Please log in instead.');
          return null;
        } else if (!docExists) {
          showAlert = true;
          await wrongCIDFailAlert(context);
          return null;
        } else if (docLinked) {
          showAlert = true;
          await showGoogleSignUpFailAlert(context,
              'User already exists for given Client ID $cid. Please log in instead.');
          return null;
        }
        // If the user does not exist in Firestore, log it and create a new user

        try {
          // Add the new user to Firestore with the provided CID
          debugPrint('cid: $cid');
<<<<<<< HEAD
<<<<<<< HEAD
          await db.linkNewUser(user.email!);
=======
          await db.f_linkNewUser(user.email!);
>>>>>>> b41e58d (Added google auth functions)
=======
          await db.linkNewUser(user.email!);
>>>>>>> b8aafa4 (Refactor authentication utility methods to remove 'f_' prefix for consistency)
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
<<<<<<< HEAD
          MaterialPageRoute(builder: (context) =>  const LoginPage()),
=======
          MaterialPageRoute(builder: (context) =>  LoginPage(signUpData: SignUpData())),
>>>>>>> b41e58d (Added google auth functions)
        );
        return null;
      }

      // Navigate to the Dashboard page
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
              const DashboardPage(),
=======
              ClientInfoPage(cid: cid),
>>>>>>> b41e58d (Added google auth functions)
=======
              ProfilePage(cid: cid),
>>>>>>> 05a2cb1 (Profile Page UI Elements Have Been Added)
=======
              ProfilePage(),
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              child,
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
