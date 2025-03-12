import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:google_fonts/google_fonts.dart';

class NameAndCID extends StatelessWidget {
  const NameAndCID({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<Client?>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Name and Client ID
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${client?.firstName} ${client?.lastName}",
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'Client ID: ${client?.cid}',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}