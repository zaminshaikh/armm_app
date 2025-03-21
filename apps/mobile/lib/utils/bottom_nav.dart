import 'package:armm_app/screens/activity/activity.dart';
import 'package:armm_app/screens/analytics/analytics.dart';
import 'package:armm_app/screens/dashboard/dashboard.dart';
import 'package:armm_app/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2B41B8),
                  ),
                ),
              ],
            ],
          ),
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
                item: NavigationItem.dashboard,
                iconAsset: 'assets/icons/dashboard_hollow.svg',
                label: 'Dashboard',
              ),
              _buildNavItem(
                context: context,
                item: NavigationItem.analytics,
                iconAsset: 'assets/icons/analytics_hollow.svg',
                label: 'Analytics',
              ),
              _buildNavItem(
                context: context,
                item: NavigationItem.activity,
                iconAsset: 'assets/icons/activities_hollow.svg',
                label: 'Activities',
              ),
              _buildNavItem(
                context: context,
                item: NavigationItem.profile,
                iconAsset: 'assets/icons/profile_hollow.svg',
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}