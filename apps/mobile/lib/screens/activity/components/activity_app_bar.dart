import 'package:armm_app/database/models/client_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Client client;

  // Callbacks the parent (ActivityPage) can pass in
  final VoidCallback onFilterPressed;
  final VoidCallback onSortPressed;
  final VoidCallback? onNotificationTap; // Added notification callback

  const ActivityAppBar({
    super.key,
    required this.client,
    required this.onFilterPressed,
    required this.onSortPressed,
    this.onNotificationTap, // Optional
  });

  @override
  _ActivityAppBarState createState() => _ActivityAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 95);
}

class _ActivityAppBarState extends State<ActivityAppBar> {
  var ARMM_blue = const Color(0xFF2B41B8);

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: ARMM_blue,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ), // Drooping effect added
        toolbarHeight: kToolbarHeight,
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0), // Adjust this value as needed
          child: Text(
            'Activity',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none,
                size: 30,
                color: Colors.white,
              ),
              onPressed: widget.onNotificationTap ?? () {},
            ),
          ),
        ], // Notification icon added
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(95),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Expanded(child: _buildFilterButton()),
                const SizedBox(width: 10),
                Expanded(child: _buildSortButton()),
              ],
            ),
          ),
        ),
      );

  /// Builds the Filter button.
  Widget _buildFilterButton() => ElevatedButton.icon(
        icon: SvgPicture.asset(
          'assets/icons/filter.svg',
          colorFilter: ColorFilter.mode(ARMM_blue, BlendMode.srcIn),
          height: 22,
          width: 22,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          splashFactory: NoSplash.splashFactory,
          side: BorderSide(color: ARMM_blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
        ),
        label: Text(
          'Filter',
          style: TextStyle(
            color: ARMM_blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        onPressed: widget.onFilterPressed,
      );

  /// Builds the Sort button.
  Widget _buildSortButton() => ElevatedButton.icon(
        icon: SvgPicture.asset(
          'assets/icons/sort.svg',
          colorFilter: ColorFilter.mode(ARMM_blue, BlendMode.srcIn),
          height: 22,
          width: 22,
        ),
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          backgroundColor: Colors.white,
          side: BorderSide(color: ARMM_blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
        ),
        label: Text(
          'Sort',
          style: TextStyle(
            color: ARMM_blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        onPressed: widget.onSortPressed,
      );
}