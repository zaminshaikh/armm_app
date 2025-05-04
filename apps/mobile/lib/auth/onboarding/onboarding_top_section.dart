import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingTopSection extends StatelessWidget {
  const OnboardingTopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        // Logo
        SvgPicture.asset(
          'assets/icons/ARMM_Logo.svg',
          height: 40,
        ),
        const SizedBox(height: 50),
        // Main Heading
        Text(
          'Your Entire Portfolio in One Place',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: const Color(0xFF1C32A4),
              ),
        ),
        const SizedBox(height: 32),
        // Subtitle
        Text(
          'See all your account balances, review transaction\n'
          'history, analyze investment performance, and\n'
          'securely access your statements—right from\n'
          'the palm of your hand',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 13,
              ),
        ),
      ],
    );
  }
}