import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Import your separate widgets
import 'login_header.dart';
import 'login_form.dart';
import 'login_social.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // The back button + "Back", illustration, and the "Log in" text
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
              ),
              const SizedBox(height: 12),
              // The divider & social login buttons & sign-up link
              LoginSocial(
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}