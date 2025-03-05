import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'onboarding_top_section.dart';
import 'onboarding_buttons.dart';

class OnboardingPage extends StatefulWidget {

  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // The top portion with logo, heading, subtitle, etc.
              const OnboardingTopSection(),
              const Spacer(),
              // Illustration
              SvgPicture.asset(
                'assets/icons/onboarding.svg',
                width: 300,
                height: 200,
              ),
              const Spacer(),
              // The bottom portion with Sign Up & Log In buttons
              const AuthButtons(),
            ],
          ),
        ),
      ),
    );
  }
}