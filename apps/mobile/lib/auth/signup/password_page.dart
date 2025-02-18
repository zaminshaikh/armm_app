<<<<<<< HEAD
// ignore_for_file: must_be_immutable, library_private_types_in_public_api

=======
>>>>>>> 07991de (Fixed UI of all Auth pages)
import 'dart:developer';

import 'package:armm_app/auth/auth_utils/auth_back.dart';
import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/auth_utils/auth_functions.dart';
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/auth/auth_utils/auth_footer.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:armm_app/auth/login/login.dart';
<<<<<<< HEAD
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/database/auth_helper.dart';
import 'package:armm_app/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PasswordPage extends StatefulWidget {
  final String cid;
  final String email;
  String password = '';

  PasswordPage({super.key, required this.cid, required this.email});
=======
=======
import 'package:armm_app/auth/login/login.dart';
>>>>>>> 3ee0730 (Enhance authentication flow by adding Client ID page routes)
import 'package:armm_app/client_info.dart';
=======
import 'package:armm_app/profile.dart';
>>>>>>> 05a2cb1 (Profile Page UI Elements Have Been Added)
import 'package:armm_app/database/auth_helper.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/screens/dashboard/home_page.dart';
import 'package:armm_app/signup_data.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatefulWidget {
  final SignUpData signUpData;

  const PasswordPage({Key? key, required this.signUpData}) : super(key: key);
>>>>>>> 07991de (Fixed UI of all Auth pages)

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

<<<<<<< HEAD
  final bool _obscurePassword = true;
  final bool _obscureConfirmPassword = true;
=======
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
>>>>>>> 07991de (Fixed UI of all Auth pages)

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasCapitalLetter => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'\d'));

<<<<<<< HEAD

  @override
  void initState() {
    super.initState();
    log("Email received in PasswordPage: ${widget.email}");
    log("CID received in PasswordPage: ${widget.cid}");
  }
=======
  int _passwordSecurityIndicator = 0;
>>>>>>> 07991de (Fixed UI of all Auth pages)

  /// Check if the user is authenticated and linked
  Future<bool> isAuthenticated() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    String uid = user.uid;
<<<<<<< HEAD
    DatabaseService db = DatabaseService(uid);
    bool isLinked = await db.isUIDLinked(uid);
    return isLinked;
  }

  /// Validate password requirements
  bool _validatePassword() {
    if (!_hasMinLength || !_hasCapitalLetter || !_hasNumber) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Password Requirements'),
          content: const Text('Your password must have at least 8 characters, 1 capital letter, and 1 number.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Password Mismatch'),
          content: const Text('Passwords do not match. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
      return false;
    }

    return true;
  }

  /// Handles the sign-up process.
  void _signUserUp() async {
    // First validate password requirements
    if (!_validatePassword()) return;

=======

    DatabaseService db = DatabaseService(uid);

    bool isLinked = await db.isUIDLinked(uid);

    return isLinked;
  }

  /// Handles the sign-up process.
  void _signUserUp() async {
>>>>>>> 07991de (Fixed UI of all Auth pages)
    setState(() { isLoading = true; });
    // Delete any existing user in the buffer.
    await deleteUserInBuffer();

    try {
      // Create a new user with email and password.
<<<<<<< HEAD
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
=======
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.signUpData.email,
>>>>>>> 07991de (Fixed UI of all Auth pages)
        password: _passwordController.text,
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(code: 'operation-not-allowed');
      }

      log('UserCredential created: ${userCredential.user!.uid}. In buffer.');

      // Initialize database service with CID.
<<<<<<< HEAD
      db = DatabaseService.withCID(userCredential.user!.uid, widget.cid);
=======
      db = DatabaseService.withCID(userCredential.user!.uid, widget.signUpData.cid);

      // Check if CID exists and is not linked.
      if (!(await db.checkDocumentExists(widget.signUpData.cid))) {
        await _showErrorAndDeleteUser(
            'There is no record of the Client ID $widget.signUpData.cid in the database. Please contact support or re-enter your Client ID.');
        return;
      } else if (await db.checkDocumentLinked(widget.signUpData.cid)) {
        await _showErrorAndDeleteUser(
            'User already exists for given Client ID $widget.signUpData.cid. Please log in instead.');
        return;
      }
>>>>>>> 07991de (Fixed UI of all Auth pages)

      // Send email verification.
      User? user = FirebaseAuth.instance.currentUser;
      
<<<<<<< HEAD
      if (user != null) {
        await user.sendEmailVerification();
      } else {
        throw FirebaseAuthException(code: 'user-not-found');
      }

      // Show email verification dialog.
      if (!mounted) return;
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
        title: const Text('Verify your email'),
        content: const Text('A verification link has been sent to your email. Please verify your email to continue.'),
        actions: [
          TextButton(
            onPressed: () async {
          Navigator.of(context).pop();
          await _verifyEmail();
            },
            child: const Text('Continue'),
          ),
        ],
=======
      if (user == null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.signUpData.email,
          password: widget.signUpData.password,
        );
      }

      user = FirebaseAuth.instance.currentUser;

      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      // Show email verification dialog.
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Verify your email'),
            content: const Text('A verification link has been sent to your email. Please verify your email to continue.'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _verifyEmail();
                },
                child: const Text('Continue'),
              ),
            ],
>>>>>>> 07991de (Fixed UI of all Auth pages)
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
<<<<<<< HEAD
      await handleFirebaseAuthException(context, e, widget.email);
    } catch (e) {
      log('Error signing user up: $e', stackTrace: StackTrace.current);
      await FirebaseAuth.instance.currentUser?.delete();
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              )
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() { isLoading = false; });
=======
      await handleFirebaseAuthException(context, e, widget.signUpData.email);
    } catch (e) {
      log('Error signing user up: $e', stackTrace: StackTrace.current);
      await FirebaseAuth.instance.currentUser?.delete();
    } finally {
      setState(() { isLoading = false; });
>>>>>>> 07991de (Fixed UI of all Auth pages)
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
<<<<<<< HEAD
<<<<<<< HEAD
      await db.linkNewUser(user.email!);
      log('User $uid connected to Client ID ${widget.cid}');
=======
      await db.f_linkNewUser(user.email!);
=======
      await db.linkNewUser(user.email!);
>>>>>>> b8aafa4 (Refactor authentication utility methods to remove 'f_' prefix for consistency)
      log('User $uid connected to Client ID $widget.signUpData.cid');
>>>>>>> 07991de (Fixed UI of all Auth pages)

      // await updateFirebaseMessagingToken(user, context);

      if (!mounted) return true;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Email verified successfully.'),
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
      if (!mounted) return true;
<<<<<<< HEAD
<<<<<<< HEAD
=======
      appState = Provider.of<AuthState>(context, listen: false) as AuthService;
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
      // appState = Provider.of<AuthService>(context, listen: false);
>>>>>>> 2fa08e3 (Remove unused appState assignment in password_page.dart causing exception.)
      setState(() {
        isLoading = false;
      });

<<<<<<< HEAD
<<<<<<< HEAD
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
=======
      await Navigator.of(context)
          .pushNamedAndRemoveUntil('/dashboard', (route) => false);
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage( cid: widget.signUpData.password,)),
        );
>>>>>>> a4dfb16 (Replace navigation method in password_page.dart to use pushReplacement for better user experience)

      return true;
    } else {
      if (!mounted) return false;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Email not verified. Please check your inbox for the verification link.'),
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
<<<<<<< HEAD
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
=======
      setState(() {
        isLoading = false;
      });
>>>>>>> 07991de (Fixed UI of all Auth pages)
      return false;
    }
  }

<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
=======
  /// Shows an error dialog and deletes the current user.
  Future<void> _showErrorAndDeleteUser(String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
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
    await FirebaseAuth.instance.currentUser?.delete();
    log('Error: $message');
  }

  @override
  Widget build(BuildContext context) {
    print("Client ID received in PasswordPage: ${widget.signUpData.cid}"); // DEBUG PRINT
>>>>>>> 07991de (Fixed UI of all Auth pages)
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
<<<<<<< HEAD
                // ...existing code...
=======
                mainAxisAlignment: MainAxisAlignment.center,
>>>>>>> 07991de (Fixed UI of all Auth pages)
                children: [
                  // Top illustration
                  const SizedBox(height: 72),
                  SvgPicture.asset(
                    'assets/icons/password.svg',
                    height: 200,
                  ),
                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    'Next, create your Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    'It will protect your account',
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
                              const Text(
                                'Minimum\n8 characters',
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
                              const Text(
                                'Minimum\n1 Capital letter',
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
                              const Text(
                                'Minimum\n1 Number',
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
<<<<<<< HEAD
                    onChanged: (_) => setState(() {widget.password = _passwordController.text;}),
=======
                    onChanged: (_) => setState(() {}),
>>>>>>> 07991de (Fixed UI of all Auth pages)
                  ),

                  // Confirm Password
                  AuthTextField(
                    hintText: 'Confirm Password',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                  ),
                  const SizedBox(height: 24),

                  // Sign Up Button
<<<<<<< HEAD
                  isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ARMM_Blue),
                        )
                      : AuthButton(
                          label: 'Sign Up',
                          onPressed: _signUserUp,
                          backgroundColor: ARMM_Blue,
                          foregroundColor: Colors.white,
                        ),
=======
                  AuthButton(
                    label: 'Sign Up',
                    onPressed: () async {
                      _signUserUp();
                    },
                    backgroundColor: ARMM_Blue,
                    foregroundColor: Colors.white,
                  ),
>>>>>>> 07991de (Fixed UI of all Auth pages)
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
                          builder: (context) => const LoginPage(),
                        ),
                      );
=======
                      // Navigate to login
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
<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> 07991de (Fixed UI of all Auth pages)
=======

>>>>>>> 3ee0730 (Enhance authentication flow by adding Client ID page routes)
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