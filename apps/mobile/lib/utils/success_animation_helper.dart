import 'package:flutter/material.dart';
import 'package:armm_app/components/success_check_mark.dart';

/// A helper class to show success animation overlay before navigating
class SuccessAnimationHelper {
  
  /// Shows a success check mark animation overlay that automatically dismisses after animating
  static Future<void> showSuccessAnimation(BuildContext context) async {
    // Create a temporary animation controller for this animation
    final animationController = AnimationController(
      vsync: Navigator.of(context) as TickerProvider,
      duration: const Duration(milliseconds: 800),
    );
    
    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticOut,
    );
    
    // Create an overlay entry
    final overlayState = Overlay.of(context);
    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return SuccessCheckMark(
          animation: animation,
        );
      },
    );
    
    // Add the overlay to the screen
    overlayState.insert(overlayEntry);
    
    // Start the animation
    animationController.forward();
    
    // Wait for the animation to complete
    await Future.delayed(const Duration(milliseconds: 1200));
    
    // Remove the overlay and dispose controller
    overlayEntry.remove();
    animationController.dispose();
  }
}
