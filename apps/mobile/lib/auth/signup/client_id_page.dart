<<<<<<< HEAD
import 'dart:developer';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/signup/email_page.dart';
import 'package:armm_app/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:armm_app/auth/auth_utils/google_auth.dart';

class ClientIDPage extends StatefulWidget {

=======
import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/signup/email_page.dart';
import 'package:armm_app/signup_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ClientIDPage extends StatefulWidget {
>>>>>>> 07991de (Fixed UI of all Auth pages)
  const ClientIDPage({Key? key}) : super(key: key);

  @override
  _ClientIDPageState createState() => _ClientIDPageState();
}

const ARMM_Blue = Color(0xFF1C32A4);

class _ClientIDPageState extends State<ClientIDPage> {
  final TextEditingController _cidController = TextEditingController();
<<<<<<< HEAD
  bool isLoading = false;

  Future<bool> isValidCID(String cid) async {
    DatabaseService db = DatabaseService.withCID('', cid);

    // Run both database checks in parallel
    final results = await Future.wait([
      db.checkDocumentExists(cid),
      db.checkDocumentLinked(cid),
    ]);

    final bool exists = results[0];
    final bool linked = results[1];

    if (!exists) {
      if (!mounted) return false;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid CID'),
          content: const Text('The CID you entered does not exist. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return false;
    } else if (linked) {
      if (!mounted) return false;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('CID Already Linked'),
          content: const Text('The CID you entered is already linked to an account. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }
    
    return true;
  }
=======
>>>>>>> 07991de (Fixed UI of all Auth pages)

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

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 3ee0730 (Enhance authentication flow by adding Client ID page routes)
                  // Center illustration
                  Center(
                    child: SvgPicture.asset(
                      'assets/icons/client_id.svg',
                      height: 180,
                    ),
<<<<<<< HEAD
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
                  const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'What is my Client ID?',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
=======
                  // Client ID Page Header
                  ClientIDPageHeader(
                    onBackPressed: () => Navigator.pop(context),
                    illustrationAsset: 'assets/icons/client_id.svg',
                    titleColor: ARMM_Blue,
                  ),
                  const SizedBox(height: 32),
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
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
>>>>>>> 3ee0730 (Enhance authentication flow by adding Client ID page routes)

                  // Client ID Text Field
                  AuthTextField(
                    hintText: 'Client ID',
                    controller: _cidController,
                  ),
<<<<<<< HEAD
<<<<<<< HEAD
                  const SizedBox(height: 12),
=======
                  const SizedBox(height: 24),
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
                  const SizedBox(height: 12),
>>>>>>> 3ee0730 (Enhance authentication flow by adding Client ID page routes)

                  // Continue Button
                  AuthButton(
                    label: 'Continue',
<<<<<<< HEAD
                    onPressed: () async {
                      log('client_id_page.dart: Checking CID: ${_cidController.text}');
                      setState(() => isLoading = true);
                      final bool valid = await isValidCID(_cidController.text);
                      setState(() => isLoading = false);

                      if (!valid) {
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmailPage(cid: _cidController.text),
=======
                    onPressed: () {
                      print(_cidController.text);
                      // Pass data to the next screen
                      SignUpData signUpData = SignUpData(cid: _cidController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmailPage(signUpData: signUpData),
>>>>>>> 07991de (Fixed UI of all Auth pages)
                        ),
                      );
                    },
                    backgroundColor: ARMM_Blue,
                    foregroundColor: Colors.white,
                  ),
                  const SizedBox(height: 16),

                  // OR Divider
<<<<<<< HEAD
                  const Row(
                    children: [
=======
                  Row(
                    children: const [
>>>>>>> 07991de (Fixed UI of all Auth pages)
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
<<<<<<< HEAD
                    onPressed: () async {
                      // Dismiss the keyboard
                      FocusScope.of(context).unfocus();
                      try {
                        setState(() => isLoading = true);
                        await GoogleAuthService().signUpWithGoogle(context, _cidController.text);
                      } finally {
                        setState(() => isLoading = false);
                      }
=======
                    onPressed: () {
                      // Implement your Google sign-up logic
>>>>>>> 07991de (Fixed UI of all Auth pages)
                    },
                  ),
                  const SizedBox(height: 24),

                  // Already have an account? Log in
                  AuthFooter(
                    primaryColor: ARMM_Blue,
                    onSignUpPressed: () {
<<<<<<< HEAD
<<<<<<< HEAD
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
=======
                      // Implement navigation to Log in
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(signUpData: SignUpData()),
                        ),
                      );
>>>>>>> 3ee0730 (Enhance authentication flow by adding Client ID page routes)
                    },
                    questionText: 'Already have an account?',
                    buttonText: 'Log in',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
<<<<<<< HEAD
<<<<<<< HEAD
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
=======
          AuthBack(onBackPressed: () => Navigator.pop(context)),
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
          Positioned(
            top: 0,
            left: 0,
            child: AuthBack(onBackPressed: () => Navigator.pop(context)),
          ),
>>>>>>> 3ee0730 (Enhance authentication flow by adding Client ID page routes)
        ],
      ),
    );
  }
}