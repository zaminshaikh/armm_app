import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClientIDPageHeader extends StatelessWidget {
  final VoidCallback onBackPressed;
  final String illustrationAsset;
  final Color titleColor;

  const ClientIDPageHeader({
    Key? key,
    required this.onBackPressed,
    required this.illustrationAsset,
    required this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Center illustration
        Center(
          child: SvgPicture.asset(
            illustrationAsset,
            height: 180,
          ),
        ),
        const SizedBox(height: 30),
        // Title text: "First, enter your CID"
        Center(
          child: Text(
            'First, enter your CID',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: titleColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        // Subtitle text
        const Center(
          child: Text(
            'This will help us confirm your identity\n'
            'to protect your data securely',
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        // "What is my Client ID?" (Clickable text to open a dialog)
        Center(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('What is a Client ID?'),
                    content: const Text(
                      'A Client ID (CID) is a unique identifier assigned to you. It helps us verify your identity and ensure the security of your data.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              color: Colors.purple,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'What is my Client ID?',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}