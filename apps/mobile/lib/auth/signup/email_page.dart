import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/auth/signup/password_page.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:flutter/services.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/components/custom_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class EmailPage extends StatefulWidget {
  final String cid;
  String email = '';

  EmailPage({super.key, required this.cid});

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  void _dismissKeyboard() {
    _emailFocusNode.unfocus();
  }
  
  @override
  void dispose() {
    _emailController.removeListener(_validateEmail);
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isValid = emailRegex.hasMatch(_emailController.text);
    
    if (isValid != _isEmailValid) {
      setState(() {
        _isEmailValid = isValid;
      });
    }
  }
  
  // Method to check if the email already exists in Firebase Auth
  Future<bool> _checkEmailExists() async {
    if (!_isEmailValid) {
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'Invalid Email',
          message: 'Please enter a valid email address.',
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return true; // Return true to indicate there's a problem
    }
    
    final email = _emailController.text.trim();
    
    try {
      // Try to sign up with the email to check if it exists
      // This is a workaround as Firebase doesn't provide a direct way to check
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: "temporaryPassword123",
      );
      
      // If we reach here, the email does not exist
      // We should sign out immediately
      await FirebaseAuth.instance.currentUser?.delete();
      
      return false; // Email does not exist, proceed
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Wrong password means the email exists
        if (!mounted) return true;
        
        showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
            title: 'Email Already Exists',
            message: 'This email is already registered. Please log in instead or use a different email address.',
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return true; // Email exists, don't proceed
      } else if (e.code == 'invalid-email') {
        if (!mounted) return true;
        
        showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
            title: 'Invalid Email',
            message: 'Please enter a valid email address.',
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return true; // Invalid email, don't proceed
      } else {
        // Handle other Firebase Auth exceptions
        log('Error checking email existence: ${e.code} - ${e.message}');
        return false; // Proceed in case of other errors
      }
    } catch (e) {
      log('Unexpected error checking email: $e');
      return false; // Proceed in case of other errors
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Client ID received in EmailPage: ${widget.cid}"); // DEBUG PRINT
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AutofillGroup(
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
                    Text(
                    'Next, enter your Email',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                    'Please enter your email address\n'
                    'to continue the registration process',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),


                  // Email Text Field
                  AuthTextField(
                    hintText: 'Email',
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newUsername, AutofillHints.email],
                    onSubmitted: (_) => _emailFocusNode.unfocus(),
                  ),
                  const SizedBox(height: 24),

                  // Continue Button
                  AuthButton(
                    label: 'Continue',
                    onPressed: () async {
                      // Save credentials to autofill service
                      TextInput.finishAutofillContext();
                      
                      setState(() {
                        _isLoading = true;
                      });
                      
                      widget.email = _emailController.text;
                      final emailExists = await _checkEmailExists();
                      
                      setState(() {
                        _isLoading = false;
                      });
                      
                      if (!emailExists && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PasswordPage(cid: widget.cid, email: _emailController.text),
                          ),
                        );
                      }
                    },
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    isEnabled: _isEmailValid,
                  ),
                  const SizedBox(height: 24),

                  // Already have an account? Log in
                  AuthFooter(
                    primaryColor: AppColors.primary,
                    onSignUpPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
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
          AuthBack(onBackPressed: () => Navigator.pop(context)),
          // Loading indicator overlay
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CustomProgressIndicator(),
              ),
            ),          ],
        ),
      ),
    );
  }
}