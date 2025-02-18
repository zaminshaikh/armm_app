import 'package:flutter/material.dart';
import 'package:armm_app/utils/app_bar.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: Center(
        child: Text('Settings Page'),
      ),
    );
  }
}
