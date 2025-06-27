/// Biometric Lock Screen
/// 
/// A modern, clean screen that handles biometric authentication when the app
/// requires security verification. This screen automatically triggers biometric
/// authentication and handles success/failure states appropriately.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import 'package:armm_app/services/biometric_security_service.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/utils/app_state.dart';

class BiometricLockScreen extends StatefulWidget {
  const BiometricLockScreen({super.key});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen>
    with WidgetsBindingObserver {
  
  bool _isAuthenticating = false;
  bool _authenticationCompleted = false;
  String _authenticationMessage = 'Unlock with biometric authentication to continue';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Automatically trigger authentication when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performBiometricAuthentication();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Re-trigger authentication when app resumes (if user backgrounded during auth)
    if (state == AppLifecycleState.resumed && !_authenticationCompleted && !_isAuthenticating) {
      _performBiometricAuthentication();
    }
  }

  /// Perform biometric authentication
  Future<void> _performBiometricAuthentication() async {
    if (_isAuthenticating || _authenticationCompleted || !mounted) return;

    setState(() {
      _isAuthenticating = true;
      _authenticationMessage = 'Authenticating...';
    });

    try {
      final securityService = BiometricSecurityService.instance;
      
      // Check if biometrics are available
      final isAvailable = await securityService.isBiometricAuthenticationAvailable();
      
      if (!isAvailable) {
        _handleAuthenticationFailure('Biometric authentication is not available on this device');
        return;
      }

      // Perform authentication
      final success = await securityService.authenticateWithBiometrics(
        reason: 'Please authenticate to access ARMM',
        useErrorDialogs: false, // We'll handle errors ourselves
        stickyAuth: true,
      );

      if (success) {
        await _handleAuthenticationSuccess();
      } else {
        _handleAuthenticationFailure('Authentication failed or was cancelled');
      }
    } catch (e) {
      log('BiometricLockScreen: Authentication error: $e');
      _handleAuthenticationFailure('Authentication error occurred');
    }
  }

  /// Handle successful authentication
  Future<void> _handleAuthenticationSuccess() async {
    if (!mounted) return;

    setState(() {
      _authenticationCompleted = true;
      _isAuthenticating = false;
      _authenticationMessage = 'Authentication successful!';
    });

    // Notify security service of successful authentication
    final securityService = BiometricSecurityService.instance;
    securityService.onBiometricAuthenticationSuccess(context);

    // Small delay to show success message
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
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

  /// Handle authentication failure
  void _handleAuthenticationFailure(String errorMessage) {
    if (!mounted) return;

    setState(() {
      _isAuthenticating = false;
      _authenticationMessage = errorMessage;
    });

    // Notify security service of failure
    final securityService = BiometricSecurityService.instance;
    securityService.onBiometricAuthenticationFailure();
  }

  /// Get appropriate biometric icon based on available types
  Widget _getBiometricIcon() {
    // For now, use a generic secure icon
    // In the future, you could check BiometricSecurityService.instance.getAvailableBiometrics()
    // and show face, fingerprint, or other icons accordingly
    return SvgPicture.asset(
      'assets/icons/auth.svg',
      height: 64,
      width: 64,
      color: const Color(0xFF1C32A4),
    );
  }

  /// Get appropriate authentication method name
  String _getAuthenticationMethodName() {
    // For now, use generic biometric term
    // In the future, you could determine the specific method (Face ID, Touch ID, etc.)
    return 'biometric authentication';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo
                SvgPicture.asset(
                  'assets/icons/ARMM_Logo.svg',
                  height: 48,
                  width: 48,
                ),
                
                const SizedBox(height: 40),
                
                // Lock status title
                Text(
                  'ARMM App Locked',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    color: const Color(0xFF1C32A4),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Authentication message
                Text(
                  _authenticationMessage,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 48),
                
                // Biometric icon with animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: _isAuthenticating
                      ? const SizedBox(
                          height: 64,
                          width: 64,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1C32A4)),
                            strokeWidth: 3,
                          ),
                        )
                      : _getBiometricIcon(),
                ),
                
                const SizedBox(height: 48),
                
                // Authentication button (only show if not currently authenticating)
                if (!_isAuthenticating && !_authenticationCompleted)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _performBiometricAuthentication,
                      icon: Icon(
                        Icons.security,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        'Use ${_getAuthenticationMethodName()}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C32A4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                
                // Success indicator
                if (_authenticationCompleted)
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Authentication Successful',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 32),
                
                // Help text
                Text(
                  'This security feature can be managed in Settings > Authentication',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF999999),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
