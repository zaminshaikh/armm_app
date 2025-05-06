import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'total_assets_section.dart'; // Adjust the import according to your project structure
import 'package:armm_app/utils/utilities.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Client? client; // ← nullable
  final VoidCallback? onNotificationTap;
  final bool implyLeading;
  final bool showNotificationButton;
  final Future<String?>? profilePicFuture;

  const DashboardAppBar({
    Key? key,
    this.client, // ← not required
    this.onNotificationTap,
    this.implyLeading = false,
    this.showNotificationButton = true,
    this.profilePicFuture,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + 180); // Increased height to accommodate the logo

  @override
  Widget build(BuildContext context) {
    final isSkeleton = client == null;
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      automaticallyImplyLeading: implyLeading,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.transparent,
      centerTitle: false,
      toolbarHeight: kToolbarHeight + 20, // Give some extra space for welcome text
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [
              Color(0xFF2B41B8),
              Color.fromARGB(255, 60, 84, 219),
              Color.fromARGB(255, 95, 116, 238),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
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
                if (isSkeleton)
                  CircleAvatar(radius: 30, backgroundColor: Colors.grey[300])
                else
                  FutureBuilder<String?>(
                    future: profilePicFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromARGB(54, 255, 255, 255),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(snapshot.data!),
                        );
                      } else {
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromARGB(54, 255, 255, 255),
                          child: Text(
                            '${client!.firstName[0]}${client!.lastName[0]}',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                const SizedBox(width: 10),
                if (isSkeleton)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 18, width: 100, color: Colors.grey[300]),
                      const SizedBox(height: 4),
                      Container(height: 22, width: 150, color: Colors.grey[300]),
                    ],
                  )
                else
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
                        formatName(client!.firstName, client!.lastName),
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
          ),
        ),
      ),
      actions: isSkeleton
          ? null
          : (showNotificationButton
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
              : null),
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Column(
            children: [
          // Total Assets Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: isSkeleton 
            ? Container(
                height: 60,
                decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
                ),
              )
            : TotalAssetsSection(client: client!),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(
              child: SvgPicture.asset(
            'assets/icons/ARMM_Logo_white.svg',
            height: 18,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            errorBuilder: (context, error, stackTrace) => const Text(
              'ARMM',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
              ),
            ),
          ),

          // ARMM Logo
            ],
          ),
        ),
        );
  }
}