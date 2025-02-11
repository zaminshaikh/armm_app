import 'package:armm_app/client_info.dart';
import 'package:armm_app/screens/auth/auth.dart';
import 'package:armm_app/screens/dashboard/home_page.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/material.dart';

class PasswordPage extends StatefulWidget {
  final SignUpData signUpData;

  const PasswordPage({Key? key, required this.signUpData}) : super(key: key);

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService(); // Your auth class

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Example flags for password strength checks
  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasCapitalLetter => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'\d'));

  @override
  Widget build(BuildContext context) {
    print("Client ID received in PasswordPage: ${widget.signUpData.clientId}"); // DEBUG PRINT
    return Scaffold(
      // Top AppBar with Back Button
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.grey,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Top illustration
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: Placeholder(), // Replace with an image or illustration
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Next, create your Password',
              style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'It will protect your account',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                fillColor: const Color(0xFFF0F0F0),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Password Requirements
            Row(
              children: [
                Icon(
                  _hasMinLength ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: _hasMinLength ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                const Text('Minimum 8 characters'),
              ],
            ),
            Row(
              children: [
                Icon(
                  _hasCapitalLetter ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: _hasCapitalLetter ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                const Text('Minimum 1 Capital letter'),
              ],
            ),
            Row(
              children: [
                Icon(
                  _hasNumber ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: _hasNumber ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                const Text('Minimum 1 Number'),
              ],
            ),
            const SizedBox(height: 16),

            // Confirm Password
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                fillColor: const Color(0xFFF0F0F0),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () async {
                  if (_passwordController.text != _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
                    return;
                  }
                  // if (!_isPasswordValid) {
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password must meet requirements")));
                  //   return;
                  // }
                  widget.signUpData.password = _passwordController.text;

                  try {
                    await _authService.createUserWithEmailAndPassword(
                      email: widget.signUpData.email,
                      password: widget.signUpData.password,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Account created successfully!")),
                    );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ClientInfoPage(signUpData: widget.signUpData,)),
                      );


                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Signup failed: $e")),
                    );
                  }
                  
                },
              child: const Text('Sign Up'),
              ),
            ),
            const SizedBox(height: 24),

            // Already have an account? Log in
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? '),
                InkWell(
                  onTap: () {
                    // Navigate to login
                  },
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}