import 'package:flutter/material.dart';

// Import your separate widgets
import 'login_header.dart';
import 'login_form.dart';
import 'login_social.dart';
import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:armm_app/components/custom_progress_indicator.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;

  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }
  
  void _dismissKeyboard() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Adjust to match your brand color
    const Color primaryColor = Color(0xFF1C32A4);

    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Padding( // Changed SingleChildScrollView to Padding
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 1), // Added Spacer for flexible top space
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
                    emailFocusNode: _emailFocusNode,
                    passwordFocusNode: _passwordFocusNode,
                    obscurePassword: _obscurePassword,
                    primaryColor: primaryColor,
                    isLoading: isLoading, // Pass isLoading state
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
                    showLoading: showLoading,
                    hideLoading: hideLoading,
                  ),
                  const Spacer(flex: 1), // Added Spacer for flexible bottom space
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: AuthBack(onBackPressed: () => Navigator.pop(context)),
          ),
          // Loading overlay for the entire page
          if (isLoading)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CustomProgressIndicator(),
              ),
            ),
        ],
      ),
    )
    );
  }
}