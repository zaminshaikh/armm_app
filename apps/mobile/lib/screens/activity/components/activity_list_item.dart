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
<<<<<<< HEAD
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
=======
        padding: const EdgeInsets.fromLTRB(30.0, 5.0, 15.0, 5.0),
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              _buildActivityIcon(),
              _buildActivityDetails(),
              const Spacer(),
              _buildActivityAmountAndTime(time),
            ],
          ),
        ),
      ),
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
    );
  }

  Widget _buildActivityIcon() => Padding(
<<<<<<< HEAD
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
=======
      padding: const EdgeInsets.only(right: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.circle,
            color: getUnderlayColor(activity.type),
            size: 50,
          ),
          getActivityIcon(activity.type),
        ],
      ),
    );

  Widget _buildActivityDetails() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          activity.fund,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
<<<<<<< HEAD
            fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
            
>>>>>>> a440029 (Removed All Font Issues)
          ),
        ),
        const SizedBox(height: 5),
        Text(
<<<<<<< HEAD
          formattedTime,
          style: const TextStyle(
            fontSize: 13,
            color: Color.fromARGB(255, 102, 102, 102),
            fontWeight: FontWeight.bold,
=======
          getActivityType(activity),
          style: TextStyle(
            fontSize: 15,
            color: getActivityColor(activity.type),
            fontWeight: FontWeight.bold,
<<<<<<< HEAD
            fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
            
>>>>>>> a440029 (Removed All Font Issues)
          ),
        ),
      ],
    );
<<<<<<< HEAD
  }


  Widget _buildActivityAmountAndName(String time) => Column(
=======

  Widget _buildActivityAmountAndTime(String time) => Column(
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
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
<<<<<<< HEAD
<<<<<<< HEAD
            
=======
            fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
            
>>>>>>> a440029 (Removed All Font Issues)
          ),
        ),
      ),
      const SizedBox(height: 5),
<<<<<<< HEAD
      Text(
        _getShortenedName(activity.recipient),
        style: const TextStyle(
          fontSize: 13,
          color: Color.fromARGB(255, 102, 102, 102),
          fontWeight: FontWeight.bold,
          
        ),
=======
      Row(
        children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              
            ),
          ),
          SvgPicture.asset(
            'assets/icons/docs.svg',
            color: Colors.white,
            height: 15,
          ),
          Text(
            _getShortenedName(activity.recipient),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              
            ),
          ),
        ],
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
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
