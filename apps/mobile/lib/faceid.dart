// ignore_for_file: library_private_types_in_public_api, empty_catches, use_build_context_synchronously

import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

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
    // Reset the hasNavigatedToFaceIDPage value to false before disposing
    if (authenticated && mounted) {
      // Use stored reference instead of accessing Provider during disposal
      _authState.setHasNavigatedToFaceIDPage(false);
    }

    // Remove the observer for this widget's lifecycle events
    WidgetsBinding.instance.removeObserver(this);
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

      _authState.setJustAuthenticated(true);
      _authState.setInitiallyAuthenticated(true);

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
        _authState.setHasNavigatedToFaceIDPage(false);
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80.0),
                      const SizedBox(height: 20.0),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'ARMM App Locked',
                          style: TextStyle(
                            fontSize: 25,
                          color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Unlock with Face ID to continue',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _isAuthenticating
                          ? null
                          : () async {
                              await _authenticate(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'Use Face ID',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

