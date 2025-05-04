import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProfitIndicator extends StatelessWidget {
  final double amount;

  const ProfitIndicator({Key? key, required this.amount}) : super(key: key);

  // Helper method to calculate font size based on value length
  double _calculateYtdFontSize(double value) {
    final digits = value.abs().toStringAsFixed(0).length;
    // Smaller base size for YTD
    return digits <= 4 ? 14.0 : 14.0 - ((digits - 4) * 0.75);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic font size for YTD (always smaller than assets)
    final ytdFontSize = _calculateYtdFontSize(amount);
    
    // Determine color based on amount (positive or negative)
    final isPositive = amount >= 0;
    final backgroundColor = isPositive ? Colors.green.shade100 : Colors.red.shade100;
    final textColor = isPositive ? Colors.green : Colors.red;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor, // Light green or red background
        borderRadius: BorderRadius.circular(15), // Capsule shape
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor,
            size: 18, // Small size similar to the image
          ),
          const SizedBox(width: 4),
          Text(
            NumberFormat.currency(decimalDigits: 2, symbol: '\$').format(amount),
            style: GoogleFonts.inter(
              fontSize: ytdFontSize,
              fontWeight: FontWeight.w800,
              color: textColor, // Matches the icon color
            ),
          ),
        ],
      ),
    );
  }
}