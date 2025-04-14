import 'package:armm_app/auth/link_sent/link_sent.dart';
import 'package:flutter/material.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;

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
        AuthButton(
          label: 'Submit',
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false, // Prevents dismissal by tapping outside
              barrierColor: Colors.black.withOpacity(0.6),
              builder: (BuildContext context) {
                return CustomAlertDialog(
                  title: 'Link Sent',
                  message: 'We\'ve sent a password reset link to your email address.',
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
          },
          backgroundColor: _isButtonEnabled ? const Color(0xFF2C43D6) : Colors.transparent,
          foregroundColor: _isButtonEnabled ? Colors.white : const Color(0xFFB0B8C7),
          borderColor: _isButtonEnabled ? const Color(0xFF2C43D6) : const Color(0xFFCBD2E0),
          isEnabled: _isButtonEnabled,
        ),
      ],
    );
  }
}