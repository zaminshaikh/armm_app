import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProfitIndicator extends StatelessWidget {
  final double amount;

  const ProfitIndicator({Key? key, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade100, // Light green background
        borderRadius: BorderRadius.circular(15), // Capsule shape
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.trending_up,
            color: Colors.green,
            size: 18, // Small size similar to the image
          ),
          const SizedBox(width: 4),
          Text(
            NumberFormat.currency(decimalDigits: 2, symbol: '\$').format(amount),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.green, // Matches the icon color
            ),
          ),
        ],
      ),
    );
  }
}