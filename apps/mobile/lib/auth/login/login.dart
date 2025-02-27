<<<<<<< HEAD
<<<<<<< HEAD
import 'package:flutter/material.dart';
=======
import 'package:armm_app/auth/auth_utils/auth_functions.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
import 'package:flutter/material.dart';
>>>>>>> dc6fab8 (Remove SignUpData class and update related components to eliminate its usage)

// Import your separate widgets
import 'login_header.dart';
import 'login_form.dart';
import 'login_social.dart';
<<<<<<< HEAD

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);
=======
import 'package:armm_app/auth/auth_utils/auth_back.dart';

class LoginPage extends StatefulWidget {

<<<<<<< HEAD
  const LoginPage({Key? key, required this.signUpData}) : super(key: key);
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
  const LoginPage({Key? key}) : super(key: key);
>>>>>>> dc6fab8 (Remove SignUpData class and update related components to eliminate its usage)

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Adjust to match your brand color
    const Color primaryColor = Color(0xFF1C32A4);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 72),
                  // The illustration, and the "Log in" text
                  LoginHeader(
                    onBackPressed: () => Navigator.of(context).pop(),
                    illustrationAsset: 'assets/icons/login.svg',
                    titleColor: primaryColor,
                  ),
                  const SizedBox(height: 24),
                  // Email & Password form + "Log in" button + "Forgot Password?"
                  LoginForm(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    obscurePassword: _obscurePassword,
                    primaryColor: primaryColor,
                    onTogglePassword: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> dc6fab8 (Remove SignUpData class and update related components to eliminate its usage)
                  ),
                  const SizedBox(height: 12),
                  // The divider & social login buttons & sign-up link
                  const LoginSocial(
=======
                    signUpData: widget.signUpData,
                  ),
                  const SizedBox(height: 12),
                  // The divider & social login buttons & sign-up link
<<<<<<< HEAD
                  LoginSocial(
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
                  const LoginSocial(
>>>>>>> b8ff76d (Refactor code to use 'const' constructors for improved performance and consistency)
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
<<<<<<< HEAD
=======
          Positioned(
            top: 0,
            left: 0,
            child: AuthBack(onBackPressed: () => Navigator.pop(context)),
          ),
>>>>>>> 07991de (Fixed UI of all Auth pages)
        ],
      ),
    );
  }
}