import 'package:armm_app/database/models/activity_model.dart';
import 'package:armm_app/screens/activity/activity.dart';
import 'package:armm_app/screens/dashboard/components/activity_card_item.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:google_fonts/google_fonts.dart';

class ActivityTilesSection extends StatelessWidget {
=======

class ActivityTilesSection extends StatefulWidget {
>>>>>>> 7b97856 (Migrated components for dashboard)
  final List<Activity> activities;

  const ActivityTilesSection({required this.activities, Key? key}) : super(key: key);

  @override
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
  Widget build(BuildContext context) {
    if (widget.activities.isEmpty) {
      return Container();
    }

    return Container(
      width: double.infinity, // Ensure the container takes up the full width
      height: 200, // Adjust the height as needed
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.activities.length + 1, // Add one more item for the "View All" button
            itemBuilder: (context, index) {
              if (index < widget.activities.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add some spacing between cards
                  child: ActivityCardItem(activity: widget.activities[index]),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0), // Add some spacing for the button
                  child: Row(
                    children: [
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
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Add padding to the container
                          child: Row(
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedOpacity(
              opacity: _gradientOpacity,
              duration: Duration(milliseconds: 300), // Adjust the duration as needed
              child: Container(
                width: 50, // Adjust the width of the gradient
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
>>>>>>> 7b97856 (Migrated components for dashboard)
      ),
    );
  }
}