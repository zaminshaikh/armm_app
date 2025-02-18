import 'package:armm_app/utils/app_bar.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Support',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: Center(
        child: Text('Support Page'),
      ),
    );
  }
}
