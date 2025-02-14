import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/signup/email_page.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:armm_app/auth/auth_utils/google_auth.dart';

class ClientIDPage extends StatefulWidget {
  const ClientIDPage({Key? key}) : super(key: key);

  @override
  _ClientIDPageState createState() => _ClientIDPageState();
}

const ARMM_Blue = Color(0xFF1C32A4);

class _ClientIDPageState extends State<ClientIDPage> {
  final TextEditingController _cidController = TextEditingController();
    bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 72),

                  // Center illustration
                  Center(
                    child: SvgPicture.asset(
                      'assets/icons/client_id.svg',
                      height: 180,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Title text: "First, enter your CID"
                  Center(
                    child: Text(
                      'First, enter your CID',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle text
                  const Center(
                    child: Text(
                      'This will help us confirm your identity\n'
                      'to protect your data securely',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // "What is my Client ID?" (You could make this a clickable text or info button)
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'What is my Client ID?',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Client ID Text Field
                  AuthTextField(
                    hintText: 'Client ID',
                    controller: _cidController,
                  ),
                  const SizedBox(height: 12),

                  // Continue Button
                  AuthButton(
                    label: 'Continue',
                    onPressed: () {
                      print(_cidController.text);
                      // Pass data to the next screen
                      SignUpData signUpData = SignUpData(cid: _cidController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmailPage(signUpData: signUpData),
                        ),
                      );
                    },
                    backgroundColor: ARMM_Blue,
                    foregroundColor: Colors.white,
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
                  AuthButton(
                    label: 'Sign up with Google',
                    icon: SvgPicture.asset(
                      'assets/icons/google.svg',
                      color: ARMM_Blue,
                      height: 24,
                    ),
                    foregroundColor: ARMM_Blue,
                    onPressed: () async {
                      // Dismiss the keyboard
                      FocusScope.of(context).unfocus();
                      try {
                        setState(() => isLoading = true);
                        await GoogleAuthService().signUpWithGoogle(context, _cidController.text);
                      } finally {
                        setState(() => isLoading = false);
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Already have an account? Log in
                  AuthFooter(
                    primaryColor: ARMM_Blue,
                    onSignUpPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(signUpData: SignUpData()),
                        ),
                      );
                    },
                    questionText: 'Already have an account?',
                    buttonText: 'Log in',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: AuthBack(onBackPressed: () => Navigator.pop(context)),
          ),
        ],
      ),
    );
  }
}