import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onLogout;
  
  const LogoutButton({Key? key, this.onLogout}) : super(key: key);

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
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && onLogout != null) {
      onLogout!();
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
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        ),
        onPressed: () => _confirmLogout(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/logout.svg',
              width: 24,
              height: 24,
              color: Colors.red,
            ),
            const SizedBox(width: 12),
            Text(
              'Log out',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 18,
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