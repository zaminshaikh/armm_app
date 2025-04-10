import 'dart:developer';

import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:armm_app/database/auth_helper.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/forgot_password/forgot_password.dart';
import 'package:armm_app/auth/signup/password_page.dart';
import 'package:armm_app/auth/auth_utils/auth_functions.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final Color primaryColor;
  final VoidCallback onTogglePassword;

  const LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.primaryColor,
    required this.onTogglePassword,
  }) : super(key: key);

  // Sign user in method
  Future<bool> signUserIn(BuildContext context) async {
    log('login.dart: Attempting to sign user in...'); // Debugging output
    try {
      log('login.dart: Calling FirebaseAuth to sign in with email and password...'); // Debugging output
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // await updateFirebaseMessagingToken(userCredential.user, context);
      log('login.dart: Signed in user ${userCredential.user!.uid}'); // Debugging output
      log('login.dart: Sign in successful, proceeding to dashboard...'); // Debugging output

      // Set initiallyAuthenticated to true
      Provider.of<AuthState>(context, listen: false)
          .setInitiallyAuthenticated(true);

      // Navigate to the dashboard
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      log('login.dart: Caught FirebaseAuthException: $e'); // Debugging output
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage =
            'Email not found. Please check your email or sign up for a new account.';
        log('login.dart: Error: $errorMessage'); // Debugging output
      } else {
        errorMessage =
            'Error signing in. Please check your email and password. $e';
        log('login.dart: Error: $errorMessage'); // Debugging output
      }
      log('login.dart: Showing error dialog...'); // Debugging output
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
        title: const Text('Error logging in'),
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
      log('login.dart: Error dialog shown, returning false...'); // Debugging output
      return false;
    } catch (e) {
      log('login.dart: An unexpected error occurred: $e'); // Debugging output for any other exceptions
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email TextField
        AuthTextField(hintText: 'Email', controller: emailController),
        const SizedBox(height: 5),
        // Password TextField with toggle visibility
        AuthTextField(
          hintText: 'Password',
          controller: passwordController,
          obscureText: obscurePassword,
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        // Log In button
        AuthButton(
          label: 'Log in',
          onPressed: () => signUserIn(context),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        const SizedBox(height: 16),
        // Forgot Password button
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
              );
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}