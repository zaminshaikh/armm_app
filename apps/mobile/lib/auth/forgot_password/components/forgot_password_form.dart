import 'dart:developer';
import 'package:armm_app/auth/link_sent/link_sent.dart';
import 'package:flutter/material.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    final isValidEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    setState(() {
      _isButtonEnabled = isValidEmail;
    });
  }

  // Send password reset email using Firebase Auth
  Future<void> _sendPasswordResetEmail() async {
    if (!_isButtonEnabled) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      
      if (!mounted) return;
      
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.6),
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Link Sent',
            message: 'We\'ve sent a password reset link to your email address.',
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to login page
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase errors
      String errorMessage = 'An error occurred. Please try again.';
      
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email address.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
      }
      
      log('Password reset error: ${e.code}');
      
      if (!mounted) return;
      
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Error',
            message: errorMessage,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      log('Unexpected error during password reset: $e');
      
      if (!mounted) return;
      
      // Show generic error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Error',
            message: 'An unexpected error occurred. Please try again.',
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email TextField
        AuthTextField(
          hintText: 'Email',
          controller: _emailController,
        ),
        const SizedBox(height: 24),
        // Submit Button
        _isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2C43D6)),
              )
            : AuthButton(
                label: 'Submit',
                onPressed: _sendPasswordResetEmail,
                backgroundColor: _isButtonEnabled ? const Color(0xFF2C43D6) : Colors.transparent,
                foregroundColor: _isButtonEnabled ? Colors.white : const Color(0xFFB0B8C7),
                borderColor: _isButtonEnabled ? const Color(0xFF2C43D6) : const Color(0xFFCBD2E0),
                isEnabled: _isButtonEnabled,
              ),
      ],
    );
  }
}