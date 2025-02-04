import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordIllustration extends StatelessWidget {
  const ForgotPasswordIllustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        // Illustration
        SvgPicture.asset(
          'assets/icons/forgot_password_icon.svg',
          width: 240,
          height: 240,
          semanticsLabel: 'Forgot Password Illustration',
          placeholderBuilder: (BuildContext context) => CircularProgressIndicator(),
        ),
      ],
    );
  }
}