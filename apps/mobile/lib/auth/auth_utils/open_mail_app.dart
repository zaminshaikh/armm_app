import 'dart:io';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/components/mail_app_picker_bottom';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void openMailApp(BuildContext context) async {
  try {
    if (Platform.isAndroid) {
      // On Android, try different approaches
      await _openMailAppAndroid(context);
    } else {
      // On iOS, use the app-specific schemes
      await _openMailAppIOS(context);
    }
  } catch (e) {
    if (context.mounted) {
      _showNoMailAppsDialog(context);
    }
  }
}

Future<void> _openMailAppAndroid(BuildContext context) async {
  try {
    // Try to launch Gmail app directly first
    final gmailUri = Uri.parse('android-app://com.google.android.gm');
    if (await canLaunchUrl(gmailUri)) {
      await launchUrl(gmailUri);
      return;
    }
    
    // Try to launch Outlook app directly
    final outlookUri = Uri.parse('android-app://com.microsoft.office.outlook');
    if (await canLaunchUrl(outlookUri)) {
      await launchUrl(outlookUri);
      return;
    }
    
    // Try Samsung Email
    final samsungUri = Uri.parse('android-app://com.samsung.android.email.provider');
    if (await canLaunchUrl(samsungUri)) {
      await launchUrl(samsungUri);
      return;
    }
    
    // Fallback to simple mailto (which might still show chooser)
    final mailtoUri = Uri.parse('mailto:');
    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(
        mailtoUri, 
        mode: LaunchMode.externalApplication,
      );
      return;
    }
    
    // If still nothing works, show error
    if (context.mounted) {
      _showNoMailAppsDialog(context);
    }
    
  } catch (e) {
    print('Error opening mail app on Android: $e');
    if (context.mounted) {
      _showNoMailAppsDialog(context);
    }
  }
}

Future<void> _openMailAppIOS(BuildContext context) async {
  // Platform-specific mail app schemes for iOS
  final List<Map<String, String>> mailApps = [
    {'name': 'Gmail', 'scheme': 'googlegmail://'},
    {'name': 'Outlook', 'scheme': 'ms-outlook://'},
    {'name': 'Apple Mail', 'scheme': 'message://'},
    {'name': 'Spark', 'scheme': 'readdle-spark://'},
    {'name': 'Airmail', 'scheme': 'airmail://'},
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