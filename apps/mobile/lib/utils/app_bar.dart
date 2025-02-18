import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onNotificationTap,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      toolbarHeight: 100,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: const Color(0xFF2B41B8),
      centerTitle: true,
      actions: [
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
      ],
    );
  }
}