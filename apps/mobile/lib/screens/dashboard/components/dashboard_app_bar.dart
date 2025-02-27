import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'total_assets_section.dart'; // Adjust the import according to your project structure

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Client client; // Client is used to display the user's name and total assets
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

  // Total height is the sum of the toolbar height (100) and the Total Assets section (160)
  @override
  Size get preferredSize => const Size.fromHeight(260);

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
      // Total assets section at the bottom
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TotalAssetsSection(client: client),
        ),
      ),
    );
  }
}