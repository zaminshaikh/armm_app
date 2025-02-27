<<<<<<< HEAD
<<<<<<< HEAD
import 'package:armm_app/screens/activity/activity.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:armm_app/screens/analytics/analytics.dart';
=======
>>>>>>> 0d5bc67 (Update BottomNavBar to navigate to DashboardPage instead of ActivityPage)
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum NavigationItem { dashboard, analytics, activity, profile }

class BottomNavBar extends StatelessWidget {
  final NavigationItem currentItem;

  const BottomNavBar({
    Key? key,
    required this.currentItem,
  }) : super(key: key);

  void _onItemTapped(BuildContext context, NavigationItem item) {
    if (item == currentItem) return;
    Widget page;
    switch (item) {
      case NavigationItem.dashboard:
        page = const DashboardPage();
<<<<<<< HEAD
        break;
      case NavigationItem.analytics:
        page = const AnalyticsPage();
        break;
      case NavigationItem.activity:
        page = const ActivityPage();
        break;
      case NavigationItem.profile:
        page = const ProfilePage();
        break;
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required NavigationItem item,
    required String iconAsset, // pass the hollow version, e.g. "assets/icons/dashboard_hollow.svg"
    required String label,
  }) {
    final bool isSelected = currentItem == item;
    final String displayedIconAsset =
        isSelected ? iconAsset.replaceAll('_hollow', '') : iconAsset;
    return GestureDetector(
      onTap: () => _onItemTapped(context, item),
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                displayedIconAsset,
                height: 24,
                color: isSelected ? const Color(0xFF2B41B8) : const Color(0xFFB0BAC9),
              ),
              const SizedBox(width: 8),
              if (isSelected) ...[
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2B41B8),
                  ),
                ),
              ],
            ],
          ),
=======
=======
import 'package:armm_app/screens/activity/activity.dart';
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
import 'package:armm_app/screens/profile/profile.dart';
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum NavigationItem { dashboard, analytics, activity, profile }

class BottomNavBar extends StatelessWidget {
  final NavigationItem currentItem;

  const BottomNavBar({
    Key? key,
    required this.currentItem,
  }) : super(key: key);

  void _onItemTapped(BuildContext context, NavigationItem item) {
    if (item == currentItem) return;
    Widget page;
    switch (item) {
      case NavigationItem.dashboard:
        page = const ActivityPage();
=======
>>>>>>> 0d5bc67 (Update BottomNavBar to navigate to DashboardPage instead of ActivityPage)
        break;
      case NavigationItem.analytics:
        page = const ActivityPage();
        break;
      case NavigationItem.activity:
        page = const ActivityPage();
        break;
      case NavigationItem.profile:
        page = const ProfilePage();
        break;
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required NavigationItem item,
    required String iconAsset, // pass the hollow version, e.g. "assets/icons/dashboard_hollow.svg"
    required String label,
  }) {
    final bool isSelected = currentItem == item;
    final String displayedIconAsset =
        isSelected ? iconAsset.replaceAll('_hollow', '') : iconAsset;
    return GestureDetector(
      onTap: () => _onItemTapped(context, item),
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                displayedIconAsset,
                height: 24,
                color: isSelected ? const Color(0xFF2B41B8) : const Color(0xFFB0BAC9),
              ),
              const SizedBox(width: 8),
              if (isSelected) ...[
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2B41B8),
                  ),
                ),
              ],
            ],
<<<<<<< HEAD
          ],
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
=======
          ),
>>>>>>> 925f89f (Refactor BottomNavBar to enhance layout structure and improve icon display with a transparent background)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context: context,
<<<<<<< HEAD
<<<<<<< HEAD
                item: NavigationItem.dashboard,
=======
                index: 0,
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
=======
                item: NavigationItem.dashboard,
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
                iconAsset: 'assets/icons/dashboard_hollow.svg',
                label: 'Dashboard',
              ),
              _buildNavItem(
                context: context,
<<<<<<< HEAD
<<<<<<< HEAD
                item: NavigationItem.analytics,
=======
                index: 1,
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
=======
                item: NavigationItem.analytics,
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
                iconAsset: 'assets/icons/analytics_hollow.svg',
                label: 'Analytics',
              ),
              _buildNavItem(
                context: context,
<<<<<<< HEAD
<<<<<<< HEAD
                item: NavigationItem.activity,
=======
                index: 2,
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
=======
                item: NavigationItem.activity,
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
                iconAsset: 'assets/icons/activities_hollow.svg',
                label: 'Activities',
              ),
              _buildNavItem(
                context: context,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
                item: NavigationItem.profile,
                iconAsset: 'assets/icons/profile_hollow.svg',
=======
                index: 3,
<<<<<<< HEAD
                iconAsset: 'assets/icons/profile_hollow.svg', // adjust if necessary
>>>>>>> 0d00a21 (Modulated Profile Page for Simpler File Structure)
=======
                iconAsset: 'assets/icons/profile_hollow.svg',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}