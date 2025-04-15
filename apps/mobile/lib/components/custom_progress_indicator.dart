import 'package:armm_app/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:armm_app/components/custom_alert_dialog.dart';

class CustomProgressIndicator extends StatefulWidget {
  final Color? color;
  final double? size;
  final bool shouldTimeout;
  final Duration timeoutDuration;
  final Function()? onTimeout;

  const CustomProgressIndicator({
    Key? key, 
    this.color = AppColors.primary, // Default to ARMM Blue
    this.size = 50.0,
    this.shouldTimeout = false,
    this.timeoutDuration = const Duration(seconds: 10),
    this.onTimeout,
  }) : super(key: key);

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    
    if (widget.shouldTimeout) {
      // Start a timer for specified duration (default 5 seconds)
      _timer = Timer(widget.timeoutDuration, () {
        // After timeout, show the dialog
        _showTimeoutDialog();
      });
    }
  }

  @override
  void dispose() {
    // Cancel the timer if the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  void _showTimeoutDialog() {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CustomAlertDialog(
        title: 'Connection Timeout',
        message: 'The connection is taking longer than expected. Please return to the login page and try again.',
        icon: const Icon(
          Icons.timer,
          color: Colors.red,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (widget.onTimeout != null) {
                widget.onTimeout!();
              } else {
                // Default behavior
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/onboarding', (Route<dynamic> route) => false);
              }
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.logout, 
                  color: Colors.red,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFoldingCube(
        color: widget.color!,
        size: widget.size!,
      ),
    );
  }
}
