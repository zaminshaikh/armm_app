import 'package:flutter/material.dart';
import 'package:armm_app/utils/app_bar.dart';

class DisclaimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Disclaimer',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: Center(
        child: Text('Disclaimer Page'),
      ),
    );
  }
}
