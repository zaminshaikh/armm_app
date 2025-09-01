import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:armm_app/utils/resources.dart';

String toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text
      .split(' ')
      .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

class FilterExpansionTile extends StatefulWidget {
  final String title;
  final String iconPath; 
  final List<String> items;
  final List<String> filterList;
  final Widget Function(String, String, List<String>) buildCheckbox;

  const FilterExpansionTile({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.items,
    required this.filterList,
    required this.buildCheckbox,
  }) : super(key: key);

  @override
  _FilterExpansionTileState createState() => _FilterExpansionTileState();
}

class _FilterExpansionTileState extends State<FilterExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      // Use the provided widget icon directly.
      leading: SvgPicture.asset(
        widget.iconPath,
        colorFilter: ColorFilter.mode(
          _isExpanded ? AppColors.primary : const Color.fromARGB(255, 77, 77, 77),
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        widget.title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          // Optionally adjust text color based on expansion.
          color: _isExpanded ? AppColors.primary : const Color.fromARGB(255, 77, 77, 77),
        ),
      ),
      iconColor: AppColors.primary,
      collapsedIconColor: AppColors.primary, // Changed to have a constant icon color.
      initiallyExpanded: _isExpanded,
      onExpansionChanged: (bool expanded) {
        setState(() => _isExpanded = expanded);
      },
      children: widget.items
          .map((item) => widget.buildCheckbox(
                toTitleCase(item),
                item,
                widget.filterList,
              ))
          .toList(),
    );
  }
}
