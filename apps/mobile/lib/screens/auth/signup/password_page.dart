import 'dart:developer';

import 'package:armm_app/client_info.dart';
import 'package:armm_app/database/auth_helper.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/screens/auth/auth.dart';
import 'package:armm_app/screens/dashboard/home_page.dart';
import 'package:armm_app/signup_data.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatefulWidget {
  final SignUpData signUpData;

  const PasswordPage({Key? key, required this.signUpData}) : super(key: key);

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

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasCapitalLetter => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'\d'));

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
        email: widget.signUpData.email,
        password: _passwordController.text,
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(code: 'operation-not-allowed');
      }

      log('UserCredential created: ${userCredential.user!.uid}. In buffer.');

      // Initialize database service with CID.
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

      // Send email verification.
      User? user = FirebaseAuth.instance.currentUser;
      
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
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      await handleFirebaseAuthException(context, e, widget.signUpData.email);
    } catch (e) {
      log('Error signing user up: $e', stackTrace: StackTrace.current);
      await FirebaseAuth.instance.currentUser?.delete();
    } finally {
      setState(() { isLoading = false; });
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

      await updateFirebaseMessagingToken(user, context);

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
      appState = Provider.of<AuthState>(context, listen: false) as AuthService;
      setState(() {
        isLoading = false;
      });

      await Navigator.of(context)
          .pushNamedAndRemoveUntil('/dashboard', (route) => false);

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
      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

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
              child: Placeholder(), // Replace with an image or illustration
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Next, create your Password',
              style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'It will protect your account',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                fillColor: const Color(0xFFF0F0F0),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Password Requirements
            Row(
              children: [
                Icon(
                  _hasMinLength ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: _hasMinLength ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                const Text('Minimum 8 characters'),
              ],
            ),
            Row(
              children: [
                Icon(
                  _hasCapitalLetter ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: _hasCapitalLetter ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                const Text('Minimum 1 Capital letter'),
              ],
            ),
            Row(
              children: [
                Icon(
                  _hasNumber ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: _hasNumber ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                const Text('Minimum 1 Number'),
              ],
            ),
            const SizedBox(height: 16),

            // Confirm Password
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                fillColor: const Color(0xFFF0F0F0),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () async {
                  _signUserUp();
                },
              child: const Text('Sign Up'),
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

