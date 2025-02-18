import 'package:flutter/material.dart';
import 'package:armm_app/utils/app_bar.dart';

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Authentication',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: Center(
        child: Text('Authentication Page'),
      ),
    );
  }
}
