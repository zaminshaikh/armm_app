import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:armm_app/utils/app_bar.dart';
=======
>>>>>>> 74eb99f (Made Dummy Sub-Pages For the Profile Page)

class DisclaimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Disclaimer',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "ARMM is a Florida limited liability company exempt from the registration requirements of the Investment Company Act of 1940 pursuant to Section 3(c) (1) thereof. Our private offerings are available for up to one hundred (100) accredited investors of which no more than thirty-five (35) may be non-accredited investors and rely on the registration exemption under Rule 506 of Regulation D under the Securities Act of 1933. A Form D claiming such exemption as a safe harbor is on file with the SEC and applicable states. ARMM is domiciled at 195 International Parkway, Suite 103, Lake Mary, Florida 32746 and is under the purview of the State of Florida and United States laws. Please contact ARMM group at management@example.com. Thank you.",
          style: TextStyle(fontSize: 16),
        ),
=======
    return Scaffold(
      appBar: AppBar(
        title: Text('Disclaimer'),
      ),
      body: Center(
        child: Text('Disclaimer Page'),
>>>>>>> 74eb99f (Made Dummy Sub-Pages For the Profile Page)
      ),
    );
  }
}
