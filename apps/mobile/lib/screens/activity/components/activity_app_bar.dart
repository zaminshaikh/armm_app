import 'package:armm_app/database/models/client_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Client client;

<<<<<<< HEAD
<<<<<<< HEAD
  // Callbacks the parent (ActivityPage) can pass in
  final VoidCallback onFilterPressed;
  final VoidCallback onSortPressed;
  final VoidCallback? onNotificationTap; // Added notification callback
=======
  // Add two callbacks that the parent (ActivityPage) can pass in
  final VoidCallback onFilterPressed;
  final VoidCallback onSortPressed;
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
  // Callbacks the parent (ActivityPage) can pass in
  final VoidCallback onFilterPressed;
  final VoidCallback onSortPressed;
  final VoidCallback? onNotificationTap; // Added notification callback
>>>>>>> 1a0bccc (Made Custom Activity App Bar)

  const ActivityAppBar({
    super.key,
    required this.client,
    required this.onFilterPressed,
    required this.onSortPressed,
<<<<<<< HEAD
<<<<<<< HEAD
    this.onNotificationTap, // Optional
=======
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
    this.onNotificationTap, // Optional
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
  });

  @override
  _ActivityAppBarState createState() => _ActivityAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 95);
}

class _ActivityAppBarState extends State<ActivityAppBar> {
<<<<<<< HEAD
<<<<<<< HEAD
  var ARMM_blue = const Color(0xFF2B41B8);

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
                Color.fromARGB(255, 116, 122, 151),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0), // Adjust this value as needed
          child: const Text(
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
=======
=======
  var ARMM_blue = const Color(0xFF2B41B8);

>>>>>>> 1a0bccc (Made Custom Activity App Bar)
  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: ARMM_blue,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ), // Drooping effect added
        toolbarHeight: kToolbarHeight,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0), // Adjust this value as needed
          child: const Text(
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
<<<<<<< HEAD
                // Activity Title + Bell icon
                Row(
                  children: [
                    const Text(
                      'Activity',
                      style: TextStyle(
                        fontSize: 27,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        
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
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
                Expanded(child: _buildFilterButton()),
                const SizedBox(width: 10),
                Expanded(child: _buildSortButton()),
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
              ],
            ),
          ),
        ),
      );

<<<<<<< HEAD
<<<<<<< HEAD
  /// Builds the Filter button.
  Widget _buildFilterButton() => ElevatedButton.icon(
        icon: SvgPicture.asset(
          'assets/icons/filter.svg',
          colorFilter: ColorFilter.mode(ARMM_blue, BlendMode.srcIn),
=======
  /// Builds the Filter button. You can style it however you wish.
  Widget _buildFilterButton() => ElevatedButton.icon(
        icon: SvgPicture.asset(
          'assets/icons/sort.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
  /// Builds the Filter button.
  Widget _buildFilterButton() => ElevatedButton.icon(
        icon: SvgPicture.asset(
          'assets/icons/filter.svg',
          colorFilter: ColorFilter.mode(ARMM_blue, BlendMode.srcIn),
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
          height: 22,
          width: 22,
        ),
        style: ElevatedButton.styleFrom(
<<<<<<< HEAD
<<<<<<< HEAD
          backgroundColor: Colors.white,
          splashFactory: NoSplash.splashFactory,
          side: BorderSide(color: ARMM_blue),
=======
          backgroundColor: const Color.fromARGB(255, 17, 24, 39),
          splashFactory: NoSplash.splashFactory,
          side: const BorderSide(color: Color.fromARGB(255, 17, 24, 39)),
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
          backgroundColor: Colors.white,
          splashFactory: NoSplash.splashFactory,
          side: BorderSide(color: ARMM_blue),
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
        ),
<<<<<<< HEAD
<<<<<<< HEAD
        label: Text(
          'Filter',
          style: TextStyle(
            color: ARMM_blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
=======
        label: const Text(
=======
        label: Text(
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
          'Filter',
          style: TextStyle(
            color: ARMM_blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
<<<<<<< HEAD
<<<<<<< HEAD
            fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
            
>>>>>>> a440029 (Removed All Font Issues)
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
          ),
        ),
        onPressed: widget.onFilterPressed,
      );

  /// Builds the Sort button.
  Widget _buildSortButton() => ElevatedButton.icon(
        icon: SvgPicture.asset(
          'assets/icons/sort.svg',
<<<<<<< HEAD
<<<<<<< HEAD
          colorFilter: ColorFilter.mode(ARMM_blue, BlendMode.srcIn),
=======
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
          colorFilter: ColorFilter.mode(ARMM_blue, BlendMode.srcIn),
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
          height: 22,
          width: 22,
        ),
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
<<<<<<< HEAD
<<<<<<< HEAD
          backgroundColor: Colors.white,
          side: BorderSide(color: ARMM_blue),
=======
          backgroundColor: const Color.fromARGB(255, 17, 24, 39),
          side: const BorderSide(color: Color.fromARGB(255, 17, 24, 39)),
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
          backgroundColor: Colors.white,
          side: BorderSide(color: ARMM_blue),
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
        ),
<<<<<<< HEAD
<<<<<<< HEAD
        label: Text(
          'Sort',
          style: TextStyle(
            color: ARMM_blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
=======
        label: const Text(
=======
        label: Text(
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
          'Sort',
          style: TextStyle(
            color: ARMM_blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
<<<<<<< HEAD
<<<<<<< HEAD
            fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
            
>>>>>>> a440029 (Removed All Font Issues)
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
          ),
        ),
        onPressed: widget.onSortPressed,
      );
}