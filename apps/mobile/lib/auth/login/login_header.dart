<<<<<<< HEAD
<<<<<<< HEAD
=======
import 'package:armm_app/auth/auth_utils/auth_back.dart';
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
>>>>>>> ad7de27 (Remove unused imports and clean up code in authentication-related files)
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
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Center illustration
              SvgPicture.asset(
                illustrationAsset,
                height: 200,
              ),
              const SizedBox(height: 24),
              // Title text: "Log in"
              Text(
                'Log in',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}