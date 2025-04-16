import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor; // Sets text and icon color.
  final Color? borderColor;
  final bool isEnabled;

  const AuthButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color effectiveBorderColor = isEnabled
        ? (borderColor ?? Theme.of(context).primaryColor)
        : Colors.grey;
    
    final Color effectiveForegroundColor = isEnabled
        ? (foregroundColor ?? Theme.of(context).primaryColor)
        : Colors.grey;
    
    final Color? effectiveBackgroundColor = isEnabled
        ? backgroundColor
        : Colors.transparent;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: effectiveBorderColor, width: 2.0), // Increased border width
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          splashFactory: NoSplash.splashFactory, // Remove splash effect
        ),
        onPressed: isEnabled ? onPressed : null,
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  const SizedBox(width: 18),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}