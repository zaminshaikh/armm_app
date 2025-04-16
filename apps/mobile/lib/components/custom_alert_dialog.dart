import 'package:armm_app/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Widget? icon;
  final Widget? input; // New property for input widgets
  final List<Widget> actions;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    this.icon,
    this.input, // Added this new property
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Theme(
      data: theme.copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: AlertDialog(
        backgroundColor: theme.cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 8, // Increased elevation for better depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Slightly more rounded
          side: BorderSide(
            color: theme.dividerColor.withOpacity(0.08),
            width: 0.5, // More subtle border
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        title: Row(
          children: [
            if(icon != null) ...[
              icon!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700, // Bolder title
                  color: theme.colorScheme.onSurface,
                  fontSize: 20, // Slightly larger title
                  letterSpacing: -0.5, // Tighter letter spacing
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400, // Regular weight for body text
                color: theme.colorScheme.onSurface.withOpacity(0.8), // Slightly muted text
                fontSize: 15, // Slightly larger for readability
                height: 1.4, // Better line height for readability
              ),
            ),
            if (input != null) ...[
              const SizedBox(height: 16),
              input!, // Display the input widget if provided
            ],
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 20), // More bottom padding
        actions: actions.map((action) {
          // Check if action is a TextButton and style it consistently
          if (action is TextButton) {
            return TextButton(
              onPressed: action.onPressed,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.transparent,
                overlayColor: Colors.transparent, // removes splash
              ),
              child: DefaultTextStyle(
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontSize: 15,
                ),
                child: action.child!,
              ),
            );
          }
          return action;
        }).toList(),
      ),
    );
  }

  static Future<void> showAlertDialog(BuildContext context, String title, String message, {Widget? icon, Widget? input}) async {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6), // Darker, more immersive barrier
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return CustomAlertDialog(
          title: title,
          message: message,
          icon: icon,
          input: input,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
