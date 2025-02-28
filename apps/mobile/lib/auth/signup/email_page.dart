<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
// ignore_for_file: deprecated_member_use, must_be_immutable
=======
// ignore_for_file: deprecated_member_use
>>>>>>> 93eb816 (Refactor email availability check to clarify registration status and improve error handling)

import 'dart:developer';
=======
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
import 'dart:developer';
>>>>>>> 779a203 (Implement email availability check, Passed on email to password page properly)
import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/signup/password_page.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmailPage extends StatefulWidget {
  final String cid;
  String email = '';

  EmailPage({super.key, required this.cid});
=======
=======
import 'package:armm_app/auth/login/login.dart';
>>>>>>> 3ee0730 (Enhance authentication flow by adding Client ID page routes)
import 'package:armm_app/auth/signup/password_page.dart';
import 'package:armm_app/signup_data.dart';
=======
>>>>>>> dc6fab8 (Remove SignUpData class and update related components to eliminate its usage)
=======
import 'package:firebase_auth/firebase_auth.dart';
>>>>>>> 779a203 (Implement email availability check, Passed on email to password page properly)
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmailPage extends StatefulWidget {
  final String cid;
  String email = '';

<<<<<<< HEAD
  const EmailPage({Key? key, required this.signUpData}) : super(key: key);
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
  EmailPage({super.key, required this.cid});
>>>>>>> dc6fab8 (Remove SignUpData class and update related components to eliminate its usage)

  @override
  _EmailPageState createState() => _EmailPageState();
}

const ARMM_Blue = Color(0xFF1C32A4);

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();
<<<<<<< HEAD
<<<<<<< HEAD
  bool _isLoading = false;

  /// Checks if the email is available (i.e. not registered) in Firebase Auth.
  /// Returns true if the email is NOT registered (available), false if it is registered.
  Future<bool> _isEmailRegistered(String email) async {
    try {
      List<String> signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email);
      print('Sign in methods: $signInMethods');
      print(!signInMethods.isEmpty);
      return !signInMethods.isEmpty;
    } catch (e) {
      log('Error checking email registration: $e');
=======
  bool _isLoading = false;

  /// Checks if the email is available (i.e. not registered) in Firebase Auth.
  /// Returns true if the email is NOT registered (available), false if it is registered.
  Future<bool> _isEmailRegistered(String email) async {
    try {
      List<String> signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email);
      // If signInMethods is empty, the email is not registered => return true.
      // Otherwise, return false.
      return signInMethods.isEmpty;
    } catch (e) {
<<<<<<< HEAD
      log('Error checking email availability: $e');
>>>>>>> 779a203 (Implement email availability check, Passed on email to password page properly)
=======
      log('Error checking email registration: $e');
>>>>>>> 93eb816 (Refactor email availability check to clarify registration status and improve error handling)
      return false;
    }
  }

  /// Handles the continue button press
  Future<void> _handleContinue() async {
    setState(() {
      _isLoading = true;
    });
    final email = _emailController.text.trim();
    widget.email = email;

    try {
      // Check if the email is valid format
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        throw Exception('Please enter a valid email address');
      }

<<<<<<< HEAD
<<<<<<< HEAD
      // Check if email is already registered
      bool isRegistered = await _isEmailRegistered(email);
      print('isRegistered: $isRegistered');
      if (isRegistered) {
        throw Exception('This email is already registered. Please log in instead.');
      }

      print('Email is valid and not registered');

      // If email is valid and not registered, proceed to password page
=======
      // Check if email is available (not already in use)
      bool isAvailable = await _isEmailAvailable(email);
      if (!isAvailable) {
        throw Exception('This email is already registered. Please log in or use a different email.');
      }

      // If email is valid and available, proceed to password page
>>>>>>> 779a203 (Implement email availability check, Passed on email to password page properly)
=======
      // Check if email is already registered
      bool isRegistered = await _isEmailRegistered(email);
      if (isRegistered) {
        throw Exception('This email is already registered. Please log in instead.');
      }

      print('Email is valid and not registered');

      // If email is valid and not registered, proceed to password page
>>>>>>> 93eb816 (Refactor email availability check to clarify registration status and improve error handling)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordPage(
            cid: widget.cid,
            email: email,
          ),
        ),
      );
    } catch (e) {
      // Handle errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text('${e.toString()}'),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Client ID received in EmailPage: ${widget.cid}");
<<<<<<< HEAD
=======

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    print("Client ID received in EmailPage: ${widget.signUpData.cid}"); // DEBUG PRINT
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
    print("Client ID received in EmailPage: ${widget.cid}"); // DEBUG PRINT
>>>>>>> dc6fab8 (Remove SignUpData class and update related components to eliminate its usage)
=======
>>>>>>> 779a203 (Implement email availability check, Passed on email to password page properly)
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  // Top illustration
                  SvgPicture.asset(
                    'assets/icons/email.svg',
                    height: 200,
                  ),
                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    'Next, enter your Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    'Please enter your email address\n'
                    'to continue the registration process',
                    textAlign: TextAlign.center,
                  ),
<<<<<<< HEAD
<<<<<<< HEAD
                  const SizedBox(height: 32),
=======
                  const SizedBox(height: 16),
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
                  const SizedBox(height: 32),
>>>>>>> 3ee0730 (Enhance authentication flow by adding Client ID page routes)

                  // Email Text Field
                  AuthTextField(
                    hintText: 'Email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 24),

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 779a203 (Implement email availability check, Passed on email to password page properly)
                  // Continue Button or CircularProgressIndicator
                  _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ARMM_Blue),
                        )
                      : AuthButton(
                          label: 'Continue',
                          onPressed: _handleContinue,
                          backgroundColor: ARMM_Blue,
                          foregroundColor: Colors.white,
<<<<<<< HEAD
                        ),
=======
                  // Continue Button
                  AuthButton(
                    label: 'Continue',
                    onPressed: () {
                      widget.email = _emailController.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PasswordPage(cid: widget.cid, email: widget.email),
                        ),
                      );
                    },
                    backgroundColor: ARMM_Blue,
                    foregroundColor: Colors.white,
                  ),
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
                        ),
>>>>>>> 779a203 (Implement email availability check, Passed on email to password page properly)
                  const SizedBox(height: 24),

                  // Already have an account? Log in
                  AuthFooter(
                    primaryColor: ARMM_Blue,
                    onSignUpPressed: () {
<<<<<<< HEAD
<<<<<<< HEAD
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
=======
                      // Navigate to login
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
>>>>>>> 3ee0730 (Enhance authentication flow by adding Client ID page routes)
                    },
                    questionText: 'Already have an account?',
                    buttonText: 'Log in',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          AuthBack(onBackPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}