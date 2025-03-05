import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  final Color primaryColor;
  final VoidCallback onSignUpPressed;
  final String questionText;
  final String buttonText;

  const AuthFooter({
    Key? key,
    required this.primaryColor,
    required this.onSignUpPressed,
    this.questionText = 'Do not have an account?',
    this.buttonText = 'Sign up',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          questionText,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        TextButton(
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: onSignUpPressed,
          child: Text(
            buttonText,
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}