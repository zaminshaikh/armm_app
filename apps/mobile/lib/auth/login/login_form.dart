import 'dart:developer';

import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/components/custom_progress_indicator.dart';
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
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool obscurePassword;
  final Color primaryColor;
  final VoidCallback onTogglePassword;
  bool isLoading;

  LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.obscurePassword,
    required this.primaryColor,
    required this.onTogglePassword,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isEmailValid = false;
  bool isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    // Check initial values
    validateEmail(widget.emailController.text);
    validatePassword(widget.passwordController.text);
  }
  
  @override
  void dispose() {
    // No need to dispose controllers here as they are managed by the parent
    super.dispose();
  }

  void validateEmail(String email) {
    // Simple email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      isEmailValid = emailRegex.hasMatch(email);
    });
  }

  void validatePassword(String password) {
    setState(() {
      isPasswordValid = password.isNotEmpty;
    });
  }

  // Sign user in method
  Future<bool> signUserIn(BuildContext context) async {
    // Save credentials to autofill service
    TextInput.finishAutofillContext();
    
    setState(() {
      widget.isLoading = true;
    });

    log('login.dart: Attempting to sign user in...'); // Debugging output
    try {
      log('login.dart: Calling FirebaseAuth to sign in with email and password...'); // Debugging output
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.emailController.text,
        password: widget.passwordController.text,
      );
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('notifsSwitchValue') ?? false) {
        log('login.dart: Notifications switch is ON, updating Firebase token...'); // Debugging output
        await updateFirebaseMessagingToken(userCredential.user, context);
      } else {
        log('login.dart: Notifications switch is OFF, not updating Firebase token...'); // Debugging output
      }

      // Set initiallyAuthenticated to true
      Provider.of<AuthState>(context, listen: false)
          .setInitiallyAuthenticated(true);

      // Set isLoading to false before navigation
      if (mounted) {
        setState(() {
          widget.isLoading = false;
        });
      }

      // Navigate to the dashboard
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      log('login.dart: Caught FirebaseAuthException: $e'); // Debugging output
      String errorMessage = '';
      
      switch (e.code) {
      case 'user-not-found':
        errorMessage = 'Email not found. Please check your email or sign up for a new account.';
        break;
      case 'wrong-password':
        errorMessage = 'Incorrect password. Please try again or reset your password.';
        break;
      case 'invalid-email':
        errorMessage = 'The email address is badly formatted.';
        break;
      case 'user-disabled':
        errorMessage = 'This user account has been disabled.';
        break;
      case 'too-many-requests':
        errorMessage = 'Too many failed login attempts. Please try again later.';
        break;
      case 'network-request-failed':
        errorMessage = 'Network error. Please check your internet connection and try again.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'This sign-in method is not allowed. Please contact support.';
        break;
      case 'invalid-credential':
        errorMessage = 'The credentials provided are invalid. Please try again.';
        break;
      case 'account-exists-with-different-credential':
        errorMessage = 'An account already exists with the same email but different sign-in credentials.';
        break;
      case 'user-token-expired':
        errorMessage = 'Your session has expired. Please sign in again.';
        break;
      default:
        errorMessage = 'Error signing in. Please check your email and password.';
        break;
      }
      
      log('login.dart: Error: $errorMessage'); // Debugging output
      log('login.dart: Showing error dialog...'); // Debugging output
      
      await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
        title: 'Error logging in',
        message: errorMessage,
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
    } finally {
      if (mounted) {
        setState(() {
          widget.isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AutofillGroup(
          child: Column(
            children: [
              // Email TextField
            AuthTextField(
              hintText: 'Email', 
              controller: widget.emailController,
              focusNode: widget.emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              onSubmitted: (_) => widget.passwordFocusNode.requestFocus(),
              onChanged: (value) => validateEmail(value),
            ),
            const SizedBox(height: 5),
            // Password TextField with toggle visibility
            AuthTextField(
              hintText: 'Password',
              controller: widget.passwordController,
              focusNode: widget.passwordFocusNode,
              obscureText: widget.obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onSubmitted: (_) => signUserIn(context),
              onChanged: (value) => validatePassword(value),
            ),
            const SizedBox(height: 12), // Reduced from 16
            // Log In button
            AuthButton(
              label: 'Log in',
              onPressed: () => signUserIn(context),
              backgroundColor: widget.primaryColor,
              foregroundColor: Colors.white,
              isEnabled: isEmailValid && isPasswordValid,
            ),
            const SizedBox(height: 12), // Reduced from 16
            // Forgot Password button
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                  );
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.inter(
                    color: widget.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        ),
      ],
    );
  }
}