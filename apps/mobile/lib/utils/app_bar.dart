import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
<<<<<<< HEAD
<<<<<<< HEAD
  final bool implyLeading;
  final bool showNotificationButton;
=======
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
=======
  final bool implyLeading;
  final bool showNotificationButton;
>>>>>>> 547db41 (All Pages Use the Custom App Bar)

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onNotificationTap,
<<<<<<< HEAD
<<<<<<< HEAD
    this.implyLeading = false,
    this.showNotificationButton = true,
=======
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
=======
    this.implyLeading = false,
    this.showNotificationButton = true,
>>>>>>> 547db41 (All Pages Use the Custom App Bar)
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> ff72afd (Refactor CustomAppBar to use a gradient background and make it transparent, enhancing visual appeal and layout structure.)
    return Stack(
      children: [
        // Gradient Background (Ensures Full Coverage)
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2B41B8),
<<<<<<< HEAD
                  Color.fromARGB(255, 169, 175, 206),
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
              fontWeight: FontWeight.w700,
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
=======
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      automaticallyImplyLeading: implyLeading,
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
<<<<<<< HEAD
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
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
        ),
      ],
=======
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
>>>>>>> 547db41 (All Pages Use the Custom App Bar)
=======
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
              fontWeight: FontWeight.w500,
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
        ),
      ],
>>>>>>> ff72afd (Refactor CustomAppBar to use a gradient background and make it transparent, enhancing visual appeal and layout structure.)
    );
  }
}