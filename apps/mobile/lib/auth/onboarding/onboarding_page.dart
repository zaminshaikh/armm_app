import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'onboarding_top_section.dart';
import 'onboarding_buttons.dart';

class OnboardingPage extends StatefulWidget {

<<<<<<< HEAD
<<<<<<< HEAD
  const OnboardingPage({super.key});
=======
  const OnboardingPage({super.key, required this.signUpData});
>>>>>>> b8ff76d (Refactor code to use 'const' constructors for improved performance and consistency)
=======
  const OnboardingPage({super.key});
>>>>>>> dc6fab8 (Remove SignUpData class and update related components to eliminate its usage)

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
<<<<<<< HEAD
<<<<<<< HEAD
              const AuthButtons(),
=======
              AuthButtons(signUpData: widget.signUpData),
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
              const AuthButtons(),
>>>>>>> dc6fab8 (Remove SignUpData class and update related components to eliminate its usage)
            ],
          ),
        ),
      ),
    );
  }
}