// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/services/biometric_security_service.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class BiometricLockScreen extends StatefulWidget {
  const BiometricLockScreen({super.key});

  @override
  _BiometricLockScreenState createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();
  final BiometricSecurityService _biometricService = BiometricSecurityService.instance;
  
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_isAuthenticating) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _authenticate();
        }
      });
    }
  }

  Future<void> _authenticate() async {
    if (!mounted || _isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    bool isAuthenticated = false;

    try {
      isAuthenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint('Authentication error: $e');
    }

    if (!mounted) return;

    setState(() {
      _isAuthenticating = false;
    });

    if (isAuthenticated) {
      // Update auth state
      final authState = Provider.of<AuthState>(context, listen: false);
      authState.setJustCompletedAuthentication(true);
      authState.setInitialAuthenticationCompleted(true);
      authState.setHasAuthenticatedThisSession(true);

      // Notify BiometricSecurityService of successful authentication
      _biometricService.onBiometricAuthenticationSuccess(context);

      // Navigate to dashboard
      await Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const DashboardPage(fromFaceIdPage: true),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
        ),
      );
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
                    onPressed: _isAuthenticating
                      ? null
                      : () async {
                          await _authenticate();
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
