import 'dart:async';
import 'dart:developer';

import 'package:armm_app/database/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoutButton extends StatelessWidget {
  
  const LogoutButton({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text("Log out"),
            ),
          ],
        );
      },
    );
    if (!context.mounted) return;
    onLogout(context);
  }

  void onLogout(BuildContext context) async{
    log('settings.dart: Signing out...');

    Future<void> handleLogout() async {
      // Continue sign out asynchronously.
      await deleteFirebaseMessagingToken(FirebaseAuth.instance.currentUser, context);
      await FirebaseAuth.instance.signOut();
      assert(FirebaseAuth.instance.currentUser == null);
      log('settings.dart: Successfully signed out');
      return;
    }

    unawaited(handleLogout());
    // Immediately navigate away to avoid security rules issues when signed out.
    await Navigator.of(context).pushNamedAndRemoveUntil('/onboarding', (route) => false);

    return;
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
            borderRadius: BorderRadius.circular(32),
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
            const Text(
              'Log out',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}