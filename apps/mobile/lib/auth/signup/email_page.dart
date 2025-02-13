import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/signup/password_page.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmailPage extends StatefulWidget {
  final SignUpData signUpData;

  const EmailPage({Key? key, required this.signUpData}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

const ARMM_Blue = Color(0xFF1C32A4);

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("Client ID received in EmailPage: ${widget.signUpData.cid}"); // DEBUG PRINT
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  // Top illustration
                  SvgPicture.asset(
                    'assets/icons/email.svg',
                    height: 200,
                  ),
                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    'Next, enter your Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    'Please enter your email address\n'
                    'to continue the registration process',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Email Text Field
                  AuthTextField(
                    hintText: 'Email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 24),

                  // Continue Button
                  AuthButton(
                    label: 'Continue',
                    onPressed: () {
                      widget.signUpData.email = _emailController.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PasswordPage(signUpData: widget.signUpData),
                        ),
                      );
                    },
                    backgroundColor: ARMM_Blue,
                    foregroundColor: Colors.white,
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
          AuthBack(onBackPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}