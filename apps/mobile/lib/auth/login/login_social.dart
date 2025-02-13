import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
<<<<<<< HEAD
import 'package:armm_app/auth/auth_utils/google_auth.dart';
import 'package:armm_app/auth/signup/client_id_page.dart';
=======
>>>>>>> 07991de (Fixed UI of all Auth pages)
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
<<<<<<< HEAD
        const Row(
          children: [
=======
        Row(
          children: const [
>>>>>>> 07991de (Fixed UI of all Auth pages)
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
<<<<<<< HEAD
            GoogleAuthService().signInWithGoogle(context);
=======
            // TODO: Handle Google sign-in
>>>>>>> 07991de (Fixed UI of all Auth pages)
          },
        ),
        const SizedBox(height: 32),
        // Sign up row
        AuthFooter(
          primaryColor: primaryColor,
          onSignUpPressed: () {
<<<<<<< HEAD
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ClientIDPage(),
              ),
            );
=======
            // TODO: Navigate to Sign Up screen
>>>>>>> 07991de (Fixed UI of all Auth pages)
          },
          questionText: 'Don\'t have an account?',
          buttonText: 'Sign Up',
        ),
      ],
    );
  }
}