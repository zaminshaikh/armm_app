import 'dart:developer';
import 'dart:io';

import 'package:armm_app/auth/auth_utils/apple_auth.dart';
import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
import 'package:armm_app/auth/auth_utils/social_tile.dart';
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/signup/email_page.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/components/custom_progress_indicator.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:armm_app/auth/auth_utils/google_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClientIDPage extends StatefulWidget {
  const ClientIDPage({Key? key}) : super(key: key);

  @override
  _ClientIDPageState createState() => _ClientIDPageState();
}

class _ClientIDPageState extends State<ClientIDPage> {
  final TextEditingController _cidController = TextEditingController();
  bool isLoading = false;
  bool _isCIDValid = false;

  @override
  void initState() {
    super.initState();
    _cidController.addListener(_validateCID);
  }

  void _validateCID() {
    final text = _cidController.text;
    // Check if the text is exactly 8 digits
    final isValid = text.length == 8 && RegExp(r'^\d{8}$').hasMatch(text);

    if (isValid != _isCIDValid) {
      setState(() {
        _isCIDValid = isValid;
      });
    }
  }

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
        builder: (context) => CustomAlertDialog(
          title: 'Invalid CID',
          message: 'The CID you entered does not exist. Please try again.',
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
        builder: (context) => CustomAlertDialog(
          title: 'CID Already Linked',
          message: 'The CID you entered is already linked to an account. Please try again.',
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

  @override
  void dispose() {
    _cidController.removeListener(_validateCID);
    _cidController.dispose();
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Center(
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
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // "What is my Client ID?" (Clickable text to open a dialog)
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomAlertDialog(
                                title: 'What is a Client ID?',
                                message:
                                    'A Client ID (CID) is a unique identifier assigned to you. It helps us verify your identity and ensure the security of your data.',
                                icon: const Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.primary,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                    ),
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: const Row(
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
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Client ID Text Field
                    AuthTextField(
                      hintText: 'Client ID',
                      controller: _cidController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Only show Apple button on iOS
                        SocialTile(
                          icon: const Icon(
                            FontAwesomeIcons.google,
                            color: AppColors.primary,
                            size: 30,
                          ),
                          onTap: () async {
                            setState(() => isLoading = true);
                            bool shouldSignUp = await isValidCID(_cidController.text);
                            if (!shouldSignUp) {
                              setState(() => isLoading = false);
                              return;
                            }
                            if (!context.mounted) return;
                            // Dismiss the keyboard
                            FocusScope.of(context).unfocus();
                            try {
                              await GoogleAuthService().signUpWithGoogle(context, _cidController.text);
                            } finally {
                              setState(() => isLoading = false);
                            }
                          },
                        ),
                        if (Platform.isIOS) const SizedBox(width: 20),
                        if (Platform.isIOS)
                          SocialTile(
                            icon: const Icon(
                              FontAwesomeIcons.apple,
                              color: Colors.black,
                              size: 30,
                            ),
                            onTap: () async {
                              setState(() => isLoading = true);
                              bool shouldSignUp = await isValidCID(_cidController.text);
                              if (!shouldSignUp) {
                                setState(() => isLoading = false);
                                return;
                              }
                              if (!context.mounted) return;
                              // Dismiss the keyboard
                              FocusScope.of(context).unfocus();
                              try {
                                await AppleAuthService().signUpWithApple(context, _cidController.text);
                              } finally {
                                if (mounted) {
                                  setState(() => isLoading = false);
                                }
                              }
                            },
                          ),
                        // Add spacing only if both buttons are shown
                      ],
                    ),
                    const SizedBox(height: 12),

                    // OR Divider
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('or', style: TextStyle(color: Colors.grey)),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Continue Button
                    AuthButton(
                      label: 'Continue with email',
                      onPressed: () async {
                        FocusScope.of(context).unfocus(); // Dismiss keyboard
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
                          ),
                        );
                      },
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      isEnabled: _isCIDValid,
                    ),
                    const SizedBox(height: 24),

                    // Already have an account? Log in
                    AuthFooter(
                      primaryColor: AppColors.primary,
                      onSignUpPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
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
          ),
          Positioned(
            top: 0,
            left: 0,
            child: AuthBack(onBackPressed: () => Navigator.pop(context)),
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const CustomProgressIndicator(),
            ),
        ],
      ),
    );
  }
}