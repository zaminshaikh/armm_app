import 'dart:async';
import 'dart:developer';

import 'package:armm_app/database/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email, 
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password);
    } on FirebaseAuthException catch (e) {
      // Print error details to help diagnose the issue
      print("FirebaseAuthException code: ${e.code}");
      print("FirebaseAuthException message: ${e.message}");
      rethrow;
    } catch (e) {
      print("Unknown error: $e");
      rethrow;
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email, 
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Print error details to help diagnose the issue
      print("FirebaseAuthException code: ${e.code}");
      print("FirebaseAuthException message: ${e.message}");
      rethrow;
    } catch (e) {
      print("Unknown error: $e");
      rethrow;
    }
  }

  Future<void> logout(BuildContext context) async {
    log('settings.dart: Signing out...');

    Future<void> handleLogout() async {
      // Continue sign out asynchronously.
      await deleteFirebaseMessagingToken(FirebaseAuth.instance.currentUser, context);
      await FirebaseAuth.instance.signOut();
      assert(FirebaseAuth.instance.currentUser == null);
      log('settings.dart: Successfully signed out');
      return;
    }
    unawaited(handleLogout());

    if (!context.mounted) return;
    // Immediately navigate away to avoid security rules issues when signed out.
    await Navigator.of(context).pushNamedAndRemoveUntil('/onboarding', (route) => false);

    // Continue sign out asynchronously.
    return;
  } 

}