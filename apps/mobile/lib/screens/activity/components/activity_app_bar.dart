import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/notifications/notifications.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Client client;

  // Callbacks the parent (ActivityPage) can pass in
  final VoidCallback onFilterPressed;
  final VoidCallback onSortPressed;
  final VoidCallback? onNotificationTap;

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
  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        toolbarHeight: kToolbarHeight,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                    Color(0xFF2B41B8),
                    Color.fromARGB(255, 60, 84, 219),
                    Color.fromARGB(255, 95, 116, 238),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            'Transactions',
            style: GoogleFonts.inter(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 10.0),
            child: GestureDetector(
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const NotificationPage(),
                ),
              );
              },
              child: IconButton(
              icon: const Icon(
                    Icons.notifications_none,
                    size: 30,
                    color: Colors.white,
              ),
              onPressed: widget.onNotificationTap == null ? null : () => widget.onNotificationTap!(),
              ),
            ),

          ),
        ], // Notification icon added
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.only(right: 30, left: 30,  bottom: 20),
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
          colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          height: 22,
          width: 22,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          splashFactory: NoSplash.splashFactory,
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
        ),
        label: Text(
          'Filter',
          style: GoogleFonts.inter(
            color: AppColors.primary,
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
          colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          height: 22,
          width: 22,
        ),
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          backgroundColor: Colors.white,
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
        ),
        label: Text(
          'Sort',
          style: GoogleFonts.inter(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        onPressed: widget.onSortPressed,
      );
}