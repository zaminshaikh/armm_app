import 'package:flutter/material.dart';

class ForgotPasswordFooter extends StatelessWidget {
  const ForgotPasswordFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4252C0);

    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Back to ',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Add navigation logic if needed
              },
              child: Text(
                'Sign in',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}