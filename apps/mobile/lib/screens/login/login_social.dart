import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginSocial extends StatelessWidget {
  final Color primaryColor;

  const LoginSocial({
    Key? key,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "or continue with"
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'or continue with',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        // Google button (you can add more: Face ID, Apple, etc.)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // TODO: Handle Google sign-in
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/google.svg',
                      color: primaryColor,
                      height: 24,
                    ),
                    const SizedBox(width: 18),
                    Text(
                      'Google',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // Sign up row
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Do not have an account?',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to Sign Up screen
              },
              child: Text(
                'Sign up',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}