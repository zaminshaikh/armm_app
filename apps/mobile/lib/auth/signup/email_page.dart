// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:developer';
import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/signup/password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmailPage extends StatefulWidget {
  final String cid;
  String email = '';

  EmailPage({super.key, required this.cid});

  @override
  _EmailPageState createState() => _EmailPageState();
}

const ARMM_Blue = Color(0xFF1C32A4);

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();
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

      // Check if email is already registered
      bool isRegistered = await _isEmailRegistered(email);
      print('isRegistered: $isRegistered');
      if (isRegistered) {
        throw Exception('This email is already registered. Please log in instead.');
      }

      print('Email is valid and not registered');

      // If email is valid and not registered, proceed to password page
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
                  const SizedBox(height: 32),

                  // Email Text Field
                  AuthTextField(
                    hintText: 'Email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 24),

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
                        ),
                  const SizedBox(height: 24),

                  // Already have an account? Log in
                  AuthFooter(
                    primaryColor: ARMM_Blue,
                    onSignUpPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
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