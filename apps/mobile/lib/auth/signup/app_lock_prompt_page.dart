import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';

class AppLockPromptPage extends StatefulWidget {
  const AppLockPromptPage({Key? key}) : super(key: key);

  @override
  _AppLockPromptPageState createState() => _AppLockPromptPageState();
}

class _AppLockPromptPageState extends State<AppLockPromptPage> {
  bool _isAppLockEnabled = false;
  bool _isNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAppLockEnabled = prefs.getBool('isAppLockEnabled') ?? false;
      _isNotificationsEnabled = prefs.getBool('isNotificationsEnabled') ?? false;
    });
  }

  Future<void> _onToggle(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    if (key == 'isAppLockEnabled') {
      context.read<AuthState>().setAppLockEnabled(value);
    }
    setState(() {
      if (key == 'isAppLockEnabled') _isAppLockEnabled = value;
      if (key == 'isNotificationsEnabled') _isNotificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: Color.fromARGB(255, 102, 102, 102),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Back',
                                  style: GoogleFonts.inter(fontSize: 14, color: Color.fromARGB(255, 102, 102, 102)),
                                ),
                              ],
                            ),
                          )
                        ),
                      const SizedBox(height: 16),
                      Text(
                        'App Lock & Notifications',
                        style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
                        softWrap: true,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Configure your app lock and notifications settings here.',
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
                        softWrap: true,
                      ),
                      ],
                    ),
                    ),
                ]
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                    SvgPicture.asset(
                    'assets/icons/auth.svg', 
                    width: 24, 
                    height: 24,
                    color: Colors.black,
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'App Lock',
                          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Secure your app with biometrics, such as Face ID.',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  CupertinoSwitch(
                    value: _isAppLockEnabled,
                    onChanged: (v) => _onToggle('isAppLockEnabled', v),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SvgPicture.asset('assets/icons/notification.svg', width: 24, height: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Receive alerts when a transaction has occured or if a statement has been uploaded to your account.',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  CupertinoSwitch(
                    value: _isNotificationsEnabled,
                    onChanged: (v) => _onToggle('isNotificationsEnabled', v),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
