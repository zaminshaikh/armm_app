import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildNoActivityMessage() => Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.info_outline,
            size: 50,
            color: Colors.grey,
          ),
            Text(
            'No Activities',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8), // Provides spacing between the text widgets
            Text(
            'Please adjust your filters to view activities.',
            style: GoogleFonts.inter(fontSize: 16, color: Colors.black),
            ),
          ],

      ),
    );
