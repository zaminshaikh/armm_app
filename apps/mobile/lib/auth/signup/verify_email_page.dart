import 'dart:developer';

import 'package:armm_app/auth/auth_utils/auth_button.dart';
import 'package:armm_app/auth/onboarding/onboarding_page.dart';
import 'package:armm_app/auth/signup/client_id_page.dart';
import 'package:armm_app/auth/signup/profile_picture_page.dart';
import 'package:armm_app/auth_check.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/components/custom_progress_indicator.dart';
import 'package:armm_app/components/success_check_mark.dart';
import 'package:armm_app/database/database.dart';
import 'package:armm_app/utils/resources.dart'; // For AppColors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmailPage extends StatefulWidget {
  final String cid; // Client ID passed from the previous step

  const VerifyEmailPage({Key? key, required this.cid}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _showSuccessAnimation = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _animationController;
  late Animation<double> _animation;

  User? get _currentUser => _auth.currentUser;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    
    // Check if user is null
    if (_currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const OnboardingPage()),
            (route) => false,
          );
        }
      });
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _showErrorDialog(String title, String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: title,
        message: message,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showSuccessDialog(String title, String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: title,
        message: message,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _resendVerificationEmail() async {
    if (_currentUser == null) {
      await _showErrorDialog('Error', 'No user logged in. Please restart the app.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _currentUser!.sendEmailVerification();
      await _showSuccessDialog('Email Sent',
          'A new verification email has been sent to ${_currentUser!.email}. Please check your inbox (and spam folder).');
    } catch (e) {
      log('Error resending verification email: $e', error: e);
      await _showErrorDialog('Error Sending Email',
          'Failed to send verification email. Please try again later.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _clearCidAndMaybeUser(bool deleteUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cid');
    log('Cleared CID from SharedPreferences.');

    if (deleteUser && _currentUser != null) {
      try {
        String? userEmailForLog = _currentUser!.email;
        String? uidForLog = _currentUser!.uid; // Capture UID before deletion
        await _currentUser!.delete();
        log('Firebase user (email: $userEmailForLog, uid: $uidForLog) deleted.');
      } catch (e) {
        log('Error deleting Firebase user: $e', error: e);
        String errorMessage = 'Could not automatically clear your previous session. This might require a recent sign-in. Please try signing out from app settings if issues persist, or contact support.';
        if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
            errorMessage = 'Deleting your old session requires a recent sign-in. Please sign out and sign back in to resolve this, or contact support if you continue to see this message.';
        }
        if (mounted) {
          await _showErrorDialog('Action Incomplete', errorMessage);
        }
      }
    }
  }

  Future<void> _useDifferentClientID() async {
    if (!mounted) return;
    final String userEmail = _currentUser?.email ?? "your current account";
    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Change Client ID?',
        message: 'This will delete your current unverified account ($userEmail) and you will start the Client ID entry again. Are you sure?',
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Proceed')),
        ],
      ),
    );

    if (shouldProceed == true) {
      setState(() => _isLoading = true);
      await _clearCidAndMaybeUser(true); 
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ClientIDPage()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _useDifferentEmail() async {
    if (!mounted) return;
    final String userEmail = _currentUser?.email ?? "your current account";
    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Change Email?',
        message: 'This will delete your current unverified account ($userEmail) and you will start the sign-up process again. Are you sure?',
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Proceed')),
        ],
      ),
    );

    if (shouldProceed == true) {
      setState(() => _isLoading = true);
      await _clearCidAndMaybeUser(true); 
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _continueAfterVerification() async {
    if (_currentUser == null) {
      await _showErrorDialog('Error', 'No user logged in. Please restart the app.');
      return;
    }

    setState(() => _isLoading = true);
    User? freshUser = _currentUser;
    try {
      await freshUser!.reload();
      freshUser = _auth.currentUser; 
    } catch (e) {
        log('Error reloading user: $e', error: e);
        await _showErrorDialog('Error', 'Could not refresh your session. Please check your internet connection and try again.');
        if (mounted) setState(() => _isLoading = false);
        return;
    }

    if (freshUser == null) {
      log('User became null after reload.');
      await _showErrorDialog('Session Error', 'Your session seems to have expired. Please try signing in again.');
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const OnboardingPage()),
            (route) => false,
        );
      }
      return;
    }

    if (freshUser.emailVerified) {
      log('Email is verified for user ${freshUser.uid}. Attempting to link UID to CID: ${widget.cid}');
      DatabaseService dbService = DatabaseService.withCID(freshUser.uid, widget.cid);
      
      bool linkedSuccessfully = false;
      try {
        // Use the existing linkNewUser method from DatabaseService
        await dbService.linkNewUser(freshUser.email ?? '');
        linkedSuccessfully = true;
      } catch (e) {
        log('Error during DatabaseService.linkNewUser: $e', error: e);
        await _showErrorDialog('Database Error', 'An error occurred while trying to link your account. Please try again or contact support.');
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      if (linkedSuccessfully) {
        // Show success animation before navigating
        if (mounted) {
          setState(() {
            _isLoading = false;
            _showSuccessAnimation = true;
          });
          
          // Play the animation
          _animationController.forward();
          
          // Wait for the animation to complete before navigating
          await Future.delayed(const Duration(milliseconds: 1200));
          
          if (mounted) {
            log('UID ${freshUser.uid} successfully linked to CID ${widget.cid}. Navigating to Profile Picture Page.');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => ProfilePicturePage(cid: widget.cid, email: freshUser?.email ?? '')),
              (route) => false,
            );
          }
        }
      } else {
        log('Failed to link UID ${freshUser.uid} to CID ${widget.cid}. linkUIDtoCID returned false.');
        await _showErrorDialog('Linking Failed',
            'We couldn\'t link your account to the Client ID ${widget.cid}. This CID might already be linked or is invalid. Please verify the CID or contact support.');
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      log('Email not verified for user ${freshUser.uid}.');
      await _showErrorDialog('Email Not Verified',
          'Your email (${freshUser.email}) is still not verified. Please check your inbox for the verification email (also check spam folder) or request a new one.');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null && !_isLoading) {
      // Fallback for initState redirect not completing or user becoming null unexpectedly
      return const Scaffold(body: Center(child: CustomProgressIndicator()));
    }
    
    final String userEmail = _currentUser?.email ?? 'your email';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    // Email Verification Icon
                    Container(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryLight.withOpacity(0.1),
                            ),
                          ),
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryLight.withOpacity(0.2),
                            ),
                            child: Icon(
                              Icons.email_outlined,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Almost There!',
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.black87, 
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'A verification email was sent to '),
                          TextSpan(text: userEmail, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          const TextSpan(text: '.\nPlease click the link in the email to verify your account.\n\n'),
                          const TextSpan(text: 'You previously entered Client ID: '),
                          TextSpan(text: widget.cid, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          const TextSpan(text: '.\nOnce your email is verified, we will link it to this Client ID.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    AuthButton(
                      label: "Check Verification Status",
                      onPressed: _continueAfterVerification,
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      borderColor: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _resendVerificationEmail,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        textStyle: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: const Text('Resend Verification Email'),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Problem with this setup?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            icon: const Icon(Icons.key_outlined, size: 20),
                            label: const Text('Use a different Client ID'),
                            onPressed: _useDifferentClientID,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFE62C2D),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              textStyle: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.email_outlined, size: 20),
                            label: const Text('Use a different Email Address'),
                            onPressed: _useDifferentEmail,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFE62C2D),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              textStyle: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            const CustomProgressIndicator(),
          if (_showSuccessAnimation)
            SuccessCheckMark(
              animation: _animation,
            ),
        ],
      ),
    );
  }
}