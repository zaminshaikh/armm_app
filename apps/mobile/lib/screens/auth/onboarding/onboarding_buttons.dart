import 'package:armm_app/screens/auth/login/login.dart';
import 'package:armm_app/screens/auth/signup/client_id_page.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/material.dart';

/// Stateless version
class OnboardingButtons extends StatelessWidget {
  final SignUpData signUpData;

  const OnboardingButtons({Key? key, required this.signUpData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sign Up (filled) button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1C32A4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClientIDPage()),
              );
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Log In (outlined) button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1C32A4),
              side: const BorderSide(color: Color(0xFF1C32A4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage(signUpData: signUpData)),
              );
            },
            child: const Text(
              'Log In',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

/// Stateful version
class OnboardingButtonsStateful extends StatefulWidget {
  final SignUpData signUpData;

  const OnboardingButtonsStateful({Key? key, required this.signUpData}) : super(key: key);

  @override
  _OnboardingButtonsStatefulState createState() => _OnboardingButtonsStatefulState();
}

class _OnboardingButtonsStatefulState extends State<OnboardingButtonsStateful> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sign Up (filled) button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1C32A4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClientIDPage()),
              );
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Log In (outlined) button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1C32A4),
              side: const BorderSide(color: Color(0xFF1C32A4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage(signUpData: widget.signUpData)),
              );
            },
            child: const Text(
              'Log In',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}