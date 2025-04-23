import 'package:app_settings/app_settings.dart';
import 'package:armm_app/auth/auth_utils/open_mail_app.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/screens/profile/components/delete_account_button.dart';
import 'package:armm_app/utils/app_bar.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:armm_app/screens/profile/components/logout_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:armm_app/components/custom_progress_indicator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Client? client;
  bool notifsSwitchValue = false;

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
  }

  Future<void> _checkNotificationPermission() async {
    var status = await Permission.notification.status;
    setState(() {
      notifsSwitchValue = status.isGranted;
    });
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Notifications Disabled',
          message: 'Please enable notifications in your device settings to receive updates.',
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openAppSettings();
              },
              child: const Text('Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.request();

    if (status.isGranted) {
      setState(() {
        notifsSwitchValue = true;
      });
      await _saveSwitchValue(notifsSwitchValue);
      _showCupertinoDialog('Notifications enabled');
    } else {
      _showCupertinoDialog('Notification permission denied. Please enable it in settings.');
    }
  }

  void _showCupertinoDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Notification Permission',
          message: message,
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            if (message.contains('denied'))
              TextButton(
                child: const Text('Settings'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _openAppSettings();
                },
              ),
          ],
        );
      },
    );
  }

  Future<void> _openAppSettings() async {
    await AppSettings.openAppSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client?>(context);
    _loadSwitchValue();
  }

  Future<void> _loadSwitchValue() async {
    final prefs = await SharedPreferences.getInstance();
    bool savedValue = prefs.getBool('notifsSwitchValue') ?? false;
    setState(() {
      notifsSwitchValue = savedValue;
    });
  }

  Future<void> _saveSwitchValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifsSwitchValue', value);
  }

  @override
  Widget build(BuildContext context) {
    return buildSettingsPage();
  }

  Scaffold buildSettingsPage() {
    if (client == null) {
      return const Scaffold(
        body: CustomProgressIndicator(
          shouldTimeout: true,
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(
      title: 'Settings',
      implyLeading: true,
      showNotificationButton: false,
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: _settings(),
      ),
      ),
    );
    }


  Column _settings() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                _buildNotificationsSection(),
                const SizedBox(height: 20),
                _buildSecuritySection(),
                const SizedBox(height: 40),
                _buildLogoutSection(),
                const SizedBox(height: 40),
                _buildDeleteAccountSection(),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      );

  Widget _buildNotificationsSection() {
    return Container(
      // Container decoration replaces Card styling
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color.fromARGB(50, 0, 0, 0), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title Text
            Text(
              'Notifications',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Description Text
            Text(
              'Let me know about new activities and statements within my portfolio.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Color.fromARGB(200, 0, 0, 0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Toggle Row with "Off" and "On" labels
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 8),
                CupertinoSwitch(
                  value: notifsSwitchValue,
                  activeColor: CupertinoColors.activeBlue,
                  onChanged: (bool value) async {
                    if (value) {
                      var settings = await FirebaseMessaging.instance.requestPermission(
                        alert: true,
                        badge: true,
                        sound: true,
                      );
                      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
                        setState(() {
                          notifsSwitchValue = true;
                        });
                        await _saveSwitchValue(true);
                        // Additional logic for enabling notifications if needed.
                      } else {
                        _showPermissionDeniedDialog();
                        setState(() {
                          notifsSwitchValue = false;
                        });
                        await _saveSwitchValue(false);
                      }
                    } else {
                      setState(() {
                        notifsSwitchValue = false;
                      });
                      await _saveSwitchValue(false);
                      // Additional logic for disabling notifications if needed.
                    }
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  notifsSwitchValue ? 'On' : 'Off',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color.fromARGB(50, 0, 0, 0), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Security Title
            Text(
              'Security',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Display current user email
            Text(
              FirebaseAuth.instance.currentUser?.email ?? '',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Include change email section/button
            _buildChangeEmailSection(),
            const SizedBox(height: 16),
            // Include change password section/button
            _buildChangePasswordSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeEmailSection() {
    return GestureDetector(
      onTap: () {
        // Capture the parent context
        final parentContext = context;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController emailController = TextEditingController();
  
            Widget buildCloseButton(BuildContext context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // This spreads elements to both edges
                children: [
                  Text(
                    'Change Email',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[700]),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            }
  
            Widget buildEmailInputSection(TextEditingController controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your new email',
                      hintStyle: GoogleFonts.inter(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF2B41B8),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 14,
                      ),
                    ),
                  ),
                ],
              );
            }
  
            Widget buildContinueButton(BuildContext context, TextEditingController emailController) {
              // Add password controller
              TextEditingController passwordController = TextEditingController();
              
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();

                    String newEmail = emailController.text.trim();
                    bool isValidEmail = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(newEmail);
                    
                    if (!isValidEmail) {
                      if (parentContext.mounted) {
                        showDialog(
                          context: parentContext,
                          builder: (context) => CustomAlertDialog(
                            title: 'Invalid Email',
                            message: 'Please enter a valid email address.',
                            actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('OK'),
                            ),
                            ],
                          ),
                        );
                      }
                      return;
                    }
                    // First check how the user is authenticated
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      List<String> providers = [];
                      for (var info in user.providerData) {
                        providers.add(info.providerId);
                      }
                      
                      // Check if user is OAuth authenticated
                      if (providers.contains('apple.com')) {
                        if (parentContext.mounted) {
                          showDialog(
                            context: parentContext,
                            builder: (context) => CustomAlertDialog(
                              title: 'Cannot Change Email',
                              message: 'You signed up with Apple. Please update your email through your Apple ID settings. Alternatively, you may delete your account and resign up if you wish to continue with a different email.',
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
                            ),
                          );
                        }
                        return;
                      } else if (providers.contains('google.com')) {
                        if (parentContext.mounted) {
                          showDialog(
                            context: parentContext,
                            builder: (context) => CustomAlertDialog(
                              title: 'Cannot Change Email',
                              message: 'You signed up with Google. Please update your email through your Google Account settings. Alternatively, you may delete your account and resign up if you wish to continue with a different email.',
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
                            ),
                          );
                        }
                        return;
                      }
                    }
                    // First ask for password to re-authenticate
                    await showDialog(
                      context: parentContext,
                      builder: (context) => CustomAlertDialog(
                        title: 'Verification Required',
                        message: 'Please enter your current password to verify your identity.',
                        input: Container(
                          width: 300, // Fixed width that should fit in the dialog
                          child: TextField(
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Current password',
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Verify'),
                          ),
                        ],
                      ),
                    ).then((confirmed) async {
                      if (confirmed == true) {
                      try {
                        // Validate email first
                        String newEmail = emailController.text.trim();
                        
                        // Get current user
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null && user.email != null) {
                        // Re-authenticate user with current email and provided password
                        AuthCredential credential = EmailAuthProvider.credential(
                          email: user.email!, 
                          password: passwordController.text
                        );
                        await user.reauthenticateWithCredential(credential);
                        
                        // Now proceed with email change
                        await user.verifyBeforeUpdateEmail(newEmail);
                        
                        // Show success dialog
                        if (parentContext.mounted) {
                          Navigator.of(parentContext).pop(); // Close email change dialog
                          showDialog(
                          context: parentContext,
                          builder: (context) => CustomAlertDialog(
                            title: 'Email Change Requested',
                            message: 'We have sent a verification email to your new email address. Please verify it to complete the update.',
                            actions: [
                              TextButton(onPressed: () => openMailApp(parentContext), child: const Text('Open Mail App'))
                            ],
                          ),
                          );
                        }
                        }
                      } catch (e) {
                        // Show error dialog
                        if (parentContext.mounted) {
                          String errorMessage = 'An error occurred while updating your email.';

                          // Check Firebase Auth error codes
                          if (e is FirebaseAuthException) {
                            switch (e.code) {
                              case 'requires-recent-login':
                                errorMessage = 'Please log out and log back in to update your email.';
                                break;
                              case 'email-already-in-use':
                                errorMessage = 'This email is already in use by another account.';
                                break;
                              case 'invalid-email':
                                errorMessage = 'The email address is invalid.';
                                break;
                              case 'wrong-password':
                                errorMessage = 'Incorrect password. Please try again.';
                                break;
                              case 'too-many-requests':
                                errorMessage = 'Too many attempts. Please try again later.';
                                break;
                              case 'network-request-failed':
                                errorMessage = 'Network error. Please check your connection.';
                                break;
                              case 'user-mismatch':
                                errorMessage = 'The credential does not match the user you\'re trying to update.';
                                break;
                              case 'user-not-found':
                                errorMessage = 'No user found for the provided email.';
                                break;
                              case 'invalid-credential':
                                errorMessage = 'The credential provided is invalid or has expired. The password entered may be incorrect.';
                                break;
                              case 'invalid-verification-code':
                                errorMessage = 'The verification code is invalid.';
                                break;
                              case 'invalid-verification-id':
                                errorMessage = 'The verification ID is invalid.';
                                break;
                              case 'missing-android-pkg-name':
                                errorMessage = 'An Android package name is required for this operation.';
                                break;
                              case 'missing-continue-uri':
                                errorMessage = 'A continue URL must be provided for this operation.';
                                break;
                              case 'missing-ios-bundle-id':
                                errorMessage = 'An iOS bundle ID is required for this operation.';
                                break;
                              case 'invalid-continue-uri':
                                errorMessage = 'The continue URL provided is invalid.';
                                break;
                              case 'unauthorized-continue-uri':
                                errorMessage = 'The domain of the continue URL is not whitelisted.';
                                break;
                              default:
                                errorMessage = 'Authentication failed: ${e.message}';
                            }
                          } else {
                            errorMessage = 'Error: ${e.toString()}';
                          }

                          log('settings.dart: Error updating email: $errorMessage');

                          showDialog(
                            context: parentContext,
                            builder: (context) => CustomAlertDialog(
                              title: 'Email Change Failed',
                              message: errorMessage,
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(parentContext).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    }
                  });
                },
                  // Rest of the button styling remains the same
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B41B8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }
            return CustomAlertDialog(
              title: 'Change Email',
              message: 'Update the email associated with your account.',
              icon: null,
              actions: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildEmailInputSection(emailController),
                    const SizedBox(height: 24),
                    buildContinueButton(context, emailController),
                  ],
                ),
              ],
            );
          },
        );
      },
      
      
      
      
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            'Change Email',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildChangePasswordSection() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController passwordController = TextEditingController();
            
            Widget buildPasswordInputSection(TextEditingController controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'You are changing the password associated with your account.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Password',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    obscureText: true,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your new password',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 14,
                      ),
                    ),
                  ),
                ],
              );
            }
            
            Widget buildContinueButton(BuildContext context, TextEditingController controller) {
              return ElevatedButton(
                onPressed: () async {
                  try {
                    String newPassword = controller.text.trim();
                    var user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user.updatePassword(newPassword);
                      // Dismiss the change password dialog first
                      Navigator.of(context).pop();
                      // Then show the success dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomAlertDialog(
                            title: 'Password Change Requested',
                            message: 'Your password has been successfully updated.',
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } catch (e) {
                    log('settings.dart: Error updating password: $e');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomAlertDialog(
                          title: 'Error',
                          message: 'Error updating password: $e',
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 30, 75, 137),
                  splashFactory: NoSplash.splashFactory,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }
            
            return CustomAlertDialog(
              title: 'Change Password',
              message: 'You are changing the password associated with your account.',
              actions: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildPasswordInputSection(passwordController),
                    const SizedBox(height: 24),
                    buildContinueButton(context, passwordController),
                  ],
                ),
              ],
            );
          },
        );
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            'Change Password',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Row with Title and Dividers
        Row(
          children: [
            // Left divider
            const Expanded(
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(50, 0, 0, 0),
              ),
            ),
            // Title in the center
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Delete Account',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Right divider
            const Expanded(
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(50, 0, 0, 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Subtitle text
        Text(
          'Delete your account. This action is irreversible.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Color.fromARGB(200, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 16),
        // Delete account button widget
        DeleteAccountButton(client: client!), 
      ],
    );
  }

  Widget _buildLogoutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Row with Title and Dividers
        Row(
          children: [
            // Left divider
            const Expanded(
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(50, 0, 0, 0),
              ),
            ),
            // Title in the center
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Log out',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Right divider
            const Expanded(
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(50, 0, 0, 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Subtitle text
        Text(
          'Log out of your account',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Color.fromARGB(200, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 16),
        // Logout button widget
        LogoutButton(
        ),
      ],
    );
  }

}

