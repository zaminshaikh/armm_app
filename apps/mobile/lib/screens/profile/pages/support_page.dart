<<<<<<< HEAD
<<<<<<< HEAD
import 'package:armm_app/utils/app_bar.dart';
import 'package:flutter/material.dart';
import 'faq_section.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  Widget _buildContactCard() {
    return Card(
      color: Colors.transparent, // Make background transparent
      elevation: 0, // Remove shadow by setting elevation to 0
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade300, // Greyish border color
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Investment Advisor',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Contact Information:',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 8),
                      Text('+234 123 456 7890'),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.email),
                      SizedBox(width: 8),
                      Text('test@email.com'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Support',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Point of Contact',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildContactCard(),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'FAQ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: FAQSection(),
            ),
          ],
        ),
      ),
    );
  }
}
=======
=======
import 'package:armm_app/utils/app_bar.dart';
>>>>>>> 547db41 (All Pages Use the Custom App Bar)
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
>>>>>>> 74eb99f (Made Dummy Sub-Pages For the Profile Page)
