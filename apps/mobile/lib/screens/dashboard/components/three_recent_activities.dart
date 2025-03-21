import 'package:armm_app/database/models/activity_model.dart';
import 'package:armm_app/screens/activity/activity.dart';
import 'package:armm_app/screens/dashboard/components/activity_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityTilesSection extends StatelessWidget {
  final List<Activity> activities;

  const ActivityTilesSection({required this.activities, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Container();
    }

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title + "View All" Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => ActivityPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'View all',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C32A4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SvgPicture.asset(
                        'assets/icons/arrow_right.svg',
                        color: Color(0xFF1C32A4),
                        height: 18,
                        width: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Transaction List (Using ActivityCardItem)
            Column(
              children: activities
                  .take(4) // Show only the latest 4 transactions
                  .map((activity) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: ActivityCardItem(activity: activity),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}