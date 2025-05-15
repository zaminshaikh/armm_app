import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'logout_button.dart';

class ProfileButtons extends StatelessWidget {

  const ProfileButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Support Button
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/documents');
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/docs.svg',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'Documents',
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Documents & Settings
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/support');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/support.svg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Support',
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/settings.svg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Settings',
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // My Profiles & Authentication
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/my_profiles');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/profile.svg',
                        width: 18,
                        height: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'My Profiles',
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            fontSize: 14.5,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/authentication');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/auth.svg',
                        width: 18,
                        height: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'App Lock',
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Disclaimer Section
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                const SizedBox(height: 8),
                // ARMM Logo
                SvgPicture.asset(
                  'assets/icons/ARMM_Logo.svg',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(height: 16),
                Text(
                'Disclaimer',
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 56, 56, 56),
                  ),
                ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Investment products and services are offered '
                  'through ARMM group Investment, a New York '
                  'limited liability company.',
                  style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 56, 56, 56),
                  ),
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/disclaimer');
                },
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Real Full Disclaimer',
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2B41B8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF2B41B8),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Log out button now uses the custom LogoutButton widget
        const LogoutButton(),
      ],
    );
  }
}