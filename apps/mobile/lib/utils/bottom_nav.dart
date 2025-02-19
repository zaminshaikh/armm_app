import 'package:armm_app/screens/activity/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex; // current page index
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String iconAsset, // pass the hollow version, e.g. "assets/icons/dashboard_hollow.svg"
    required String label,
  }) {
    final bool isSelected = selectedIndex == index;
    // Use filled version when selected: remove "_hollow" from the file name.
    final String displayedIconAsset =
        isSelected ? iconAsset.replaceAll('_hollow', '') : iconAsset;
    return GestureDetector(
      onTap: () {
        // For Activities icon, navigate to the Activity Page.
        if (index == 2) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ActivityPage(),
            ),
          );
        } else if (!isSelected) {
          onItemTapped(index);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              displayedIconAsset,
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
                index: 0,
                iconAsset: 'assets/icons/dashboard_hollow.svg',
                label: 'Dashboard',
              ),
              _buildNavItem(
                context: context,
                index: 1,
                iconAsset: 'assets/icons/analytics_hollow.svg',
                label: 'Analytics',
              ),
              _buildNavItem(
                context: context,
                index: 2,
                iconAsset: 'assets/icons/activities_hollow.svg',
                label: 'Activities',
              ),
              _buildNavItem(
                context: context,
                index: 3,
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