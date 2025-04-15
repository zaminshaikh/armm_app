import 'dart:async';
import 'dart:developer';
import 'package:armm_app/components/custom_alert_dialog.dart';
import 'package:armm_app/utils/app_state.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Define ARMM blue color constant
const Color ARMMBlue = Color(0xFF1C32A4);

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  NoInternetScreenState createState() => NoInternetScreenState();
}

class NoInternetScreenState extends State<NoInternetScreen> with SingleTickerProviderStateMixin {
  // We'll keep track of the connectivity status as a single value.
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  // Note: The stream now emits a List<ConnectivityResult>
  late final StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _mounted = true; // Track if the widget is mounted

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller and animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );
    
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Initial connectivity check remains the same.
  Future<void> _initConnectivity() async {
    List<ConnectivityResult> results;
    try {
      results = await _connectivity.checkConnectivity();
    } catch (e) {
      results = [ConnectivityResult.none];
    }
    if (!_mounted) return;
    setState(() {
      // Choose the first result if available; otherwise, default to none.
      _connectionStatus = results.isNotEmpty ? results.first : ConnectivityResult.none;
    });
    log('Initial connectivity: $_connectionStatus');
    
    // Auto-reload when connectivity is initially available
    if (_connectionStatus != ConnectivityResult.none) {
      // Small delay to ensure the app has time to initialize
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_mounted) {
          _reload(context);
        }
      });
    }
  }

  // Update our state with the new connectivity status.
  // Since the stream now provides a List, we pick one result.
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (!_mounted) return;
    
    final previousStatus = _connectionStatus;
    setState(() {
      _connectionStatus = results.isNotEmpty ? results.first : ConnectivityResult.none;
    });
    log('Connectivity List: $results');
    log('Connectivity changed: $_connectionStatus');

    // Auto-reload if connectivity was just restored
    if (previousStatus == ConnectivityResult.none && 
        _connectionStatus != ConnectivityResult.none) {
      // Small delay to ensure connection is stable
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_mounted) {
          _reload(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _animationController.dispose();
    _mounted = false; // Update mounted flag
    super.dispose();
  }

  Future<void> _reload(BuildContext context) async {
    if (_connectionStatus != ConnectivityResult.none) {
      log('Reload initiated - connection available: $_connectionStatus');
      final authState = Provider.of<AuthState>(context, listen: false);
      // Set flag to force navigation to dashboard
      authState.setForceDashboard(true);
      Phoenix.rebirth(context);
    } else {
      await showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again.',
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or brand element
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: SvgPicture.asset(
                    'assets/icons/ARMM_Logo.svg',
                    height: 40,
                    errorBuilder: (context, error, stackTrace) => 
                      Icon(
                        Icons.account_balance,
                        size: 80, 
                        color: ARMMBlue
                      ),
                  ),
                ),
                
                // Animated disconnected icon
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ARMMBlue.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.wifi_off_rounded, 
                      size: 64, 
                      color: ARMMBlue,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Title text
                Text(
                  'No Internet Connection',
                  style: TextStyle(
                    color: ARMMBlue,
                    fontSize: 24,
                    fontFamily: 'Titillium Web',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Description text
                const Text(
                  'Please check your connection and try again',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontFamily: 'Titillium Web',
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Reload button with ARMM blue color
                ElevatedButton(
                  onPressed: () => _reload(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ARMMBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: ARMMBlue.withOpacity(0.4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Try Again',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Titillium Web',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}