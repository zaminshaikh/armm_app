import 'package:flutter/material.dart';
import 'package:armm_app/utils/app_bar.dart';

class DisclaimerPage extends StatelessWidget {
  const DisclaimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Disclaimer',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "ARMM Group LLC, a New York LLC, is exempt from the Investment Company Act of 1940 under Section 3(c) (1). We offer private placements to up to 100 accredited investors and 35 non-accredited investors under Rule 506 of Regulation D of the Securities Act of 1933, claiming this exemption as a safe harbor. A Form D is filed with the SEC and relevant states. Located at 6800 Jericho Turnpike, Suite 120W, Syosset, NY 11791, we operate under New York and U.S. laws. For inquiries, contact us at info@armmgroup.com. Thank you.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
