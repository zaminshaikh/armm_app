import 'dart:developer';
<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
=======

import 'package:flutter/material.dart';
>>>>>>> 431e0b9 (Replace Inter font files with updated versions and adjust pubspec.yaml for new font assets)
import 'package:armm_app/database/models/client_model.dart';
import 'total_assets_section.dart'; // Adjust the import according to your project structure

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
<<<<<<< HEAD
  final Client client;
=======
  final Client client; // Client is used to display the user's name and total assets
>>>>>>> 431e0b9 (Replace Inter font files with updated versions and adjust pubspec.yaml for new font assets)
  final VoidCallback? onNotificationTap;
  final bool implyLeading;
  final bool showNotificationButton;

  const DashboardAppBar({
    Key? key,
    required this.client,
    this.onNotificationTap,
    this.implyLeading = false,
    this.showNotificationButton = true,
  }) : super(key: key);

<<<<<<< HEAD
  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + 160); // Base height + estimated total assets section height
=======
  // Total height is the sum of the toolbar height (100) and the Total Assets section (160)
  @override
  Size get preferredSize => const Size.fromHeight(260);
>>>>>>> 431e0b9 (Replace Inter font files with updated versions and adjust pubspec.yaml for new font assets)

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      automaticallyImplyLeading: implyLeading,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
<<<<<<< HEAD
      backgroundColor: Colors.transparent,
      centerTitle: false,
      toolbarHeight: kToolbarHeight + 20, // Give some extra space for welcome text
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [
              Color(0xFF2B41B8),
              Color.fromARGB(255, 116, 122, 151), // Added a slightly darker shade for gradient effect
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color.fromARGB(54, 255, 255, 255),
                  child: Text(
                    '${client.firstName[0]}${client.lastName[0]}',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '${client.firstName} ${client.lastName}',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
=======
      toolbarHeight: 100,
      backgroundColor: const Color(0xFF2B41B8),
      centerTitle: false,
      // Use flexibleSpace to display a left-aligned column with welcome text and user's name.
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Text(
                  '${client.firstName[0]}${client.lastName[0]}',
                  style: const TextStyle(
                    color: Color(0xFF2B41B8),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${client.firstName} ${client.lastName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
>>>>>>> 431e0b9 (Replace Inter font files with updated versions and adjust pubspec.yaml for new font assets)
          ),
        ),
      ),
      actions: showNotificationButton
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: onNotificationTap ?? () {},
                ),
              ),
            ]
          : null,
<<<<<<< HEAD
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
=======
      // Total assets section at the bottom
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
>>>>>>> 431e0b9 (Replace Inter font files with updated versions and adjust pubspec.yaml for new font assets)
          child: TotalAssetsSection(client: client),
        ),
      ),
    );
  }
}