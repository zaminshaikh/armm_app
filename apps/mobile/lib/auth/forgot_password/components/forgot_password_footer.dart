import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordFooter extends StatelessWidget {
  const ForgotPasswordFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2C43D6);

    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Back to ',
              style: GoogleFonts.inter(
                color: Colors.black45,
                fontSize: 16, // Increased font size
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate back to login screen
              },
              child: Text(
                'Log in',
                style: GoogleFonts.inter(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16, // Increased font size
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}