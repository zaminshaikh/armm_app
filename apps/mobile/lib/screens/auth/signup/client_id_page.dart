import 'package:armm_app/screens/auth/signup/email_page.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/material.dart';

class ClientIDPage extends StatefulWidget {
  const ClientIDPage({Key? key}) : super(key: key);

  @override
  _ClientIDPageState createState() => _ClientIDPageState();
}

class _ClientIDPageState extends State<ClientIDPage> {
  final TextEditingController _clientIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            // Top illustration (replace with  Image.asset or any widget you prefer)
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: Placeholder(), // Replace with your illustration widget
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'First, enter your CID',
              style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'This will help us confirm your identity\n'
              'to protect your data securely',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // "What is my Client ID?" (You could make this a clickable text or info button)
            InkWell(
              onTap: () {
                // Implement your "What is my Client ID?" logic
              },
              child: const Text(
                'What is my Client ID?',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Client ID Text Field
            TextField(
              controller: _clientIdController,
              decoration: InputDecoration(
                labelText: 'Client ID',
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
                  print(_clientIdController.text);
                  // Pass data to the next screen
                  SignUpData signUpData = SignUpData(clientId: _clientIdController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmailPage(signUpData: signUpData),
                    ),
                  );
                },
                child: const Text('Continue'),
              ),
            ),
            const SizedBox(height: 16),

            // OR Divider
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('or'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),

            // Sign up with Google
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                icon: const Icon(Icons.g_mobiledata), // Replace with a Google icon
                label: const Text('Sign up with Google'),
                onPressed: () {
                  // Implement your Google sign-up logic
                },
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
                    // Implement navigation to Log in
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