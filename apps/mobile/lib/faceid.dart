// ignore_for_file: library_private_types_in_public_api, empty_catches, use_build_context_synchronously

import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class FaceIdPage extends StatefulWidget {
  const FaceIdPage({super.key});

  @override
  _FaceIdPageState createState() => _FaceIdPageState();
}

class _FaceIdPageState extends State<FaceIdPage> with WidgetsBindingObserver {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  bool authenticated = false;
  late AuthState _authState; // Store reference to AuthState provider

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely store reference to the provider
    _authState = Provider.of<AuthState>(context, listen: false);
  }

  @override
  void dispose() {
    // Remove the observer for this widget's lifecycle events
    WidgetsBinding.instance.removeObserver(this);
    
    // Schedule state update for when the framework is unlocked
    if (authenticated) {
      // Use a microtask to update state after dispose completes
      Future.microtask(() {
        _authState.setHasNavigatedToFaceIDPage(false);
      });
    }
    
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_isAuthenticating) {
        _isAuthenticating = true; // Set the flag to prevent multiple calls
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Use stored reference instead of accessing Provider directly
          _authState.setHasNavigatedToFaceIDPage(true);
          if (mounted) {
            _authenticate(context).then((_) {
              _isAuthenticating = false; // Reset the flag after authentication
            });
          }
        });
      }
    }
  }

  Future<void> _authenticate(BuildContext context) async {
    if (!mounted) return;

    setState(() {
      _isAuthenticating = true;
    });

    authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Authentication error: $e');
    }

    if (authenticated) {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }

      // Schedule state updates for next frame when framework is unlocked
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _authState.setJustAuthenticated(true);
        _authState.setInitiallyAuthenticated(true);
      });

      if (mounted) {
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
    } else {
      if (mounted) {
        // Schedule state update for next frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _authState.setHasNavigatedToFaceIDPage(false);
        });
        
        setState(() {
          _isAuthenticating = false;
        });
      }
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
                          await _authenticate(context);
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

