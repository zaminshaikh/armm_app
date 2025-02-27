import 'package:armm_app/database/models/activity_model.dart';
import 'package:armm_app/screens/activity/activity.dart';
import 'package:armm_app/screens/dashboard/components/activity_card_item.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:google_fonts/google_fonts.dart';

class ActivityTilesSection extends StatelessWidget {
=======

class ActivityTilesSection extends StatefulWidget {
>>>>>>> 7b97856 (Migrated components for dashboard)
=======
import 'package:google_fonts/google_fonts.dart';

class ActivityTilesSection extends StatelessWidget {
>>>>>>> 26828f3 (Refactor ActivityCardItem to streamline layout, enhance readability, and improve transaction details display)
  final List<Activity> activities;

  const ActivityTilesSection({required this.activities, Key? key}) : super(key: key);

  @override
<<<<<<< HEAD
<<<<<<< HEAD
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ActivityPage()),
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
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Color(0xFF1C32A4),
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
=======
  _ActivityTilesSectionState createState() => _ActivityTilesSectionState();
}

class _ActivityTilesSectionState extends State<ActivityTilesSection> {
  final ScrollController _scrollController = ScrollController();
  double _gradientOpacity = 0.8;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      bool isEnd = _scrollController.position.pixels != 0;
      setState(() {
        _gradientOpacity = isEnd ? 0.0 : 0.8;
      });
    } else {
      double maxScrollExtent = _scrollController.position.maxScrollExtent;
      double currentScrollPosition = _scrollController.position.pixels;
      double threshold = maxScrollExtent - 50; // Adjust the threshold as needed

      setState(() {
        _gradientOpacity = currentScrollPosition >= threshold ? 0.0 : 0.8;
      });
    }
  }

  @override
=======
>>>>>>> 26828f3 (Refactor ActivityCardItem to streamline layout, enhance readability, and improve transaction details display)
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ActivityPage()),
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
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Color(0xFF1C32A4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
<<<<<<< HEAD
          ),
        ],
>>>>>>> 7b97856 (Migrated components for dashboard)
=======
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
>>>>>>> 26828f3 (Refactor ActivityCardItem to streamline layout, enhance readability, and improve transaction details display)
      ),
    );
  }
}