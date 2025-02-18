<<<<<<< HEAD
import 'dart:developer';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/forgot_password/forgot_password.dart';
=======
<<<<<<< HEAD:apps/mobile/lib/screens/login/login_form.dart
import 'package:flutter/material.dart';
import 'package:armm_app/screens/forgot_password/forgot_password.dart';
=======
import 'dart:developer';

import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:armm_app/database/auth_helper.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/forgot_password/forgot_password.dart';
import 'package:armm_app/auth/signup/password_page.dart';
import 'package:armm_app/auth/auth_utils/auth_functions.dart';
import 'package:armm_app/signup_data.dart';
>>>>>>> 07991de (Fixed UI of all Auth pages)
import 'package:armm_app/utils/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
=======
>>>>>>> d518e85 (Migrated all cloud functions and added auth functions respectively):apps/mobile/lib/screens/auth/login/login_form.dart
>>>>>>> 07991de (Fixed UI of all Auth pages)

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

<<<<<<< HEAD
=======
<<<<<<< HEAD:apps/mobile/lib/screens/login/login_form.dart
=======
>>>>>>> 07991de (Fixed UI of all Auth pages)
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
<<<<<<< HEAD
<<<<<<< HEAD
        MaterialPageRoute(builder: (_) => const ProfilePage()),
=======
        MaterialPageRoute(builder: (_) => ClientInfoPage(cid: "")),
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
        MaterialPageRoute(builder: (_) => ProfilePage(cid: "")),
>>>>>>> 05a2cb1 (Profile Page UI Elements Have Been Added)
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

<<<<<<< HEAD
=======

>>>>>>> d518e85 (Migrated all cloud functions and added auth functions respectively):apps/mobile/lib/screens/auth/login/login_form.dart
>>>>>>> 07991de (Fixed UI of all Auth pages)
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email TextField
<<<<<<< HEAD
=======
<<<<<<<< HEAD:apps/mobile/lib/screens/login/login_form.dart
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            filled: true,
            fillColor: const Color(0xFFF0F0F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Password TextField
        TextField(
========
>>>>>>> 07991de (Fixed UI of all Auth pages)
        AuthTextField(hintText: 'Email', controller: emailController),
        const SizedBox(height: 5),
        // Password TextField with toggle visibility
        AuthTextField(
          hintText: 'Password',
<<<<<<< HEAD
=======
>>>>>>>> 07991de (Fixed UI of all Auth pages):apps/mobile/lib/auth/login/login_form.dart
>>>>>>> 07991de (Fixed UI of all Auth pages)
          controller: passwordController,
          obscureText: obscurePassword,
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        // Log In button
<<<<<<< HEAD
=======
<<<<<<<< HEAD:apps/mobile/lib/screens/login/login_form.dart
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
<<<<<<< HEAD:apps/mobile/lib/screens/login/login_form.dart
            onPressed: () {
              // TODO: Handle Log In
            },
=======
            onPressed: () => signUserIn(context),
>>>>>>> d518e85 (Migrated all cloud functions and added auth functions respectively):apps/mobile/lib/screens/auth/login/login_form.dart
            child: const Text(
              'Log in',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
========
>>>>>>> 07991de (Fixed UI of all Auth pages)
        AuthButton(
          label: 'Log in',
          onPressed: () => signUserIn(context),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
<<<<<<< HEAD
        ),
        const SizedBox(height: 16),
        // Forgot Password button
=======
>>>>>>>> 07991de (Fixed UI of all Auth pages):apps/mobile/lib/auth/login/login_form.dart
        ),
        const SizedBox(height: 16),
        // Forgot Password?
>>>>>>> 07991de (Fixed UI of all Auth pages)
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