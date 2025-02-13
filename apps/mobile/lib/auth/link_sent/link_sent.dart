import 'package:armm_app/auth/forgot_password/components/forgot_password_footer.dart';
import 'package:flutter/material.dart';

// Import components for this screen
import 'components/link_sent_header.dart';
import 'components/link_sent_illustration.dart';
import 'components/link_sent_body.dart';


class LinkSentPage extends StatelessWidget {
  const LinkSentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 24.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Main scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    children: const [
                      SizedBox(height: 20),
                      // Header (logo)
                      LinkSentHeader(),
                      SizedBox(height: 60),
                      // Illustration (SVG)
                      LinkSentIllustration(),
                      SizedBox(height: 60),
                      // Body (title, subtitle, resend link)
                      LinkSentBody(),
                    ],
                  ),
                ),
              ),
            ),
            // Footer (shared component from Forgot Password)
            const ForgotPasswordFooter(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
