import 'package:armm_app/screens/auth/signup/password_page.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/material.dart';

class EmailPage extends StatefulWidget {
  final SignUpData signUpData;

  const EmailPage({Key? key, required this.signUpData}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("Client ID received in EmailPage: ${widget.signUpData.cid}"); // DEBUG PRINT
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
              child: Placeholder(), // Replace with your illustration widget
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Next, enter your Email',
              style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Please enter your email address\n'
              'to continue a registration process',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Email Text Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                fillColor: const Color(0xFFF0F0F0),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  widget.signUpData.email = _emailController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordPage(signUpData: widget.signUpData),
                    ),
                  );
                },
                child: const Text('Continue'),
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