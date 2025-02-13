import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/signup/client_id_page.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/material.dart';

/// Stateless version
class AuthButtons extends StatelessWidget {
  final SignUpData signUpData;

  const AuthButtons({Key? key, required this.signUpData}) : super(key: key);

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
class AuthButtonsStateful extends StatefulWidget {
  final SignUpData signUpData;

  const AuthButtonsStateful({Key? key, required this.signUpData}) : super(key: key);

  @override
  _AuthButtonsStatefulState createState() => _AuthButtonsStatefulState();
}

class _AuthButtonsStatefulState extends State<AuthButtonsStateful> {
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