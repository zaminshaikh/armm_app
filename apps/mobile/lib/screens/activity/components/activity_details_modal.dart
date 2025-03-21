import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/database/models/activity_model.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/activity_styles.dart';

final DateFormat timeFormat = DateFormat('h:mm a');
final DateFormat dateFormat = DateFormat('EEEE, MMM. d, yyyy');
final DateFormat dayHeaderFormat = DateFormat('MMMM d, yyyy');

class ActivityDetailsModal extends StatelessWidget {
  final Activity activity;

  const ActivityDetailsModal({
    Key? key,
    required this.activity,
  }) : super(key: key);

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
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildModalHeader(context),
                _buildModalBody(activity),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalHeader(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: SvgPicture.asset(
                'assets/icons/ARMM_Logo.svg',
                width: 40,
                height: 40,
              ),
            ),
          Text(
            'Activity Details',
            style: GoogleFonts.inter(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
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
          style: GoogleFonts.inter(
            fontSize: 30,
            color: getActivityColor(activity.type),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Center(
          child: Text(
            getActivityDescription(activity),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
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
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: getActivityColor(activity.type),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        _buildModalDetailSection(
          icon: SvgPicture.asset(
            'assets/icons/docs.svg',
            color: const Color.fromARGB(255, 82, 82, 82),
          ),
          title: 'Description',
          content: getActivityDescription(activity),
        ),
        const Divider(color: Colors.black, thickness: 0.2),
        _buildModalDetailSection(
          icon: Icon(
            Icons.calendar_today_rounded,
            size: 32,
            color: const Color.fromARGB(255, 82, 82, 82),
          ),
          title: 'Date',
          content: date,
        ),
        const Divider(color: Colors.black, thickness: 0.2),
        _buildModalDetailSection(
          icon: SvgPicture.asset(
            'assets/icons/profile_hollow.svg',
            color: const Color.fromARGB(255, 82, 82, 82),
          ),

          title: 'Recipient',
          content: activity.recipient,
        ),
      ],
    );
  }

  Widget _buildModalDetailSection({
    required Widget icon,
    required String title,
    required String content,
  }) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: icon,
            ),// inserted icon widget

            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    content,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}