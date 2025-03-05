import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4252C0);

    return Column(
      children: [
        // Logo
        SvgPicture.asset(
          'assets/icons/ARMM_Logo.svg',
          width: 30,
          height: 30,
        ),
        const SizedBox(height: 16),
        // Title
        const Text(
          'Forgot Password?',
          style: TextStyle(
            color: primaryColor,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Subtitle
        const Text(
          'Enter your email. We will email instructions on how to reset your password.',
          style: TextStyle(
            color: Color.fromARGB(219, 0, 0, 0),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}