import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/components/mail_app_picker_bottom';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';

void openMailApp(BuildContext context) async {
  final result = await OpenMailApp.openMailApp();

  if (!context.mounted) return; // Ensure widget is still mounted before proceeding

  // No mail clients at all
  if (!result.didOpen && !result.canOpen) {
    _showNoMailAppsDialog(context);
    return;
  }

  // Several clients → present sheet
  if (!result.didOpen && result.canOpen) {
    showModalBottomSheet(
      context: context,
      // identical glass‑dim effect you use for dialogs
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: Colors.transparent,       // let us draw our own card
      isScrollControlled: true,                  // sheet hugs content
      builder: (ctx) => MailAppPickerSheet(options: result.options),
    );
  }
}

void _showNoMailAppsDialog (BuildContext context) => showDialog(
  context: context,
  builder: (context) {
    return CustomAlertDialog(
      title: 'No Mail Apps Installed',
      message: 'Please install a mail app to verify your email.',
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  },
);