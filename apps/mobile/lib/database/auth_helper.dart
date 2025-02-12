import 'dart:developer';
<<<<<<< HEAD
import 'dart:io' show Platform;
=======
import 'dart:io';
>>>>>>> 164ecb2 (Add models for Graph, GraphPoint, Activity, and Notif; implement configuration loading and utility functions)
import 'package:armm_app/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD
Future<void> deleteUserInBuffer() async {
  if (FirebaseAuth.instance.currentUser != null) {
    try {
      // await FirebaseAuth.instance.currentUser!.delete();
=======

/// Deletes any user currently in the Firebase Auth buffer.
Future<void> deleteUserInBuffer() async {
  if (FirebaseAuth.instance.currentUser != null) {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
>>>>>>> 164ecb2 (Add models for Graph, GraphPoint, Activity, and Notif; implement configuration loading and utility functions)
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await FirebaseAuth.instance.signOut();
      } else {
        log('Error deleting user: $e', stackTrace: StackTrace.current);
      }
    }
    log('User after delete: ${FirebaseAuth.instance.currentUser ?? 'deleted'}');
  }
}

<<<<<<< HEAD

=======
>>>>>>> 164ecb2 (Add models for Graph, GraphPoint, Activity, and Notif; implement configuration loading and utility functions)
/// Handles FirebaseAuthException and displays an error message.
Future<void> handleFirebaseAuthException(
    BuildContext context, FirebaseAuthException e, String email) async {
  String errorMessage = 'Failed to sign up. Please try again.';
<<<<<<< HEAD
  switch (e.code) {
    case 'email-already-in-use':
=======
  String? temp = FirebaseAuth.instance.currentUser?.email;
  switch (e.code) {
    case 'email-already-in-use':
      if (FirebaseAuth.instance.currentUser?.email == email) {
        await deleteUserInBuffer();
      } 
>>>>>>> 164ecb2 (Add models for Graph, GraphPoint, Activity, and Notif; implement configuration loading and utility functions)
      errorMessage =
          'Email $email is already in use. Please use a different email.';
      break;
    case 'invalid-email':
      errorMessage = '"$email" is not a valid email format. Please try again.';
      log('Invalid email format.');
      break;
    case 'weak-password':
      errorMessage = 'The password provided is too weak.';
      log('Weak password.');
      break;
    default:
      log('FirebaseAuthException: $e');
  }
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
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
}

<<<<<<< HEAD

Future<void> updateFirebaseMessagingToken(User? user, BuildContext context) async {
  if (user == null) return;

  String? token;

  // First, try to fetch the FCM token.
  try {
    token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM token fetched: $token');
  } catch (e) {
    log('Error fetching FCM token: $e');
  }

  // If FCM token isn’t available and the platform is iOS,
  // try to fetch the APNS token with a retry.
  if (token == null && Platform.isIOS) {
    try {
      token = await FirebaseMessaging.instance.getAPNSToken();
      debugPrint('Initial APNS token fetched: $token');
      if (token == null) {
        // Retry after a short delay.
        await Future.delayed(const Duration(seconds: 3));
        token = await FirebaseMessaging.instance.getAPNSToken();
        debugPrint('Retried APNS token fetched: $token');
      }
    } catch (e) {
      log('Error fetching APNS token: $e');
    }
  }

  // Only attempt subscription and update if we got a token.
  if (token != null) {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(user.uid);
      debugPrint('Subscribed to topic: ${user.uid}');
    } catch (e) {
      log('Error subscribing to topic ${user.uid}: $e');
    }

    // Update the token in your database.
    DatabaseService? db = await DatabaseService.fetchCID(user.uid, context);
    if (db != null) {
      try {
        List<dynamic> tokens = (await db.getField('tokens')) ?? [];
        if (!tokens.contains(token)) {
          tokens = [...tokens, token];
          await db.updateField('tokens', tokens);
          debugPrint('Token updated in database: $token');
        } else {
          debugPrint('Token already exists in the database.');
        }
      } catch (e) {
        log('Error updating tokens: $e');
      }
    } else {
      log('DatabaseService instance not found for user ${user.uid}');
    }
  } else {
    log('No messaging token available.');
  }
}




=======
/// Updates Firebase Messaging token.
Future<void> updateFirebaseMessagingToken(User? user, BuildContext context) async {
  if (user == null) {
    return;
  }
  String? token;
  try {
    token = await FirebaseMessaging.instance.getToken();
  } catch (e) {
    log('Error fetching token: $e');
    token = await FirebaseMessaging.instance.getAPNSToken();
    log('APNS Token found: $token');
  }
  if (token != null) {
    // Fetch CID using async constructor
    DatabaseService? db = await DatabaseService.fetchCID(user.uid, context);

    if (db != null) {
    try {
      List<dynamic> tokens =
          (await db.getField('tokens') ?? []);

      if (!tokens.contains(token)) {
        tokens = [...tokens, token];
        await db.updateField('tokens', tokens);
      }
    } catch (e) {
      log('login.dart: Error fetching tokens: $e');
    }
  }
  }// async gap widget mounting check
}

>>>>>>> 164ecb2 (Add models for Graph, GraphPoint, Activity, and Notif; implement configuration loading and utility functions)
/// Deletes the Firebase Messaging token when the user signs out.
Future<void> deleteFirebaseMessagingToken(User? user, BuildContext context) async {
  if (user == null) {
    log('auth_helper.dart: User is null.'); 
    return;
  }
  // Retrieve the current FCM token
  String? token;
  try {
    token = await FirebaseMessaging.instance.getToken();
  } catch (e) {
    log('Error fetching token: $e');
    token = await FirebaseMessaging.instance.getAPNSToken();
    log('APNS Token found: $token');
  }

  if (token != null) {
    // Fetch the DatabaseService instance for the user
    DatabaseService? db = await DatabaseService.fetchCID(user.uid, context);

    if (db != null) {
      try {
        // Retrieve the current list of tokens from Firestore
        List<dynamic> tokens = (await db.getField('tokens')) ?? [];

        if (tokens.contains(token)) {
          // Remove the current token from the list
          tokens.remove(token);

          // Update the tokens field in Firestore
          await db.updateField('tokens', tokens);
          log('Token removed successfully.');
        }
      } catch (e) {
        log('Error deleting token: $e');
      }
    }
  }
}