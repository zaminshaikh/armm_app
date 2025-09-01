import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/components/mail_app_picker_bottom';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void openMailApp(BuildContext context) async {
  try {
    // List of mail app schemes to try in order of preference
    final List<Map<String, String>> mailApps = [
      {'name': 'Gmail', 'scheme': 'googlegmail://'},
      {'name': 'Outlook', 'scheme': 'ms-outlook://'},
      {'name': 'Apple Mail', 'scheme': 'message://'},
    ];

    // Check which mail apps are available
    List<String> availableApps = [];
    for (var app in mailApps) {
      final uri = Uri.parse(app['scheme']!);
      if (await canLaunchUrl(uri)) {
        availableApps.add(app['name']!);
      }
    }

    // If multiple apps are available, show picker
    if (availableApps.length > 1 && context.mounted) {
      showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (ctx) => MailAppPickerSheet(options: availableApps),
      );
      return;
    }

    // Try to open the first available app or fallback to mailto
    bool opened = false;
    for (var app in mailApps) {
      final uri = Uri.parse(app['scheme']!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        opened = true;
        break;
      }
    }

    // If no specific mail app worked, try generic mailto
    if (!opened) {
      final mailtoUrl = Uri.parse('mailto:');
      if (await canLaunchUrl(mailtoUrl)) {
        await launchUrl(mailtoUrl, mode: LaunchMode.externalApplication);
        opened = true;
      }
    }

    // If still no mail app can be opened, show dialog
    if (!opened && context.mounted) {
      _showNoMailAppsDialog(context);
    }
  } catch (e) {
    if (context.mounted) {
      _showNoMailAppsDialog(context);
    }
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