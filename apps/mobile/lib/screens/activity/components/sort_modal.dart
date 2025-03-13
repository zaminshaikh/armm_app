import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/screens/activity/utils/sort_activities.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A modal widget for selecting sort options.
class ActivitySortModal extends StatelessWidget {
  final SortOrder currentOrder;
  final Function(SortOrder) onSelect;

  const ActivitySortModal({
    Key? key,
    required this.currentOrder,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sort By',
                    style: GoogleFonts.inter(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              _buildSortOption(
                  context, 'Date: New to Old (Default)', SortOrder.newToOld),
              _buildSortOption(context, 'Date: Old to New', SortOrder.oldToNew),
              _buildSortOption(
                  context, 'Amount: Low to High', SortOrder.lowToHigh),
              _buildSortOption(
                  context, 'Amount: High to Low', SortOrder.highToLow),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );

  /// Builds an individual sort option.
  Widget _buildSortOption(BuildContext context, String title, SortOrder value) => ListTile(
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: currentOrder == value
              ? ARMM_Blue
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(
              color: currentOrder == value
                  ? Colors.white
                  : const Color.fromARGB(160, 0, 0, 0),
              fontWeight: FontWeight.w600,
              fontSize: 18,
              ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onSelect(value);
      },
    );
}
