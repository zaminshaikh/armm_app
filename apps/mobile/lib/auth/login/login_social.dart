import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
import 'package:armm_app/auth/auth_utils/google_auth.dart';
import 'package:armm_app/auth/signup/client_id_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginSocial extends StatelessWidget {
  final Color primaryColor;

  const LoginSocial({
    Key? key,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "or continue with"
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'or continue with',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        // Google button (you can add more: Face ID, Apple, etc.)
        AuthButton(
          label: 'Google',
          icon: SvgPicture.asset(
            'assets/icons/google.svg',
            color: primaryColor,
            height: 24,
          ),
          foregroundColor: primaryColor,
          borderColor: primaryColor,
          onPressed: () {
            GoogleAuthService().signInWithGoogle(context);
          },
        ),
        const SizedBox(height: 32),
        // Sign up row
        AuthFooter(
          primaryColor: primaryColor,
          onSignUpPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClientIDPage(),
              ),
            );
          },
          questionText: 'Don\'t have an account?',
          buttonText: 'Sign Up',
        ),
      ],
    );
  }
}