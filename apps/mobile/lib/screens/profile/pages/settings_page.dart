import 'package:app_settings/app_settings.dart';
import 'package:armm_app/screens/profile/components/delete_account_button.dart';
import 'package:armm_app/utils/app_bar.dart';
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
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            'Notifications Disabled',
            style: TextStyle(
              color: CupertinoColors.darkBackgroundGray,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: const Text(
            'Please enable notifications in your device settings to receive updates.',
            style: TextStyle(
              color: CupertinoColors.black,
              fontSize: 16,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: const Text(
                'Settings',
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openAppSettings();
              },
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
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Notification Permission'),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            if (message.contains('denied'))
              CupertinoDialogAction(
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
        body: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Settings',
              implyLeading: true,
              showNotificationButton: false,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: _settings(),
            ),
          ],
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
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title Text
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Description Text
            const Text(
              'Let me know about new activities and statements within my portfolio.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
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
                  style: const TextStyle(
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
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Security Title
            const Text(
              'Security',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Display current user email
            Text(
              FirebaseAuth.instance.currentUser?.email ?? '',
              style: const TextStyle(
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController emailController = TextEditingController();
  
            Widget buildCloseButton(BuildContext context) {
              return Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[700]),
                  onPressed: () => Navigator.pop(context),
                ),
              );
            }
  
            Widget buildEmailInputSection(TextEditingController controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Change Email',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Update the email associated with your account.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your new email',
                      hintStyle: TextStyle(color: Colors.grey[500]),
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
  
            Widget buildContinueButton(
                BuildContext context, TextEditingController controller) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      String newEmail = controller.text.trim();
                      var user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        // Send the verification email
                        await user.verifyBeforeUpdateEmail(newEmail);
                        // Dismiss the current dialog
                        Navigator.of(context).pop();
                        // Show the success dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Email Change Requested'),
                              content: const Text(
                                'We have sent a verification email to your new email address. Please verify it to complete the update.',
                              ),
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
                    } catch (e, stackTrace) {
                      log('settings_page.dart: Error updating email: $e');
                      log(stackTrace.toString());
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: Text('Error updating email: $e'),
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
                    backgroundColor: const Color(0xFF2B41B8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }


            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildCloseButton(context),
                    const SizedBox(height: 16),
                    buildEmailInputSection(emailController),
                    const SizedBox(height: 24),
                    buildContinueButton(context, emailController),
                  ],
                ),
              ),
            );
          },
        );
      },
      
      
      
      
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: const Center(
          child: Text(
            'Change Email',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
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
            Widget buildCloseButton(BuildContext context) {
              return Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.black),
                ),
              );
            }
            Widget buildIconArt() {
              return SvgPicture.asset(
                '',
              );
            }
            Widget buildPasswordInputSection(TextEditingController passwordController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Change Password',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You are changing the password associated with your account.',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Password',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        ),
                    decoration: InputDecoration(
                      hintText: 'Enter your new password',
                      hintStyle: TextStyle(
                          color: Colors.grey[400],
                          ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(
                            color: Colors.blue, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 14),
                    ),
                  ),
                ],
              );
            }
            Widget buildContinueButton(BuildContext context, TextEditingController passwordController) {
              return ElevatedButton(
                onPressed: () async {
                  try {
                    String newPassword = passwordController.text.trim();
                    var user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user.updatePassword(newPassword);
                      // Dismiss the change password dialog first
                      Navigator.of(context).pop();
                      // Then show the success dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Password Change Requested'),
                            content: const Text('Your password has been successfully updated.'),
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
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text('Error updating password: $e'),
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
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      ),
                ),
              );
            }
            AlertDialog buildsettingsDialog(BuildContext context, TextEditingController passwordController) {
              const Color ARMM_blue = Color(0xFF2B41B8);
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: ARMM_blue, width: 2),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Updated close button with ARMM blue color
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: ARMM_blue),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Keep the email/password input section as is
                      buildPasswordInputSection(passwordController),
                      const SizedBox(height: 20),
                      buildContinueButton(context, passwordController),
                    ],
                  ),
                ),
              );
            }
            return buildsettingsDialog(context, passwordController);
          },
        );
      },

      
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: const Center(
          child: Text(
            'Change Password',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
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
        const Row(
          children: [
            // Left divider
            Expanded(
              child: Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ),
            // Title in the center
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Right divider
            Expanded(
              child: Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Subtitle text
        const Text(
          'Delete your account. This action is irreversible.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        // Delete account button widget
        DeleteAccountButton(client: client!), 
      ],
    );
  }

  Widget _buildLogoutSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Row with Title and Dividers
        Row(
          children: [
            // Left divider
            Expanded(
              child: Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ),
            // Title in the center
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Log out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Right divider
            Expanded(
              child: Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        // Subtitle text
        Text(
          'Log out of your account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16),
        // Logout button widget
        LogoutButton(),
      ],
    );
  }

}

