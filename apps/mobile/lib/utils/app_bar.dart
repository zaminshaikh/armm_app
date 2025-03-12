import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                colors: [
                  Color(0xFF2B41B8),
                  Color.fromARGB(255, 55, 82, 233),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          actions: showNotificationButton
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/notification.svg',
                        width: 30,
                        height: 30,
                        color: Colors.white,
                      ),
                      onPressed: onNotificationTap ?? () {},
                    ),
                  ),
                ]
              : null,
        ),
      ],
    );
  }
}