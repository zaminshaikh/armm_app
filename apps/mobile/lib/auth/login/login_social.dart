import 'package:armm_app/auth/auth_utils/apple_auth.dart';
import 'package:armm_app/auth/auth_utils/google_auth.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
import 'package:armm_app/auth/auth_utils/social_tile.dart';
import 'package:armm_app/auth/signup/client_id_page.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        // Divider with "or"
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'or',
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
        // Social login tiles row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google login tile
            SocialTile(
              icon: SvgPicture.asset(
                'assets/icons/google.svg',
                color: primaryColor,
                height: 24,
              ),
              onTap: () {
                GoogleAuthService().signInWithGoogle(context);
              }
            ),
            const SizedBox(width: 20),
            // Apple login tile
            SocialTile(
              icon: const Icon(
                FontAwesomeIcons.apple,
                color: Colors.black,
                size: 30,
              ),
              onTap: () async {
                if (await AppleAuthService().signInWithApple(context) && context.mounted) {
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 32),
        // Sign up row
        AuthFooter(
          primaryColor: primaryColor,
          onSignUpPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ClientIDPage(),
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