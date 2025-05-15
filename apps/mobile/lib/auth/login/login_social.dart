import 'dart:io';
import 'package:armm_app/auth/auth_utils/apple_auth.dart';
import 'package:armm_app/auth/auth_utils/google_auth.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
import 'package:armm_app/auth/auth_utils/social_tile.dart';
import 'package:armm_app/auth/signup/client_id_page.dart';
import 'package:armm_app/components/custom_progress_indicator.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginSocial extends StatefulWidget {
  final Color primaryColor;
  final Function showLoading;
  final Function hideLoading;

  const LoginSocial({
    Key? key,
    required this.primaryColor,
    required this.showLoading,
    required this.hideLoading,
  }) : super(key: key);

  @override
  State<LoginSocial> createState() => _LoginSocialState();
}

class _LoginSocialState extends State<LoginSocial> {
  
  void _navigateToDashboard(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
      (route) => false, // This removes all previous routes
    );
  }

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
                color: widget.primaryColor,
                height: 24,
              ),
              onTap: () async {
                widget.showLoading();
                try {
                  final success = await GoogleAuthService().signInWithGoogle(context);
                  if (success == true && mounted) {
                    // Hide loading before navigation to avoid setState after dispose
                    widget.hideLoading();
                    _navigateToDashboard(context);
                  } else if (mounted) {
                    widget.hideLoading();
                  }
                } catch (e) {
                  if (mounted) {
                    widget.hideLoading();
                  }
                }
              }
            ),
            // Only show Apple button on iOS
            if (Platform.isIOS) ...[
              const SizedBox(width: 20),
              // Apple login tile
              SocialTile(
                icon: const Icon(
                  FontAwesomeIcons.apple,
                  color: Colors.black,
                  size: 30,
                ),
                onTap: () async {
                  widget.showLoading();
                  try {
                    final success = await AppleAuthService().signInWithApple(context);
                    if (success && mounted) {
                      // Hide loading before navigation to avoid setState after dispose
                      widget.hideLoading();
                      _navigateToDashboard(context);
                    } else if (mounted) {
                      widget.hideLoading();
                    }
                  } catch (e) {
                    if (mounted) {
                      widget.hideLoading();
                    }
                  }
                },
              ),
            ],
          ],
        ),
        const SizedBox(height: 24), // Reduced from 32
        // Sign up row
        AuthFooter(
          primaryColor: widget.primaryColor,
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