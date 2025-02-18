import 'package:flutter/material.dart';
import 'package:armm_app/utils/app_bar.dart';

class DocumentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Documents',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: Center(
        child: Text('Documents Page'),
      ),
    );
  }
}
