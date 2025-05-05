import 'package:armm_app/screens/notifications/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final bool implyLeading;
  final bool showNotificationButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onNotificationTap,
    this.implyLeading = false,
    this.showNotificationButton = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background (Ensures Full Coverage)
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: const [
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
        ),

        // AppBar Content
        AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: implyLeading,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: 100,
          backgroundColor: Colors.transparent, // Allows the gradient to show
          centerTitle: true,
            title: Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          actions: showNotificationButton
              ? [
                    Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
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
                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationPage(),
                        ),
                        );
                      },
                      ),
                    ),
                    ),
                ]
              : null,
        ),
      ],
    );
  }
}