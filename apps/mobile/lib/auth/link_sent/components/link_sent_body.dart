import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LinkSentBody extends StatelessWidget {
  const LinkSentBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4252C0);

    return Column(
      children: [
        // Title
        Text(
          'Link Has Been Sent',
          style: GoogleFonts.inter(
            color: primaryColor,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 15),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'A link to reset your password has been sent to your email.',
            style: GoogleFonts.inter(
              color: const Color.fromARGB(219, 0, 0, 0),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 32),

        // Resend Email Link
        const _ResendEmailLink(),
      ],
    );
  }
}

class _ResendEmailLink extends StatelessWidget {
  const _ResendEmailLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4252C0);

    return Text(
      'Resend Email Link',
      style: GoogleFonts.inter(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      textAlign: TextAlign.center,
    );
  }
}
