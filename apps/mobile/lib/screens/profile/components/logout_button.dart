import 'package:armm_app/auth/auth_utils/auth_functions.dart';
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';

class LogoutButton extends StatelessWidget {
  
  const LogoutButton({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomAlertDialog(
          title: "Confirm Logout",
          message: "Are you sure you want to log out?",
            icon: const Icon(Icons.logout, color: Colors.red),
            actions: [
              TextButton(
                onPressed: () {
                Navigator.of(dialogContext).pop(false);
                },
                child: Text(
                "Cancel",
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () {
                Navigator.of(dialogContext).pop(true);
                },
                child: Text(
                "Log out",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Colors.red, // Make the logout option red
                ),
                ),
              ),
            ],
        );
      },
    );

    if (shouldLogout == true) {
      await AuthService().signOut();
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red, width: 1.5),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        onPressed: () => _confirmLogout(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/logout.svg',
              width: 20,
              height: 20,
              color: Colors.red,
            ),
            const SizedBox(width: 12),
            Text(
              'Log out',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}