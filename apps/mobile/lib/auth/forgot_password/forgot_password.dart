import 'package:flutter/material.dart';
import 'components/forgot_password_header.dart';
import 'components/forgot_password_form.dart';
import 'components/forgot_password_footer.dart';
import 'components/forgot_password_illustration.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 30.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: const [
                      SizedBox(height: 20),
                      // Header (logo, title, subtitle)
                      ForgotPasswordHeader(),
                      SizedBox(height: 32),
                      // Form (email TextField, submit button)
                      ForgotPasswordForm(),
                      SizedBox(height: 20),
                      // Illustration
                      ForgotPasswordIllustration(),
                    ],
                  ),
                ),
              ),
            ),
            // Footer (Back to Sign In)
            const ForgotPasswordFooter(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}