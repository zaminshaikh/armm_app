import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginHeader extends StatelessWidget {
  final VoidCallback onBackPressed;
  final String illustrationAsset;
  final Color titleColor;

  const LoginHeader({
    Key? key,
    required this.onBackPressed,
    required this.illustrationAsset,
    required this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row with back arrow + "Back" text
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.grey,
              onPressed: onBackPressed,
            ),
            TextButton(
              onPressed: onBackPressed,
              child: const Text(
                'Back',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Center illustration
        Center(
          child: SvgPicture.asset(
            illustrationAsset,
            height: 200,
          ),
        ),
        const SizedBox(height: 24),
        // Title text: "Log in"
        Center(
          child: Text(
            'Log in',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: titleColor,
                ),
          ),
        ),
      ],
    );
  }
}