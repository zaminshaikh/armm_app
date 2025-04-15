import 'dart:developer';

import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_functions.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
import 'package:armm_app/auth/login/login.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:armm_app/database/auth_helper.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/utils/resources.dart'; // Import the resources file
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordPage extends StatefulWidget {

  final String cid;
  final String email;
  String password = '';

  PasswordPage({super.key, required this.cid, required this.email});

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isLoading = false;

  // Firebase and app state.
  late DatabaseService db;
  late AuthService appState;

  final bool _obscurePassword = true;
  final bool _obscureConfirmPassword = true;

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasCapitalLetter => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'\d'));
  bool get _passwordsMatch => _passwordController.text == _confirmPasswordController.text && _confirmPasswordController.text.isNotEmpty;
  
  bool get _isPasswordValid => _hasMinLength && _hasCapitalLetter && _hasNumber && _passwordsMatch;

  int _passwordSecurityIndicator = 0;

  /// Check if the user is authenticated and linked
  Future<bool> isAuthenticated() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    String uid = user.uid;

    DatabaseService db = DatabaseService(uid);

    bool isLinked = await db.isUIDLinked(uid);

    return isLinked;
  }

  /// Handles the sign-up process.
  void _signUserUp() async {
    setState(() { isLoading = true; });
    // Delete any existing user in the buffer.
    await deleteUserInBuffer();

    try {
      // Create a new user with email and password.
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: _passwordController.text,
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(code: 'operation-not-allowed');
      }

      log('UserCredential created: ${userCredential.user!.uid}. In buffer.');

      // Initialize database service with CID.
      db = DatabaseService.withCID(userCredential.user!.uid, widget.cid);

      // Send email verification.
      User? user = FirebaseAuth.instance.currentUser;
      
      if (user == null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );
      }

      user = FirebaseAuth.instance.currentUser;

      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      // Show email verification dialog.
      if (!mounted) return;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Verify your email',
            message: 'A verification link has been sent to your email. Please verify your email to continue.',
            actions: [
              TextButton(
                onPressed: () async {
                  // Check if the email is verified
                  User? user = FirebaseAuth.instance.currentUser;
                  await user?.reload();
                  user = FirebaseAuth.instance.currentUser;
                  
                  if (user != null && user.emailVerified) {
                    Navigator.of(context).pop(); // Close the dialog
                    
                    // Show success dialog
                    if (!mounted) return;
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomAlertDialog(
                          title: 'Success',
                          message: 'Email verified successfully.',
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _verifyEmail(); // Continue with the verification process
                              },
                              child: const Text('Continue'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Show "check your email" dialog
                    if (!mounted) return;
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomAlertDialog(
                          title: 'Email Not Verified',
                          message: 'Please check your email and click on the verification link. If you don\'t see it, check your spam folder.',
                          icon: const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Continue'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      await handleFirebaseAuthException(context, e, widget.email);
    } catch (e) {
      log('Error signing user up: $e', stackTrace: StackTrace.current);
      await FirebaseAuth.instance.currentUser?.delete();
    } finally {

      if (mounted) setState(() { isLoading = false; });
    }
  }

  /// Verifies if the email is confirmed and proceeds accordingly.
  Future<bool> _verifyEmail() async {
    setState(() { isLoading = true; });
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      String uid = user.uid;
      await db.linkNewUser(user.email!);
      log('User $uid connected to Client ID $widget.signUpData.cid');

      // await updateFirebaseMessagingToken(user, context);
            
      if (!mounted) return true;
      // appState = Provider.of<AuthService>(context, listen: false);
      setState(() {
        isLoading = false;
      });

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );

      return true;
    } else {
      if (!mounted) return false;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Error',
            message: 'Email not verified. Please check your inbox for the verification link.',
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Client ID received in PasswordPage: ${widget.cid}"); // DEBUG PRINT
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top illustration
                  const SizedBox(height: 72),
                  SvgPicture.asset(
                    'assets/icons/password.svg',
                    height: 200,
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    'Next, create your Password',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'It will protect your account',
                    style: GoogleFonts.roboto(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // Password Requirements
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: _hasMinLength ? Colors.green[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _hasMinLength ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: _hasMinLength ? Colors.green : Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '8 characters',
                                style: GoogleFonts.roboto(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: _hasCapitalLetter ? Colors.green[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _hasCapitalLetter ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: _hasCapitalLetter ? Colors.green : Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '1 Capital letter',
                                style: GoogleFonts.roboto(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: _hasNumber ? Colors.green[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _hasNumber ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: _hasNumber ? Colors.green : Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '1 Number',
                                style: GoogleFonts.roboto(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),

                  // Password TextField
                  AuthTextField(
                    hintText: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: (_) => setState(() {widget.password = _passwordController.text;}),
                  ),

                  // Confirm Password
                  AuthTextField(
                    hintText: 'Confirm Password',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    onChanged: (_) => setState(() {}), // Trigger rebuild to update button state
                  ),
                  const SizedBox(height: 24),

                  // Sign Up Button
                  AuthButton(
                    label: 'Sign Up',
                    onPressed: () async {
                      _signUserUp();
                    },
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    isEnabled: _isPasswordValid, // Only enable when password is valid
                  ),
                  const SizedBox(height: 24),



                  // Already have an account? Log in
                  AuthFooter(
                    primaryColor: AppColors.primary, // Use centralized color
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