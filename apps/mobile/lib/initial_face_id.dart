// ignore_for_file: library_private_types_in_public_api, empty_catches, use_build_context_synchronously

import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:google_fonts/google_fonts.dart';

class InitialFaceIdPage extends StatefulWidget {
  const InitialFaceIdPage({super.key});

  @override
  _InitialFaceIdPageState createState() => _InitialFaceIdPageState();
}

class _InitialFaceIdPageState extends State<InitialFaceIdPage>
    with WidgetsBindingObserver {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initialAuthenticate(BuildContext context) async {
    if (!mounted) return;

    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated && mounted) {
        final appState = Provider.of<AuthState>(context, listen: false);
        appState.setInitiallyAuthenticated(true); // Set the flag

        // Set hasTransitioned to false
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasTransitioned', false);

        await Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                 const DashboardPage(fromFaceIdPage: true),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child,
          ),
        );
      }
    } catch (e) {
      // Handle authentication error if needed
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add logo image
                SvgPicture.asset(
                  'assets/icons/ARMM_Logo.svg',
                  height: 40,
                  width: 40,
                ),
                const SizedBox(height: 40.0),
                Text(
                  'ARMM App Locked',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    color: const Color(0xFF1C32A4),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Unlock with Face ID to continue',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: const Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60.0),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _initialAuthenticate(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C32A4), // AppColors.primary
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      'Use Face ID',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
