import 'package:armm_app/database/models/activity_model.dart';
import 'package:armm_app/screens/activity/utils/activity_styles.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:flutter_svg/svg.dart';
>>>>>>> 7b97856 (Migrated components for dashboard)
import 'package:intl/intl.dart';

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

<<<<<<< HEAD
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // Date and Time
                Text(
                  '$date at $time',
                  style: const TextStyle(
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: getActivityColor(activity.type),
                ),
              ),

              // Fund Type (IRA, Roth IRA, etc.)
              Text(
                activity.recipient,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700
=======
    return Container(
      width: MediaQuery.of(context).size.width * 0.6, // Set a fixed width
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: getActivityColor(activity.type), width: 2.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActivityDetails(),
                  SizedBox(height: 16.0),
                  _buildActivityAmountAndRecipient(time),
                  SizedBox(height: 16.0),
                  _buildActivityDateTime(date, time),
                ],
              ),
            ),
            _buildActivityIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityDateTime(String date, String time) => Row(
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontFamily: 'Titillium Web',
            ),
          ),
          SizedBox(width: 2),
          SizedBox(width: 2),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontFamily: 'Titillium Web',
            ),
          ),
        ],
      );

  Widget _buildActivityIcon() => Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.circle,
            color: Colors.white,
            size: 50,
          ),
          getActivityIcon(activity.type),
        ],
      );

  Widget _buildActivityDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            activity.fund,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Titillium Web',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            getActivityType(activity),
            style: TextStyle(
              fontSize: 15,
              color: getActivityColor(activity.type),
              fontWeight: FontWeight.bold,
              fontFamily: 'Titillium Web',
            ),
          ),
        ],
      );

  Widget _buildActivityAmountAndRecipient(String time) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${activity.type == 'withdrawal' ? '-' : ''}${currencyFormat(activity.amount.toDouble())}',
              style: TextStyle(
                fontSize: 18,
                color: getActivityColor(activity.type),
                fontWeight: FontWeight.bold,
                fontFamily: 'Titillium Web',
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                _getShortenedName(activity.recipient),
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Titillium Web',
>>>>>>> 7b97856 (Migrated components for dashboard)
                ),
              ),
            ],
          ),
        ],
<<<<<<< HEAD
      ),
    );
  }

=======
      );

  // Helper function to get the shortened name
  String _getShortenedName(String name) {
    final parts = name.split(' ');
    if (parts.length > 1) {
      final firstName = parts[0];
      final lastName = parts[1];
      final fullName = '$firstName $lastName';
      if (fullName.length > 20) {
        return '${firstName.substring(0, 1)}. ${lastName.substring(0, 1)}.';
      } else {
        return fullName;
      }
    } else {
      return name.length > 20 ? '${name.substring(0, 1)}.' : name;
    }
  }
>>>>>>> 7b97856 (Migrated components for dashboard)
}