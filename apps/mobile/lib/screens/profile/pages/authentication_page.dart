// ignore_for_file: deprecated_member_use, use_build_context_synchronously, duplicate_ignore, prefer_expression_function_bodies, unused_catch_clause, empty_catches, library_private_types_in_public_api

import 'package:armm_app/database/database.dart';
import 'package:armm_app/utils/app_bar.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);
  
  @override
  // ignore: library_private_types_in_public_api
  _AuthenticationPageState createState() => _AuthenticationPageState();
} 
class _AuthenticationPageState extends State<AuthenticationPage> {
  final Future<void> _initializeWidgetFuture = Future.value();

  // Database service instance
  DatabaseService? _databaseService;

  String? cid;

  @override
  void initState() {
    super.initState();
    _loadSelectedTimeOption();
    _loadAppLockState();
  }

  // Load the selected time option from SharedPreferences
  Future<void> _loadSelectedTimeOption() async {
    final prefs = await SharedPreferences.getInstance();
    final timeOption = prefs.getString('selectedTimeOption') ?? 'Immediately'; // Changed default to 'Immediately'
    context.read<AuthState>().setSelectedTimeOption(timeOption);
    print('Loaded selected time option: $timeOption');
  }

  // Save the selected time option to SharedPreferences
  Future<void> _saveSelectedTimeOption(String timeOption) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTimeOption', timeOption);
    context.read<AuthState>().setSelectedTimeOption(timeOption);
    print('Saved selected time option: $timeOption');
  }

  // Load the app lock state from SharedPreferences
  Future<void> _loadAppLockState() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('isAppLockEnabled') ?? false;
    context.read<AuthState>().setAppLockEnabled(isEnabled);
    print('Loaded app lock state: $isEnabled');
  }

  // Save the app lock state to SharedPreferences
  Future<void> _saveAppLockState(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAppLockEnabled', isEnabled);
    context.read<AuthState>().setAppLockEnabled(isEnabled);
    print('Saved app lock state: $isEnabled');
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _initializeWidgetFuture, // Initialize the database service
    builder: (context, snapshot) {
      return buildAuthenticationPage(context);
    }
  );

  Scaffold buildAuthenticationPage(BuildContext context) {
    final appState = Provider.of<AuthState>(context, listen: false);
  
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Authentication',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLockFeatureInfo(),
            if (appState.isAppLockEnabled) _buildSampleCupertinoListSection(),
          ],
        ),
      ),
    );
  }

  Column _buildLockFeatureInfo() {
    return Column(
      children: [
        // Container for the app lock toggle
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(25.0), // increased overall padding
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/auth.svg',
                  color: Colors.grey,
                  height: 40,
                  width: 40,
                ),
                const SizedBox(width: 15),
                Text(
                  'App Lock',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                  CupertinoSwitch(
                    value: context.watch<AuthState>().isAppLockEnabled,
                    onChanged: (bool value) {
                    context.read<AuthState>().setAppLockEnabled(value);
                    _saveAppLockState(value);
                    print('App lock enabled: $value');
                    },
                    activeColor: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.watch<AuthState>().isAppLockEnabled ? 'On' : 'Off',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Container for the description text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 218, 218, 219),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              'Each time you exit the app, a passcode or biometric authentication such as Face ID will be required to re-enter. '
              'To reduce how often you are prompted, you can set a timer below. '
              'Choose how much time should pass before a passcode or biometric authentication is requested again.',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSampleCupertinoListSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent, // Gray background
          borderRadius: BorderRadius.circular(12.0), // Rounded borders
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildCupertinoListTile('Immediately'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(color: CupertinoColors.separator, thickness: 1.5),
            ),
            _buildCupertinoListTile('1 minute'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(color: CupertinoColors.separator, thickness: 1.5),
            ),
            _buildCupertinoListTile('2 minute'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(color: CupertinoColors.separator, thickness: 1.5),
            ),
            _buildCupertinoListTile('5 minute'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(color: CupertinoColors.separator, thickness: 1.5),
            ),
            _buildCupertinoListTile('10 minute'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoListTile(String timeOption) {
    return CupertinoListTile(
      leading: SvgPicture.asset(
        'assets/icons/auth.svg',
        width: 24,
        height: 24,
        color: Colors.black,
      ),
      title: Text(
        timeOption,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        setState(() {
          context.read<AuthState>().setSelectedTimeOption(timeOption);
          _saveSelectedTimeOption(timeOption);
        });
        print('Selected time option: $timeOption');
      },
      trailing: context.watch<AuthState>().selectedTimeOption == timeOption
          ? const Icon(Icons.check_rounded, color: Colors.black)
          : null,
    );
  }
}