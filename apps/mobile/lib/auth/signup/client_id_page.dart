import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
import 'package:armm_app/auth/signup/email_page.dart';
import 'package:armm_app/auth/signup/client_id_page_header.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ClientIDPage extends StatefulWidget {
  const ClientIDPage({Key? key}) : super(key: key);

  @override
  _ClientIDPageState createState() => _ClientIDPageState();
}

const ARMM_Blue = Color(0xFF1C32A4);

class _ClientIDPageState extends State<ClientIDPage> {
  final TextEditingController _cidController = TextEditingController();

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

                  // Client ID Page Header
                  ClientIDPageHeader(
                    onBackPressed: () => Navigator.pop(context),
                    illustrationAsset: 'assets/icons/client_id.svg',
                    titleColor: ARMM_Blue,
                  ),
                  const SizedBox(height: 32),

                  // Client ID Text Field
                  AuthTextField(
                    hintText: 'Client ID',
                    controller: _cidController,
                  ),
                  const SizedBox(height: 24),

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
                    onPressed: () {
                      // Implement your Google sign-up logic
                    },
                  ),
                  const SizedBox(height: 24),

                  // Already have an account? Log in
                  AuthFooter(
                    primaryColor: ARMM_Blue,
                    onSignUpPressed: () {
                      // Implement navigation to Log in
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