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
            // Replace IconButton with GestureDetector
            GestureDetector(
              onTap: onBackPressed,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}