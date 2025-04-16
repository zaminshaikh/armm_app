import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/analytics/components/line_chart.dart';
import 'package:armm_app/screens/dashboard/components/ytd.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TotalAssetsSection extends StatelessWidget {
  final Client client;

  const TotalAssetsSection({Key? key, required this.client}) : super(key: key);

  // Helper method to calculate font size based on value length
  double _calculateAssetsFontSize(double value) {
    final digits = value.toStringAsFixed(0).length;
    // Start with base size and reduce for larger numbers
    return digits <= 6 ? 24.0 : 24.0 - ((digits - 6) * 1.5);
  }

  @override
  Widget build(BuildContext context) {
    double totalAssets = client.assets?.totalAssets ?? 0;

    if (client.connectedUsers != null) {
      for (var user in client.connectedUsers!) {
        totalAssets += user?.assets?.totalAssets ?? 0;
      }
    }

    // Calculate dynamic font size based on total assets
    final assetsFontSize = _calculateAssetsFontSize(totalAssets);

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
                      fontSize: assetsFontSize,
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