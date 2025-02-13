import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor; // Sets text and icon color.
  final Color? borderColor;
<<<<<<< HEAD
  final bool isEnabled;
=======
>>>>>>> 07991de (Fixed UI of all Auth pages)

  const AuthButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
<<<<<<< HEAD
    this.isEnabled = true,
  }) : super(key: key);
=======
  }) : super(key: key);
  
>>>>>>> 07991de (Fixed UI of all Auth pages)

  @override
  Widget build(BuildContext context) {
    final Color effectiveBorderColor =
        borderColor ?? Theme.of(context).primaryColor;
    final Color effectiveForegroundColor =
        foregroundColor ?? Theme.of(context).primaryColor;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: effectiveBorderColor, width: 2.0), // Increased border width
          shape: RoundedRectangleBorder(
<<<<<<< HEAD
            borderRadius: BorderRadius.circular(26),
=======
        borderRadius: BorderRadius.circular(26),
>>>>>>> 07991de (Fixed UI of all Auth pages)
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: backgroundColor,
          foregroundColor: effectiveForegroundColor,
        ),
<<<<<<< HEAD
        onPressed: isEnabled ? onPressed : null,
=======
        onPressed: onPressed,
>>>>>>> 07991de (Fixed UI of all Auth pages)
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  const SizedBox(width: 18),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}