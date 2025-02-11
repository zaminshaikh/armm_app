import 'package:armm_app/screens/auth/forgot_password/forgot_password.dart';
import 'package:armm_app/screens/auth/signup/password_page.dart';
import 'package:armm_app/screens/auth/auth.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final Color primaryColor;
  final VoidCallback onTogglePassword;
  final SignUpData signUpData;

  const LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.primaryColor,
    required this.onTogglePassword,
    required this.signUpData,
  }) : super(key: key);

  void _handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }

    try {
      // Authentication logic
      await AuthService().signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to the Client Info Page on successful login
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordPage(signUpData: signUpData),
        ),
      );
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email TextField
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            filled: true,
            fillColor: const Color(0xFFF0F0F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Password TextField with toggle visibility
        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            filled: true,
            fillColor: const Color(0xFFF0F0F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onTogglePassword,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Log In button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: () => _handleLogin(context),
            child: const Text(
              'Log in',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Forgot Password button
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
              );
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}