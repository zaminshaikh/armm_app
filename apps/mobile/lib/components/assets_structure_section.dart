import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AssetsStructureSection extends StatelessWidget {
  final Client client;
  final String fundName;
  final Map<String, double> accountSums = {};

  AssetsStructureSection({
    super.key,
    required this.client,
    required this.fundName,
  });

  @override
  Widget build(BuildContext context) {
    double overallTotal = 0;

    // Helper function to collect assets
    void addFundAssetsFromClient(Client client) {
      final fund = client.assets?.funds[fundName];
      if (fund == null) return;

      fund.assets.forEach((_, asset) {
        final amount = asset.amount;
        final accountName = asset.displayTitle;
        accountSums[accountName] = (accountSums[accountName] ?? 0) + amount;
        overallTotal += amount;
      });
    }

    // Add main client’s assets
    addFundAssetsFromClient(client);

    // Add connected users' assets
    if (client.connectedUsers != null) {
      for (final user in client.connectedUsers!) {
        if (user != null) {
          addFundAssetsFromClient(user);
        }
      }
    }

    final List<PieChartSectionData> sections = [];
    final List<_AccountSlice> sliceData = [];

    final colorPalette = <Color>[
      Color(0xFF1C32A4),
      Color.fromARGB(255, 72, 93, 197),
      Color.fromARGB(255, 16, 49, 209),
      Color.fromARGB(255, 129, 147, 239),
      Color.fromARGB(255, 160, 172, 231),
    ];

    int colorIndex = 0;

    if (overallTotal > 0) {
      accountSums.forEach((accountName, amount) {
        final percent = (amount / overallTotal) * 100;
        final color = colorPalette[colorIndex % colorPalette.length];
        colorIndex++;

        sections.add(
          PieChartSectionData(
            color: color,
            radius: 22,
            value: percent,
            showTitle: false,
          ),
        );

        sliceData.add(
          _AccountSlice(
            accountName: accountName,
            amount: amount,
            percentage: percent,
            color: color,
          ),
        );
      });
    }

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 10),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Investment Allocation',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
              
                      // Subtitle
                      Text(
                        'Account distribution',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),

                      const SizedBox(height: 20),

                      SvgPicture.asset(
                        'assets/icons/ARMM_Logo.svg',
                        width: 26,
                        height: 26,
                      ),


                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // Pie Chart with Center Label
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      startDegreeOffset: 120,
                      centerSpaceRadius: 80,
                      sectionsSpace: 4,
                      sections: sections,
                    ),
                  ),

                  // Center Text for Total
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currencyFormat(overallTotal),
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Total',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Account Legend (List of Accounts)
            Column(
              children: sliceData.map((slice) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      // Color Dot
                      Icon(Icons.circle, size: 12, color: slice.color),
                      const SizedBox(width: 8),

                      // Account Name
                      Expanded(
                        child: Text(
                          slice.accountName,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // Amount
                      Text(
                        currencyFormat(slice.amount),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(135, 0, 0, 0),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Percentage
                      Text(
                        '${slice.percentage.toStringAsFixed(0)}%',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper class for the legend data
class _AccountSlice {
  final String accountName;
  final double amount;
  final double percentage;
  final Color color;

  _AccountSlice({
    required this.accountName,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}