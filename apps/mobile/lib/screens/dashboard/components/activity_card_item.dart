import 'package:armm_app/database/models/activity_model.dart';
import 'package:armm_app/screens/activity/utils/activity_styles.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityCardItem extends StatelessWidget {
  final Activity activity;

  const ActivityCardItem({
    required this.activity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat timeFormat = DateFormat('h:mm a');
    final DateFormat dateFormat = DateFormat('MMM d, yyyy');
    String time = timeFormat.format(activity.time);
    String date = dateFormat.format(activity.time);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Adds spacing between rows
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction Type (Profit, Withdrawal, Deposit, etc.)
                Text(
                  getActivityType(activity),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // Date and Time
                Text(
                  '$date at $time',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Transaction Amount & Fund Type
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount (Positive/Negative)
              Text(
                '${activity.type == 'withdrawal' ? '-' : '+'}${currencyFormat(activity.amount.toDouble())}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: getActivityColor(activity.type),
                ),
              ),

              // Fund Type (IRA, Roth IRA, etc.)
              Text(
                activity.recipient,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}