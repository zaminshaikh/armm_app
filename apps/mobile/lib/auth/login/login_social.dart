import 'package:armm_app/auth/auth_utils/apple_auth.dart';
import 'package:armm_app/auth/auth_utils/google_auth.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
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
            _buildSocialTile(
              context, 
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
            _buildSocialTile(
              context,
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

  Widget _buildSocialTile(
    BuildContext context, {
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: icon),
      ),
    );
  }
}