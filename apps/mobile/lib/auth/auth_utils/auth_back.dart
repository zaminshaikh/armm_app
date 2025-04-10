import 'package:flutter/material.dart';

class AuthBack extends StatelessWidget {
  final VoidCallback onBackPressed;

  const AuthBack({
    Key? key,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top:60.0, left: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.grey,
              onPressed: onBackPressed,
            ),
            // TextButton(
            //   onPressed: onBackPressed,
            //   child: const Text(
            //     'Back',
            //     style: TextStyle(
            //       color: Colors.grey,
            //       fontSize: 16,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}