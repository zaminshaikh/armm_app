import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/dashboard/components/ytd.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TotalAssetsSection extends StatelessWidget {
  final Client client;

  const TotalAssetsSection({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalAssets = client.assets?.totalAssets ?? 0;

    if (client.connectedUsers != null) {
      for (var user in client.connectedUsers!) {
        totalAssets += user?.assets?.totalAssets ?? 0;
      }
    }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              // Left Column for Total Assets
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Total Assets',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 94, 94, 94),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat(totalAssets),
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Right Column for YTD (Latest Return)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Latest Return',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 94, 94, 94),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ProfitIndicator(amount: client.assets?.totalYTD ?? 0),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}