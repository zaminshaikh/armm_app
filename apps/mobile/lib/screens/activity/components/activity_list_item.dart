// widgets/activity_list_item.dart
import 'package:armm_app/database/models/activity_model.dart';
import 'package:armm_app/screens/activity/utils/activity_styles.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';


class ActivityListItem extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;

  const ActivityListItem(
      {required this.activity, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat timeFormat = DateFormat('h:mm a');
    String time = timeFormat.format(activity.time);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
      child: Container(
        decoration: BoxDecoration(
        color: Colors.transparent, 
        border: Border.all(
          color: Colors.black, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0), // Optional: Border radius
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
          children: [
            _buildActivityIcon(),
            _buildActivityDetails(),
            const Spacer(),
            _buildActivityAmountAndName(time),
          ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildActivityIcon() => Padding(
    padding: const EdgeInsets.only(right: 20),
    child: getActivityIcon(activity.type, size: 40), // Directly use the widget from getActivityIcon
  );

  Widget _buildActivityDetails() {
    final DateFormat dateTimeFormat = DateFormat("MMM d, yyyy 'at' h:mm a");
    String formattedTime = dateTimeFormat.format(activity.time);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getActivityType(activity),
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 13,
            color: Color.fromARGB(255, 102, 102, 102),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


  Widget _buildActivityAmountAndName(String time) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          '${activity.type == 'withdrawal' ? '-' : ''}${currencyFormat(activity.amount.toDouble())}',
          style: TextStyle(
            fontSize: 18,
            color: getActivityColor(activity.type),
            fontWeight: FontWeight.bold,
            
          ),
        ),
      ),
      const SizedBox(height: 5),
      Text(
        _getShortenedName(activity.recipient),
        style: const TextStyle(
          fontSize: 13,
          color: Color.fromARGB(255, 102, 102, 102),
          fontWeight: FontWeight.bold,
          
        ),
      ),
    ],
  );
  
  // Helper function to get the shortened name
  String _getShortenedName(String name) {
    final parts = name.split(' ');
    if (parts.length > 1) {
      final firstName = parts[0];
      final lastName = parts[1];
      final fullName = '$firstName $lastName';
      if (fullName.length > 30) {
        return '${firstName.substring(0, 1)}. ${lastName.substring(0, 1)}.';
      } else {
        return fullName;
      }
    } else {
      return name.length > 20 ? '${name.substring(0, 1)}.' : name;
    }
  }

}
