import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/forgot_password_header.dart';
import 'components/forgot_password_form.dart';
import 'components/forgot_password_footer.dart';
import 'components/forgot_password_illustration.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black38),
                    SizedBox(width: 4),
                    Text(
                      'Back',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const ForgotPasswordIllustration(),
              const SizedBox(height: 10),
              Text(
                'Forgot Password?',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter your email. We will email instructions on how to reset your password.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              const ForgotPasswordForm(),
              const Spacer(),
              const ForgotPasswordFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}