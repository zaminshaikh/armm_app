import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
<<<<<<< HEAD
import 'package:google_fonts/google_fonts.dart';
=======
import 'package:flutter_svg/flutter_svg.dart';
>>>>>>> 7b97856 (Migrated components for dashboard)

class AssetsStructureSection extends StatelessWidget {
  final Client client;
  final String fundName;
  final Map<String, double> accountSums = {};

<<<<<<< HEAD
  AssetsStructureSection({
    super.key,
    required this.client,
    required this.fundName,
=======

  AssetsStructureSection({
    super.key,
    required this.client,
    required this.fundName, 
>>>>>>> 7b97856 (Migrated components for dashboard)
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    double overallTotal = 0;

    // Helper function to collect assets
=======
    // 1) Gather all the account amounts across this client and any connected users
    double overallTotal = 0;

    // Threshold for displaying a slice in the pie chart
    final double thresholdPercent = 2.0;

    // Helper to add the specified fund’s assets to the map
>>>>>>> 7b97856 (Migrated components for dashboard)
    void addFundAssetsFromClient(Client client) {
      final fund = client.assets?.funds[fundName];
      if (fund == null) return;

      fund.assets.forEach((_, asset) {
        final amount = asset.amount;
<<<<<<< HEAD
        final accountName = asset.displayTitle;
=======
        final accountName = client.firstName + ' ' + client.lastName + ' - ' + asset.displayTitle;    // <- use the asset’s displayTitle
>>>>>>> 7b97856 (Migrated components for dashboard)
        accountSums[accountName] = (accountSums[accountName] ?? 0) + amount;
        overallTotal += amount;
      });
    }

<<<<<<< HEAD
    // Add main client’s assets
    addFundAssetsFromClient(client);

    // Add connected users' assets
=======
    // Main client
    addFundAssetsFromClient(client);

    // Connected users
>>>>>>> 7b97856 (Migrated components for dashboard)
    if (client.connectedUsers != null) {
      for (final user in client.connectedUsers!) {
        if (user != null) {
          addFundAssetsFromClient(user);
        }
      }
    }

<<<<<<< HEAD
    final List<PieChartSectionData> sections = [];
    final List<_AccountSlice> sliceData = [];

    final colorPalette = <Color>[
      const Color(0xFF0066FF),
      const Color(0xFF3A98FC),
      const Color(0xFF74B8F7),
      const Color(0xFF9CD7F0),
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

            const SizedBox(height: 40),

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
=======
    // 2) Convert each account to a pie slice
    final List<PieChartSectionData> sections = [];
    final List<_AccountSlice> sliceData = [];

    // 3) Add a “hidden” slice for any accounts below the threshold
    final List<_AccountSlice> hiddenSliceData = [];


    // Provide a color palette for slices 
    final colorPalette = <Color>[
      const Color(0xFF0D5EAF), 
      const Color(0xFF3199DD),
      const Color.fromARGB(255, 103, 187, 243),
      const Color.fromARGB(255, 39, 71, 100),
      const Color.fromARGB(255, 30, 116, 84),
      const Color.fromARGB(255, 12, 78, 18),
      const Color.fromARGB(255, 91, 11, 14),
      const Color.fromARGB(255, 255, 255, 255),
      const Color.fromARGB(255, 141, 141, 141),
      const Color.fromARGB(255, 115, 128, 141),
      const Color(0xFF0D3B5F),
      const Color(0xFF5BB7F0),
      const Color(0xFF0B2E47),
      const Color(0xFF90D5F7),
      const Color(0xFFD3EEFF), 
    ];


    // Two separate indices: one for visible slices, one for hidden slices
    int visibleIdx = 0;
    int hiddenIdx = 0;
    
    if (overallTotal > 0) {
      // Loop over "displayNameSums" and decide which slices are hidden vs visible
      accountSums.forEach((displayName, sum) {
        final percent = (sum / overallTotal) * 100;
    
        if (percent < thresholdPercent) {
          // Get color from the back of the palette for hidden slices
          final color = colorPalette[colorPalette.length - 1 - (hiddenIdx % colorPalette.length)];
          hiddenIdx++;
    
          hiddenSliceData.add(
            _AccountSlice(
              accountName: displayName,
              color: color,
              percentage: percent,
            ),
          );
        } else {
          // Get color from the front of the palette for visible slices
          final color = colorPalette[visibleIdx % colorPalette.length];
          visibleIdx++;
    
          sections.add(
            PieChartSectionData(
              color: color,
              radius: 25,
              value: percent,
              showTitle: false,
            ),
          );
          sliceData.add(
            _AccountSlice(
              accountName: displayName,
              color: color,
              percentage: percent,
            ),
          );
        }
      });
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 41, 59),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 5),
              const Text(
                  'Assets Structure',
                  style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Titillium Web',
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  if (fundName.toLowerCase() == 'agq')
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5),
                      child: SvgPicture.asset(
                        'assets/icons/agq_logo.svg',
                        color: Colors.white,
                        height: 25,
                        width: 25,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                      ),
                    ),
                ],
              )
            ],
          ),
          
          const SizedBox(height: 60),

          // Pie chart with a center label
          SizedBox(
            width: 250,
            height: 250,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: 120,
                    centerSpaceRadius: 100,
                    sectionsSpace: 10,
                    sections: sections, // Our newly built list
                  ),
                ),
                // “Total” in the center
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Titillium Web',
                        ),
                      ),
                      Text(
                        currencyFormat(overallTotal),
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Titillium Web',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // If we have no data, show a “No data” message
          if (overallTotal == 0)
            const Text(
              'No data available for this fund',
              style: TextStyle(color: Colors.white),
            )
          else ...[
            // Otherwise, show the table of slices
            const Row(
              children: [
                SizedBox(width: 30),
                Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 216, 216, 216),
                    fontFamily: 'Titillium Web',
                  ),
                ),
                Spacer(),
                Text(
                  '%',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 216, 216, 216),
                    fontFamily: 'Titillium Web',
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 5),
            const Divider(
              thickness: 1.2,
              height: 1,
              color: Color.fromARGB(255, 102, 102, 102),
            ),
            const SizedBox(height: 10),
            Column(
              children: sliceData.map((slice) {
                final pctString = slice.percentage.toStringAsFixed(1);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 20,
                        color: slice.color,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        slice.accountName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Titillium Web',
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$pctString%',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Titillium Web',
                        ),
                      ),
                      const SizedBox(width: 10),
>>>>>>> 7b97856 (Migrated components for dashboard)
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
<<<<<<< HEAD
        ),
=======
          if (hiddenSliceData.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Row(
              children: [
                SizedBox(width: 30),
                Text(
                  'Not Shown',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 216, 216, 216),
                    fontFamily: 'Titillium Web',
                  ),
                ),
                Spacer(),
                Text(
                  '%',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 216, 216, 216),
                    fontFamily: 'Titillium Web',
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 5),
            const Divider(
              thickness: 1.2,
              height: 1,
              color: Color.fromARGB(255, 102, 102, 102),
            ),
            const SizedBox(height: 10),

            Column(
              children: hiddenSliceData.map((slice) {
                final pctString = slice.percentage.toStringAsFixed(1);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 20,
                        color: slice.color,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        slice.accountName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Titillium Web',
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$pctString%',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Titillium Web',
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

        ],
>>>>>>> 7b97856 (Migrated components for dashboard)
      ),
    );
  }
}

<<<<<<< HEAD
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
=======
/// Helper class for building the “legend” of accounts below the chart.
class _AccountSlice {
  final String accountName;
  final Color color;
  final double percentage;
  _AccountSlice({
    required this.accountName,
    required this.color,
    required this.percentage,
>>>>>>> 7b97856 (Migrated components for dashboard)
  });
}