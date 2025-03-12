import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Widget? icon;
  final List<Widget> actions;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    this.icon,
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
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.dividerColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.titleLarge?.color,
                  fontSize: 18,
                ),
              ),
            ),
            if(icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            color: theme.textTheme.bodyMedium?.color,
            fontSize: 14,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: actions,
      ),
    );
  }
}
