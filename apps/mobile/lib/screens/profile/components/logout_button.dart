import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onLogout;
  
  const LogoutButton({Key? key, this.onLogout}) : super(key: key);

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
        onPressed: onLogout ?? () {},
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
