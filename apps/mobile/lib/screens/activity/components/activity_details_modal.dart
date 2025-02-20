<<<<<<< HEAD
<<<<<<< HEAD
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
=======
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
>>>>>>> 1e012e0 (Activity Cards Complete)
import 'package:armm_app/database/models/activity_model.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../utils/activity_styles.dart';

final DateFormat timeFormat = DateFormat('h:mm a');
final DateFormat dateFormat = DateFormat('EEEE, MMM. d, yyyy');
final DateFormat dayHeaderFormat = DateFormat('MMMM d, yyyy');

class ActivityDetailsModal extends StatelessWidget {
  final Activity activity;
<<<<<<< HEAD
<<<<<<< HEAD

  const ActivityDetailsModal({
    Key? key,
    required this.activity,
  }) : super(key: key);
=======
  final bool isFromAGQ; // make it final
=======
>>>>>>> 1e012e0 (Activity Cards Complete)

  const ActivityDetailsModal({
    Key? key,
<<<<<<< HEAD
  })  : isFromAGQ = (activity.fund == 'AGQ'),  // automatically sets based on fund
        super(key: key);
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
    required this.activity,
  }) : super(key: key);
>>>>>>> 1e012e0 (Activity Cards Complete)

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.67,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: Container(
<<<<<<< HEAD
<<<<<<< HEAD
          color: const Color.fromARGB(255, 232, 232, 232),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildModalHeader(context, ),
=======
          color: Colors.black,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildModalHeader(context, isFromAGQ),
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
          color: const Color.fromARGB(255, 232, 232, 232),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildModalHeader(context, ),
>>>>>>> 1e012e0 (Activity Cards Complete)
                _buildModalBody(activity),
              ],
            ),
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
  Widget _buildModalHeader(BuildContext context) => Column(
=======
  Widget _buildModalHeader(BuildContext context, bool isFromAGQ) => Column(
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
  Widget _buildModalHeader(BuildContext context) => Column(
>>>>>>> 1e012e0 (Activity Cards Complete)
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded,
<<<<<<< HEAD
<<<<<<< HEAD
                      color: Colors.black),
=======
                      color: Color.fromARGB(171, 255, 255, 255)),
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
                      color: Colors.black),
>>>>>>> 1e012e0 (Activity Cards Complete)
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 1e012e0 (Activity Cards Complete)
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: SvgPicture.asset(
                'assets/icons/ARMM_Logo.svg',
=======
          if (isFromAGQ)
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: SvgPicture.asset(
<<<<<<< HEAD
                'assets/icons/agq_logo.svg',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
                'assets/icons/ARMM_Logo.svg',
>>>>>>> a440029 (Removed All Font Issues)
                width: 40,
                height: 40,
              ),
            ),
          const Text(
            'Activity Details',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 1e012e0 (Activity Cards Complete)
              color: Colors.black,
              
=======
              color: Colors.white,
<<<<<<< HEAD
              fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
              
>>>>>>> a440029 (Removed All Font Issues)
            ),
          ),
        ],
      );

  Widget _buildModalBody(Activity activity) {
    String date = dateFormat.format(activity.time);
    return Column(
      children: [
        Text(
          '${activity.type == 'withdrawal' ? '-' : ''}${currencyFormat(activity.amount.toDouble())}',
          style: TextStyle(
            fontSize: 30,
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
        const SizedBox(height: 15),
        Center(
          child: Text(
            getActivityDescription(activity),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 1e012e0 (Activity Cards Complete)
              color: Colors.black,
              
=======
              color: Colors.white,
<<<<<<< HEAD
              fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
              
>>>>>>> a440029 (Removed All Font Issues)
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getActivityIcon(activity.type, size: 35),
              const SizedBox(width: 5),
              Text(
                getActivityType(activity),
                style: TextStyle(
                  fontSize: 16,
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
            ],
          ),
        ),
        const SizedBox(height: 25),
        _buildModalDetailSection(
          icon: SvgPicture.asset(
<<<<<<< HEAD
<<<<<<< HEAD
            'assets/icons/docs.svg',
=======
            'assets/icons/activity_description.svg',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
            'assets/icons/docs.svg',
>>>>>>> a440029 (Removed All Font Issues)
            color: getActivityColor(activity.type),
          ),
          title: 'Description',
          content: getActivityDescription(activity),
<<<<<<< HEAD
<<<<<<< HEAD
        ),
        const Divider(color: Colors.black, thickness: 0.2),
        _buildModalDetailSection(
          icon: SvgPicture.asset(
            'assets/icons/docs.svg',
=======
          underlayColor: getUnderlayColor(activity.type),
=======
>>>>>>> 1e012e0 (Activity Cards Complete)
        ),
        const Divider(color: Colors.black, thickness: 0.2),
        _buildModalDetailSection(
          icon: SvgPicture.asset(
<<<<<<< HEAD
            'assets/icons/activity_date.svg',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
            'assets/icons/docs.svg',
>>>>>>> a440029 (Removed All Font Issues)
            color: getActivityColor(activity.type),
          ),
          title: 'Date',
          content: date,
<<<<<<< HEAD
<<<<<<< HEAD
        ),
        const Divider(color: Colors.black, thickness: 0.2),
        _buildModalDetailSection(
          icon: SvgPicture.asset(
            'assets/icons/docs.svg',
=======
          underlayColor: getUnderlayColor(activity.type),
=======
>>>>>>> 1e012e0 (Activity Cards Complete)
        ),
        const Divider(color: Colors.black, thickness: 0.2),
        _buildModalDetailSection(
          icon: SvgPicture.asset(
<<<<<<< HEAD
            'assets/icons/activity_user.svg',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
            'assets/icons/docs.svg',
>>>>>>> a440029 (Removed All Font Issues)
            color: getActivityColor(activity.type),
          ),
          title: 'Recipient',
          content: activity.recipient,
<<<<<<< HEAD
<<<<<<< HEAD
=======
          underlayColor: getUnderlayColor(activity.type),
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
>>>>>>> 1e012e0 (Activity Cards Complete)
        ),
      ],
    );
  }

  Widget _buildModalDetailSection({
    required Widget icon,
    required String title,
    required String content,
<<<<<<< HEAD
<<<<<<< HEAD
=======
    required Color underlayColor,
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
>>>>>>> 1e012e0 (Activity Cards Complete)
  }) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: Row(
          children: [
<<<<<<< HEAD
<<<<<<< HEAD
=======
            Stack(
              children: [
                Icon(
                  Icons.circle,
                  color: underlayColor,
                  size: 50,
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: icon,
                  ),
                ),
              ],
            ),
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
>>>>>>> 1e012e0 (Activity Cards Complete)
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 1e012e0 (Activity Cards Complete)
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      
=======
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
                    content,
                    style: const TextStyle(
                      fontSize: 14,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 1e012e0 (Activity Cards Complete)
                      color: Colors.black,
                      
=======
                      color: Colors.white,
<<<<<<< HEAD
                      fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
                      
>>>>>>> a440029 (Removed All Font Issues)
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
<<<<<<< HEAD
<<<<<<< HEAD
=======

  // Activity details modal
  void _showActivityDetailsModal(BuildContext context, Activity activity, bool isFromAGQ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: FractionallySizedBox(
          heightFactor: 0.67,
          child: Container(
            color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildModalHeader(context, isFromAGQ),
                  _buildModalBody(activity),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
>>>>>>> 1e012e0 (Activity Cards Complete)
}