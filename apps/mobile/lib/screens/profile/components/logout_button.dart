import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onLogout;
  
  const LogoutButton({Key? key, this.onLogout}) : super(key: key);

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 0449d9d (Add confirmation dialog for logout action in LogoutButton)
  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
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

    if (shouldLogout == true && onLogout != null) {
      onLogout!();
    }
  }

<<<<<<< HEAD
=======
>>>>>>> ab28c91 (Settings Page Complete)
=======
>>>>>>> 0449d9d (Add confirmation dialog for logout action in LogoutButton)
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
<<<<<<< HEAD
<<<<<<< HEAD
        onPressed: () => _confirmLogout(context),
=======
        onPressed: onLogout ?? () {},
>>>>>>> ab28c91 (Settings Page Complete)
=======
        onPressed: () => _confirmLogout(context),
>>>>>>> 0449d9d (Add confirmation dialog for logout action in LogoutButton)
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
<<<<<<< HEAD
<<<<<<< HEAD
}
=======
}
>>>>>>> ab28c91 (Settings Page Complete)
=======
}
>>>>>>> 0449d9d (Add confirmation dialog for logout action in LogoutButton)
