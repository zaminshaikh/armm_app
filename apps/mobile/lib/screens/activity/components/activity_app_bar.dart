import 'package:armm_app/database/models/client_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Client client;

  // Add two callbacks that the parent (ActivityPage) can pass in
  final VoidCallback onFilterPressed;
  final VoidCallback onSortPressed;

  const ActivityAppBar({
    super.key,
    required this.client,
    required this.onFilterPressed,
    required this.onSortPressed,
  });

  @override
  _ActivityAppBarState createState() => _ActivityAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 95);
}

class _ActivityAppBarState extends State<ActivityAppBar> {
  @override
  Widget build(BuildContext context) => SliverAppBar(
        backgroundColor: const Color.fromARGB(255, 30, 41, 59),
        automaticallyImplyLeading: false,
        toolbarHeight: widget.preferredSize.height,
        expandedHeight: 0,
        snap: false,
        floating: true,
        pinned: true,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 15),
            // Put a Row with Activity Title + Notification icon on the left,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Activity Title + Bell icon
                Row(
                  children: [
                    const Text(
                      'Activity',
                      style: TextStyle(
                        fontSize: 27,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Titillium Web',
                      ),
                    ),
                    Spacer(),
                  ],
                ),

                Spacer(),

                // Filter and Sort Buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Row(
                    children: [
                      Expanded(child: _buildFilterButton()),
                      const SizedBox(width: 10),
                      Expanded(child: _buildSortButton()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  /// Builds the Filter button. You can style it however you wish.
  Widget _buildFilterButton() => ElevatedButton.icon(
        icon: SvgPicture.asset(
          'assets/icons/filter.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          height: 22,
          width: 22,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 17, 24, 39),
          splashFactory: NoSplash.splashFactory,
          side: const BorderSide(color: Color.fromARGB(255, 17, 24, 39)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
        ),
        label: const Text(
          'Filter',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Titillium Web',
          ),
        ),
        onPressed: widget.onFilterPressed,
      );

  /// Builds the Sort button.
  Widget _buildSortButton() => ElevatedButton.icon(
        icon: SvgPicture.asset(
          'assets/icons/sort.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          height: 22,
          width: 22,
        ),
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          backgroundColor: const Color.fromARGB(255, 17, 24, 39),
          side: const BorderSide(color: Color.fromARGB(255, 17, 24, 39)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
        ),
        label: const Text(
          'Sort',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Titillium Web',
          ),
        ),
        onPressed: widget.onSortPressed,
      );
}