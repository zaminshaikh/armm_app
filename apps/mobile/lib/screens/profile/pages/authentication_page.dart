// ignore_for_file: deprecated_member_use, use_build_context_synchronously, duplicate_ignore, prefer_expression_function_bodies, unused_catch_clause, empty_catches, library_private_types_in_public_api

import 'package:armm_app/services/biometric_security_service.dart';
import 'package:armm_app/utils/app_bar.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// Authentication Settings Page
/// 
/// Allows users to configure biometric security settings including:
/// - Enable/disable biometric authentication
/// - Set security delay timing
/// - View current security status
class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);
  
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
} 

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool _isCheckingBiometrics = false;

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  /// Initialize authentication state and check biometric availability
  Future<void> _initializeSettings() async {
    await context.read<AuthState>().loadSavedSettings();
  }

  /// Handle biometric security toggle
  Future<void> _handleBiometricSecurityToggle(bool enableSecurity) async {
    if (_isCheckingBiometrics) return;
    
    setState(() => _isCheckingBiometrics = true);

    try {
      final securityService = BiometricSecurityService.instance;
      
      if (enableSecurity) {
        // Try to enable biometric security
        final success = await securityService.enableBiometricSecurity(context);
        
        if (!success) {
          if (mounted) {
            _showBiometricUnavailableDialog();
          }
        }
      } else {
        // Disable biometric security
        await securityService.disableBiometricSecurity(context);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to update security settings. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isCheckingBiometrics = false);
      }
    }
  }

  /// Handle security delay time selection
  Future<void> _handleSecurityDelaySelection(String timeOption) async {
    try {
      final securityService = BiometricSecurityService.instance;
      await securityService.setSecurityDelayTime(context, timeOption);
      
      if (mounted) {
        setState(() {}); // Refresh UI to show selection
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to update security timing. Please try again.');
      }
    }
  }

  /// Show dialog when biometric authentication is not available
  void _showBiometricUnavailableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Biometric Authentication Unavailable'),
        content: const Text(
          'Biometric authentication is not available on your device or has not been set up. '
          'Please configure Face ID, Touch ID, or another biometric method in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'App Lock',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSecurityToggleSection(),
            if (context.watch<AuthState>().isBiometricSecurityEnabled) 
              _buildSecurityTimingSection(),
          ],
        ),
      ),
    );
  }

  /// Build the main security toggle section
  Widget _buildSecurityToggleSection() {
    return Column(
      children: [
        // Security toggle container
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/auth.svg',
                  color: Colors.grey.shade600,
                  height: 40,
                  width: 40,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Biometric Security',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Secure your app with biometric authentication',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Row(
                  children: [
                    if (_isCheckingBiometrics)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      CupertinoSwitch(
                        value: context.watch<AuthState>().isBiometricSecurityEnabled,
                        onChanged: _handleBiometricSecurityToggle,
                        activeColor: const Color(0xFF1C32A4),
                      ),
                    const SizedBox(width: 10),
                    Text(
                      context.watch<AuthState>().isBiometricSecurityEnabled ? 'On' : 'Off',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 10),
        
        // Description container
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              'When enabled, you\'ll need to authenticate with biometrics (Face ID, Touch ID, or fingerprint) '
              'when opening the app after it has been in the background. '
              'You can set how long the app can be in the background before requiring authentication.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 30),
      ],
    );
  }

  /// Build the security timing options section
  Widget _buildSecurityTimingSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              'Require Authentication After',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildTimingOption('Immediately'),
                const Divider(height: 1, color: Colors.grey),
                _buildTimingOption('1 minute'),
                const Divider(height: 1, color: Colors.grey),
                _buildTimingOption('2 minute'),
                const Divider(height: 1, color: Colors.grey),
                _buildTimingOption('5 minute'),
                const Divider(height: 1, color: Colors.grey),
                _buildTimingOption('10 minute'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual timing option tile
  Widget _buildTimingOption(String timeOption) {
    final isSelected = context.watch<AuthState>().securityDelayOption == timeOption;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleSecurityDelaySelection(timeOption),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/auth.svg',
                width: 20,
                height: 20,
                color: isSelected ? const Color(0xFF1C32A4) : Colors.grey.shade500,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  timeOption,
                  style: GoogleFonts.inter(
                    color: isSelected ? const Color(0xFF1C32A4) : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: const Color(0xFF1C32A4),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}