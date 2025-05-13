import 'package:app_settings/app_settings.dart';
import 'package:armm_app/auth/auth_utils/open_mail_app.dart';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/database/auth_helper.dart';
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
                        // Optionally, you can show a dialog or a snackbar to inform the user
                        updateFirebaseMessagingToken(FirebaseAuth.instance.currentUser, context);
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
                      deleteFirebaseMessagingToken(FirebaseAuth.instance.currentUser, context);
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
        final parentContext = context;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController newEmailController = TextEditingController();
            TextEditingController currentPasswordController = TextEditingController();
            bool isFormValid = false;

            // Corrected: This function will now use the dialog's setState
            void validateFormFields(void Function(void Function()) dialogSetState) {
              final newEmail = newEmailController.text.trim();
              final currentPassword = currentPasswordController.text.trim();
              dialogSetState(() { // Use the passed-in setState
                isFormValid = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(newEmail) && currentPassword.isNotEmpty;
              });
            }

            Future<void> onContinuePressed() async {
              final newEmail = newEmailController.text.trim();
              final currentPassword = currentPasswordController.text.trim();

              // Close the dialog first
              Navigator.of(context).pop();

              if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(newEmail)) {
                if (parentContext.mounted) {
                  showDialog(
                    context: parentContext,
                    builder: (context) => CustomAlertDialog(
                      title: 'Invalid Email',
                      message: 'Please enter a valid email address.',
                      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
                    ),
                  );
                }
                return;
              }

              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                List<String> providers = user.providerData.map((info) => info.providerId).toList();
                if (providers.contains('apple.com') || providers.contains('google.com')) {
                  String providerName = providers.contains('apple.com') ? 'Apple' : 'Google';
                  if (parentContext.mounted) {
                    showDialog(
                      context: parentContext,
                      builder: (context) => CustomAlertDialog(
                        title: 'Cannot Change Email',
                        message: 'You signed up with $providerName. Please update your email through your $providerName ID settings. Alternatively, you may delete your account and resign up if you wish to continue with a different email.',
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
                      ),
                    );
                  }
                  return;
                }

                try {
                  if (user.email == null) {
                     if (parentContext.mounted) {
                        showDialog(
                          context: parentContext,
                          builder: (context) => CustomAlertDialog(
                            title: 'Error',
                            message: 'Your current email is not set.',
                            actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
                          ),
                        );
                      }
                    return;
                  }
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPassword,
                  );
                  await user.reauthenticateWithCredential(credential);
                  await user.verifyBeforeUpdateEmail(newEmail);

                  if (parentContext.mounted) {
                    showDialog( // Toast-like notification
                      context: parentContext,
                      builder: (context) => CustomAlertDialog(
                        title: 'Verification Email Sent',
                        message: 'A verification email has been sent to $newEmail. Please verify it to complete the update.',
                        actions: [TextButton(onPressed: () { Navigator.of(context).pop(); openMailApp(parentContext); }, child: const Text('Open Mail'))],
                      ),
                    );
                  }
                } catch (e) {
                  String errorMessage = 'An error occurred.';
                  if (e is FirebaseAuthException) {
                    switch (e.code) {
                      case 'requires-recent-login':
                        errorMessage = 'Please log out and log back in to update your email.';
                        break;
                      case 'email-already-in-use':
                        errorMessage = 'This email is already in use by another account.';
                        break;
                      case 'invalid-email':
                        errorMessage = 'The new email address is invalid.';
                        break;
                      case 'wrong-password':
                        errorMessage = 'Incorrect current password. Please try again.';
                        break;
                      case 'too-many-requests':
                        errorMessage = 'Too many attempts. Please try again later.';
                        break;
                      default:
                        errorMessage = e.message ?? 'An unknown error occurred.';
                    }
                  }
                  log('settings.dart: Error updating email: $errorMessage, code: ${e is FirebaseAuthException ? e.code : 'N/A'}');
                  if (parentContext.mounted) {
                    showDialog( // Toast-like notification
                      context: parentContext,
                      builder: (context) => CustomAlertDialog(
                        title: 'Email Change Failed',
                        message: errorMessage,
                        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
                      ),
                    );
                  }
                }
              }
            }

            return StatefulBuilder(
              builder: (context, dialogSetState) { // Ensure this dialogSetState is used for validateFormFields
                return Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        SvgPicture.asset(
                          'assets/icons/change_email.svg',
                          height: 180,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Change Email',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Enter your current password and new email address.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: currentPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Current Password',
                            hintStyle: GoogleFonts.inter(color: Colors.black54),
                            filled: true,
                            fillColor: Color(0xFFF2F3FA),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: GoogleFonts.inter(color: Colors.black),
                          onChanged: (value) => validateFormFields(dialogSetState), // Corrected
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: newEmailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'New Email',
                            hintStyle: GoogleFonts.inter(color: Colors.black54),
                            filled: true,
                            fillColor: Color(0xFFF2F3FA),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: GoogleFonts.inter(color: Colors.black),
                          onChanged: (value) => validateFormFields(dialogSetState), // Corrected
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isFormValid ? onContinuePressed : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: isFormValid ? AppColors.primary : Colors.grey[300]!,
                              disabledBackgroundColor: Colors.transparent, // Consider a less transparent color for disabled
                              side: BorderSide(
                                color: isFormValid ? AppColors.primary : Colors.grey[300]!,
                                width: 2,
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Continue',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isFormValid ? Colors.white : Colors.grey[600]!,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
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
        final parentContext = context;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController newPasswordController = TextEditingController();
            TextEditingController currentPasswordController = TextEditingController();
            bool isFormValid = false;

            // Local setState for the dialog
            void validateForm(void Function(void Function()) dialogSetState) {
              final newPassword = newPasswordController.text.trim();
              final currentPassword = currentPasswordController.text.trim();
              dialogSetState(() {
                isFormValid = newPassword.length >= 6 && currentPassword.isNotEmpty;
              });
            }

            Future<void> onContinuePressed() async {
              final newPassword = newPasswordController.text.trim();
              final currentPassword = currentPasswordController.text.trim();

              // Close the dialog first
              Navigator.of(context).pop();

              if (newPassword.length < 6) {
                if (parentContext.mounted) {
                  showDialog( // Toast-like notification
                    context: parentContext,
                    builder: (context) => CustomAlertDialog(
                      title: 'Invalid Password',
                      message: 'Password should be at least 6 characters.',
                      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
                    ),
                  );
                }
                return;
              }
              
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                List<String> providers = user.providerData.map((info) => info.providerId).toList();
                if (providers.contains('apple.com') || providers.contains('google.com')) {
                  String providerName = providers.contains('apple.com') ? 'Apple' : 'Google';
                  if (parentContext.mounted) {
                    showDialog(
                      context: parentContext,
                      builder: (context) => CustomAlertDialog(
                        title: 'Cannot Change Password',
                        message: 'You signed up with $providerName. Please manage your password through your $providerName ID settings.',
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
                      ),
                    );
                  }
                  return;
                }

                try {
                  if (user.email == null) {
                     if (parentContext.mounted) {
                        showDialog(
                          context: parentContext,
                          builder: (context) => CustomAlertDialog(
                            title: 'Error',
                            message: 'Your current email is not set. Cannot re-authenticate.',
                            actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
                          ),
                        );
                      }
                    return;
                  }
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPassword,
                  );
                  await user.reauthenticateWithCredential(credential);
                  await user.updatePassword(newPassword);
                  
                  if (parentContext.mounted) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      const SnackBar(
                        content: Text('Your password has been successfully updated.'),
                        duration: Duration(seconds: 3), // You can adjust the duration
                      ),
                    );
                  }
                } catch (e) {
                  String errorMessage = 'An error occurred.';
                  if (e is FirebaseAuthException) {
                    switch (e.code) {
                      case 'requires-recent-login':
                        errorMessage = 'Please log out and log back in to update your password.';
                        break;
                      case 'weak-password':
                        errorMessage = 'The new password is too weak.';
                        break;
                      case 'wrong-password':
                        errorMessage = 'Incorrect current password. Please try again.';
                        break;
                      case 'too-many-requests':
                        errorMessage = 'Too many attempts. Please try again later.';
                        break;
                      default:
                        errorMessage = e.message ?? 'An unknown error occurred.';
                    }
                  }
                  log('settings.dart: Error updating password: $errorMessage, code: ${e is FirebaseAuthException ? e.code : 'N/A'}');
                  if (parentContext.mounted) {
                    showDialog( // Toast-like notification for errors
                      context: parentContext,
                      builder: (BuildContext context) {
                        return CustomAlertDialog(
                          title: 'Password Change Failed',
                          message: errorMessage,
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              }
            }

            return StatefulBuilder(
              builder: (context, dialogSetState) { // Pass dialogSetState to validateForm
                return Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        SvgPicture.asset(
                          'assets/icons/change_password.svg', 
                          height: 180,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Change Password',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Enter your current password and new password.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: currentPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Current Password',
                            hintStyle: GoogleFonts.inter(color: Colors.black54),
                            filled: true,
                            fillColor: Color(0xFFF2F3FA),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: GoogleFonts.inter(color: Colors.black),
                          onChanged: (value) => validateForm(dialogSetState),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: newPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'New Password (min. 6 characters)',
                            hintStyle: GoogleFonts.inter(color: Colors.black54),
                            filled: true,
                            fillColor: Color(0xFFF2F3FA),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: GoogleFonts.inter(color: Colors.black),
                          onChanged: (value) => validateForm(dialogSetState),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isFormValid ? onContinuePressed : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: isFormValid ? AppColors.primary : Colors.grey[300]!,
                              disabledBackgroundColor: Colors.transparent,
                              side: BorderSide(
                                color: isFormValid ? AppColors.primary : Colors.grey[300]!,
                                width: 2,
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Continue',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isFormValid ? Colors.white : Colors.grey[600]!,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
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

