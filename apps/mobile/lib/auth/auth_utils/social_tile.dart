  import 'package:flutter/material.dart';

  class SocialTile extends StatelessWidget {
    final Widget icon;
    final VoidCallback onTap;

    const SocialTile({
      Key? key,
      required this.icon,
      required this.onTap,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: icon),
        ),
      );
    }
  }