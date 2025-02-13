import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LinkSentHeader extends StatelessWidget {
  const LinkSentHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
        // Header with Back Button and Logo
        Column(
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          SvgPicture.asset(
                            'assets/icons/ARMM_Logo.svg',
                            width: 30,
                            height: 30,
                          ),
                        ],
                      ),
                    ),
              ],
            ),
        const SizedBox(height: 16),
          ],
        );
      
  }
}